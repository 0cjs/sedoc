TD-4 4-Bit CPU
==============

References:
- [CPUの創りかた]: The book describing the CPU.
- [wuxx clone][wuux] (CN), as sold by AliExpress.


    MOV A, Im   A ← v
    MOV B, Im   MOVE Im to B register
    MOV A, B    MOVE A register to B register
    MOV B, A    MOVE B register to A register
    ADD A, Im   ADD Im to A register
    ADD B, Im   ADD Im to B register
    IN A        copy input port to A register
    IN B        copy input port to B register
    OUT Im      copy Im to output register
    OUT B       copy B register to output port
    JMP Im      Jump to Im
    JNC Im      Jump to Im if C flag is not 1


Registers and Instruction Set
-----------------------------

    r=0     A   register
    r=1     B   register
           IN   input switches
          OUT   ouput LEDs
           PC   program counter

    1234 5678   LSBit – MSBit

    nnnn 0000  add  A ← A + nnnn
    0000 1000  mov  A ← B
    nnnn 1000
    0000 0100  mov  A ← IN
    nnnn 0100
    nnnn 1100  mov  A ← nnnn
    0000 0010  mov  B ← A
    nnnn 0010
    nnnn 1010  add  B ← B + nnnn
    0000 1110  mov  B ← IN
    nnnn 1110  mov  B ← nnnn
    0000 1001  mov  OUT ← B
    nnnn 1001
    nnnn 1101  mov  OUT ← nnnn
    nnnn 0111  jmp  PC ← nnnn IF Cy ≠ 0
    nnnn 1111  jmp  PC ← nnnn


Layout and Pinout
-----------------

    U3      U4      U5      U6
    U7      U8      U9      U1
    U11     U10     LEDs    switches
    U2

### Clock and Reset

    swCLK   R3,R1    C1         R7,R2
            ───── U2 ─────      R10,R11
    swRST   R4,8,9  C2,C3       R5,R6

- `U2` '14 hex inverter:
  - clock on any register (U3,4,5,6) pin 2
    - manual clock: switch → … → U2.13/12 → 10
    - auto clock output through R11
      - auto clock C3 → R2 -> 11/10 → 9/8 → C3
  - reset: button → R8 → R9 → 3/4 → 5/6 → RESET bus

### Registers: '161 presettable 4-bit counters

16 Pins: `C̅L̅R̅ CLK A B C D ENP GND ‥ L̅O̅A̅D̅ ENT Qd Qc Qb Qa RCO Vcc`
Outputs: LSB 14,13,12,11 MSB

    U3/A  U4/B  U5/OUT  U6/PC

### ALU: '283 


<!-------------------------------------------------------------------->
[wuux]: https://github.com/wuxx/TD4-4BIT-CPU/
[CPUの創りかた]: https://www.amazon.co.jp/CPUの創りかた-渡波-郁/dp/4839909865/
