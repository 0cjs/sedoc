Motorola 6809 / Hitachi 6309
============================

Condition code (CC) byte:

    7  E  entire register state stacked
    6  F  FIRQ masked
    5  H  half-carry
    4  I  IRQ masked
    3  N  negative result (two's complement)
    2  Z  zero result
    1  V  overflow
    0  C  carry flag (also set for borrow)

Vectors:

    FFF0    Reserved (6309: divide/0 and illegal instruction error)
    FFF2    SWI3
    FFF4    SWI2
    FFF6    FIRQ
    FFF8    IRQ
    FFFA    SWI
    FFFC    NMI
    FFFE    Reset
