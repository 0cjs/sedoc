MSX BASIC Technical Information
===============================


Syntax Notes
------------

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

Loading/saving:
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
- `BLOAD`, `BSAVE`: See below.

Functions:
- `MID$(X$,I[,J])`: Substring of length _J_ (default to end of string)
  beginning with the _I_th character. `1` is the first character of _X$_.

Misc:
- `DEFINT`, `DEFSNG`, `DEFDBL`, `DEFSTR`: Declares all variables starting
  with a letter from the range (required parameter, e.g., `I-N`) to be
  integer, floating point single or double precision, or string. Variables
  with explicit type declarations (`%`, `!`, `#` for integer, single,
  double precision) are excluded from this.

References:
- MSX Wiki: [MSX-BASIC]
- MSX Wiki: [Instructions by category][instr]
- MSX Wiki: [Extensions][extn]
- _MSX2 Technical Handbook_ (en) [Ch.2 BASIC][the.2.0]. Starts with a
  complete list of BASIC keywords, functions and special variables, and
  continues with technical information on the internals of BASIC.
- _MSX2 Technical Handbook_ (ja), [Ch.3 BASICの内部構造][thj.kouzou]. BASIC
  internals only.
- [_A Guide to MSX-BASIC Version 2.0_][guide], Sony.


File Formats
------------

- ASCII files (including BASIC files saved with `SAVE "filename",A`) use
  CR+LF line terminators and end with a `^Z` ($1A).
- Tokenized BASIC files have an $FF type byte followed by a binary dump of
  the in-memory BASIC program text format (see below). The next line pointers
  are recalculated after load.
- [`BSAVE`/`BLOAD` files][binfile] have an $FE type byte followed by three
  little-endian words: start address, end address and entrypoint (execution
  address).

#### Common File Extensions

- Binary files: `.BIN`, `.SC?`, `.PL?`, `.GE5`, `.PIC`.

#### File-handling Commands

- [`BSAVE "name",start,end,exec`][bsave]
- [`BLOAD "name",[RS],offset`][bload]. Optional params:
  - 2: `R` to run code after loading, `S` to load to VRAM.
  - 3: Offset to add to start and execution address. (XXX confirm this.)


Memory Usage
------------

Addresses of system variables:

     hex   dec  name    descr
    002D                BASIC version ($00=1.0, $01=2.0)
    409B                BASIC warm start entrypoint
    F672 -2446  MEMSIZ  high address of string data heap
    F674 -2444  STKTOP  base of stack (grows down from here)
    F676 -2442  TXTTAB  BASIC program text start addr (usu. $8001)
    FBB1 -1103  BASROM  BASIC text location: 0=RAM, ¬0=ROM
    FBE5 -1051  NEWKEY  key matrix status new
    FC48  -952  BOTTOM  $00 byte before start of BASIC text
    FC4A  -950  HIMEM   BASIC allocates only below this

Memory map (default/common values in brackets):

    $0000-7FFF  BIOS and BASIC interpreter (ROM)
    BOTTOM      [$8000 (higher on < 32K RAM systems)] $00 byte
    TXTTAB      [$8001] BASIC program text starts
    VARTAB      scalar variables start
    ARYTAB      array variables start
    STREND      free memory start
    SP          (stack pointer indicates lowest stack extent)
    STKTOP      base address for stack (grows down)
    -           string data heap bottom
    MEMSIZ      string data heap top
                file control block(s) (set with MAXFILES=n; 264 bytes each)
    HIMEM       [$DE78 on Son HB-F1XD] set by CLEAR 2nd param

BASIC program text is in standard MS format as used in tokenized saves (see
above).

Scalar variables are stored as type (1 byte) and name (2 bytes) followed by
variable data. `VARPTR` returns a pointer to the variable data after the
three type/name bytes.

    type           type byte   variable data
    ───────────────────────────────────────────────────────────────────────
    integer               02   16-bit signed 2's complement integer
    string                03   1-byte length, 2-byte pointer to string data
    single-prec. float    04   4 byte floating point number
    double-prec. float    08   8 byte floating point number

The string data heap is fixed size and is used only for dynamically
generated string values; constants in program text use the value from the
program text area. The remaining free space in the heap queried with
`FRE("")`; `FRE(0)` space does not include the string heap. Allocating a
string will reduce the string heap space by the length of the string and
`FRE(0)` space by 6 bytes for the variable overhead. Exceeding string heap
storage will result in an `Out of string space` error.

Memory from HIMEM upward is used for MSX-DOS etc, typically leaving 23-28K
for BASIC. At boot it's $DE78 on a single-drive Sony HB-F1XD. It may be set
to a new value with the second optional parameter to `CLEAR` which is
typically used to reserve space for machine language routines.

References:
- MSX Wiki [The Memory][mem]
- _MSX2 Technical Handbook_ (ja), [Ch.3 BASICの内部構造][thj kouzou]
- _MSX2 Technical Handbook_ (en), [Ch.2 §3 Internal Structure of BASIC][the.2.3]
- [_Learn Assembly Programming With ChibiAkumas_][chibiaku].
  Includes a table of memory addresses and their values.


BASIC Program Text and Tokenization
-----------------------------------

Program lines are stored as follows:

    2 bytes     pointer to next line; $0000 for end of text
    2 bytes     line number (16 bit unsigned int); max $FFF9 or 65529
    n bytes     tokenized program text; see below
    00          program line terminator

Tokenization:

    $00             program line terminator, when not part of token data
    $0B $nn $nn     &O octal number; unsigned 16-bit int
    $0C $nn $nn     &H hex number; unsigned 16-bit int
    $0D $nn $nn     line number (post-`RUN`); addr of destination line
    $0E $nn $nn     line number (pre-`RUN`); unsigned 16-bit int line number
    $0F $nn         integer 10-255
    $11 - $1A       integer 0-9
    $1C $nn $nn     integer 256-32767
    $1D 4×$nn       single-prec. float
    $1E 8×$nn       double-prec. float
    $20-$7F         ASCII character
    $80-$FE         keyword token
    $FF $nn         keyword token

Tokenized integer values are always positive; the non-tokenized `+` or `-`
prefix determines the sign. There is no tokenization for `&B` numbers.

Keyword token lists are available in the [scanned Japanese][thj.tok] and
[machine-readable English][the.tok] MSX2 Technical Handbooks, without the
following omissions and corrections:
- `REM` is tokenized as just `8F` (not `3A 8F`).
- Apostrophe `'` also serves to introduce a comment and does not require a
  `:` to separate it from preceeding code on the line. It's tokenized as
  `3A 8F E6`, i.e., a `:`, `REM` token and `E6` to indicate it should not
  be LISTed as `:REM`.

#### Character Encoding

In programs entered in the BASIC interpreter, non-ASCII characters appear
only in string constants (quoted strings and bare strings in `DATA`
statements) and `REM` statements. The [256 code points][charset] are
encoded as follows. `CP` means "code point"; all numeric values are
hexadecimal.

    CP      Encoding                            Description
    ───────────────────────────────────────────────────────────────────────────
            00                                  control character
    00-1F   01 nn   CP = nn-40; 40≤ nn < 5F     "extended" characters
            02-1F   control characters
    20-7E   nn      cp = nn                     ASCII characters [1]
    7F      --                                  control character [2]
    80-FF   80-FF   cp = nn                     graphics characters/kana
                                                (varying by charset)

Notes:
1. In the Japanese charset only, code point `5C` is `¥` instead of `\`.
2. It seems that code point `7F` cannot be encoded or printed in BASIC. In
   the Japanese charset this is a blank glyph, in other charsets it's `△`.

References:
- [MSX Characters and Control Codes][codes], msx.org wiki.
- [`bastok`] MS-BASIC tokenization tools documentation.

#### Tokenization Process

This is really more of a weird kind of lexer than a parser, and I don't
think it can be parsed with a standard parser framework.

MS BASIC uses a subroutine called `CRUNCH` to scan the complete line from
start to end. When the characters starting at the current scan point match
a string from the "crunch table," those characters are replaced by a token.
This implies that keywords in the middle of variable names are parsed as
keywords, e.g. `XSIN=1` is tokenized as `X`, `SIN` (function token), etc.
and is (later) parsed as variable `X` followed by a function call.

Not everything is tokenized; a `DORES` variable is set when parsing `DATA`
statements so that strings in them need not be quoted. (And presumably that
or something similar is used for string constants and `REM`/`'`.)


Machine-language Subroutines
----------------------------

HIMEM (last usable address + 1) can be read from $FC4A (-950); the default
is $DE78 on the sony HB-F1XD. The second parameter to `CLEAR` will reset
this to another value, after clearing variables. Typical use is to reserve
space for machine code.

`DEFUSRn=addr` (_n_ = 0 to 9) sets call address of `USRn(x)`. On entry, `A`
and $F663 will contain the type of `x` and, for numeric parameters, `HL`
will point to $F7F6. For the return value, set $F663 to the return type and
registers as set for a call of that type. (You do not use `USR$(x)` when
return values are strings.)
- `A=2` int: parameter at $F7F8-$F7F9
- `A=4` single precision: parameter at $F7F6-$F7F9
- `A=8` double precision: parameter at $F7F6-$F7FD
- `A=3` string: `DE` points to string descriptor: length byte followed by
  pointer to string contents.

Example from the Sony _Guide_ (p.256). Not clear why it sets HL=$F03C
instead of HL=$F7F6 (or leaving it alone) per above. (The later example in
the guide uses $F7F6+2 to return an int.)

    100 A=&hD000
    110 READ B$ : IF B$="end" THEN END
    120 POKE A,VAL("&H"+B$)
    130 A=A+1 : GOTO 110
    140 DATA 21,3C,F0,C9,end : REM ld hl,$F03C; RET

References:
- Chapter 10 of the [Sony _Guide_][guide].


<!-------------------------------------------------------------------->
[MSX-BASIC]: https://www.msx.org/wiki/Category:MSX-BASIC
[`bastok`]: https://github.com/0cjs/bastok
[binfile]: https://www.msx.org/wiki/MSX-BASIC_file_formats#MSX-BASIC_binary_files
[bload]: https://www.msx.org/wiki/BLOAD
[bsave]: https://www.msx.org/wiki/BSAVE
[charset]: ./charset.md
[chibiaku]: https://www.chibiakumas.com/z80/msx.php
[codes]: https://www.msx.org/wiki/MSX_Characters_and_Control_Codes
[extn]: https://www.msx.org/wiki/Category:MSX-BASIC_Extensions
[guide]: https://archive.org/stream/AGuideToMSXVersion2.0#page/n3/mode/1up
[instr]: https://www.msx.org/wiki/Category:MSX-BASIC_Instructions
[mem]: https://www.msx.org/wiki/The_Memory
[the.2.0]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter2.md/#3-internal-structure-of-basic
[the.2.3]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter2.md/#3-internal-structure-of-basic
[the.tok]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter2.md/#table-220--list-of-intermediate-codes
[thj.kouzou]: https://archive.org/stream/MSX2TechnicalHandBookFE1986#page/n68/mode/1up
[thj.tok]: https://archive.org/stream/MSX2TechnicalHandBookFE1986#page/n74/mode/1up
