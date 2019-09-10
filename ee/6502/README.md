MOS Technology 6502
===================

- [Opcodes by addressing mode](opcodes)
- [OUPRG Programmer's card](progcard)


Flags
-----

[Flags][6502flags], bits 7 to 0:

    7  N    negative    BIT, most instrs with a result
    6  V    overflow    CLV; ADC, SBC, BIT
    5  -                0 on push, ignored on pull
    4  -    how stacked 0=I̅R̅Q̅,N̅M̅I̅ 1=PHP,BRK; ignored on PLP/RTI
    3  D    decimal     SED/CLD; no effect on some clones
    2  I    I̅R̅Q̅ mask    SEI/CLI; I̅R̅Q̅, RTI
    1  Z    zero        most instrs with a result
    0  C    carry       SEC/CLC; ADC, SBC, CMP, ASL/LSR/ROL/ROR

- [Status flags: Nesdev wiki][nesdev-flags]


Tips and Tricks
---------------

- Unconditional relative branch (relocatable): `CLC`, `BCC addr`.
  Same size as `JMP` but 2+2 cycles instead of 3.



<!-------------------------------------------------------------------->
[nesdev-flags]: https://wiki.nesdev.com/w/index.php/Status_flags
