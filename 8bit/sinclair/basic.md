Sinclair ZX81 BASIC
===================

Key notation: `⇧`=SHIFT. `↵`=NEW LINE. `⇧0`=RUBOUT.

The input modes are indicated by the letter in the reverse-video cursor:

- `K`: Keyword written above key. But numbers, SPACE, `⇧`+key taken as is.
- `F`: Function, entered with `⇧↵"`+key.
- `L`: Letter: char at left of key; shifted chars/keyword in red on key.
- `G`: Graphics mode: enter/exit with `⇧9`. Reverse video char on key or,
  holding `⇧`, char to right or reverse-video shifted punctuation.
- `S` Syntax error at marked position in line; input not accepted with `NEW
  LINE` until fixed. (`⇧←` and `⇧→` move cursor to help fix.)

Editing programs:
- Note that cursor is _between_ chars; its position is not a real char.
- ←/`⇧5` and →/`⇧6` move cursor back and forth in current line.
- ↓/`⇧6` and ↑/`⇧7` scroll through program to select line. EDIT/`⇧1` to
  bring up line for editing.

Running programs:
- Status report at pause or end is `N/M` of error code (Appendix B) and
  last line executed.
- When screen fills, output will pause. You can enter any keyword here;
  press CONT to continue executing program.
- SPACE becomes BREAK when program is running.

### Common Errors

    0   Success / no error
    2   Undefined variable
    3   Subscript out of range
    5   No more room on screen. CONT will clear and continue.

### Keywords

- `PLOT x,y`, `UNPLOT x,y`: Plot quarter-character boxes in (0,0) – (63,43)
  range. Leaves cursor at character cell just after the cell with the
  plotted dot.

### Functions

Function invocations are always followed by a space. Parens are not
necessary except to compose an expression to be passed to the function.
