6800 Opcode Quickref
====================

This is a quick reference for hand-assembly.

    JMPᵢ  JMPₓ  BRA      JSRᵢ  JSRₓ  BSR   RTS      SWI   RTI      NOP
     BD₉   AD₈   20₄      BD₉   AD₈   8D₈   39₅      3F₁₂  3B₁₀     01₂

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

### Notes

- Instruction subscripts:
  - `i`: Immediate argument
  - `x`: [X] plus one-byte offset
- Opcode subscripts are cycle counts.
