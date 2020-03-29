6502 Opcode Quickref
====================

This is a quick reference for hand-assembly.

    JSR  RTS  JMP  (JMP)
     20   60   4C    6C

    BPL  BMI  BVC  BVS  BCC  BCS  BNE  BEQ
     10   30   50   70   90   B0   D0   F0

    TAX  TXA  TAY  TYA  TSX  TXS
     AA   8A   A8   98   BA   9A

           #nn      zp     addr    zp,X   aaaa,X  aaaa,Y  (zp,X)  (zp),Y
    LDA     A9      A5      AD      B5      BD      B9      A1      B1
    STA             85      8D      95      9D      99      81      91
    LDX     A2      A6      AE      B6,Y            BE
    STX             86      8E      96,Y
    LDY     A0      A4      AC      B4      BC
    STY             84      8C      94
