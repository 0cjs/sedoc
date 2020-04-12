Apple II Disk Hardware and I/O
==============================

References:
- [bad] Don Worth and Pieter Lechner, [_Beneath Apple DOS_][bad] (1981).
- [tdm] Apple Computer Inc., [_Apple II: The DOS Manual_][tdm] (1981).
- [a2ref] Apple Computer Inc., [_Apple II Reference Manual_][a2ref],
  1979 edition.
- [ua2] Jim Sather, [_Understanding the Apple II_][ua2] Chapter 9 (1983)


Disk II Controller
------------------

### I/O Addresses

"Hardware Addresses" [bad 6-2]. I/O addresses are $C080 - $C08F for
slot 0; add slot number × 16 for other slots. Typically done by
loading X with slot number << 4 and using `$C080,X` addressing mode.
Addresses below are hardcoded for slot 6.

    C0E0  49280  s  PHASEOFF: Stepper motor phase 0 off
    C0E1  49281  s  PHASEON: Stepper motor phase 0 on
    C0E2  49282  s  PHASE1OFF
    C0E3  49283  s  PHASE1ON
    C0E4  49284  s  PHASE2OFF
    C0E5  49285  s  PHASE2ON
    C0E6  49286  s  PHASE3OFF
    C0E7  49287  s  PHASE3ON
    C0E8  49288  s  MOTOROFF: Drive motor off
    C0E9  49289  s  MOTORON: Drive motor on
    C0EA  49290  s  DRIVE0EN: Select drive 1
    C0EB  49291  s  DRIVE1EN: Select drive 2
    C0EC  49292     Q6L: Strobe data latch for I/O  (P6A A2 low)
    C0ED  49293     Q6H: Load data latch            (P6A A2 high)
    C0EE  49294     Q7L: Prepare latch for input    (P6A A3 low)
    C0EF  49295     Q7H: Parepare latch for output  (P6A A3 high)

#### Drive Hardware Direct Access

Examples from [bad 6-3]:

            LDA $C088,X     ; turn motor off
            LDA $C089,X     ; turn motor on

    ;   sense write protect
            LDA $C08D,X     ; set Q6 high
            LDA $C08E,X     ; set Q7 low, read shift register
            BMI protected   ; protected if high bit set

    ;   read a byte
    read    LDA $C08C,X     ; set Q6 low to strobe data input; read shift reg
            BPL READ        ; not valid until 1 shifted into bit 7

### Controller Hardware Design (schematic: [tdm 145])

#### Apple II bus interface ([a2ref 80], [a2ref 106]):

- `R̅E̅S̅`: System power-on reset.
- `I̅O̅S̅E̅L̅`: "I/O" ROM select; low when $Cnxx (_n_ = slot #) referenced.
- `D̅E̅V̅`: Device select; low when $C0nx (_n_ = slot # + 8) referenced.
- `AD0`-`AD7`: low bits of address bus, buffered by P5AD3.
- `DA0`-`DA7`: data bus.
- `Q3`: 2 MHz asymmetrical clock (300 ns high, 200 low [a2ref 91])

#### ICs and Logic (see also [7400 summaries]):

- P5A (P5AD3): [6309] 256×8 PROM, selected by `I̅O̅S̅E̅L̅`.
  - Output to data bus and C3 shift register parallel inputs.
  - `AD0…AD7` are pins 6…9,14…11 of the chip (the schematic correctly
    labels data bus lines as `D0…D7`); `D4…D7` are reversed from the
    [standard `O5…O8`][6309] numbering of the PROM.
  - I can't tell from the schematic or board images, so I'm assuming
    that shift register I/O `H…A` map directly to `AD0…AD7`, though
    this could be wrong.
- C3 [74LS323]: 8-bit universal shift storage register (sync clear).
  - Selected by `D̅E̅V̅` and `AD0` low.
  - `SL` (low shift input), `S1,S0` (mode select) and `C̅L̅R̅` from P6A
    `D2,D0,D1,D3`.
  - `S0`: Wired-AND of P6A `D1` and MOTOR ON (through 2× '05 open
    collector inverter gates).

- P6A (B3): [6309] 256×8 PROM (always selected) used for controller
  state machine.

- A3 [74LS174] hex D flip-flop, async clear.
 - `C̅L̅R̅` (R): asserted when not MOTOR ON
 - `CLK` (CP): input from `Q3` (2 MHz) qualified by MOTOR ON.
 - `4D` (D4) input from read head signal pulses (see analog board below).

- C2 [74LS259] ("9334"): addressable 8×1bit latch, enabled by `D̅E̅V̅`,
  cleared by `R̅E̅S̅`. Decodes device I/O address access, `A3…A0` →
  `CBAD` (S2,S1,S0,D), matching I/O addreses above. Outputs:
  - Q0…Q3: Stepper motor lines Φ₀…Φ₃.
  - Q4: Motor on line.
  - Q5: Drive select line (into 74LS132).

- A2 74LS132: Quad NAND gate, schmitt trigger.
  - 1,2   →  3: Q3 clock pulse to '323, qualified by MOTOR ON.
  - 4,5   →  6: drive select qualified by MOTOR ON to `E̅N̅B̅L̅ ̅2̅` on drive connector.
  - 9,10  →  8: drive select qualified by MOTOR ON to `E̅N̅B̅L̅ ̅1̅` on drive connector.
  - 12,13 → 11: A3 '174 Q3,Q4 outputs to P6A `A4`.

#### Theory of Operation

The MOTOR ON signal follows Q4 from C2 '259, with a delay on power
off. The delay is produced by inverting Q4 and passing it through D2
½556 (inverting it again). It qualifies many other signals below.

The state machine (also known as the Woz machine, later turned into
the IWM chip) is run by the P6A ROM and the six '174 flip-flops. It's
clocked by the 2 MHz `Q3` signal from the bus interface, enabled by
MOTOR ON.

The P6A ROM inputs are `A0…A7`, and outputs here relabeled `RD0…RD7`.
The '174 flip-flops' inputs are here relabeled `F0…F5`, and outputs
are `Q0…Q5`.
- `A2…A3` from C2 `Q6…Q7`, corresponding to addrs $C08C…$C08F.
- `Q4` → `F3`, `A4`.
- `RD4…RD7` → `F2,F5,F1,F0`.
- `Q0` → `A7`, `WR DATA`
- `Q1,Q2,Q5` → `A6,A5,A0`
- `QA'` shift register low bit output → `A1`

The state machine shifts data into the shift register via:
- `SR` (high bit H to low bit A) from `W PROT` line from drive. This is
   triggered by setting Q6=1 Q7=0.
- `SL` (low bit A to high bit H) from `RD2`.

### Drive Analog Board (schematic: [tdm 146])

This attaches to a Shugart SA390, replacing the standard logic board
supplied with an SA400. The core is an [MC3470] Floppy Disk
Read-Amplifier Systems chip (B1). It was designed by Rod Holt, Apple
employee #5.

The differential R/W signals from the drive head are sent to the
amplifer inputs (MC3470 pins 1 and 2). For each peak of the input
signal, the MC3470 generates a pulse of configured length (150-1000 ns
via R/C networks on pins 6-9) on the data output (pin 10). This is
buffered and sent to `RD DATA` on the controller board when the
drive's `E̅N̅B̅L̅` input is asserted. (`RD DATA` is marked as positive
logic on the controller board schematic, but negative logic,
`R̅D̅ ̅D̅A̅T̅A̅`, on the analog board schematic.)


<!-------------------------------------------------------------------->
[a2ref]: https://archive.org/details/Apple_II_Reference_Manual_1979_Apple
[bad]: https://archive.org/details/Beneath_Apple_DOS_OCR/page/n2/mode/1up
[tdm]: https://archive.org/stream/The_DOS_Manual_HQ#page/n3/mode/1up
[ua2]: https://archive.org/stream/Understanding_the_Apple_II_1983_Quality_Software#page/n230/mode/1up

[6309]: https://archive.org/stream/6309PROM#page/n1/mode/1up
[7400 summaries]: ../../ee/7400.md
[74LS174]: https://www.ti.com/lit/ds/symlink/sn74s175.pdf
[74LS259]: https://www.ti.com/lit/ds/symlink/sn74ls259b.pdf
[74LS323]: https://www.ti.com/lit/ds/symlink/sn54ls323.pdf
[MC3470]: http://www.applelogic.org/files/MC3470.pdf


[a2ref 106]: https://archive.org/stream/Apple_II_Reference_Manual_1979_Apple#page/n116/mode/1up
[a2ref 80]: https://archive.org/stream/Apple_II_Reference_Manual_1979_Apple#page/n90/mode/1up
[a2ref 91]: https://archive.org/stream/Apple_II_Reference_Manual_1979_Apple#page/n101/mode/1up
[bad 6-2]: https://archive.org/stream/Beneath_Apple_DOS_OCR#page/n62/mode/1up
[bad 6-3]: https://archive.org/stream/Beneath_Apple_DOS_OCR#page/n63/mode/1up
[tdm 145]: https://archive.org/stream/The_DOS_Manual_HQ#page/n156/mode/1up
[tdm 146]: https://archive.org/stream/The_DOS_Manual_HQ#page/n157/mode/1up
