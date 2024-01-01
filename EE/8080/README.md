Intel 8080 and Related CPUs
===========================

Contents:
- Introduction
- 8080 Architecture
- Support Chips
- Tools

Introduction
------------

The original 8080 (1973-12) was a flawed prototype (driving with TTL
increased ground voltages), though with 40k units produced. The successor
8080A (1974-04) is the standard CPU.

There's good documentation many different kinds of old systems at
[Daves Old Computers][dunfield]; the undocumented (and unlinked)
[`/dunfield/r`] subdir contains programming information for various
architectures (and ZIPped docs on C64 cassette and video monitor).


8080 Architecture
-----------------

An excellent instruction summary is [8080.txt](8080.txt), downloaded
from [`/dunfield/r`]. Intel mnemonics given here in upper case

The 8085 adds:
- Single +5V power supply
- Has many 8224/8228 features, but addr/data buses require demux.
- ~50% faster (fewer cycles)
- New interrupts; `SI`/`SO` pins for bitbanged serial in/out
- `RIM`, `SIM` instructions

Where the Z80 differs in naming from the 8080/8085, the Z80 alternative
name is given in parens after the Intel name. Z80 mnemonics are given
in lower case.

### Registers

- `F`, `A`, status register (flags), accumulator; together `PSW`.
- `B`, `C`; together `B` (`BC`).
- `D`, `E`; together `D` (`DE`).
- `H`, `L`; together `H` (`HL`); indirect `M` (`(HL)`).
- `SP` stack and `PC`; never directly referenced.

Z80 adds:
- `IX`, `IY`: Index registers; op prefixes give new instructions to use these
  with a 1-byte offset. These tend to be slower than using `HL` and `inc`.
- `I`: Interrupt page: high-order 8 bits of addr on interrupt in mode 2. In
  modes 0 and 1, can be used for programmer-defined purposes. $00 on reset.
- `R`: Memory refresh (7 bits): incremented with each instruction fetch.
  Can be read/set by programmer for testing or other purposes.
- `AF'` alternate accumulator and flags, swapped with `ex af,af'`.
- `BC' DE' HL'` alternate register set swapped with `exx`.

### Flags

Summary: status register bit, 8080 name, Z80 name (if different) and function.

    bit '80 Z80   descr
     7   S        sign (bit 7 of result)
     6   Z        zero (all bits of result = 0)
     5   -        unused
     4  AC   H    auxiliary carry/half carry (carry from bit 3)
     3   -        unused
     2   P  P/V   parity/overflow
     1   -   N    8080: unused; Z80: add/subtract (most recent operation)
     0   C        carry/borrow: 0=no borrow, 1=borrow (sometimes "CY")

`AC` (`H`) and `N` not directly testable; used by `DAA`. decimal adjust.
(Only Z80 has `N` and adjusts properly after a subtraction.)

On the 8080/8085, `P` is always set to the parity of the result (odd/even)
on the 8080/8085. The Z80  does that only for logical operations, instead
using it to indicate signed overflow for arithmetic operations.

For `cmp`/`sub` doing an _unsiged_ comparsion of A to operand:
- (nc) C=0: A ≥ operand
-  (c) C=1: A < operand

### Stack Pointer

The stack pointer points to the lowest _used_ address on the stack. Stack
operations always use a a register pair (`AF`, `BC`, `DE`, `HL`) using the
following sequence
- `PSH`: (SP-1) ← MSB; (SP-2) ← LSB; SP ← SP - 2.
- `POP`: LSB ← (SP); MSB ← (SP+1); SP ← SP + 2.

### Addressing Modes

Addressing modes: direct and indirect through a register. Nothing involving
addition of offsets. (Such poverty!) Z80 adds offsets for `IX` and `IY`
registers.

### Instructions

New 8085 instructions for serial bit and interrupts:
- `RIM`: Read Interrupt Mask
  - b7:   serial I/O data bit, if any
  - b6-4: pending interrupts: 1=pending
  - b3:   interrupt enable flag: 1=enabled
  - b2-0: interrupt masks: 1=masked
- `SIM`: Set Interrupt Mask
  - b7:   serial output data, used only if b6=1
  - b6:   0=ignore b7; 1=send b7 to serial output data latch
  - b5:   ignored
  - b4:   1=RST7.5 flip flop is reset off
  - b3:   1=set mask, 0=b2-0 ignored
  - b2-0: interrupt masks 7.5, 6.5, 5.5: 1=masked 0=available

New Z80 instructions:
- `ex (sp),ix`. `ex af,af'`. `eex`.
- Relative jumps `jr a8`, with `z`, `nz`, `c`, `nc` conditions available.
- `djnz`:
- `ldir`: (HL) → (DE), HL++, DE++; BC--; repeat unless BC=0. [PM 184]
  - `ED B0`. BC≠0 21 (4,4,3,5,5), BC=0 16 (4,4,3,5)

### Instruction Timings

Here we use Z80 terminology. Clock cycles are _T cycles_; instructions use
one or more _M cycles_ each of 2-5 T cycles. Generally, the first M-cycle
(opcode fetch) is four T cycles. Intell calls M and T cycles _cycles_ and
_states_.


Interrupts
----------

On all processors, `DI` masks all interrupts except NMI and `EI` enables
all interrupts. Interrupts exit `halt` state.

Single-byte instructions intended for interrupt use are "restart" `RST 0` -
`RST 7` jumping to $0000, $0008, $0010, ..., $0038.

Interrupt routine should `push AF` at start, execute `EI` before/at end,
and `pop AF`, `RTS` at end.

### 8080

One maskable interrupt, `INTR` signal, level sensitive input on `INT` pin 14.
`INTE` pin 16 high output indicates interrupts are enabled.

On interrupt: current instruction is completed; all interrupts masked
(effectively `DI`); current PC placed on address bus while next complete
instruction (single- or multi-byte) is read from data bus, then executed.

Typically an `RST n` is stuffed on to the bus to avoid dealing with
multi-cycle byte stuffing. Sufficiently sophisticated systems can gate e.g.
`CALL` on to the bus.

Hardware must ensure that instruction byte(s) for interrupt, rather than
data from memory, is returned during first FETCH cycle after interrupt.
8228 can optionally handle this internally, gating `RST 7` on to data bus.

RST and interrupt vectors:

    intr    addr    notes
    ────────────────────────────────────────────
    RST0    $0000
    RST1    $0008
    RST2    $0010
    RST3    $0018
    RST4    $0020
    TRAP    $0024   8085 only
    RST5    $0028
    RST5.5  $002B   8085 only
    RST6    $0030
    RST6.5  $0034   8085 only
    RST7    $0038
    RST7.5  $003B   8085 only
    NMI     $0066   Z80 only

### 8085

8085 adds four more interrupts with dedicated pins for each, all with
higher priority than `INTR`:

    priority    intr    addr    notes
    ────────────────────────────────────────────────────────
    highest     TRAP    $0024   edge sensitive, non-maskable
                RST7.5  $003B   edge sensitive
                RST6.5  $0034
                RST5.5  $002B
    lowest      INTR    -

### Z80

Z80 has NMI (8080 doesn't), restarting at $0066. The Z80 has three
interrupt modes:
- _mode 0:_ standard Intel interrupt scheme
- _mode 1:_ always restarting at with `RST7` at $0038 (à la 8228 option)
- _mode 2:_ the interrupting device supplies 8-bits of low address (LSbit
  must be 0), 8 bits of high address is supplied by `I` register, and the
  interrupt vector is looked up from that address.


Support Chips
-------------

The following support chips were designed to be used with the 8080A. For
more details see [P.60 Chapter 5][csum-5] of the _Intel MCS80 Computer
Systems Users Manual._

    CPU Group
      8224 Clock Generator                              5-1
      8228 System Controller                            5-7
      8080A Central Processor
      8080A-1 Central Processor (1.3μs)
      8080A-2 Central Processor (1.5μs)
      M8080A Central Processor (-55° to +125°C)

    ROMs
      8702A Erasable PROM (256 × 8)                     5-37
      8708/8704 Erasable PROM (1K × 8)
      8302 Mask ROM (256 × 8)
      8308 Mask ROM (1K × 8)
      8316A Mask ROM (2K × 8)

    RAMs
      8101-2 Static RAM (256 × 4)                       5-67
      8111-2 Static RAM (256 × 4)
      8102-2 Static RAM (1 × 1)
      8102A-4 Static RAM (1K × 1)
      8107B-4 Dynamic RAM (4K × 1)
      5101 Static CMOS RAM (256 × 4)
      8210 Dynamic RAM Driver
      8222 Dynamic RAM Refresh Controller

    I/O
      8212 8-Bit I/O Port                               5-101
      8255 Programmable Peripheral Interface (PPI)      5-113   P.181
      8251 Programmable Communication Interface         5-135   P.203

    Peripherals
      8205 One of Eight Decoder                         5-147
      8214 Priority Interrupt Control Unit              5-153
      8216/8226 4-Bit Bi-Directional Bus Driver         5-163

    Coming Soon
      8253 Programmable Interval Timer                  5-169
      8257 Programmable DMA Controller                  5-171
      8259 Programmable Interrupt Controller            5-173

#### 8224 Clock Generator

External crystal resonator controls oscillator running at 9× system speed;
from divide-by-9 counter is derived two 8080 clocks (ϕ1, ϕ2) and auxiliary
signals.
- ϕ1: of 9×: 1-2 high, 3-9 low.
- ϕ2: of 9×: 1-2 low, 3-7 high, 8-9 low.
- RC network on `R̅E̅S̅I̅N̅` has slow rise at power-up; fast-edge reset signal
  is generated from this. Active-low switch can also be connected here.
- Signal on `RDYIN` produces properly synchronized signal for CPU `READY`.

#### 8228 System Controller

- Data bus driver for monitoring status, tristate and better fanout.
- Latched output of derived status signals:
  - Generates `M̅E̅M̅ ̅R̅`, `M̅E̅M̅ ̅W̅`, `I̅/̅O̅ ̅R̅`, `I̅/̅O̅ ̅W̅`, `I̅N̅T̅A̅`.
  - From 8080 `DBIN`, `W̅R̅` and start-of-cycle status on data bus
- Interrupt handling:
  - Connect `I̅N̅T̅A̅` output to +12V via 1kΩ to have 8228 gate `RST 7` on to
    data bus on any interrupt.
  - Otherwise use standard interrupt data bus stuffing; if 8228 detects
    instruction to be `CALL` it will generate `I̅N̅T̅A̅` pulses for additional
    two bytes read by CPU.

#### Other

- __8212 8-Bit I/O Port:__ Unidirectional latch w/tri-state outputs.
  - Input port generating interrupt from input strobe.
  - Latching output port w/handshake line.
  - Can be used to gate `RST` instruction on to bus during interrupt.
- __8251 UART:__ ([P.203 p.5-135 datasheet][csum-8251] )
- __8255 PPI:__ ([P.181 p.5-113 datasheet][csum-8255]) Ports A, B 8-bit
  input or output. Port C split 2× 4 bits each input or output. (Or as they
  put it, two groups of 12: group A ports A,C; group B ports B,C.)


Tools
-----

- [z80dasm]: Improved version of dz80; still overly simplistic but packaged
  in most Linux distros.
- [z88dk]: Development kit for over a hundred Z80 family machines,
  including C compilers (`sccz80` and `zsdcc`), assembler, linker,
  libraries, simulator/debugger, disassembler, and more. Targets include
  TRS-80, PC-8801, Sharp MZ, Kyotronic 85, Pasopia 7, MSX,
  ZX80/81/Spectrum, Robotron KC 87, RC2014 (CP/M, HBIOS, RC2014), etc.


<!-------------------------------------------------------------------->
[`/dunfield/r`]: http://www.classiccmp.org/dunfield/r/
[csum-5]: https://archive.org/details/bitsavers_intelMCS80ocomputerSystemsUsersManual197509_43049640/page/n58/mode/1up?view=theater
[csum-8251]: https://archive.org/details/bitsavers_intelMCS80ocomputerSystemsUsersManual197509_43049640/page/n202/mode/1up?view=theater
[csum-8255]: https://archive.org/details/bitsavers_intelMCS80ocomputerSystemsUsersManual197509_43049640/page/n180/mode/1up?view=theater
[dunfield]: http://www.classiccmp.org/dunfield/

<-- Tools -->
[z88dk]: https://github.com/z88dk/z88dk
[z80dasm]: https://web.archive.org/web/20230925185822/https://www.tablix.org/~avian/blog/articles/z80dasm/
