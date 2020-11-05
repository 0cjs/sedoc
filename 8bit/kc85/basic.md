KC85 Microsoft BASIC
====================

- Lines are up to 255 chars long.
- The screen is not editable; use `EDIT [nnn[-mmm]]` to bring up a
  full-screen editor (the TEXT program) on the entire program or a line or
  line range. Adding additional lines will add new lines to the program.
  De/re-tokenization make take some time.
- `PAUSE` will pause output.

File management:
- BASIC has a "current workspace" which is either a `fname.BA` file or the
  unnamed workspace. Changes to the workspace immediately change the file.
  From the unnamed workspace you may `SAVE "fname"` to create a new named
  workspace; from a named workspace it will produce an `?FC Error` (illegal
  function call).
- `LOAD "fname"` will change the workspace to the given file.
- Selecting a program file from the menu and hitting Enter will set the
  workspace to that file and `RUN`, going to interpreter after break/exit.
- Selecting `BASIC` uses the unnamed workspace; this is preserved across
  runs of other selected programs.
- `SAVE "fname",A` will save a copy of the current program in ASCII format
  to `fname.DO`; the current workspace does not change.
- `LOAD "fname.xx"` when _xx_ is not a `.BA` file will wipe the current
  workspace, replacing it with the ASCII load.
- `MERGE` merges another file into the current workspace.
- Use `KILL "fname.ex"` to remove a RAM file. (`?FC Error` if it's current
  workspace.)
- `FILES` lists RAM files.
- `NAME` renames a RAM file.


Data Types
----------

- Double precision (8 bytes): 14 digit significand, 7-bit (signed)
  exponent. Use `D` in exponent to force.
- Single precision (4 bytes): 6 digit significand, 7-bit (signed) exponent.
  Use `E` in exponent to force.
- Integer (2 bytes): 16-bit signed (-32768 to 32767).
- String: up to 255 chars.
- Arrays as `XY(0)` etc. Single-dimension arrays ≤ 11 elements need not be
  `DIM`ed.

Only the first two chars of variable names are significant. Suffixes are
`%` integer, `!` single precision, `#` double precision, `$` string; no
suffix defaults to double precision. `DEFINT`, `DEFSNG`, `DEFDBL`, `DEFSTR`
are available.

Numeric operators: `+ - * / \ ^ MOD`. (`\` is integer division; type with
`GRPH -`.)

Logical operators convert their arguments to integers and do bitwise
operations; 0 is false and 1 is true. As well as `NOT`, `AND`, `OR` and
`XOR`, `EQV` is inverted XOR (1 when both bits are 0 or both are 1) and
`IMP` is 1 when the LHS bit is 1 and RHS bit is 0, otherwise 0.

Conversions between numeric types are automatic. Conversion to integer is
via truncation, double to single via rounding. `VAL(s)` and `STR$(n)` do
numeric/string conversions.


Special Variables
-----------------

- `MAXRAM`: highest memory addr available to BASIC?


Interrupts
----------

Certain conditions can generate a `GOSUB`:

- `ON COM`: when data received on RS-232C port.
- `ON MDM`: when data received by modem.
- `ON KEY`: when function key pressed.
- `ON TIME$`: at given time (`ON TIME$="10:00:00"`)
- `ON ERROR`

Use `COM/MDM/KEY/TIME$` followed by `ON` to re-enable, `STOP` to mask
(remembering `ON ...` settings), and `OFF` to clear `ON ...` settings.


Statements and Functions
------------------------

- `MID$(a$, pos[, len])`. Evaluates to _len_ (default all) chars starting
  at 1-based _pos_. As LHS may be assigned to replace a substring, but
  length may not change; if replacement is less than _len_ the
  replacement's length is used; if greater only _len_ chars are replaced.


Machine Language Interface
--------------------------

- `CALL addr[,a[,hl]]`: Calls _addr_ with A register and HL register.
