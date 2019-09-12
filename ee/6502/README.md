MOS Technology 6502
===================

- [Opcodes by addressing mode](opcodes)
- [OUPRG Programmer's card](progcard)

#### References

6502:
- \[hm1976] [MCS6500 Family Hardware Manual][hm1976]. MOS, 1976-01.
- \[pm1976] [MCS6500 Microcomputer Family Programming Manual][pm1976].
  MOS, 1976.

Systems:
- \[a2ref] [Apple II Reference Manual][a2ref]. Apple, 1978-01.


Program Status Register (P, Flags)
----------------------------------

This is officially called the "program status register," abbreviated
to `P`. However, many sources call these the "flags."

    7  N    negative    BIT, most instrs with a result
    6  V    overflow    CLV; ADC, SBC, BIT
    5  1                0 on push, ignored on pull
    4  1    how stacked on stack only; 0=I̅R̅Q̅,N̅M̅I̅ 1=PHP,BRK; ignored on PLP/RTI
    3  D    decimal     SED/CLD; no effect on some clones
    2  I    I̅R̅Q̅ mask    SEI/CLI; I̅R̅Q̅, RTI
    1  Z    zero        most instrs with a result
    0  C    carry       SEC/CLC; ADC, SBC, CMP, ASL/LSR/ROL/ROR

- [Status flags: Nesdev wiki][nesdev-flags]
- The [WDC W65C02S datasheet][ds2018] (2018-10) indicates in the
  register diagram on p.8 that bit 5 is always `1`; it gives bit 4 as
  "1 = BRK, 0 = IRQB." In the opcode table 6-4 it indicates that both
  bits 5 and 4 are `1`. However, [pm1976] §3.5 p.27 says it's "likely"
  `1` but not guaranteed.
- [Wilson Mines][wmint2.2] indicates that bit 4 is always set in the
  PSR.
- The `BRK` instruction does appear to set `I` (the IRQ mask). This is
  is indicated in the [1976 preliminary data sheet][ds1976] and the
  [2018 WDC 65C02S data sheet][ds2018], though not the [1980 data
  sheet][ds1980].
- [pm1976] gives exact details of flag set/reset behaviour for all
  instructions.


Execution Cycles
----------------

The following sources give cycle-by-cycle breakdowns of the execution
of individual 6502 opcodes and their operands.
- [hm1976] Appendix A, "Summary of Single Cycle Execution." There is
  also considerable other timing information here, including expected
  oscilloscope waveforms.


Tips and Tricks
---------------

#### Software

- Clear C before `ADC`, set C before `SBC`.
- `BRK` [increments PC by 2][brk-pc2] before pushing it; follow with a
  filler byte unless your assembler does this automatically. Or
  consider an `INT n` macro that inserts _n_ after `BRK` as a param to
  the IRQ routine. [Wilson Mines][wmint2.2] has a good discussion of
  how to write interrupt routines to use the second byte, and both the
  Apple II BIOS IRQ routine at `$FA86` ([a2ref] p.81) and [pm1976]
  p.144 demonstrate how to do a `BRK` vs. IRQ check.
- Stack-relative addressing can be done with `TSX`, `LDA 1aa,X`.
  Described in [Wilson Mines][wmint2.2].
- Unconditional relative branch (relocatable): `CLC`, `BCC addr`. Same
  size as `JMP` but 2+2 cycles instead of 3.
- An indirect `JMP` sometimes is more efficiently done by pushing the
  address on the stack and executing `RTS`, as explained in [Woz's
  Sweet 16 article][sw16] (`SW16D` symbol in [listing][sw16asm]).


Code
----

- [a2ref], as well as containing the BIOS listing, also contains
  listings for floating point routines and the miniassembler.

#### Hardware

- See [hm1976] pp. 123-132 (Chapter 3) for suggestions on bring-up
  testing, including static testing, single cycle and instruction
  execution, bus data latching, hardware-induced loops via RESET and
  scope sync for them, etc.


<!-------------------------------------------------------------------->
[a2ref]: https://archive.org/details/bitsavers_appleapple_10059029/
[brk-pc2]: http://forum.6502.org/viewtopic.php?t=1917
[ds1976]: http://archive.6502.org/datasheets/mos_6500_mpu_preliminary_may_1976.pdf
[ds1980]: http://archive.6502.org/datasheets/mos_6500_mpu_mar_1980.pdf
[ds2018]: http://archive.6502.org/datasheets/wdc_w65c02s_oct_8_2018.pdf
[hm1976]: http://archive.6502.org/books/mcs6500_family_hardware_manual.pdf
[nesdev-flags]: https://wiki.nesdev.com/w/index.php/Status_flags
[pm1976]: https://archive.org/details/6500-50a_mcs6500pgmmanjan76
[sw16]: http://amigan.1emu.net/kolsen/programming/sweet16.html
[sw16asm]: https://github.com/cbmeeks/Sweet-16/blob/master/sweet16.asm
[wmint2.2]: http://wilsonminesco.com/6502interrupts/#2.2
