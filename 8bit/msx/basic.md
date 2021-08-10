MSX BASIC Reference
===================

- Only the first two characters are significant in variable names,
  excepting some system variables (e.g., `ERL` and `ERR`, which have their
  own tokens and are thus actually keywords), but in program text they may
  be of arbitrary length so long as they do not include keywords (which
  will be tokenized).
- In BASIC hexadecimal numbers may be specified with `&Hnnnn` syntax.
- Default mode is screen 1 (32×24 characters); use `SCREEN 0` for 40×24 and
  then `WIDTH 80` (MSX2) for 80×24. (`SET SCREEN` will save these settings
  and restore them on startup.)
- The `MEM:` device cannot be used until you `CALL MEMINI (size)` (default
  size is 32000 bytes). List files on it with `CALL MFILES`, and erase with
  `CALL MKILL ("myfile.bas")`.

### Loading/Saving

- `LOAD "<dev>[<filename>]"`. Non-empty string argument required. Default
  device is cassette (`CAS:`?).
- `CLOAD ["<filename>"]`: Load from cassette. Filename optional, baud rate
  determined automatically. After reading the header, `Found:filename` will
  be displayed.
- `CLOAD? ["<filename>"]`: Verify in-memory program against cassette.
  Prints `Found:<filename>` followed by ? or `Verify error`.
- `CSAVE "<filename>"[,<baudrate>]`: _baudrate_ is `1`=1200 baud, `2`=2400
  baud. (Default set with `SCREEN` command.)
- `SAVE "<dev>[<filename>]"`
- `BLOAD`, `BSAVE`: See [Technical/Internals](./bastech.md).

### Variable Definition and Special Variables

- `DEFINT`, `DEFSNG`, `DEFDBL`, `DEFSTR`: Declares all variables starting
  with a letter from the range (required parameter, e.g., `I-N`) to be
  integer, floating point single or double precision, or string. Variables
  with explicit type declarations (`%`, `!`, `#` for integer, single,
  double precision) are excluded from this.
- `TIME` (unsigned integer): Incremented by 1 every VDP interrupt (60 Hz on
  NTSC systems). Not incremented when interrupts disabled, e.g. when doing
  cassette I/O.
- `SPRITE$(<pat no>)` (string), `VDP(<n>)` (unsigned byte), `BASE(<n>)`
  (integer). Graphics-related.

### Functions

- `MID$(X$,I[,J])`: Substring of length _J_ (default to end of string)
  beginning with the _I_th character. `1` is the first character of _X$_.

### Screen and Graphics

- `CLS`: Clear screen. Valid in all screen modes.
- `COLOR [foreground][,background][,border]`. Set color of all character
  cells on the screen. All parameters optional, one must be given. The `F6`
  default programming sets the default startup colours: 15,4,7 for JP,
  15,4,4 for all others.

Color codes:

    0 transparent    4 blue dark     8    red medium   12   green dark
    1 black          5 blue light    9    red light    13 magenta
    2 green medium   6  red dark    10 yellow dark     14    gray
    3 green light    7 cyan         11 yellow medium   15   white


References
----------

- MSX Wiki: [MSX-BASIC]
- MSX Wiki: [Instructions by category][instr]
- MSX Wiki: [Extensions][extn]
- _MSX2 Technical Handbook_ (en) [Ch.2 BASIC][the.2.0]. Starts with a
  complete list of BASIC keywords, functions and special variables, and
  continues with technical information on the internals of BASIC.
- _MSX2 Technical Handbook_ (ja), [Ch.3 BASICの内部構造][thj.kouzou]. BASIC
  internals only.
- [_A Guide to MSX-BASIC Version 2.0_][guide], Sony.



<!-------------------------------------------------------------------->
[MSX-BASIC]: https://www.msx.org/wiki/Category:MSX-BASIC
[extn]: https://www.msx.org/wiki/Category:MSX-BASIC_Extensions
[guide]: https://archive.org/stream/AGuideToMSXVersion2.0#page/n3/mode/1up
[instr]: https://www.msx.org/wiki/Category:MSX-BASIC_Instructions
[the.2.0]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter2.md/#3-internal-structure-of-basic
[thj.kouzou]: https://archive.org/stream/MSX2TechnicalHandBookFE1986#page/n68/mode/1up
