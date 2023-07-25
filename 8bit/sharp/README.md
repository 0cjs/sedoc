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

[Keyboard input control codes][som 027]:

    Ctrl n₁₀  Function
      E   5   lower-case input mode
      F   6   upper-case input mode
      M  13   carriage return (CR)
      P  16   DEL key
      Q  17   cursor ↓ down
      R  18   cursor ↑ up
      S  19   cursor → right
      T  20   cursor ← left
      U  21   home position (HOME)
      V  22   clear screen to BG color (CLR)
      W  23   GRAPH mode
      X  24   insert a space (INST)
      Y  25   alphanumeric input mode (ALPHA/英数)

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


<!-------------------------------------------------------------------->
[smzo-h&t]: https://original.sharpmz.org/mz-80k/tips.htm

[som]: https://archive.org/details/sharpmz700ownersmanual/page/n5/mode/1up?view=theater
[som 006]: https://archive.org/details/sharpmz700ownersmanual/page/n7/mode/1up?view=theater
[som 027]: https://archive.org/details/sharpmz700ownersmanual/page/n28/mode/1up?view=theater
[ssm]: https://archive.org/details/sharpmz700servicemanual/
