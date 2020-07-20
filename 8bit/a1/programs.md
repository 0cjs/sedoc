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

#### Check for ROR Bug

[By Chromatix](http://forum.6502.org/viewtopic.php?f=3&t=5643#p73970).

    0300 A9 0D                  LDA #$0D    ; CR
    0302 20 EF FF               JSR $FFEF   ; ECHO
    0305 A9 01                  LDA #01
    0307 18                     CLC
    0308 6A                     ROR
    0309 A2 00                  LDX #0
    030B B0 02                  BCS pmesg
    030D A2 03                  LDX #3
    030F BD 1D 03       pmesg   LDA $31D,X
    0312 20 EF FF               JSR $FFEF
    0315 E8                     INX
    0316 C9 00                  CMP #0
    0318 D0 F5                  BNE pmesg
    031A 4C 1F FF               JMP FF1F    ; enter monitor
    031D 4E 4F 20               DB  "NO "
    0320 52 4F 52 20            DB  "ROR BUG",0
    0324 42 55 47 00

    0300: A9 0D 20 EF FF A9 01 18 6A A2 00 B0 02 A2 03 BD
        : 1D 03 20 EF FF E8 C9 00 D0 F5 4C 1F FF 4E 4F 20
        : 52 4F 52 20 42 55 47 00
