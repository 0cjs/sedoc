Misc. Architecture Descriptions
===============================

While retrocomputing, many of these are not 8-bit.


PDP-1 (1959)
------------

- 18-bit, 1's complement, bit 0 (MSB) is sign.
- Registers:
  - 18-bit accumulator
  - Overflow flip-flop
  - Program flags 1-6 (mainly I/O related)
  - In-Out Register
- Addrs: 4096 (2^12) words × 18 bits (expandable to 65K words)
- Instructions are memory refrence (below) or agumented (5‥17 contain
  further operation information).

                  ↓── 1=indirect through address
      operation | I | address
          0 ‥ 4 | 5 | 6 . . . . . . . . . . 17

PDP-8 (1965)
------------

- 12 bit, 2's complement, bit 0 MSB
- Registers:
  - 12-bit program counter `PC`
  - 12-bit accumulator `AC`.
  - 1-bit carry flag: link register `L`
- Addrs: 4096 (2^12) words × 12 bits (32 × 128 word pages)
  - Locations 010-017 auto-increment on indirect ref through them
- Single-word instructions that may access memory only in page 0 or page
  into which the PC points:

                           0 . 2 | 3 | 4 | 5 . . . . . 11
                       operation | I | Z | offset (address)
      indirect through address=1 ──↑   ↑ addr 0‥4: 0=0000, 1=PC 0‥4

Basic instructions:

    000  AND  AC ← AC ∧ [addr]
    001  TAD  (L,AC) ← AC + [addr]   (two's complement add)
    010  ISZ  [addr] ← [addr] + 1; [addr] = 0 → skip next instruction
    011  DCA  [addr] ← AC; AC ← 0
    100  JMS  [addr] ← PC; PC ← addr + 1   (jump to subroutine)
    101  JMP  PC ← addr
    110  IOT  input/output transfer (bits 3‥8 device, 9‥11 function)
    111  OPR  microcoded operation (b3=0, b4‥11 operation)


PDP-10 (1966)
-------------

- 36-bit, 2's complement, bit 0 MSB
- Registers:
  - `AC0` (cannot be used for indexing)
  - `AC1`-`AC7`,`AC10`-`AC17` (right half can be used for indexing, left
    half is often "count")
  - Program counter `PC` (bits 18-35 of PC word)
  - Condition flags (bits 0-12 of PC word)
- Addrs 256 K (2^18) words × 36 bits
- Instructions

         | 0 .. 8 |  9 .. 12 | 13 | 14 .. 17 | 18 .. 35 |
         | opcode | register |  I |  effective address  |
            indir. through EA=1 ↑ | register |  offset  |


Data General Nova (1969)
------------------------

- 16-bit
- Simple load/store design
- Registers: 4 accumulators (to compensate for lack of addressing modes)


PDP-11 (1970)
-------------

- 16-bit, 2's complement, bit 15 MSB, byte-oriented, little-endian
- Registers: `R0`-`R7` (R6=SP, R7=PC), condition codes N Z V C

Instruction formats:
- No I/O instructions; memory-mapped I/O.
- Index addressing modes are followed by 1 or 2 words giving index `m`.

      | 15 ─── 12 | 11 ─ 9 | 8 ─ 6 | 5 ── 3 | 2 ─ 0 |
      |  opcode   |  mode  |  reg  |  mode  |  reg  |
      |           |     source     |   destination  |  2-operand
      |          opcode            |                |  1-operand

      | 15  ──────────── 9 | 8 | 7 ────────────── 0 |  branch
      |        opcode      | C |    signed offset   |  C = condition code value

      JSR Rn,addr: (SP--) ← Rn; Rn ← PC; PC ← addr
      RTS Rn     : PC ← Rn; Rn ← (SP++)

      Various other forms left out.

Addressing modes (3 bit `mode`s above):

    0     Rn    REGISTER (operand in Rn)
    1    (Rn)   REGISTER DEFERRED (indirect; Rn points to operand)
    2    (Rn)+  AUTOINCREMENT (Rn points to operand; Rn +1/+2 after use)
    3   @(Rn)+  AUTOINCREMENT DEFERRED
                (Rn points to memory pointer to operand; Rn +2 after use)
    4   -(Rn)   AUTODECREMENT (Rn -1/-2 before use; Rn points to operand)
    5  @-(Rn)   AUTODECREMENT DEFERRED
                (Rn -2 before use; Rn points to memory pointer to operand)
    6   m(rn)   INDEX (Rn+m points to operand, m from 2nd/3rd word of instr)
    6  @m(rn)   INDEX DEFERRED (Rn+m points to memory pointer to operand;
                m from 2nd/3rd word of instr)

References:
- Wikipedia, [PDP-11 architecture][11arch]


[11arch]: https://en.wikipedia.org/wiki/PDP-11_architecture
