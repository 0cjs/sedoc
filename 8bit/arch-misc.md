Misc. Architecture Descriptions
===============================

While retrocomputing, many of these are not 8-bit.


PDP-1
-----

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

PDP-8
-----

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


PDP-10
------

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
