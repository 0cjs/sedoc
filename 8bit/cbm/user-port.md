CBM User Ports
==============

Most CBM machines (with the exception of the Max Machine) have a 24-pin
card-edge "user port" that brings out one of the 6522 VIA or 6526 CIA 8-bit
GPIO ports and various other signals. This is often used to add an RS-232
serial interface, see below.

The user port lines are numbered 1-12 on the top edge and A-N (excluding G
and I) on the bottom edge. `←` is always input, `→` always output.

      Pin   PET/CBM         VIC-20          C64
      ──────────────────────────────────────────────────────────────────
       1    GND             GND             GND
       2    TV Video →      +5V             +5V (100 mA)
       3    SRQ (IEEE)      RESET           RESET
       4    EOI (IEEE)      JOY0            CNT1
       5    Diag Sense      JOY1            SP1
       6    READ 1          JOY2            CNT2
       7    READ 2          PEN             SP2
       8    WRITE           SENSE           PC2
       9    Vert            Serial ATN      Serial ATN
      10    Horiz           9VAC + phase    9VAC + phase
      11    GND             GND             9VAC - phase
      12    GND             GND             GND
      ──────────────────────────────────────────────────────────────────
       A    GND             GND             GND
       B    CA1             CB1             FLAG2
       C    PB0             PB0             PB0
       D    PB1             PB1             PB1
       E    PB2             PB2             PB2
       F    PB3             PB3             PB3
       H    PB4             PB4             PB4
       J    PB5             PB5             PB5
       K    PB6             PB6             PB6
       L    PB7             PB7             PB7
       M    CB2             CB2             PA2
       N    GND             GND             GND
      ──────────────────────────────────────────────────────────────────

PET/CBM:
- `Diag Sense`: Held low starts diagnostic routines at power-up
- `READ1/2`: CMT read lines
- `WRITE (Diag CMT)`: Diagnostic tape write verify
- `Vert`, `Horiz`: monitor vertical and horizontal sync outputs

VIC-20:
- `JOY0/1/2`: joystick switches
- `PEN`: light pen input and joystick fire button
- `SENSE`: CMT switch sense line

Commodore 64:
- `CNT1/2`, `SP1/2`: Serial port counters and data from CIAs 1 and 2.
- `PC2`: Handshaking line from CIA 2.


RS-232 Serial User Port Lines
-----------------------------

On the VIC-20 and C64 the [VIA]/[CIA] shift register lines can be used to
drive an RS-232 level-converter board to get a standard asynchronous serial
interface. Commodore standardised the pins for this, and the C64 (and
VIC-20?) KERNAL contains code to read/write the serial port.

VIC-20 uses VIA1 at $9110; C64 uses CIA 2 at $DD00.

    Pin   652x        Function
    ──────────────────────────────────────────────
     A    GND         GND
     B    CB1/FLAG2   RXD  serial input
     C    PB0         RXD  serial input
     D    PB1         RTS
     E    PB2         DTR
     F    PB3         RI
     H    PB4         DCD
     J    PB5         -    unassigned
     K    PB6         CTS
     L    PB7         DSR
     M    CB2/PA2     TXD  serial output
     N    GND         GND
    ──────────────────────────────────────────────

See [[cca port]] for control register details.


References
----------

- \[cca port] commodore.ca, ["Commodore VIC-20 64 and PET Port
  Pinouts"][cca-port]. Also includes IEEE 488, serial bus, cassette,
  expansion/cartridge, joystick, audio and video port pinouts and details of
  the IEEE 488 bus signals.
- \[VIA] MOS [MCS6522 Versatile Interface Adapter][VIA] datasheet, 1977.
- \[CIA] MOS [6526 Complex Interface Adapter (CIA)][CIA] datasheet, recreated.


[cca-port]: https://www.commodore.ca/manuals/pdfs/commodore_pet_vic-20_c64_port_pinouts.pdf
[VIA]: http://archive.6502.org/datasheets/mos_6522_preliminary_nov_1977.pdf
[CIA]: http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
