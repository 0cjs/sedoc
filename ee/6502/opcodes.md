6502 Opcode Quickref
====================

This is a quick reference for hand-assembly.

    JSR  RTS  JMP (JMP)      BRK  RTI       NOP
    20₆  60₆  4C₃  6C₅       00₇  40₆       EA₂

    BEQ  BNE  BMI  BPL  BCS  BCC  BVS  BVC
    F0₂₊ D0₂₊ 30₂₊ 10₂₊ B0₂₊ 90₂₊ 70₂₊ 50₂₊

    CLC  SEC  CLV  CLI  SEI  CLD  SED
    18₂  38₂  B8₂  58₂  78₂  D8₂  F8₂

    TAX  TXA  TAY  TYA  TSX  TXS       PHA  PLA  PHP  PLP
    AA₂  8A₂  A8₂  98₂  BA₂  9A₂       48₃  68₃  08₄  28₄

                                   zp  addr zp,X  aaaa,X
    INX  DEX  INY  DEY        INC  E6₅  EE₆  F6₆    FE₆
    E8₂  CA₂  C8₂  88₂        DEC  C6₅  CE₆  D6₆    DE₆

            #nn     zp     addr    zp,X   aaaa,X  aaaa,Y  (zp,X)  (zp),Y
    LDA     A9₂     A5₂     AD₃     B5₄     BD₄₊    B9₄₊    A1₆     B1₅₊
    STA             85₃     8D₄     95₄     9D₅     99₅     81₆     91₆
    LDX     A2₂     A6₃     AE₄     B6₄y            BE₄₊
    STX             86₃     8E₄     96₄y
    LDY     A0₂     A4₃     AC₄     B4₄     BC₄₊
    STY             84₃     8C₄     94₄

            #nn     zp     addr    zp,X   aaaa,X  aaaa,Y  (zp,X)  (zp),Y
    ADC     69₂     65₃     6D₄     75₄     7D₄₊    79₄₊    61₆     71₅₊
    SBC     E9₂     E5₃     ED₄     F5₄     FD₄₊    F9₄₊    E1₆     F1₅₊
    CMP     C9₂     C5₃     CD₄     D5₄     DD₄₊    D9₄₊    C1₆     D1₅₊
    CPX     E0₂     E4₃     EC₄
    CPX     C0₂     C4₃     CC₄

            #nn     zp     addr    zp,X   aaaa,X  aaaa,Y  (zp,X)  (zp),Y
    ORA     09₂     05₃     0D₄     15₄     1D₄₊    19₄₊    01₆     11₅₊
    AND     29₂     25₃     2D₄     35₄     3D₄₊    39₄₊    21₆     31₅₊
    EOR     49₂     45₃     4D₄     55₄     5D₄₊    59₄₊    41₆     51₅₊
    BIT             24₃     2C₄
    ASL     0A₂     06₅     0E₆     16₆     1E₇
    LSR     4A₂     46₅     4E₆     56₆     5E₇
    ROL     2A₂     26₅     2E₆     36₆     3E₇
    ROR     6A₂     66₅     6E₆     76₆     7E₇

Notes:
- Subscripts are cycle counts.
- `n+` subscript indicates an extra cycle for branch taken or page
  boundary crossed (two extra cycles for both).
- Indirect jump does not use an extra cycle on NMOS because (due to
  the bug) it loads MSB of address from _same page_.
- `zp,X` column for `LDX/STX` indexes with Y register
