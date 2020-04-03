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

#### Pinout Diagram

Also see [families](families.md) for further information on variants.

      W65C02           NMOS/R65C02          W65C02
                       +---__---+
         /VP       Vss | 1    40| /RES ←
                →  RDY | 2    39| Φ2   →
                ←   Φ1 | 3    38| /SO  ←
                → /IRQ | 4    37| Φ0   ←    Φ2in
         /ML        NC | 5    36| NC        BE ('102, '112 also)
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

References:
- [Image][multipinimg] by [Dr Jefyll][multipin]
- [Rockwell R65C02 data sheet][rock]

Do not use [`progcard`](progcard); it has several errors.


Variants
--------

See the [Mock-A-65xx_Pins PDF](Mock-A-65xx_Pins.pdf) file (from forum64.de
[MockA65xx - Universal MOS 65xx / 85xx CPU replacement][mock65]; see second
post for English, and also discussed on [forum.6502.org][mock65f6o]) for
pinouts for the following Commodore parts:
- 6502: PET
- 6508: C900 FDC
- 6509: P500, P6x0/7x0
- 6510/8500: C64
- 6510T: 1551 FDC
- 8501: C16, Plus/4
- 8502: C128

#### 6510

The [6510] includes a PIA and has a substantially different pinout. It
came in several variations; below is the most common. We give the 6809
pin, the 6502 pin that originally had that signal (if it was moved),
the 6510 function, and the function that from the 6502 that was
replaced.

    Pin MvFr  6510          Replaces    Notes
     1   39   Φ0 (CLKIN)    Vss, /VP
     2    2   /HALT         READY       Same signal; changed name/active level
     3    4   /IRQ          Φ1 out
     4    6   /NMI          /IRQ
     5    -   AEC           NC          Address bus enable; otherwise tri-state
     6    8   Vcc           NMI
     7    9   A0            SYNC
     ~~~ 8…20 are A1…A13 ~~~
     21  21   GND           GND
     22  24   A14
     23  25   A15
     24   -   P5                        PIA I/O 5
     ...
     29   -   P0                        PIA I/O 0
     30  26   D7
     ...
     37  33   D0
     38  34   R/W̅



<!-------------------------------------------------------------------->
[6510]: https://en.wikipedia.org/wiki/MOS_Technology_6510
[mock65]: https://www.forum64.de/index.php?thread/84266-mocka65xx-universeller-mos-65xx-85xx-cpu-ersatz/
[mock65f6o]: http://forum.6502.org/viewtopic.php?f=1&t=5347
[multipin]: http://forum.6502.org/viewtopic.php?f=4&t=6027#p73889
[multipinimg]: http://forum.6502.org/download/file.php?id=9416&mode=view
[rock]: http://archive.6502.org/datasheets/rockwell_r65c00_microprocessors.pdf
