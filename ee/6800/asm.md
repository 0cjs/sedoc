6800 Assembler Syntax
=====================

### References

- [M6800 Programming Reference Manual][6800ref] M68PRM(D), Motorola, Nov. 1976.

### Registers

- `A`, `B`: 8-bit accumulators (no `D` on 6800/02)
- `X` (`IX`): 16-bit index register
- `SP`: Stack pointer, points to next "empty" location; `TSX`=`X←SP+1`
- `PC`: Program counter
- `CCR`: Condition code register: `11HINZVC`
  - Half carry: set on b3→b4 carry for `ADD`, `ABA`, `ADC`
  - Interrupt mask (blocked if set)
  - Negative: high order bit of result
  - Zero, oVerflow, Carry-Borrow

### Instruction Set Notes

- Both 2s-complement `NEG` and 1s-complement `COM` available.
- `COMA` sets carry; `EORA $FF` does not.
- `LDAA $1234` can test memory w/o clearing carry like `TST $1234`.
- `CLR`/`CLRA`/`CLRB` to zero mem/reg clears carry; `LDAA #0` does not.
- `INC`/`DEC` do not affect carry.
- 8-bit rotate: `ASLA` / `BCC *+3` / `INCA`.
- `TSX` increments when xfering; `TXS` decrements when xfering;
  and remember interrupts when manipulating stack via `X`!
- Signed uses V-bit branches (`BGT`), unsigned ignores V-bit (`BHI`).
- `CPX` doesn't work w/all branches until 6801.

### Branch Tests

- Single Flag:
  - Zero: `BEQ` `BNE`
  - Negative: `BMI` `BPL`
  - Carry: `BCS` `BCC`
  - oVerflow: `BVS` `BVC`
- Multi-flag comparison results:
  - Unsigned: `BLS` (less-than/same) `BHI`
  - Two's complement: `BLT` `BLE` `BGE` `BGT`

### Operands

Value annotations:
- `97`: decimal
- `$61`: hexadecimal
- `%01100001`: binary
- `'a`: ASCII character
- `@171`: octal
- `*`: current location

Addressing Modes:
- `#$0C`: immediate operand

The [Motorola assembler][masm] always uses extended (two byte)
addressing mode for forward references, but will choose the shorter of
extended or direct (one-byte) for backward references.

Relative addresses (for `BRA` etc.) are -128 through +127 from the
location of the following instruction, i.e., `BRA` to a relative
address of zero executes the next instruction.

Indexed addressing on 6800/01/02/03 is always a single byte constant
offset (the operand) added to the X register:

      E3 00         ADDA    X
      E3 00         ADDA    ,X
      E3 00         ADDA    0,X
      E3 04         ADDA    4,X


6801/03 Extensions over 6800/02
-----------------------------------

- 6801/03 changes some instruction timings.
- "D" register is concatenation of A, B.
- Complete [6801/03 instruction table][6801inst]

    D register:
      LDD, STD
      ADDD          D ← D + mem, no carry
      SUBD          D ← D - mem
      ASLD/LSLD     LSB ← 0, Carry ← MSB
      LSRD          MSB ← 0, Carry ← LSB
      LSL           Same as ASL (memory or either accumulator)
    X register:
      ABX           B ← X + B
      PSHX, PULX
    Branches:
      BHS       Branch higher or same, = BCC
      BLO       Branch lower, = BCS
      BRN       Branch never
      JSR       Additional direct (1-byte operand) addressing mode.
    Miscellaneous:
      MUL       D ← A * B (unsigned)
      CPX       Compare X now works with any conditional branch instr.


<!-------------------------------------------------------------------->
[6800ref]: https://archive.org/stream/bitsavers_motorola68rammingReferenceManualM68PRMDNov76_6944968#page/n0/mode/1up
[6801inst]: https://archive.org/stream/bitsavers_motorola68ReferenceManualMay84_19173732#page/n98/mode/1up
[masm]: https://archive.org/details/bitsavers_motorola68ReferenceManualMay84_19173732/page/n91
