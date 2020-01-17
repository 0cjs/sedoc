Apple I Notes
=============

- [_Apple I Manual_][a1man].

Memory Map
----------

### I/O ports

    $D010   KBD: keyboard input register. Valid when KBDCR bit 7 is 1.
            Reads clear KBDCR bit 7.
    $D011   KBDCR: Bit 7 cleared when KBD is read; set when keyboard
            key pressed.
    $D012   DSP: when bit 7 is 0, write bits 0-6 to output char and
            set bit 7.
    $D013   DSPCR: control register for output; init'd by WozMon


ROM Software
------------

### ROM Routines

    $E000   Woz BASIC entry point (`E000R` to run)
    $E2B3   Woz BASIC warm entry point (preserves existing program)
    $FF1F   GETLINE: Monitor entry point (CALL -225 from BASIC)
    $FFEF   ECHO: Print char in A to terminal
    $FFDC   PRBYTE: Print value in A as two hex digits
    $FFE5   PRHEX: Print lower nybble of A as a single hex digit

### Woz Monitor

- SB-Projects, [The Woz Monitor][sbp-wozmon].
- Jeff Tranter, [Woz Monitor Source Code][jt-wozmon]

Multiple commands may be given in sequence (numbers must be separated
with spaces); the current location _curloc_ will be used when not
being set.

- _nnnn_: Examine byte value at _nnnn_ and set _curloc_ = _nnnn_+1.
- _.nnnn_: Examine byte values in range _curloc_ through _nnnn_ (eight
  bytes per line); set _curloc_ = _nnnn_+1. Often preceeded by address
  to set/examine _curloc_ above, e.g., _mmmm.nnnn_.
- _nnnn: aa bb ..._: Deposit starting at _nnnn_ bytes _aa_, _bb_,
  etc., set _curloc_ = last loc. deposited + 1, and print previous
  value at _nnnn_.
- _R_: "Run," `JMP` (not `JSR`) to _curloc_. Return to monitor with
  `JMP $FF1F`.

### Woz BASIC

- SB-Projects, ["The Apple 1 Basic"][sbp-basic]


Video Circuit
-------------

Schematic on second-last page of the [Apple I Manual][a1man].

Parts included:
- [555] timer
- 2504 possibly RAM? (?×)
- 2513 character ROM (1×)
- [2519] hex 40-bit shift register (1×)
- [74157] quad 2-line to 1-line data selector/multiplexer (2×)
- [74161] 4-bit binary counters (5×, plus one decade 74160)
- [74166] parallel load 8-bit shift register (1×)
- [74174] hex D flip-flop, common asynchronous clear (1×)
- DS0025 ??? (1×)
- Lots of AND/OR/etc. gates
- 14.31818 Mhz crystal


RC6502 Apple I Replica SBC
--------------------------

Details in [this GitHub project][1rep-sbc].

Revision F+ board jumpers are marked on back with a box around the
pins that enable.

- `OSC_EN`: Closed, links pin 8 (OUT) of oscillator to `CLOCK` line.
  Close to use onboard clock.
- `VP GND`: Closed, pin 1 of CPU floating, otherwise grounds it. Close
  for UM6502, SY6502, R65C02. Open for WD65C02. (From silk screen
  under CPU socket; confirmed with early MOS hardware manual that pin
  one is Vss on original 6502.)
- `PIA_EN`: Center pin is PIA `CS1`. Bottom pin is ground (disable),
  top pin is Vcc (enable).
- `RAM_EN`: Center pin is RAM `C̅S̅` and `O̅E̅` pins. Left is ground
  (enable) right is Vcc (disable).
- `ROM_EN`: Center pin is ROM `C̅E̅` and `O̅E̅` pins. (Rev. B schematic
  uses negative logic marker instead of overbar.) Bottom is Vcc
  (disable), top is ground (enable).
- `A14_W`, `A13_W`: Middle pin to `A14`, `A13` of ROM (there are no
  other connections to these address lines). Allows choice of the four
  8K "banks" in the 32K ROM. Left pin Vcc. Right pin ground. Both to
  ground for first bank.

Communications are at 115,200 bps. At startup or when the Arduino is
reset it will print `RC6502 Apple 1 Replica`.

#### ICs and Pinouts

- [555] timer
- [HM62256BLP][62256] 32K×8 SRAM
- [AT28C256] 32K×8 EEPROM

      HM62256BLP, AT28C256               6502
             _____                        _____
    A14  1 -|     |- 28 Vcc      /VP  1 -|     |- 40 /RESET
    A12  2 -|     |- 27 /WE      RDY  2 -|     |- 39 Φ2out
     A7  3 -|     |- 26 A13    Φ1out  3 -|     |- 38 /SO
     A6  4 -|     |- 25  A8     /IRQ  4 -|     |- 37 Φ2in
     A5  5 -|     |- 24  A9      /ML  5 -|     |- 36 BE
     A4  6 -|     |- 23 A11     /NMI  6 -|     |- 35 NC
     A3  7 -|     |- 22 /OE     SYNC  7 -|     |- 34 RW̅
     A2  8 -|     |- 21 A10      Vcc  8 -|     |- 33 D0
     A1  9 -|     |- 20 /CS       A0  9 -|     |- 32 D1
     A0 10 -|     |- 19  D7       A1 10 -|     |- 31 D2
     D0 11 -|     |- 18  D6       A2 11 -|     |- 30 D3
     D1 12 -|     |- 17  D5       A3 12 -|     |- 29 D4
     D2 13 -|     |- 16  D4       A4 13 -|     |- 28 D5
    Vss 14 -|_____|- 15  D3       A5 14 -|     |- 27 D6
                                  A6 15 -|     |- 26 D7
                                  A7 16 -|     |- 25 A15
                                  A8 17 -|     |- 24 A14
                                  A9 18 -|     |- 23 A13
                                 A10 19 -|     |- 22 A12
                                 A11 20 -|_____|- 21 GND


<!-------------------------------------------------------------------->
[a1man]: https://www.applefritter.com/files/a1man.pdf
[jt-wozmon]: https://github.com/jefftranter/6502/tree/master/asm/wozmon
[sbp-basic]: https://www.sbprojects.net/projects/apple1/a1basic.php
[sbp-wozmon]: https://www.sbprojects.net/projects/apple1/wozmon.php

[2519]: https://www.applefritter.com/files/signetics2519.pdf
[555]: http://www.ti.com/lit/gpn/sn74s175
[74157]: http://www.ti.com/lit/gpn/sn74ls157
[74160]: http://www.ti.com/lit/gpn/sn74ls161a
[74161]: http://www.ti.com/lit/gpn/sn74ls161a
[74166]: http://www.ti.com/lit/gpn/sn54ls166a
[74174]: http://www.ti.com/lit/gpn/sn74s175

[AT28C256]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf
[62256]: https://ecee.colorado.edu/~mcclurel/hm62256b.pdf

[1rep-sbc]: https://github.com/tebl/RC6502-Apple-1-Replica/tree/master/RC6502%20Apple%201%20SBC
