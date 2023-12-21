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

Where the Z80 differs in naming from the 8080/8085, the Z80 alternative
name is given in parens after the Intel name.

An excellent instruction summary is [8080.txt](8080.txt),
downloaded from [`/dunfield/r`].

### Registers

- `F`, `A`, status register (flags), accumulator; together `PSW`.
- `B`, `C`; together `B` (`BC`).
- `D`, `E`; together `D` (`DE`).
- `H`, `L`; together `H` (`HL`); indirect `M` (`(HL)`).
- `SP` stack and `PC`; never directly referenced.

Z80 adds:
- `IX`, `IY`: Index registers; op prefixes give new instructions to use
  these with a 1-byte offset. These tend to be slower than using `HL` and
  `INC`.
- `I`: Interrupt page: high-order 8 bits of addr on interrupt in mode 2. In
  modes 0 and 1, can be used for programmer-defined purposes. Set to $00
  on reset.
- `R`: Memory refresh (7 bits): incremented with each instruction fetch.
  Can be read/set by programmer for testing or other purposes.
- `AF'` alternate accumulator and flags, swapped with `EX AF, AF'`.
- `BC' DE' HL'` alternate register set swapped with `EXX`.

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

### Interrupts

Z80 has NMI (8080 doesn't), restarting at $0066. The Z80 calls the standard
Intel interrupt scheme _mode 0_, and adds _mode 1_, always restarting at
$0038 (`RST7`) and _mode 2_, where the device supplies 8-bits of low
address (LSbit must be 0), 8 bits of high address is supplied by `I`
register, and the interrupt vector is looked up from that address.

### Instructions

New 8085 instructions for serial bit and interrupts:
- `RIM`:
  - b7:   serial I/O data bit, if any
  - b6-4: pending interrupts: 1=pending
  - b3:   interrupt enable flag: 1=enabled
  - b2-0: interrupt masks: 1=masked
- `SIM`:
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

- Data bus driver
- Latched output of derived status signals `M̅E̅M̅ ̅R̅`, `M̅E̅M̅ ̅W̅`, `I̅/̅O̅ ̅R̅`,
  `I̅/̅O̅ ̅W̅`, `I̅N̅T̅A̅`.
- Can gate `RST7` on to data bus on interrupt, or generate `I̅N̅T̅A̅` pulses
  for each of the three bytes of a `CALL` instruction.

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
