Apple IIc Hardware
==================

All page numbers below not otherwise indicated refer to the _Apple IIc
Technical Reference Manual_. See that for full details, including
hardware design, ROM listings, and schematics.

References:
- [_The Apple IIc Technical Reference Manual_][techref]
  - Schematics on pp. 292-296 (newer model)
- [Schematic Diagram of the Apple IIc][schematics] (A2S4000 model).
- [_SAMS COMPUTERFACTS™: Apple® IIc A2S4000, Monitor A2M4090_][sams].
  Includes alternative schematics.

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
- A2S4100: Memory expansion connector, 128K as 4×256 kbit, ROM 3, Alps
  keyswitches.
- A2S4500: IIc+. 3.5" internal drive, 4 MHz accelerator, ROM 5, new
  keyboard layout.


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


I/O Areas
---------

### Onboard and "Slot" I/O and ROM Address Space

All ROM space, including the dedicated "slot" ranges $C100-$C7FF and
the shared slot range $C800-$CFFF, are used by the IIc onboard ROM.
The I/O spaces (p.316) have many reserved ranges (both in onboard and
slot areas) that appear from testing not to be decoded to a chip
select. (`b`=onboard area; `0…7`=slot area.)

    $C000-$C07F  b   Apple II onboard I/O
    $C080-$C08F  0   RAM/ROM bank switching
    $C090-$C09F  1   Port 1 ACIA
    $C0A0-$C0AF  2   Port 2 ACIA
    $C0B0-$C0BF  3   Reserved
    $C0C0-$C0CF  4   Reserved
    $C0D0-$C0DF  5   Reserved
    $C0E0-$C0EF  6   Reserved
    $C0F0-$C0FF  7   Reserved

### Video

There is a built-in 80-column card. `PR#3` and `PR#0` switch to 80 and
40 column modes. The character ROM has original Apple II and modern
MouseText character sets available.

          W = write once to set soft switch

    C00C  W    80Col off: 40-column display
    C00D  W    80Col  on: 80-column display
    C00E  W    AltChar off: display primary (original Apple II) character set
    C00F  W    AltChar  on: display alternate (MouseText) character set

Further display and memory control switches are documented in
Table 2-6 (p.44-46). These allow switching the frame buffer banks
separately from the rest of memory and enabling double high-res
graphics.


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

The serial port firmware has buffers in auxiliary memory page $08.

Sending a "command character" (`Ctrl-I` port 1, `Ctrl-A` port 2) will
cause the firmware to change the serial port settings (p.155, 169):

    nnn     line width (1-255); follow with N or CR
    nnB     bps rate: 15=19200 14=9600  12=4800 10=2400 8=1200 6=300 3=110
     nD     serial format: 0=8p1 1=7p1 7=5p2 (parity set with nP)
     nP     parity: 0=none 1=odd 3=even 5=mark 7=space
      I     echo output to screen as well

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

#### Full II Series

Integer BASIC loaded from a DOS or BASICS disk loads the original
Apple II monitor into the language card as well. Typing `INT` will
switch to both Integer BASIC _and_ the original monitor, until you
type `FP` or activate the 80-column firmware.

"Appendix F: Apple II Series Differences" (p. 348) gives an overview
followed by some details of differences between all models in the
line, IIs, IIes and IIcs. ROM difference summary:

    II         8K  $E000-$FFFF
    II+       12K  $D000-$FFFF  miniasm/step/trace removed
    IIe       16K  $C100-$FFFF  at start, self test code in $C400-$C7FF
    IIc $FF   16K  $C100-$FFFF
    IIc $00+  32K  $C100-$FFFF  bank swiched, miniasm/step/trace added

Unlike the IIe, the IIc always maps $C800-$CFFF to system ROM because
no ports (emulating slots) need it.

#### IIc Models and ROMs

There are several versions of the IIc. ROM versions are identified by
`PEEK(-1089)` (64447, $FBBF); hex values are given below, along with ROM
size, MON chip labelling and dates shipped. Sources: [c.s.a2]

- Original (__$FF__): 16K 342-0272 1984-04〜1985-11. The only version that
  can boot external drive with `PR#7`.
- Serial port timing fix: Replaces 74LS161 with an oscillator to bring
  serial port timing within spec (it was 3% low).
- UniDisk 3.5 (0, __$00__): 32K 342-0033-A 1985-11〜1986-09. Protocol
  Converter (earlier version of Smartport) routines to support UniDisk 3.5
  external drive. Mini-Assembler and step/trace monitor commands. Built-in
  diagnostics (Ctrl-OpenApple-Reset). Improved interrupt handlers. New
  external drive startup procedures.
- 342-0033-B marking: unknown difference from -A. Perhaps Imagewriter II
  support?
- Memory expansion (3, __$03__): 32K 342-0445-A 1986-09〜1988-01. Uses four
  64K×4bit RAM instead of sixteen 64K×1bit RAM chips and adds motherboard
  connectors for a RAM expansion card (expands up to 1 MB). Updates ROM to
  SmartPort. Moves mouse to port 7; memory expansion uses port 4.
- Memory expansion (4, __$04__): 342-0445-B 1988-01〜1988-08. Version 3
  with bugfixes.
- Apple IIc+ (5, __$05__): 342-0625-A 1988-09〜1990-11. Next generation of
  IIc machines.

Ch. 11 §"MMU" (p.242) and §"ROM addressing" (pp. 249-250) describe the
decoding. The MMU (UE16) generates `ROMEN1*` (pin 19, also `H`?) and
`ROMEN2*` (pin 20, also `P`?); these are tied (through diodes)
together to MON (UD18) `C̅E̅`, which also has a 1 kΩ pullup. `ROMEN1*`
is said to enable decoding of $C100-$DFFF; `ROMEN2*` is not mentioned.

IOU (I/O Unit UE14) `CASSO` (pin 7) is tied to MON `A14` (pin 27) in
32K ROM systems. p. 244 describes this only as "Reserved", but clearly
it's dealing with ROM bank switching, which is undocumented by Apple.
[rcse 14999] indicates that writing $C028 flips the two halves
(there's no way to tell which is the current half, except by checking
the contents of that address space). The exact behaviour varies per
machine; the canonical addresses, actual ranges and functions are:

    IIc       $C028  $C020-$C02F  flips $C100-$FFFF range
    IIgs      $C028  ?            flips $D000-$FFFF range
    IIe card  $C028  ?            switches to main ROM
              $C029  ?            switches to aux. ROM

$C780-$C7FF of the ROM (p. 416) is the same in both banks and contains
code to switch between the two in various circumstances (RTS, RTI,
etc.).

XXX stuff to check out:
- 'Scope `CASS0` pin on old ROM system.

ROM map summaries and firmware listings are in Appendix I (p. 396).
Enhanced video firmware in $C300-$C3FF and much of $C800-$CFFF.

#### ROM Socket Pinout

IC MON (UD18) is a 27128 (16K) in $FF models and 27256 in later models.
The A2S4000 motherboard has provisions for upgrading to a 32K ROM:
- `W1` cuttable trace to to signal `S5`.
  - '128 (16K) ROM pin 27 = `P̅G̅M̅`.
  - Connects: `N̅M̅I̅` on CPU, probably other things.
  - Pin 27 marked as "(N.C.)" on p. 249; differs from schematic.
  - Not sure why they'd bring `P̅G̅M̅` low on NMI.
- `W2` solderable split pad jumper to `RA14`.
  - '256 (32K) ROM pin 27 = `A14`.
  - Connects: IOU (Input/Output Unit, UE14) pin 7 (`CASS0`?).

To use other chips, the following need to be dealt with:
- 27512 (64K): pin 1 `Vpp`→`A15`
  - Use top half without modifications.
  - To use bottom half, cut pin 1 link to 5 V and jumper to switch.
- 28C256 (32K, 5V programmable):
  - pin 1: `Vpp`→`A14`, cut link to 5 V and jumper.
  - pin 27: `A14` → `W̅E̅`

If the version __$FF__ image is written to any device larger than 16K
it must be written twice.
* On a system wired for a 16K ROM, A14 (connected to `S5/N̅M̅I̅`) will
  normally be high, selecting the second copy, but when `N̅M̅I̅` is low,
  the first copy will be selected.
* On a system wired for a 32K ROM this ensures that if the $C020-C02F
  (canonical port, $C028) range is accessed it will not switch to an
  "empty" ROM.

#### Further references:

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
[c.s.a2]: https://comp.sys.apple2.narkive.com/T5lckfnp/apple-iic-models-and-rom-numbers
[evb-teardown]: https://www.youtube.com/watch?v=JsUM-ZcBFE0
[hwdin]: ../../hw/din-connector.md
[ifixit]: https://www.ifixit.com/Guide/Disassembling+Apple+IIc+Cover/6772
[keycaps]: https://www.apple2online.com/web_documents/Apple%20IIc%20Keycaps.pdf
[mspec]: http://apple2.org.za/gswv/a2zine/faqs/Csa2KBPADJS.html#024
[rcse 14999]: https://retrocomputing.stackexchange.com/a/14999/7208
[romver]: http://apple2online.com/web_documents/apple_iic_rom_versions.pdf
[sams]: https://archive.org/stream/Sams_Computer_Facts_Apple_IIc#mode/1up
[schematics]: https://archive.org/details/Schematic_Diagram_of_the_Apple_IIc
[techref]: https://archive.org/details/Apple_IIc_Technical_Reference_Manual
