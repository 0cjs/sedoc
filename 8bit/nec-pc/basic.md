N80 and N88 BASIC
=================

Also see [`programs`](programs.md).

Basic versions/startup messages:

    NEC PC-8001 BASIC Ver 1.1
    Copyright 1979 (c) by Microsoft

(PC-8001 v1.1 is a varaiant of Microsfot Disk BASIC 4.51, but disk I/O
is not in ROM version I think.)

References:
- \[hb68] [パソコンPCシリーズ 8001 6001 ハンドブック][hb68]. Covers PC-8001
  and PC-6001 BASIC, memory maps, disk formats, peripheral lists, and all
  sorts of further technical info.
- \[mr] [NEC PC-8801mkIIMR N88-BASIC / N88-日本語BASIC REFERENCE
  MANUAL][mr], PC-8801MR-RM.


Usage
-----

`ESC` pauses listings, program operation, etc. (Works in monitor, too.)

#### Extensions

- `BEEP`: Short beep; add `1` to turn on, `0` to turn off.
- `HEX$(n)`
- `MON`: Enter monitor.
- `MOTOR`: Toggle cassette motor relay. Add `1` to turn on, `0` to turn off.
- `STRING$(n,c)`: _n_ copies of character code _c_.
- `SWAP`: Exchange values of two vars.
- `TERM`: Act as terminal via RS-232.

Untested/unresearched:
- `CMD ...`: ???
- `IN p`,`OUT p,x`: Peek/poke for I/O ports.

#### Text/Graphics

Also see Table 2 (p.80) in [Byte] for summary and [asahi] for more details.

The following are all the non-printing control characters in BASIC. ($08
does not backspace, but prints control picture `␈`. However, `DEL` key sends
backspace.)

    Dec  Hex  Ctrl Key       Function
    ───────────────────────────────────────────────────────────────────────
      7  $07  BEL            beeps speaker?
      9  $09  TAB            cursor to next multiple of 8 columns
     10  $0A  LF             cursor down one line
     11  $0B  VT   HOME      cursor to upper left of screen
     12  $0C  FF   CLR       clear screen and cursor to upper left
     13  $0D  CR   RETURN    cursor to beginning of current line
     28  $1C       →         cursor right
     29  $1D       ←         cursor left
     30  $1E       ↑         cursor up
     31  $1F       ↓         cursor down

- `WIDTH h,v`: _h_ = 80, 72, 40, 36; 72 and 36 are same char cell size as
  80 and 24, with narrower lines. Optional _v_ = 25, 20. Use v=25 if using
  160×96 (with status line) or 160×100 graphics.
- `CONSOLE top,len,fkey,cbw`: At least one arg required.
  - _top_: this many lines at top of screen do not scroll
  - _len_: this many lines in the scroll area (lines below do not scroll)
  - _fkey_: 0=last line usable; 1=last line shows fkeys.
  - _cbw_: 0=b/w mode, 1=color mode (greyscale on mono output)
- `CLS`: Doesn't exist; use `PRINT CHR$(12);`.
- `COLOR fg,bg,gr`: _fg_ color of following output. _bg_ background colour
  to fill on next screen clear. _gr_ 0=character mode, 1=graphic mode. (All
  args optional but at least 1 must be given.)
- `LOCATE x,y,csr`: Optional _csr_ 0=cursor off 1=cursor on.
- `GET @(x₀,y₀)-(x₁,y₁), arr`: Store chars from screen into array _arr_.
- `PUT @(x₀,y₀)-(x₁,y₁), arr`: Put chars from array _arr_ onto screen.
- `PSET (x,y),c`, `PRESET (x,y)`: Draws dot at 0-based _x,y_. _c_ is
  optional color (PC-6001 only?). _x,y_ > (159,95) will set "pixel" at edge
  of screen.
- `LINE ln,mode`: Color mode only; mono mode is syntax error. Screen line
  _ln_ is changed to mode: 0=normal 1=blink 2=reverse 3=reverse blink.
- `LINE (x₀,y₀)-(x₁,y₁), "ch", color, b, f`.  _ch_ (required) is character
  to draw or `PSET`/`PRESET`. _color_ is optional. Adding `B`,`F` params at
  end (no commas needed) draw a block (square) and filled square.

Color codes (for `COLOR`, `LINE`, `PSET`). Monochrome mode default is
`COLOR 0,0`; color mode default is `7,0`.

    Code    Color Mode      Monochrome Mode (char attributes)
    ────────────────────────────────────────────────────────────────
      0      黒  black              normal
      1      青  blue               secret (non-printing text)
      2      赤  red                blink
      3      紫  magenta            secret
      4      緑  green      reverse
      5     水色 cyan       reverse secret
      6      黄  yellow     reverse blink
      7      白  white      reverse secret

#### Machine-language Interface

- `DEFUSRn=m`:
- `a=USR(n)`: _n_ = 0-7


Technical Information
---------------------

Reserved word map: [[hb68]] pp.96-97.

<!-------------------------------------------------------------------->
[asahi]: https://archive.org/details/PC8001600100160011982
[byte]: https://tech-insider.org/personal-computers/research/acrobat/8101.pdf
[hb68]: https://archive.org/stream/PC8001600100160011982#page/n5/mode/1up
[mr]: https://archive.org/stream/NECPC8801mkIIMRN88BASICN88BASICREFERENCEMANUAL1986L#mode/1up
