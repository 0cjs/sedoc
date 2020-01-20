Apple-1 Test Programs
=====================

#### Print Character Set

From page 2 of the manual, print out full character set (only CR and
space through `_` print):

    0000  A9 00             LDA #00
    0002  AA                TAX
    0003  20 EF FF          JSR $FFEF   ; ECHO
    0006  E8                INX
    007   8A                TXA
    0008  4C 02 00          JMP $0002
