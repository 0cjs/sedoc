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

    unsigned         two's complement
    BLS   BHI      BLT   BLE   BGE   BGT
     23₄   22₄      2D₄   2F₄   2C₄   2E₄

    CLC   SEC   CLV   SEV   CLI   SEI
     0C₂   0D₂   0A₂   0B₂   0E₂   0F₂

    TAB   TBA   TAP   TPA   TXS   TSX      PSH A  PSH B  PUL A  PUL B
     16₂   17₂   06₂   07₂   35₄   30₄       36₄    37₄    32₄    33₄

            #nn     zp     addr     n,X
    LDA A   86₂     96₂     B6₄     A6₅
    STA A           97₄     B7₅     A7₆
    LDA B   C6₂     D6₂     F6₄     E6₅
    STA B           D7₄     F7₅     E7₆
    LDX     CE₃     DE₄     FE₅     EE₆
    STX             DF₅     FF₆     EF₇
    LDS     8E₃     9E₄     BE₅     AE₆
    STS             9F₅     BF₆     AF₇

               INC A  INC B   INX   INS   INC   INCx
    increment    4C₂    5C₂    08₄   31₄   7C₆   6C₇
    decrement    4A₂    5A₂    09₄   34₄   7A₆   6A₇
               DEC A  DEC B   DEX   DES   DEC₁  DECx

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
