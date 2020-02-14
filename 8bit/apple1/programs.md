Apple-1 Test Programs
=====================

#### Print Character Set

From page 2 of the manual, print out full character set (only CR and
space through `_` print):

    0000  A9 00             LDA #00
    0002  AA                TAX
    0003  20 EF FF          JSR $FFEF   ; ECHO
    0006  E8                INX
    0007  8A                TXA
    0008  4C 02 00          JMP $0002

#### Print Partial Charset

First char at $0301; last char + 1 at $0308.

    0300  A2 A0     start   LDX #A0     ; space
    0302  8A        next    TXA
    0303  20 EF FF          JSR $FFEF   ; ECHO
    0306  E8                INX
    0307  E0 E0             CPX #E0     ; underscore + 1
    0309  90 F7             BCC $0302
    030B  B0 F3             BCS $0300
