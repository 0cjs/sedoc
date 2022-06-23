CBM User Ports
==============

Most CBM machines (with the exception of the Max Machine) have a 24-pin
card-edge "user port" that brings out one of the 6522 VIA or 6526 CIA 8-bit
GPIO ports and various other signals. This is often used to add an RS-232
serial interface, see below. The Plus/4 is an exception; it has a simple
8-bit register and a 6551 ACIA on the user port. [[p4sc3]]

The user port lines are numbered 1-12 on the top edge and A-N (excluding G
and I) on the bottom edge. `←` is always input, `→` always output.

      Pin   PET/CBM         VIC-20          C64             Plus/4
      ──────────────────────────────────────────────────────────────────
       1    GND             GND             GND             GND
       2    TV Video →      +5V             +5V (100 mA)    +5V
       3    SRQ (IEEE)      RESET           RESET           /B.RESET
       4    EOI (IEEE)      JOY0            CNT1            P2
       5    Diag Sense      JOY1            SP1             P3
       6    READ 1          JOY2            CNT2            P4
       7    READ 2          PEN             SP2             P5
       8    WRITE           SENSE           PC2             Receive Clock
       9    Vert            Serial ATN      Serial ATN      Serial ATN
      10    Horiz           9VAC + phase    9VAC + phase    9VAC + phase
      11    GND†            GND             9VAC - phase    9VAC - phase
      12    GND             GND             GND             GND
      ──────────────────────────────────────────────────────────────────
       A    GND             GND             GND             GND
       B    CA1 ←           CB1 ←           FLAG2           P0
       C    PA0             PB0             PB0             RXD
       D    PA1             PB1             PB1             RTS
       E    PA2             PB2             PB2             DTR
       F    PA3             PB3             PB3             P7
       H    PA4             PB4             PB4             DCD
       J    PA5             PB5             PB5             P6
       K    PA6             PB6             PB6             P1
       L    PA7             PB7             PB7             DSR
       M    CB2             CB2             PA2             TXD
       N    GND             GND             GND             GND
      ──────────────────────────────────────────────────────────────────
      Chip  6522            6522            6526            6529
      IC#   A5/UB15         UAB3            U2              U5

      †CA2/Graphic on 8032

PET/CBM:
- Note that [[cca-port]] has an error in the PET user port pinout;
  according to the schematics the user port is PA0-7, not PB0-7.
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

The VIC-20 and C64 can implement a TTL asynchronous serial interface using
the [VIA]/[CIA] shift register lines. (See [[cca-port]] for control
register details.) The Plus/4 has a 6551 ACIA. ([[p4um]] p.210-213) All
systems use Commodore-standardised lines on the user port which are
documented in the various manuals. As well as the full interface, these
also define two subsets: "three-line" (GND, TXD and RXD) and "X-line" (GND,
swapped TXD/RXD and VIC DSR input from the device's DTR).

The Plus/4 apparently has some slight differences in the serial interface
that cause some hardware for VIC-20/C64 not to work. ([[p4prg]] p.380) The
Commodore VIC Modem does not work; the Commodore 1660 MODEM/300 is
compatible with all.

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

Ports:
- VIC-20: VIA1 at $9110
- C64: CIA 2 at $DD00.
- Plus/4: 6851 ACIA at $FD00-$FD0F

The KERNALs contain code to do serial I/O to these interfaces, though an
error in the VIC's routines causes it to ignore DSR. Additional sample
programs can be found in:
- [[Byte8305]]: VICTTY assembly listing; data sent to screen is echoed to
  a serial printer with handshaking. (Fixes VIC DSR problem and works at up
  to 9600 bps. Also does PETSCI to ASCII translation.)
- [[p4um]] p.212-214: Simple BASIC terminal program.
- [[DeadTED]]: Plus/4 BASIC code

Commodore modems use TTL levels; an RS-232 interface requires level
conversion. This is traditionally done with MC1488 and MC1489 chips.
- On the C64 and Plus/4 the required +/- RS-232 levels can be rectified
  from the two phases of the 9 VAC output; see [[Byte8503]] for an example.
- The VIC has only one phase and an alternative source must be found for
  the negative level; [[Byte8305]] shows a circuit using a 9V battery.


References
----------

- \[cca-port] commodore.ca, ["Commodore VIC-20 64 and PET Port
  Pinouts"][cca-port]. Also includes IEEE 488, serial bus, cassette,
  expansion/cartridge, joystick, audio and video port pinouts and details
  of the IEEE 488 bus signals.
- \[VIA] MOS [MCS6522 Versatile Interface Adapter][VIA] datasheet, 1977.
- \[CIA] MOS [6526 Complex Interface Adapter (CIA)][CIA] datasheet,
  recreated.
- \[Byte8305] Joel Swank, ["The Enhanced VIC-20 Part 4: Connecting Serial
  RS-232C peripherals to the VIC's TTL port"][Byte8305], _Byte_ Vol.8 No.5
  May 1983, p.331.
- \[Byte8503] ["The Commodore 64 80-Column Terminal"][Byte8503], _Byte_
  Vol.10 No.3 March 1985, p.183. An 80-column display board and RS-232
  level converter to make the C64 into a terminal. Software (for an EPROM
  on the video board) was downloadable from BYTEnet but is presumably no
  longer available.
- \[p4sc3] [Plus/4 schematic, page 3][p4sc3]. Details user port
  connections.
- \[p4um] [_Commodore Plus/4 User's Manual_][p4um]. Commodore, 1984.
- \[p4prg] Cyndie Merten, Sarah Meyer, [_Programmer's Reference Guide for
  the Commodore Plus/4_][p4prg]. Scott Foresman and Company, 1986. Mentions
  that some older VIC-20/C64 serial devices don't work on the Plus/4 due to
  port differences (p.380 P.392). Describes KERNAL interface to serial port
  for BASIC (p.381 P.393) and machine language (p.389 P.401).
- \[DeadTED] [Commodore Plus/4 RS232 Interface][DeadTED] (PDF). Schematic,
  photos, Veroboard layout, etc. for a Plus/4 RS-232 interface similar to
  (same as?) the VIC-20/C64 interface and BASIC programs for data transfer
  in Plus/$ BASIC and PC QuickBasic.
  - The userport serial pinouts (pins A-M only) are from [[p4um]] p.212.
  - The circuit diagram for the level converter is from [[Byte8503]] p.190.

<!-------------------------------------------------------------------->
[Byte8305]: https://archive.org/details/byte-magazine-1983-05/page/n332/mode/1up?view=theater
[Byte8503]: https://archive.org/details/byte-magazine-1985-03/page/n174/mode/1up?view=theater
[CIA]: http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
[DeadTED]: https://plus4world.powweb.com/images/hardware/commodore_plus4_rs232.pdf
[VIA]: http://archive.6502.org/datasheets/mos_6522_preliminary_nov_1977.pdf
[cca-port]: https://www.commodore.ca/manuals/pdfs/commodore_pet_vic-20_c64_port_pinouts.pdf
[p4prg]: https://archive.org/details/Programmers_Reference_Guide_for_the_Commodore_Plus_4_1986_Scott_Foresman_Co/page/n391/mode/1up?view=theater
[p4sc3]: http://www.zimmers.net/anonftp/pub/cbm/schematics/computers/plus4/plus4-310164-3of4.gif
[p4um]: https://plus4world.powweb.com/publications/Commodore_Plus4_Users_Manual
