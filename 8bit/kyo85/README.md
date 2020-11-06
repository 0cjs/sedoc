Kyocera Kyotronic 85 Family
===========================

Models:
- __KC85__ Kyocera Kyotronic 85: Original system.
  - Ports: RS-232, printer, cassette.
  - Software: BASIC, Text, Telcom.
  - Internal: 1× expansion ROM socket.
- __M100__ TRS-80 Model 100: same system purchased by Radio Shack.
  - Add. ports: 300 baud modem, bar code reader.
  - Add. software: Address, Scheduler.
  - Mem: 8K or 24K, upgradable to 32K.
- __PC82__ NEC PC-8201 (1983-03): built on KC85 platform.
  - Add. SIO1, 2 (19.2 kbps), bar code reader, system RAM slot.
  - Internal: 2× ROM, 6× RAM (up to 96K) sockets.
  - Outside Japan, PC-8201A and PC-8300 released.
- __OM10__ Olivetti M-10: built on KC85 platform. Tilting LCD.
  - Add. ports: 300 baud modem (US only), bar code reader. 4 RAM/ROM.
  - Add. software: Address, Scheduler.
  - Internal: 4× RAM/ROM socket.

M100 and PC82 both appear to work with NiMH batteries and do not show a low
battery light, but during TELCOM downloads and at other times the M100 shut
off even with >1.2 V (no load) batteries, so it's probably best to stick
with alkaline (1.5 V nominal) batteries.


Usage Notes
-----------

### Power

(M100) Turning on the power switch does a warm start, preserving previous
state. RESET button on back returns to main menu. Changing memory config
(ROM or RAM) requires a cold start, done by colding either `Ctrl`+`Pause`
or RESET while turning on the computer.

(M100) The default power-off timeout is after 10 minutes of no keypresses.
In BASIC, `POWER n` (_n_ = 10 - 255) sets the timeout to _n*6_ seconds and
`POWER CONT` disables the timeout.

(M100) 4×AA alkaline batteries give about 20 hours of runtime. gLow battery
indicator lights when about 20 minutes of battery (alkaline) remaining.

(M100) The memory power switch on the bottom must be ON for the computer to
run. Turning it OFF erases memory entirely and disables power-up. (Do this
for long-term storage.) The internal NiCD battery will maintain 32K RAM for
about eight days.

### RAM

(M100) At cold start 3130 bytes used; free RAM on menu screen:
8K = 5062, 24K = 21446, 32K = 29638.

### Keyboard

(M100)
- `SHIFT-BKSP` gives `DEL` char.
- `GRPH` and `CODE`/`カナ` shifts can both be used with `SHIFT`.
- `LABEL` turns on/off F-key label row on screen.
- `PRINT` prints screen contents.
- `PAUSE` pauses, `SHIFT-PAUSE` breaks.
- `F1`-`F8`. Typically `F8 Menu`.

(PC82)
- `SHIFT-BKSP` gives `DEL` char.
- `GRPH` and `カナ` shifts can both be used with `SHIFT` (kana shifts
  typically give small version of vowel).
- `STOP`
- `F1`-`F5`, `SHIFT-F1`-`SHIFT-F5`. Typically `SHIFT-F8 Menu`; sometimes
  `SHIFT-F1 Keys` to toggle label line. (In BASIC, `SCREEN 0,n` where _n_
  is 0=labels off, 1=labels on)

### Date/Time

(M100) In BASIC, `DATE$ = "mm/dd/yy"`, `DAY$ = 'day'` (`MON`, `TUE` etc.),
`TIME$ = "hh:mm:ss"`.

### Files

Filenames are 6 chars plus 2 char extension, (M100) upper-case only or
(PC82) upper/lower case-sensitive.

    .DO     ASCII text document
    .BA     BASIC program (tokenized)
    .CO     machine-language ("command") program

Delete files from BASIC with `KILL "fname.ex"`.

Connector Pinouts
-----------------

### RS-232

(M100) The only connected serial port pins are 1-7 (GND, TXR, RXR, RTS,
XTS, DSR, GND) and 20 (DTR).

### PHONE (Modem)

(M100) DIN-8 268° female.

### CMT

(M100) DIN-8 270° female. Standard JP pinout (2=GND 4=ear 6=mic) except
relay (on 1 and 3) and additional GND on 6. (RS cable is DIN-5 male.) Input
is 100Ω impedence 800 mV - 5 V pp; output is 3.3 KΩ impedence 650 mV pp.

### Bar Code Reader

(M100) DE-9 male. 2=recieve data, 5,7=GND, 9=Vdd, all others NC.

### Expansion Bus

(M100) on 40-pin DIP-W socket in same compartment as option ROM socket.
See Owner's Manual p.208.


Documentation
-------------

### Model 100

- [Model 100 Owner's Manual][m100 user]
- [_Service Manual: TRS-80 Model 100 Portable Computer_][m100 service]
- Carl Oppedahl, [_Inside the TRS-80® Model 100_][m100 inside].
  - Ch.4 (p.73) has extensive details of Z80 instruction set differences.


Cross-development Tools and Emulators
-------------------------------------

- [Virtual T] Model 100 emulator. Includes dev/debugging tools.
- [Virtual Vanessa]: Limited Model 100/102 emulator for DOS (1991). Does
  not support full ROM operation (none of the built-in programs work); the
  primary purpose is to play some M100 arcade games written by the same
  author (included).



<!-------------------------------------------------------------------->
[m100 service]: https://archive.org/stream/m100service#page/n1/mode/1up
[m100 user]: https://archive.org/stream/trs-80-m-100-user-guide#page/n4/mode/1up
[m100 inside]: https://archive.org/stream/InsideTheTrs80Model100#page/n6/mode/1up

[Virtual T]: https://sourceforge.net/projects/virtualt/
[Virtual Vanessa]: https://archive.org/details/VirtualVanessaTRS80Model100LIMITEDEmulator_1020
