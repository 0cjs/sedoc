Intel 8080 and Related CPUs
===========================

There's good documentation many different kinds of old systems at
[Daves Old Computers][dunfield]; the undocumented (and unlinked)
[`/dunfield/r`] subdir contains programming information for various
architectures (and ZIPped docs on C64 cassette and video monitor).

References:
- [_8080/8085 Assembly Language Programming Manual_][i85], Intel, 1981
- [_Z80 Programming Manual_][z80], MOSTEK, 1977. Note eratta on p.iv (PDF p.7).


8080 Architecture
-----------------

where the Z80 differs in naming from the 8080/8085, the Z80 alternative
name is given in parens after the Intel name.

An excellent instruction summary is [8080.txt](8080.txt),
downloaded from [`/dunfield/r`].

### Registers

- `A`, status register (flags); together `PSW`.
- `B`, `C`; together `B` (`BC`).
- `D`, `E`; together `D` (`DE`).
- `H`, `L`; `M` in `MOV` instructions is pointed-to memory loc (`HL`).
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

    7  S       sign (bit 7 of result)
    6  Z       zero (all bits of result = 0)
    5  X       unused
    4  AC H    auxiliary carry/half carry (carry from bit 3)
    3  X       unused
    2  P  P/V  parity/overflow
    1     N    add/subtract (most recent operation)
    0  C       carry/borrow (0=no borrow, 1=borrow)

`AC` (`H`) and (`N`) not directly testable; used by `DAA`. decimal adjust.

On the 8080/8085, `P` is always set to the parity of the result (odd/even)
on the 8080/8085. The Z80  does that only for logical operations, instead
using it to indicate signed overflow for arithmetic operations.

### Addressing Modes

Addressing modes: direct and indirect through a register. Nothing involving
addition of offsets. (Such poverty!) Z80 adds offsets for `IX` and `IY`
registers.

### Interrupts

Z80 has NMI (8080 doesn't), restarting at $0066. The Z80 calls the standard
Intel interrupt scheme _mode 0_, and adds _mode 1_, always restarting at
$0038 and _mode 2_, where the device supplies 8-bits of low address (LSbit
must be 0), 8 bits of high address is supplied by `I` register, and the
interrupt vector is looked up from that address.



<!-------------------------------------------------------------------->
[`/dunfield/r`]: http://www.classiccmp.org/dunfield/r/
[dunfield]: http://www.classiccmp.org/dunfield/
[i85]: https://archive.org/stream/bitsavers_intelISISIssemblyLanguageProgrammingManualMay81_7150831#page/n4/mode/1up
[z80]: https://archive.org/stream/Z80ProgrammingManual#page/n3/mode/1up
