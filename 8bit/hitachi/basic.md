Hitachi BASIC MASTER BASIC
--------------------------

References:
- [MB-6885 ﾍﾞｰｼｯｸﾏｽﾀｰJr.][ar-bmj] system manual. (p._n_ references below.)

### Character Codes

- Chart on p.47. Block graphics, greek/math, ASCII through `z`,
  graphics, kana, kanji, grahpics.
- Char codes <16 control screen, cursor, etc.
  - For ROM glyphs 0-15 print `CHR$(1)` followed by code.
  - $04: cursor home (doesn't work?)
  - $07: bell
  - $08,$09,$10,$11: cursor left, right, down, up
  - $0C: clear screen and home cursor
  - $0E: shift-out; swap text/background color
  - $0F: shift-in; cancel above?
  - $7F: move cursor back; rubout previous char

### Graphics

The two pages of 256×192 monochrome graphics starting at $0900 and $2100
are not not directly supported by Level 2 BASIC, but you can call some ROM
routines and PEEK/POKE, as described on pp.114 et seq. More details in
[memmap](./memmap.md).


Data, Values, Variables
-----------------------

- Use `$FF`/`$FFFF` notation for hex input; `HEX(n)` for conversion to
  16-bit unsigned int.
- FP numeric range is approx 3e-329 to 1.7e38.
- Variables have 1-2 letter names.
- Arrays are 1-based, only 1 or 2 dimensions.


Statements and Functions
------------------------

Commands:
- Use `,`, not `,` to separate args to `LIST`.
- `SEQ n,k` to auto-generate line numbers at which to type.
- `RESEQ n,k` to renumber existing lines. Destroys numbering.

Etc.
- `A$=INKEY$` returns `A$<CHR$(1)` on no input.
- Supports `DEF FNF(P)=…`.
- `MUSIC ﾄﾚﾐ` to play do-re-me. (p.81)
- `POKE addr,v0,v1,…`


Input/Output
------------

I/O support (p.83) includes user-level drivers, e.g. `OPEN
log,phy,"name",drv`. _log_ is the logical device number chosen by the
programmer. _phy_ is the physical device: 1=screen, 2=keyboard, 3=CMT1
out, 4=CMT1 in, 5=CMT2 out, 6=CMT2 in, 7-15=user devices. For 7-15
specify a driver with the _drv_ parameter. (_phy_ 7-15 without a third
parameter gives `ERROR 6`.)

The _drv_ parameter is the address of the data block for the driver,
e.g., `$5000`. This is a 9-byte block of three `JMP` (`$7E`)
instructions to the open, I/O and close routines. See p.87 for an
example of this with JMP to an RTS (`$39`) for open/close and to
`$F00C` for I/O which is some sort of `MUSIC` thing? Also example on
p.104 using $E200 (jump tables to $E224, $E280, $E217) and several
examples using $E209 (JMP $E271, $E169 and start of actual routine at
$E20F).

pp.100- has info on saving machine-language code along with BASIC (or
separately?) using some $F682 routine (maybe monitor ML load/save?)
Looks like they `DIM` an array first thing for the space, and look up
top of BASIC variable area from $08/$09 (default $3FFF).



<!-------------------------------------------------------------------->
[ar-bmj]: https://archive.org/details/Hitachi_MB-6885_Basic_Master_Jr/
