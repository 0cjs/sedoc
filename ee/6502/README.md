MOS Technology 6502
===================

Contents:
- [Opcodes by addressing mode](opcodes)
- [OUPRG Programmer's card](progcard)
- [Pinouts](pinout.md)
- [Families and Variants](families.md)

#### References

6502:
- \[hm1976] [MCS6500 Family Hardware Manual][hm1976]. MOS, 1976-01.
- \[pm1976] [MCS6500 Microcomputer Family Programming Manual][pm1976].
  MOS, 1976.
- \[oxyron] [6502/6510/8500/8502 Opcode matrix][oxyron], oxyron.de.
  Good reference, includes inst. oper. details and flag effects.
- \[wmcdiff] Wilson Mines' [NMOS 6502/CMOS 65C02 Differences][wmcdiff].
- \[nw-guide] Nesdev Wiki [Programming Guide][nw-guide].
  Has significant generaic 6502 information, and particularly a good
  [optimizations][nw-optimize] page..

Systems:
- \[a2ref] [Apple II Reference Manual][a2ref]. Apple, 1978-01.


Vectors
-------

See also pp. 124-147 from [pm1976] for exact details of what happens
(particularly on the address bus with "ignored fetch" cycles) during
interrupt handling, the `RTI` instruction, etc.

    $FFFA $FFFB     NMI (has prioirty over IRQ)
    $FFFC $FFFD     RESET
    $FFFE $FFFF     IRQ, BRK

#### Reset/Startup

On reset interrupts are disabled and the PC loaded from the reset vector;
all other registers and status are undefined. Therefore the start up
sequence must set the stack pointer, clear decimal mode and (when ready)
clear the IRQ mask flag.

CMOS parts may clear decimal mode on reset as they do on IRQ.


Program Status Register (P, Flags)
----------------------------------

This is officially called the "program status register," abbreviated
to `P`. However, many sources call these the "flags."

    7  N    negative    BIT, most instrs with a result
    6  V    overflow    BIT bit 6 test, same as C for signed arith.
    5  1                usu. reads as 1; 0 on push, ignored on pull
    4  1    how stacked as 5, but stacked as 0=I̅R̅Q̅,N̅M̅I̅ 1=PHP,BRK
    3  D    decimal     decimal mode for ADC/SBC; no effect on some clones
    2  I    I̅R̅Q̅ mask    SEI/CLI; I̅R̅Q̅, RTI
    1  Z    zero        most instrs with a result
    0  C    carry       SEC/CLC; ADC, SBC, CMP, ASL/LSR/ROL/ROR

`V` is an XOR between `C` and the carry from bit 6 to 7. (This is true
in decimal mode, too; so it's never a decimal overflow.)

The following instructions affect specific flags ([pm1976] pp.24).
Additionally, `RTI` and `PLP` always set all flags.

    C   SEC CLC
        ADC SBC                                         ASL LSR ROL ROR
        BIT CMP CPX CPY

    NZ          LDA LDX LDY TAX TXA TAY TYA     TSX PLA
        ADC SBC INC DEC INX DEX INY DEY     AND ORA EOR ASL LSR ROL ROR
        BIT CMP CPX CPY

    V       CLV
        ADC SBC
        BIT

    D   SED CLD
    I   SEI CLI BRK
    (4) BRK

- No `SEV` instruction; use `BIT` on a location with bit 6 set.
- V flag very persistent; good for "saving" a predicate for later use.
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
  instructions. It sometimes forgets that ROR affects flags.


Execution Cycles and Timing
---------------------------

The following sources give cycle-by-cycle breakdowns of the execution
of individual 6502 opcodes and their operands.
- [hm1976] Appendix A, "Summary of Single Cycle Execution." There is
  also considerable other timing information here, including expected
  oscilloscope waveforms.

The timing of the 6502 can be a bit tricky.
- Generally, the address bus and control signals are driven to new values
  sometime during Φ2 low (just after the falling edge, in my testing) and
  so the following rising edge of Φ2 should be used to qualify use of those
  signals.
- The data bus is driven for writes just after the rising edge of Φ2. This
  is not an issue for RAM, where a wrong early value will quickly be
  overridden by the later correct value, but can cause issues with I/O.
  Transparent latches should not be used for I/O: do like the 65xx I/O ICs
  that read the value at the falling edge of Φ2 (edge-triggered registers).
  See `tDCW` setup time and `tHW` hold time in the data sheets.


Tips and Tricks
---------------

#### Instruction Set Notes

- SP always points to free byte below head of stack.
- JSR stacks last byte of its instruction; RTS adds one to stacked
  address before returning. RTI does not add one.
- ROL/ROR always rotate through carry.
- `BRK` [increments PC by 2][brk-pc2] before pushing it; append filler
  byte if continuing after unless assembler does this automatically.
  Sets I flag, only CMOS versions also clear D flag.

#### Software

- Always `CLD` on reset. Probably `CLD` in interrupt routines (unless
  no `ADC/SBC`). Subroutines with totally unknown callers should
  `PHP;CLD` then later `PLP`  to preserve caller's decimal mode.
- Clear C before `ADC`, set C before `SBC`.
- To handle `BRK` PC+2 issue, consider an `INT n` macro that inserts
  _n_ after `BRK` as a param to the IRQ routine. [Wilson
  Mines][wmint2.2] has a good discussion of how to write interrupt
  routines to use the second byte, and both the Apple II BIOS IRQ
  routine at `$FA86` ([a2ref] p.81) and [pm1976] p.144 demonstrate how
  to do a `BRK` vs. IRQ check.
- Stack-relative addressing can be done with `TSX`, `LDA 1aa,X`.
  Described in [Wilson Mines][wmint2.2].
- Unconditional relative branch (relocatable): `CLC`, `BCC addr`. Same
  size as `JMP` but 2+2 cycles instead of 3.
- A calculated indirect `JMP` sometimes is more efficiently done by
  pushing the address _minus one_ on the stack and executing `RTS`, as
  explained in [Woz's Sweet 16 article][sw16] (`SW16D` symbol in
  [listing][sw16asm]). (Or, faster yet, just use `JMP (nnnn)` with
  self-modifying code, if not running in ROM.)
- Set up loops to finish at $00 or $FF to branch on Z or N flags w/o
  `CMP` instruction.
- Use shift/rotate instructions to move bits into carry for testing
  when you don't mind the value being changed.

#### Wilson Mines Notes

This is a summary (excluding 65C02 tips) of the Wilson Mines [Tips for
Programming the 65(c)02][wmtips] page. Also see [routines](routines.md).

- Use BIT _addr_ to to test bit 7 (N flag) or 6 (V flag) _addr_
  without using a register. (C offers more extensive BB7 etc. instrs.)
- To set high bits, DEC _addr_ if you know it's currently 0, otherwise
  store any register that currently has the bit set. (C offers
  TSB/TRB.)
- To toggle bit 0, use INC _addr_ and DEC _addr_. On a port, chain for
  fast positive pulse. Also sets N to bit 7, for a simultaneous test.
- Use PHA/PHX/PHY for fast temporary storage.
- DEC;BEQ/BNE is a slightly shorter (than CMP) destructive test for
  $01. Same for $FF with INC.
- CMP/CPX/CPY #$80 copies bit 7 of a register into carry. Follow w/ROR
  for a sign-extended right shift.
- Don't compare to zero or $80 after any of the instructions listed
  above that already set Z/N flags. (Load/xfer/pull, inc/dec,
  arithmetic/bits).

Code
----

- [a2ref], as well as containing the BIOS listing, also contains
  listings for floating point routines and the mini-assembler.
- [Apple-II Mini-Assembler][a2mini-asm] instructions and listing.


#### Hardware

- See [hm1976] pp. 123-132 (Chapter 3) for suggestions on bring-up
  testing, including static testing, single cycle and instruction
  execution, bus data latching, hardware-induced loops via RESET and
  scope sync for them, etc.


<!-------------------------------------------------------------------->
[a2mini-asm]: https://archive.org/details/Apple2_Woz_MiniAssembler/page/n1/mode/1up
[a2ref]: https://archive.org/details/bitsavers_appleapple_10059029/
[brk-pc2]: http://forum.6502.org/viewtopic.php?t=1917
[ds1976]: http://archive.6502.org/datasheets/mos_6500_mpu_preliminary_may_1976.pdf
[ds1980]: http://archive.6502.org/datasheets/mos_6500_mpu_mar_1980.pdf
[ds2018]: http://archive.6502.org/datasheets/wdc_w65c02s_oct_8_2018.pdf
[hm1976]: http://archive.6502.org/books/mcs6500_family_hardware_manual.pdf
[nesdev-flags]: https://wiki.nesdev.com/w/index.php/Status_flags
[nw-guide]: http://wiki.nesdev.com/w/index.php/Programming_guide
[nw-optimize]: http://wiki.nesdev.com/w/index.php/6502_assembly_optimisations
[oxyron]: http://www.oxyron.de/html/opcodes02.html
[pm1976]: https://archive.org/details/6500-50a_mcs6500pgmmanjan76
[sw16]: http://amigan.1emu.net/kolsen/programming/sweet16.html
[sw16asm]: https://github.com/cbmeeks/Sweet-16/blob/master/sweet16.asm
[wmcdiff]: http://wilsonminesco.com/NMOS-CMOSdif/
[wmint2.2]: http://wilsonminesco.com/6502interrupts/#2.2
[wmtips]: http://wilsonminesco.com/6502primer/PgmTips.html
