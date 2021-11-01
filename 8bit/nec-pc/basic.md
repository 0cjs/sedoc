N80 and N88 BASIC
=================

Also see [`programs`](programs.md).

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

- `WIDTH h,v`: _h_ = 80, 72, 40, 36; 72 and 36 are same char cell size as
  80 and 24, with narrower lines. Optional _v_ = 25, 20.
- `LOCATE x,y`
- `PSET x,y`, `PRESET x,y`: Draws dot at _x_, _y_.
- `LINE x₀,y₀-x₁,y₁, "char", color, b, f`. _b_ if present is block, _f_ if
  present is fill.
- `GET @x₀,y₀-x₁,y₁, arr`: Store chars from screen into array _arr_.
- `PUT @x₀,y₀-x₁,y₁, arr`: Put chars from array _arr_ onto screen.




<!-------------------------------------------------------------------->
[asahi]: https://archive.org/details/PC8001600100160011982
[byte]: https://tech-insider.org/personal-computers/research/acrobat/8101.pdf
[hb68]: https://archive.org/stream/PC8001600100160011982#page/n5/mode/1up
[mr]: https://archive.org/stream/NECPC8801mkIIMRN88BASICN88BASICREFERENCEMANUAL1986L#mode/1up
