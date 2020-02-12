RC6502 Apple 1 Replica SBC
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


Keyboard and Video I/O Emulation
--------------------------------

An Arduino Nano monitors and talks to the MC6821 PIA and emulates the
keyboard and video circuitry. The Nano talks to a computer via a
115kbps USB serial connection; connect to it with the following
command (but note the issues described below).

    minicom -8 -b 115200 -D /dev/ttyUSB0

### Keyboard I/O

Unlike the real Apple I, which leaves MC6820 PIA `CA2` unconnected,
this board wires `CA2` to an input on the Arduino Nano. The [current
software][piacom] (`1907bba` 2017-06-02) uses this to detect that the
data on port A has been read so it can delay writing further
keystrokes until the current keystroke has been read and avoid
overflowing the Apple on fast input.

### Video I/O

The [current software][piacom] (`1907bba` 2017-06-02) does not
correctly translate output; the character is ANDed with $7F to clear
the top bit but is then directly sent out the serial port. This will
print control characters other than CR; the original Apple printed
nothing for these.


ICs and Pinouts
---------------

#### Power

- Power header above Nano: top=+5V bus, bottom=Nano +5V supply. Jumper
  to have USB power the board, which pulls < 250 mA.
- On 1-based bus pins, 17=GND, 18=+5V. These are to the right and left
  of the center pin of the RAM_EN jumper.
- A handy ground bus pin is the bottom pin of the PIA_EN jumper (when
  PIA_EN is enabled via jumpering top-two pins, CS and +5).

RC6502 Bus Pinout

       A15 →  1
         …   …
        A0 → 16
       GND   17
       Vcc   18
     Φ2out → 19
    /RESET ← 20
      Φ0in ← 21
      /IRQ ← 22
     Φ1out → 23
       R/W̅ → 24
       RDY ← 25
      SYNC → 26
        D0 ↔ 27
        D7 ↔ 34
        TX ↔ 35
        RX ↔ 35
      /NMI ← 37
         ×   38
         ×   39

- [555] timer
- [HM62256BLP][62256] 32K×8 SRAM
- [AT28C256] 32K×8 EEPROM
- [MC6821](../../ee/mc6820.md) PIA

      HM62256BLP, AT28C256               6502
             _____                        _____
    A14  1 -|     |- 28 Vcc      /VP  1 -|     |- 40 /RESET
    A12  2 -|     |- 27 /WE      RDY  2 -|     |- 39 Φ2out
     A7  3 -|     |- 26 A13    Φ1out  3 -|     |- 38 /SO
     A6  4 -|     |- 25  A8     /IRQ  4 -|     |- 37 Φ2in
     A5  5 -|     |- 24  A9      /ML  5 -|     |- 36 NC (WDC: BE)
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
[1rep-sbc]: https://github.com/tebl/RC6502-Apple-1-Replica/tree/master/RC6502%20Apple%201%20SBC

[piacom]: https://github.com/tebl/RC6502-Apple-1-Replica/blob/master/RC6502%20Serial%20IO/pia_communicator/pia_communicator.ino

[2519]: https://www.applefritter.com/files/signetics2519.pdf
[555]: http://www.ti.com/lit/gpn/sn74s175
[74157]: http://www.ti.com/lit/gpn/sn74ls157
[74160]: http://www.ti.com/lit/gpn/sn74ls161a
[74161]: http://www.ti.com/lit/gpn/sn74ls161a
[74166]: http://www.ti.com/lit/gpn/sn54ls166a
[74174]: http://www.ti.com/lit/gpn/sn74s175

[AT28C256]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf
[62256]: https://ecee.colorado.edu/~mcclurel/hm62256b.pdf

