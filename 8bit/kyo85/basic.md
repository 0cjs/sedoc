KC85 Microsoft BASIC
====================

References:
- Model 100 Owner's Manual, Part III [Ch.12-16][m100 user bas]
- [_PC-8201 N₈₂-BASIC Reference Manual_][basref-j] (Japanese)
- [_PC-8201A N₈₂-BASIC Reference Manual_][basref-e] (English)

Model 100 Microsoft BASIC seems to be a late 8080/8085 version, similar to
MSX. PC-8201 "N₈₂-BASIC" seems very similar, but not identical.

- (M100) `PAUSE` will pause output.

General:
- Lines are up to 255 chars long.
- (M100) The screen is not editable; use `EDIT [nnn[-mmm]]` to bring up a
  full-screen editor (the TEXT program) on the entire program or a line or
  line range. Lines may be added and removed. Re-tokenization make take
  some time.
- (PC82) Screen is editable. `SHIFT-F4 List.↑↑` will list current line and
  move cursor back up to it. (But `EDIT` still available.)

### File Management

BASIC has a "current workspace" which is either a `fname.BA` file or the
unnamed workspace. Changes to the workspace immediately change the file.
From the unnamed workspace you may `SAVE "fname"` to create a new named
workspace; from a named workspace it will produce an `?FC Error` (illegal
function call).

- `LOAD "fname"` will change the workspace to the given file.
- Selecting a program file from the menu and hitting Enter will set the
  workspace to that file and `RUN`, going to interpreter after break/exit.
- Selecting `BASIC` uses the unnamed workspace; this is preserved across
  runs of other selected programs.
- `LOAD "fname.xx"` when _xx_ is not a `.BA` file will wipe the current
  workspace, replacing it with the ASCII load.
- `NEW` will switch back to the unnamed workspace and clear it, leaving the
  previous workspace as it was (unless it was already the unnamed workspace).
- `SAVE "[dev:]fname",A` (or with `.DO` extension given) will save a copy
  of the current program in ASCII format to `fname.DO`; the current
  workspace does not change.
- See "Machine Language Interface" for using/managing `.CO` files.

File management commands:
- `MERGE "[dev:]fname"` merges another file into the current workspace.
- Use `KILL "fname.ex"` to remove a RAM file. (`?FC Error` if it's current
  workspace.)
- `FILES` lists RAM files. (PC82: The current workspace file is marked with
  `*`.)
- `NAME` renames a RAM file.

Devices (used where optional `[dev:]`; default often `RAM:`):
- `RAM:`: Internal memory (PC82: current bank). For `SAVE`, if no extension
  is given `.BA` or `.DO` (when `,A` given) is appended.
- `CAS:`: Cassette tape (CMT). Filename has no extension. No filename for
  load uses next found file. Same as `CLOAD`, `CLOAD?`, `CSAVE`.
- `COM:` _fname_ is a configuration as used by TELCOM. Always saves as
  ASCII with CR+LF terminators.
  - (M100) _fname_ required. speed/wordlen/parity/stopbits/xonflow;
  - (PC82) Optional. speed/parity/wordlen/stopbits/xonflow/sisoflow. Cannot
    be used while CMT in use.
- `MDM`: (M100) As per `COM:`, but _fname_ has no speed char at start.
- `LCD:`: Output only to screen.
- `LPT:`: Output only to printer. Like `LLIST`.

To load a program from the serial port, use (M100) `LOAD "COM:98n1d"` (19.2
kbps) or (PC82) `LOAD "COM:"`. Send the file (only ASCII format can be
used) followed by a `^Z`, which can be typed manually in the terminal
program. This will clear any previously existing code. Errors (usually
`?DS` "direct statement" or `?UL` "undefined line" usally indicate
overflow. For 19.2 kbps, 75 ms line delay and 3 ms char delay seems to
work. (That's for BASIC only; it's still too fast for TELCOM downloads,
probably due to display and screen scrolling during download.)


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


Special Variables
-----------------

(For memory-related vars, see "Machine Language Interface" below.)

- `INKEY$`: Next char from keyboard buffer, or empty string if none avail.


General Statements and Functions
--------------------------------

- `MID$(a$, pos[, len])`. Evaluates to _len_ (default all) chars starting
  at 1-based _pos_. As LHS may be assigned to replace a substring, but
  length may not change; if replacement is less than _len_ the
  replacement's length is used; if greater only _len_ chars are replaced.


Display-related Statements/Functions
------------------------------------

- (M100,PC82) `KEY ON|OFF`: Not present. (On MSX, this turns on and off the
  label line. Do this with `SCREEN` or the `LABEL` key on M100.)
- (M100,PC82) `SCREEN 0,n`: Disable/enable function key label line: _n_ is
  0=off, 1=on.

Graphics (_x_ = 0-239, _y_ = 0-63):
- `PSET (x,y)`, `PRESET (x,y)`.
- `LINE [(x1,y1)]-(x2,y2)[,switch[,BF]]` (M100): Starts at last ending
  position (default 0,0) if _x1,y1_ not given. _switch_ sets points if odd
  (defeault) or clears points if even. `B` draws box with given corners;
  `F` fills the box. (PC82: not present unless `LINE.CO` is loaded.)


Machine Language Interface
--------------------------

`.CO` files are machine-language programs prefixed by three words: start
addr, length, entrypoint. These return to the caller (BASIC or menu) on RET.

BASIC load/save:
- `SAVEM "[RAM:|CAS:]fname",start,end[,entry]`: Save binary data from
  memory with given header. _Entry_ defaults to _start._
- `LOADM "[RAM:|CAS:]fname"`: Load a machine-lanuage program. The device
  defaults to `RAM:` and the `.CO` extension is optional. Prints `Top:…`,
  `End:…`, `Exe:…` addresses in decimal before load. Returns `?OM Error` if
  load overlaps BASIC memory space.
- `RUNM "[RAM:|CAS:]fname",start,end[,entry]`: Run a machine-lanuage
  program. Prints address as `LOAD`. Program start with cursor at end of
  `End:…` line. Running directly from menu starts with clear screen
  instead. (If `CLEAR` not set properly, no error is printed.)

BASIC memory setup/access:
- `MAXRAM`: highest memory addr possibly available to BASIC. will return
  `?FC ERROR` for _aaaa_ above this. Always at the start of BASIC/BIOS
  workspace area: T100=$F5F0, T200=EEB0.
- `HIMEM`: Current end of BASIC RAM. Default `MAXRAM`; set with `CLEAR`.
- `CLEAR n[,aaaa]`: Set string heap to size _n_ and optionally `HIMEM` to
  address _aaaa_ (given in decimal).
- `CALL addr[,a[,hl]]`: Calls _addr_ with A register and HL register values
  (in decimal).


Converting Programs Between Models
----------------------------------

### M100 → PC82

High-level:
- `PRINT @nn` → `LOCATE x,y:PRINT`; _x_ = `nn MOD 40`; _y_ = `nn \ 40`.
- `MID$` LHS assignment not supported. Build new string instead.
- `ON KEY GOSUB`/`KEY ON|OFF|STOP` not available. You can sort-of
  substitute by polling with `INKEY$`.
- `LINE`: not present unless `LINE.CO` loaded.
- Use of `CHR$(131-255)` requires `CHR100.CO` or `LAPTOP.CO`.

Low-level:
- Assembly obviously needs to be converted to use correct ROM addrs, etc.
- `POKE`/`PEEK` need conversion (maybe `INP`/`OUT`, too).
- `CALL` not present; use `EXEC` after poking A and HL to certain memory
  locations.
- `VARPTR` not implemented; use routine below.

PC82 `VARPTR` substitute:

    40000 H=0:L=0:TY=0
    40010 POKE64448,205:POKE64449,175:POKE64450,73:POKE64451,235
    40020 POKE64452,58:POKE64453,139:POKE64454,250:POKE64456,201
    40030 IFVY$=""THENPRINT"VY$ not defined!":STOP
    40040 FORH=64457TO64463:POKEH,ASC(MID$(VY$,H,1)+CHR$(0)):NEXT:POKE64464,0
    40050 POKE63912,201:POKE63913,251:EXEC64448
    40060 L=PEEK(63912!):H=PEEK(63913!):TY=PEEK(63911!)
    40070 RETURN
    40080 ' VARPTR by Gary Weber
    40090 ' Entry: VY$ must contain the name of variable of interest
    40100 ' Exit: H & L contain variable's address, TY contains type
    40110 ' Example:
    40120 '   100 A$="This is a sample string."
    40130 '   110 VY$="A$":GOSUB 40000
    40140 '   120 PRINT "VARPTR of ";VY$;" is ";L+(H*256)

Sources: The [web8201 page][w8 basconv].



<!-------------------------------------------------------------------->
[basref-j]: https://archive.org/stream/n-82-basic-manual#page/n7/mode/1up
[basref-e]: https://archive.org/stream/nec-pc8201-n82-basic-reference#page/n3/mode/1up
[m100 user bas]: https://archive.org/stream/trs-80-m-100-user-guide#page/99/mode/1up
[w8 basconv]: https://www.web8201.net/default.asp?content=m100nec.asp
