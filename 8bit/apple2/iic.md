Apple IIc Hardware
==================

All page numbers below not otherwise indicated refer to [The Apple IIc
Technical Reference Manual][techref]. See that for full details,
including hardware design, ROM listings, and schematics (pp. 292-296).
There is also a separate [schematics] PDF, but that's worse quality
than the manual.

Changes from IIe:
- CMT (cassette) support dropped.
- 65C02 processor.
- The logical slots are now called "ports," but function the same way
  in software.
- Adds built-in support for interrupt handling, including new vertical
  blank interrupt. (IIe could poll vertical blank; not available on
  earlier models.)
- Easter egg: `IN#5 : INPUT A$ : PRINT A$`.

Models:
- A2S4000: Original model, 128K as 16×64 kbit, Apple/generic keyswitches.
- A2S4100: Memory expansion connector, 128K as 4×256 kbit, Alps keyswitches.


Misc Notes
----------

Always run propped up on handle (folded down) for airflow.

[ADTPro][adtpro-din5] client (Apple II) defaults are serial port 2
(phone icon) and 115,200 bps. Tie together Apple DTR and DSR, also PC
RTS and CTS. See [`/hw/din-connector`][hwdin] for more info. Possibly
need to start ADTPro server (PC) _after_ client is started on Apple II.


Main Unit Disassembly
---------------------

Photos at [ifixit]. EEVblog has a [teardown video][evb-teardown].

The six 19mm wide-thread #2 phillips screws holding the case together
are on the bottom at the outside edge: four on either side of the
keyboard and two right next to the handle. (The two middle ones are
very different on mine; bad replacements?)

There's a catch on the front edge, slightly to the right, above the
speaker. Push in at the seam to push the top edge back from the bottom
hook.


Power
-----

(p.234) Power input is unregulated 9 to 20 V DC max 25 W. The Apple
external PSU is 15 V 1.2 A. The chassis connector is a male 7-pin DIN.
Below, LI = "looking into."

    DIN Numbering       DIN Numbering    Apple Numbering
    LI female plug      LI male jack      LI male jack
          ∪                  ∪                  ∪
       7     6            6     7            7     1
     3         1        1         3        6         2
       5     4            4     5            5     3
          2                  2                  4

    DIN    Apple   Function
    1,4     2,3    +15 V DC
      2       4    Chassis ground (AC input ground)
    3,5     5,6    Signal ground
    6,7     1,7    Not connected

Internally the converter generates voltages +5 (1.5A), +12 (0.6 A, 1.5
A surge), -12 (100 mA) and -5 (50 mA). It can run all internal
components plus one 5.25" external drive. It will limit voltages,
dropping to 0 if they can't be maintained, if any supply voltage is
shorted to ground or if any output voltages goes outside normal range
(±5% on 5V, ±10% on 12V).

Max case temperature is 60°.


Disk I/O
--------

(p.273-274) The manual says you should _not_ use power from the
external DB-19 disk connector for any other purpose; instead get power
from a different port and respect current limits.

    10 9  8  7  6  5  4  3  2  1        ?Looking into connector on chassis?
     19 18 17 16 15 14 13 12 11

(p.296) The internal connector J8 is a 20-pin DIP header. This is
almost identical to the Disk II controller from the Apple II, with the
exception that on the Disk II pin 19 was +12V and pin 14 was called
just `ENABLE*` (having the same function).

    Ext  Int  IO  Function
      1   1   -   GND
      2   3   -   GND
      3   5   -   GND
      4   7   -   GND
      5   9   -   -12V
      6  11   -   +5V
      7  13   -   +12V
      8  15   -   +12V
         17   -   +12V
         19   O   DISKACTY  Disk activity light, to J9-11 (keyboard conn.)
      9       i?  EXTINT*   External interrupt
     10       i   WRPROT    Write-protect
     11   2   O   SEEKPH0   Motor phase 0-3
     12   4   O   SEEKPH1
     13   6   O   SEEKPH2
     14   8   O   SEEKPH3
     15  10   ?   WRREQ*    Write request
         12   -   +5V
         14   ?   EN1*      Drive 1 select (ENABLE* on disk II)
     16       -   n/c       (+5V on some controllers?)
     17       O   DR2*      Drive 2 select (EN2* on schematic)
     18  16   i   RDDATA    (in) Read data
     19  18   O   WRDATA    (out) Write data
         20   i   WRPROT

The interface might be called ["SA390"], since it connects to on
Shugart SA400 drives with most of their electronics removed.


Other I/O
---------

#### Serial Ports

(p.274) Two 6551 ACIAs; port/slot 1 "printer" and port/slot 2 "modem."
The control registers are at $C09B and $C0AB, respectively. (p.279)

    DIN Numbering     DIN Numbering     Apple Numbering
    LI male plug      LI female jack     LI female jack
         ∪                  ∪                  ∪
    1         3        3         1        5         1
      4     5            5     4            4     2
         2                  2                  3

    DIN    Apple   Dir  Function
     1       1     out   DTR  Data Terminal Ready
     2       3      -    GND
     3       5     in    DSR  Data Set Ready; input to DCD on ACIA
     4       2     out   TD   Transmit Data
     5       4     in    RD   Receive Data

The DSR inputs on the ACIAs are not conected to the serial ports for
reasons related to the routing of interrupts.
- Port 1 DSR: `E̅X̅T̅I̅N̅T̅` from the external drive connector.
- Port 2 DSR: `KSTRB` from keyboard.

#### Mouse/Hand Controller (Paddles/Joystick)

(p.282) DB-9 female jack. Supplies no more than 100 mA @ +5V. Paddles
resistors should be 150 KΩ pots connected to +5V.

    5 4 3 2 1     Looking into female jack on motherboard.
     9 8 7 6

    1  M̅O̅U̅S̅E̅I̅D̅,GAMESW1 Disables 556 paddle timer when asserted; paddle 1 button
    2  +5V
    3  GND
    4  XDIR            Direction indicator
    5  XMOVE,PDL0      Movement interrupt, paddle 1 resistor
    6  n/c
    7  M̅S̅W̅,GAMESW0     Mouse button, paddle 0 button
    8  YDIR,PDL1       Direction indicator, paddle 1 resistor
    9  YMOVE           Movement interrupt

#### Keyboard

There are two different [keyboard PCB assemblies], with differing
keycaps to match the keyswitch stems:
- On A2S4000, composite (tan) board with unnamed ("generic" or
  "Apple") keyswitches using male cross-shaped stems. Black rubber
  spill guard.
- On A2S4100, black, thin board with Alps keyswitches using female
  rectangular stems.

[Michael Spector says][mspec] that you can improve the keyboard feel
by removing the black rubber mat, which is a spill guard that was not
included in the Alps IIc. Removing the small metal clips between each
key stem (producing the clicks) my also help. Both these mods are
reversible.


Models and ROM Versions
-----------------------

There are several versions of the IIc. ROM versions are identified by
`PEEK(-1089)` (64447, $FBBF); hex values are given below.

- Original ($FF): 16K. The only version that can boot external drive
  with `PR#7`.
- Serial port timing fix: Replaces 74LS161 with an oscillator to bring
  serial port timing within spec (it was 3% low).
- UniDisk 3.5 (0, $00): 32K. Protocol Converter (earlier version of
  Smartport) routines to support UniDisk 3.5 external drive.
  Mini-Assembler and step/trace monitor commands. Built-in diagnostics
  (Ctrl-OpenApple-Reset). Improved interrupt handlers. New external
  drive startup procedures.
- Memory expansion (3, $03): 32K. Uses four 64K×4bit RAM instead of
  sixteen 64K×1bit RAM chips and adds motherboard connectors for a RAM
  expansion card (expands up to 1 MB). Updates ROM to SmartPort. Moves
  mouse to port 7; memory expansion uses port 4.
- Memory expansion (4, $04): Version 3 with bugfixes.
- Apple IIc+ (5): next generation of IIc machines.

16K ROM systems have trace W1 closed and W2 open; to change to 32K cut
the former and bridge the latter.

Further references:
- [techref] Appendix F (pp.348-365) gives more detailed information on
  differences between all models.
- [Apple IIc ROM Versions][romver]
- BMOW's [Apple IIc ROM Upgrade][bmow-2crom] has additional
  information and covers how to do an upgrade.
- [ROM images][a2za-a2crom].


The Apple IIc Plus
------------------

This was model A2S4500. Differences include:
- 3.5" internal drive
- Mains voltage PSU is now internal, with standard PC IEC C14 jack on
  the chassis.
- Serial ports now use miniDIN-9 (or something?)



<!-------------------------------------------------------------------->
["SA390"]: https://apple2history.org/history/ah05/
[a2za-a2crom]: http://mirrors.apple2.org.za/Apple%20II%20Documentation%20Project/Computers/Apple%20II/Apple%20IIc/ROM%20Images/
[adtpro-din5]: https://adtpro.com/connectionsserial.html#DIN5
[bmow-2crom]: https://www.bigmessowires.com/2015/05/29/apple-iic-rom-upgrade/
[evb-teardown]: https://www.youtube.com/watch?v=JsUM-ZcBFE0
[hwdin]: ../../hw/din-connector.md
[ifixit]: https://www.ifixit.com/Guide/Disassembling+Apple+IIc+Cover/6772
[keycaps]: https://www.apple2online.com/web_documents/Apple%20IIc%20Keycaps.pdf
[mspec]: http://apple2.org.za/gswv/a2zine/faqs/Csa2KBPADJS.html#024
[romver]: http://apple2online.com/web_documents/apple_iic_rom_versions.pdf
[schematics]: https://archive.org/details/Schematic_Diagram_of_the_Apple_IIc
[techref]: https://archive.org/details/Apple_IIc_Technical_Reference_Manual
