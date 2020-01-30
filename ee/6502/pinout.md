6602 Pinouts
============

Minimum NMOS/early CMOS hookup.

      GND    Power   Clock   PullDown   PullUp
    ------------------------------------------------------------
     1 Vss
                                         2 RDY
                                         4 /IRQ
                                         6 /NMI
             8 Vcc
    21 Vss
                     37 Φ0
                                        40 /RESET

XXX Add pin 1 change, `BE`, etc. for CMOS that have it.

`NOP` opcode `EA` for data pins:

    26 27 28 29 30 31 32 33
     ↑  ↑  ↑  _  ↑  _  ↑  _

#### NMOS

This is from [`progcard`](progcard), not verified with data sheet and
probably has some errors.

           +---__---+
       Vss | 1    40| /RES  ←
    →  RDY | 2    39| CLK2 →
    ← CLK1 | 3    38| SOB
    →  IRQ | 4    37| CLK0 ←
        NC | 5    36| NC
    →  NMI | 6    35| NC
    ← SYNC | 7    34| R/W  →
       Vcc | 8    33| DB0  ↔
    ←   A0 | 9    32| DB1  ↔
    ←   A1 |10    31| DB2  ↔
    ←   A2 |11    30| DB3  ↔
    ←   A3 |12    29| DB4  ↔
    ←   A4 |13    28| DB5  ↔
    ←   A5 |14    27| DB6  ↔
    ←   A6 |15    26| DB7  ↔
    ←   A7 |16    25| A15  →
    ←   A8 |17    24| A14  →
    ←   A9 |18    23| A13  →
    ←  A10 |19    22| A12  →
    ←  A11 |20    21| Vss
           +--------+

#### Rockwell R65C02

[Data sheet][rock].

           +---__---+
       Vss | 1    40| /RES ←
    →  RDY | 2    39| Φ2   →
    ←   Φ1 | 3    38| /SO
    → /IRQ | 4    37| Φ0   ←
        NC | 5    36| NC        (BE for '102 and '112)
    → /NMI | 6    35| NC
    ← SYNC | 7    34| R/W̅  →
       Vcc | 8    33| DB0  ↔
    ←   A0 | 9    32| DB1  ↔
    ←   A1 |10    31| DB2  ↔
    ←   A2 |11    30| DB3  ↔
    ←   A3 |12    29| DB4  ↔
    ←   A4 |13    28| DB5  ↔
    ←   A5 |14    27| DB6  ↔
    ←   A6 |15    26| DB7  ↔
    ←   A7 |16    25| A15  →
    ←   A8 |17    24| A14  →
    ←   A9 |18    23| A13  →
    ←  A10 |19    22| A12  →
    ←  A11 |20    21| Vss
           +--------+



<!-------------------------------------------------------------------->
[rock]: http://archive.6502.org/datasheets/rockwell_r65c00_microprocessors.pdf
