NEC PC-nnn Series
=================

- 1979: [PC-8001](8001.md): Business/games.
- 1981: [PC-6001](6001.md): Lower-end gaming; includes cartridge port.
- 1981: [PC-8801](8801.md): Moving more towards business. Separate keyboard
  on all models; integrated FDDs in models after the first.
- 1982: [PC-9801](9801.md): 16-bit, business
- 1983: mkII released for all 8-bit series
- 1985: 8-bit  mkII SRs released: end of PC-80 and focus on games for PC-88.


Machine-language Monitor
------------------------

Enter from Basic with `MON` command. Prompt is `*`.

- `Dx,y`: Display bytes at addrs _x_ (def. 0) to _y_ (def. x+$10).
- `Sx`: Display byte at _x_ and prompt for new value;
  continue with next addr until no value entered.
- `G x`: Goto addr _x_.
- `W x, y`: Write tape block from _x_ to _y_.
- `L`: Load tape block.
- `LV`: Load tape block and verify it's correctly loaded.
- `TM`: Test memory and return to Basic.
- Ctrl-B: Return to Basic.


BASIC
-----

`Esc` pauses listings, program operation, etc. (Works in monitor, too.)

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
