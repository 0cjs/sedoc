- [README](README.md), [asm](asm.md), [opcodes](opcodes.md),
  [progcard](progcard)

6800 Opcode Quickref
====================

This is a quick reference for hand-assembly.

    JMP   JMPx  BRA      JSR   JSRx  BSR   RTS      SWI    WAI   RTI     NOP
     7E₉   6E₈   20₄      BD₉   AD₈   8D₈   39₅      3F₁₂   3E₉   3B₁₀    01₂

      Zero         Negative        Carry       oVerflow
    BEQ   BNE      BMI   BPL     BCS   BCC     BVS   BVC
     27₄   26₄      2B₄   2A₄     25₄   24₄     29₄   28₄
                                A<mem  A≥mem

    /  after  \     unsigned       two's complement
    | CMP CBA |    BLS   BHI     BLT   BLE   BGE   BGT
    \ SUB SBA /     23₄   22₄     2D₄   2F₄   2C₄   2E₄
             lower/same  higher

    CLC   SEC   CLV   SEV   CLI   SEI
     0C₂   0D₂   0A₂   0B₂   0E₂   0F₂

    TAB   TBA   TAP   TPA   TXS   TSX      PSH A  PSH B  PUL A  PUL B
     16₂   17₂   06₂   07₂   35₄   30₄       36₄    37₄    32₄    33₄

             A       B     addr     n,X      X       S
    TST     4D₂     5D₂     7D₆     6D₇
    CLR     4F₂     5F₂     7F₆     6F₇
    COM     43₂     53₂     73₆     63₇
    NEG     40₂     50₂     70₆     60₇
    INC     4C₂     5C₂     7C₆     6C₇     08₄     31₄     (INX,INS)
    DEC     4A₂     5A₂     7A₆     6A₇     09₄     34₄     (DEX,DES)

    ASL     48₂     58₂     78₆     68₇
    ASR     47₂     57₂     77₆     67₇
    LSR     44₂     54₂     74₆     64₇
    ROL     49₂     59₂     79₆     69₇
    ROR     46₂     56₂     76₆     66₇

            #nn     zp     addr     n,X     A←A•B
    SUB A   80₂     90₃     B0₄     A0₅     SBA 10₂
    CMP A   81₂     91₃     B1₄     A1₅     CBA 11₂
    SBC A   82₂     92₃     B2₄     A2₅
    AND A   84₂     94₃     B4₄     A4₅
    BIT A   85₂     95₃     B5₄     A5₅
    LDA A   86₂     96₂     B6₄     A6₅
    STA A           97₄     B7₅     A7₆
    EOR A   88₂     98₃     B8₄     A8₅
    ADC A   89₂     99₃     B9₄     A9₅     DAA 19₂
    ORA A   8A₂     9A₃     BA₄     AA₅
    ADD A   8B₂     9B₃     BB₄     AB₅     ABA 1B₂

            #nn     zp     addr     n,X
    SUB B   C0₂     D0₃     F0₄     E0₅
    CMP B   C1₂     D1₃     F1₄     E1₅
    SBC B   C2₂     D2₃     F2₄     E2₅
    AND B   C4₂     D4₃     F4₄     E4₅
    BIT B   C5₂     D5₃     F5₄     E5₅
    LDA B   C6₂     D6₂     F6₄     E6₅
    STA B           D7₄     F7₅     E7₆
    EOR B   C8₂     D8₃     F8₄     E8₅
    ADC B   C9₂     D9₃     F9₄     E9₅
    ORA B   CA₂     DA₃     FA₄     EA₅
    ADD B   CB₂     DB₃     FB₄     EB₅

            #nnnn   zp     addr     n,X
    CPX     8C₃     9C₄     BC₅     AC₆
    LDS     8E₃     9E₄     BE₅     AE₆
    STS             9F₅     BF₆     AF₇
    LDX     CE₃     DE₄     FE₅     EE₆
    STX             DF₅     FF₆     EF₇

### Notes

- Opcode subscripts are cycle counts.
- Instructions postfixed `x` use _indexed_ addressing mode: add one-byte
  offset argument to X to produce the operand.
- Identical instructions not postfixed `x` use _extended_ addressing mode:
  the address is the following two bytes.


Instruction Groups
------------------

This [Instruction set of 6800][tp-is68] page breaks down the instructions
into groups with counts for each group. These are listed below, along with
the count of instructions from that group currently missing (_msg_) from
the chart above.

    msg tot Group and Mnemonics

            *** Data Transfer
     0   8  LDA  A,B d8,a16,a8,X
     0   6  STA  A,B,a16,a8,X
     0   8  LDS/LDX  d16,a16,a8,X
     0   6  STS/STX  a16,a8,X
     0   4  PSH/PUL  A,B
     0   6  TAB/TBA/TSX/TXS/TAP/TPA

            *** Arithmetic
     2   2  ABA/SBA
    32  32  SBC/SUB/ADC/ADD  A,B,d8,a8,a16,X
     4   4  INS/INX/DES/DEX
     8  16  NEG/CLR/INC/DEC  A,B,a16,X
     1   1  DAA

            *** Logical
    40  40  BIT/CMP/EOR/ORA/AND  A,B,d8,a8,a16,X
    28  28  ROR/ROL/LSR/ASR/ASL/COM/TST  A,B,a16,X
     4   4  CPX  d16,a8,a16,X
     1   1  CBA

            *** Branch
     0   8  BCC/BCS/BEQ/BNE/BMI/BPL/BVC/BVS  r8
     0   2  BHI/BLS  r8
     0   4  BGT/BGE/BLT/BLE  r8
     0   2  BRA/BSR  r8
     0   4  JMP/JSR  a16,X
     0   2  RTS/RTI
     0   1  SWI

            *** Miscellaneous
     0   1  WAI
     0   1  NOP
     0   6  CLC/SEC/CLI/SEI/CLV/SEV



<!-------------------------------------------------------------------->
[tp-is68]: https://www.tutorialspoint.com/instruction-set-of-6800
