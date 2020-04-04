6502 Opcode Quickref
====================

This is a quick reference for hand-assembly.

    JSR  RTS  JMP (JMP)      BRK  RTI       NOP
     20   60   4C   6C        00   40        EA

    BEQ  BNE  BMI  BPL  BCS  BCC  BVS  BVC
     F0   D0   30   10   B0   90   70   50

    CLC  SEC  CLV  CLI  SEI  CLD  SED
     18   38   B8   58   78   D8   F8

    TAX  TXA  TAY  TYA  TSX  TXS       PHA  PLA  PHP  PLP
     AA   8A   A8   98   BA   9A        48   68   08   28

                                   zp  addr zp,X  aaaa,X
    INX  DEX  INY  DEY        INC  E6   EE   F6     FE
     E8   CA   C8   88        DEC  C6   CE   D6     DE

           #nn      zp     addr    zp,X   aaaa,X  aaaa,Y  (zp,X)  (zp),Y
    LDA     A9      A5      AD      B5      BD      B9      A1      B1
    STA             85      8D      95      9D      99      81      91
    LDX     A2      A6      AE      B6,Y            BE
    STX             86      8E      96,Y
    LDY     A0      A4      AC      B4      BC
    STY             84      8C      94

           #nn      zp     addr    zp,X   aaaa,X  aaaa,Y  (zp,X)  (zp),Y
    ADC     69      65      6D      75      7D      79      61      71
    SBC     E9      E5      ED      F5      FD      F9      E1      F1
    CMP     C9      C5      CD      D5      DD      D9      C1      D1
    CPX     E0      E4      EC
    CPX     C0      C4      CC

           #nn      zp     addr    zp,X   aaaa,X  aaaa,Y  (zp,X)  (zp),Y
    ORA     09      05      0D      15      1D      19      01      11
    AND     29      25      2D      35      3D      39      21      31
    EOR     49      45      4D      55      5D      59      41      51
    BIT             24      2C
    ASL     0A      06      0E      16      1E
    LSR     4A      46      4E      56      5E
    ROL     2A      26      2E      36      3E
    ROR     6A      66      6E      76      7E
