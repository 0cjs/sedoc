Sharp 8-bit Computers
=====================

Files:
- [`models`](models.md): List of models and brief specs.

`original.sharpmz.org` has some useful [Hints and Tips][smzo-h&t].

#### MZ-700 Usage Notes

Keyboard:
- JP machines: `英数`, `カナ` (above CR), `Graph` mode locks.
  `SHIFT` gives lower case.
- Western machines: `ALPHA` (Tab key location) and `Graph` (Esc key
  location) are mode locks; `Shift` can be used with `Graph` for additional
  graphics characters (replacing kana). Kana key has blank top.
- `Graph` cursor is inverted cross.
- 3D model for MZ-700 Key Post [available from thingiverse][tv-mz700-keypost]

[Keyboard input control codes][som 027]:

    Ctrl dec hex  Function
      E   5  $05  lower-case input mode
      F   6  $06  upper-case input mode
      M  13  $0D  carriage return (CR)
      P  16  $10  DEL key
      Q  17  $11  cursor ↓ down
      R  18  $12  cursor ↑ up
      S  19  $13  cursor → right
      T  20  $14  cursor ← left
      U  21  $15  home position (HOME)
      V  22  $16  clear screen to BG color (CLR)
      W  23  $17  GRAPH mode
      X  24  $18  insert a space (INST)
      Y  25  $19  alphanumeric input mode (ALPHA/英数)

Monitor:
- `LOAD` or `L` to load next thing from tape.

Ctrl-RESET or `#` in IPL/Monitor will boot RAM? XXX [[ssm] p.5]

Hardware
--------

Video:
- `VIDEO` RCA output is CVBS: NTSC(-J?) for JP, PAL for EU
- `RGB` DIN-8F output is JP standard, with additionally:
  - Pin 1: CVBS. Pin 3: `C̅S̅Y̅N̅C̅`

CMT:
- Internal 9-pin connector for MZ-1T01 CMT. Read/write 3.5mm mono jacks for
  external CMT. "Push Record/Play" messages do not appear when using
  external CMT.
- 1200 baud. Format given in [[ssm] p.13 P.14]. Each data block written
  twice. Header includes 16-char name, file size, load/exec addresses and
  124-byte "comment" not usually used, but S-BASIC has a "save a copy"
  program hidden in there.

Sound:
- MZ-80K Apparently uses a [74LS221] for sound. (Dual monostable
  multivibrators with Schmitt-trigger inputs. Dual versions of '121
  one-shots, pinout identical to '123.)
- MZ-700 uses `OUT0` on 8253 PIT (Programmable Interval Timer). Counter #0
  counts 895 kHz pulses, divides by value for particular note, sends on to
  amp.

#### MZ-700 Connectors

From [[smzo-conn]]. Also see [[som 141]].

(P-11) Expansion bus looking into back has pin 1 at upper right, pin 2 below it.

    A15  A14  A13  A12 A11 A10   A9 A8  A7 A6   A5   A4  A3  A2
     ₄₉   ₄₇   ₄₅   ₄₃  ₄₁  ₃₉   ₃₇ ₃₅  ₃₃ ₃₁   ₂₉   ₂₇  ₂₅  ₂₃
     ⁵⁰   ⁴⁸   ⁴⁶   ⁴⁴  ⁴²  ⁴⁰   ³⁸ ³⁶  ³⁴ ³²   ³⁰   ³⁸  ²⁶  ²⁴
    N̅M̅I̅ E̅X̅I̅N̅T̅ GND M̅R̅E̅Q̅ GND I̅O̅R̅Q̅ GND R̅D̅ GND W̅R̅ E̅X̅W̅A̅I̅T̅ M̅1̅ GND H̅A̅L̅T̅

                        A1      A0  BUSΦ D7  D6 │  D5  D4  D3  D2  D1  D0
                        ₂₁      ₁₉   ₁₇  ₁₅  ₁₃ │  ₁₁   ₉   ₇   ₅   ₃   ₁
                        ²²      ²⁰   ¹⁸  ¹⁶  ¹⁴ │  ¹²  ¹⁰   ⁸   ⁶   ⁴   ²
                     E̅X̅R̅E̅S̅E̅T̅  RESET GND GND GND │ GND GND GND GND GND GND

(P-10) Printer port looking into back has pin 1 at upper right, pin 2 below it.

    FG S̅T̅A̅ R̅D̅A̅ IRT RD8 RD7 RD6 RD5 RD4 RD3 │ RD2 RD1 RDP
    ₂₅  ₂₃  ₂₁  ₁₉  ₁₇  ₁₅  ₁₃  ₁₁   ₉   ₇ │   ₅   ₃   ₁
    ²⁶  ²⁴  ²²  ²⁰  ¹⁸  ¹⁶  ¹⁴  ¹²  ¹⁰   ⁸ │   ⁶   ⁴   ²
    FG GND GND GND GND GND GND GND GND GND │ GND GND GND

(P-5) Plotter power connector (internal):

    1:+5V  2:+5V  3:GND  4:GND

(P-1) Plotter signals:

    ARDP ARD1 ARD2 ARD3 ARD4 ARD5 ARD6 ARD7 ARD8 AIRT GND ARDA GND ASTA ALPS
      1    2    3    4    5    6    7    8    9   10   11  12   13  14   15

(P-13, P-14) Joystick (pin 1 at left from front of connector, analog):

    1:5V   2:V̅B̅L̅K̅   3:JA1   4:JA2   5:GND

(P-9) UHF-oscillator, RGB and Video:

    1:GND   2:C̅S̅Y̅N̅C̅   3:CVBS    4:H̅S̅Y̅N̅C̅    5:V̅S̅Y̅N̅C̅   6:GND
    7:+5V   8:RED     9:BLUE   10:GREEN   11:COLR   12:GND

(P-4) Keyboard:

    1-10    columns select 1-10
    11-18   rows D7-D0
    19      LED power on
    20      GND

(P-12) Tape (internal):

    1   External write
    2   External read
    3   GND
    4   Motor/remote
    5   Sense (motor)
    6   +5V
    7   Write
    8   READ
    9   GND / E


References
----------

- [[som]] _Sharp MZ-700 Owner's Manual,_ Sharp.
  - [p.4][som]       (P.%): Table of Contents
  - [p.6][som 006]   (P.7): Index of BASIC commands
  - [p.27][som 027] (P.29): Control codes for keyboard input control.
  - p.122 (P.124): System diagram, memoory maps
  - p.131 (P.133): 8255 keyboard scan, VRAM description, etc.
  - p.134 (P.136): Schematics
  - p.146 (P.149): IPL Monitor documentation
  - p.154 (P.159): "ASCII" and screen code tables (2nd SC set p.155-2)
- [[ssm]] _Sharp Service Manual MZ-700 MZ-1T01 MZ-1P01,_ code 00ZMZ700SM//E.
- [[ppmz7]] G.P. Ridley, _Peeking and Pokeing the Sharp MZ-700._



<!-------------------------------------------------------------------->
[smzo-h&t]: https://original.sharpmz.org/mz-80k/tips.htm

[74LS221]: https://www.ti.com/product/SN74LS221
[ppmz7]: https://archive.org/details/peeking-poking-the-sharp-mz-700
[smzo-conn]: https://original.sharpmz.org/mz-700/connect.htm
[som]: https://archive.org/details/sharpmz700ownersmanual/page/n5/mode/1up?view=theater
[som 006]: https://archive.org/details/sharpmz700ownersmanual/page/n7/mode/1up?view=theater
[som 027]: https://archive.org/details/sharpmz700ownersmanual/page/n28/mode/1up?view=theater
[som 141]: https://archive.org/details/sharpmz700ownersmanual/page/n142/mode/1up?view=theater
[ssm]: https://archive.org/details/sharpmz700servicemanual/
[tv-mz700-keypost]: https://archive.org/details/thingiverse-5447518
