Apple II Mini-Programs
======================


Screen Code Display
-------------------

    10 TEXT : HOME : VTAB 10
    20 FOR R = 0 TO 7
    30 FOR C = 0 TO 31
    40 POKE R * 128 + 1024 + C,R * 32 + C
    50 NEXT C, R
