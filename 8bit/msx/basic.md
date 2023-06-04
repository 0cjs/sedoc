MSX BASIC Reference
===================

See §References below for complete statement/function listings.
Additional notes "(KH: …)" below refer to functions from [Kanji BASIC]
and [Hangul BASIC] with extended functionality.

² indicates MSX2-only feature.

### General

- Only the first two characters are significant in variable names,
  excepting some system variables (e.g., `ERL` and `ERR`, which have their
  own tokens and are thus actually keywords), but in program text they may
  be of arbitrary length so long as they do not include keywords (which
  will be tokenized).
- In BASIC hexadecimal numbers may be specified with `&Hnnnn` syntax.
- Default mode for JP models is screen 1 (32×24 characters); use `SCREEN 0`
  for 40×24 and then `WIDTH 80` (MSX2) for 80×24. (`SET SCREEN` will save
  these settings and restore them on startup.)
- Optional parameters (`[,…]`) may be omitted; the trailing comma must be
  given if parameters after that are specified.

### Devices

    Device  Description                 Provided by
    ──────────────────────────────────────────────────────────────────
    CAS:    Cassette tape               MSX1 standard BIOS
    CRT:    CRT screen                  MSX1 standard BIOS
    GRP:    Graphic screen              MSX1 standard BIOS
    LPT:    Printer                     MSX1 standard BIOS
    COM:    Serial port                 RS-232 cart; some MIDI carts?
    CAT:†   Nonvolatile memory cart¹    Sony BIOS only?
    A:-H:   Floppy disk drive           FDC cart ROM
    MEM:†   RAMdisk                     MSX2 BIOS; disk BIOS only?

†Notes:
- `CAT:` The nonvolatile memory cartridge is the "external memory" on I/O
  ports $B0-$B3 described in the [I/O Address Map](
  ./address-decoding.md#i/o-address-map). The Sony HBI-55 and Yamaha UDC-01
  carts implementing this are also described there.
- `MEM:`: The device cannot be used until you `CALL MEMINI (size)` (default
  size is 32000 bytes). List files on it with `CALL MFILES`, and erase with
  `CALL MKILL ("myfile.bas")`.

### Loading/Saving

The default device is `CAS:` (CMT) in standard BASIC; Disk BASIC changes
the default to `A:` (or current drive?).

- `RUN "<dev>[<filename>]"` will load and run a file.
- `LOAD "<dev>[<filename>]"`. Non-empty string argument required. Default
  device is cassette (`CAS:`?). Add `,R` to run after loading.
- `MERGE file$`: Read ASCII lines from _f$_ and merge them into the current
  program. Does not work on binary files. If used in a program, program
  ends immediately after.
- `CLOAD ["<filename>"]`: Load from cassette. Filename optional, baud rate
  determined automatically. After reading the header, `Found:filename` will
  be displayed.
- `CLOAD? ["<filename>"]`: Verify in-memory program against cassette.
  Prints `Found:<filename>` followed by ? or `Verify error`.
- `CSAVE "<filename>"[,<baudrate>]`: _baudrate_ is `1`=1200 baud, `2`=2400
  baud. (Default set with `SCREEN` command.)
- `SAVE "<dev>[<filename>]"`
- `BLOAD`, `BSAVE`: See [Technical/Internals](./bastech.md).

Disk-only commands:
- `KILL "<filename>"` deletes (erases) a file.
- `NAME "<filename>" AS "<filename">"` renames a file.
- `CALL CHDRV("<letter>")`. Change default drive. Not available in
  Disk BASIC v1; use `POKE &HF247,n` where _n_ is 0=A, 1=B, etc.

### Memory Management

- `CLEAR [s[,m]]`: Clear all variables and DEF FN.
  - _s:_ Size of string heap at top of BASIC memory (default 200).
  - _m:_ Set `HIMEM` ($FC4A); BASIC will use memory only below this.
    - Min $831F, max $F380 (start of BASIC/BIOS work area).
    - Check w/`?hex$(peek(-950)+peek(-949)*256)`
    - Default depends Disk BASIC etc.: regular, Ctrl-boot, Shift-boot
      - MSX2 1drv Sony HB-F1XD:          $DE78, $E48E, $F380
      - MSX1 1drv National CF-3300:      $DE77, $E48D, $F380
      - MSX2 1drv Panasonic FS-A1F/A1FM: $DE67, $E47D, $F380
  - See also [How to call MSX-BASIC CLEAR command in Assembly][clear-asm],
    and perhaps [[clear-asm2]].
- `VARPTR(v)`: Return pointer to variable data for variable _v._
  See [§Variables in `bastech.md`](bastech.md#variables) for more information.

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

### Statements

- `REM`, `'`. The `'` version does not usually need to be preceeded by a
  colon if there are statements before it, though in some cases (after
  `CALL`?) the lack of a colon will cause errors.
- `ELSE`: Without a preceeding `IF` on the same line, ignores remainder
  of line. Unlike REM, the remainder is still tokenised and, if used to
  comment out a `GOTO`, `RENUM` will still renumber that `GOTO`.

### Functions

- `MID$(s$,i[,len])`: Return substring of _s$_ starting at 1-based index
  _i_ and of length _len_ (default to end of _s$_).
- `INSTR([start,] str$, sub$)`: Return the 1-based offset of _sub$_ in
  _str$,_ returning 0 if _sub$_ is not found. Optional _start_ is the
  1-based offset into _str$_ to start searching. (KH: `CALL KINSTR(…)`)

### Text and File I/O

Below, _f_ is a file handle, 1 to 15, but see `MAXFILES`.

- `MAXFILES=n`: Clear all vars, close all files, and set open file limit to
  _n_ (default 1). Limit is 6 on floppy disk and 2 on QuickDisk. Each
  available file uses 267 bytes.
- `OPEN path$ [FOR dir] AS #f [LEN=reclen]`
  - _path$_ not required for text/graphic screen or printer
  - _dir_ is `INPUT`, `OUTPUT` or `APPEND` and forces sequental mode.
  - `#` can be omitted from `#f`.
  - `LEN` uses random access mode; after open define w/`FIELD` and use `GET
    #f,recno`/`PUT`.
  - In sequential mode $1A char is always EOF; random treats $1A as data.
- `INPUT ["prompt";|#f,]v[,v…]`, `LINE INPUT ["prompt";|#f,]v$`:
  - `"prompt"` must be a string constant, not a variable
  - Screen editor is used so existing chars on the cursor's line will be
    returned. Open `CON:` to retrieve only what's typed.
  - `INPUT` parses like `DATA`; commas or newlines separate vars _v,_ and
    values can be quoted to read comma characters. `LINE INPUT` takes only
    one var and reads everything as-is.
- `INPUT$(n,f)`: Read _n_ characters from file. CR and LF are preserved
  as-is, but $1A is still considered EOF on text files.
- `FIELD #f, n as v[, n₁ as v₁ …]`
  - _n_ is an integer constant or integer variable (`I%`).
- `EOF(f)`: Returns 0 if not at EOF on _f._ Error on random access mode.

### Keyboard/Controller Input

- `INKEY$` (pseudo-variable): Returns `""` when no key pressed, otherwise
  the ASCII/MSX-charset character corresponding to a keypress w/given
  keyboard state (ctrl/shift/kana/etc.).
  - Special keys: 11 HOME, 12 CLS, 18 INS, 24 SELECT, 28 →, 29 ←, 30 ↑, 31 ↓
  - F-keys return their programmed sequence of characters.

### Screen, Graphics

- `CLS`: Clear screen. Valid in all screen modes.
- `COLOR [foreground][,background][,border]`. Set color of all character
  cells on the screen. All parameters optional, one must be given. The `F6`
  default programming sets the default startup colours: 15,4,7 for JP,
  15,4,4 for all others.
- `SET PAGE display,active`²: At least one parameter must be given.
  - Only for display modes 5,6 (64K:0-1; 128K:0-3)
    and 7,8,10,12 (64K:invalid; 128:0-1).
    Odd page must be used for interlace mode.
  - _display:_ page to display.
  - _active:_ page to use for VRAM reads/writes (inc. line drawing).
- `SCREEN <DisplayMode>, <SpriteSize>, <Keyclick>, <BaudRate>,
  <PrinterType>, <InterlaceMode>`: see [SCREEN] for full details.
  - _DisplayMode:_ 0=text 40×24 (2 colors only), 1=text 32×24, 2=block
    graphic 32×8×3, 3=bitmap 64×48, more for MSX2.
  - _SpriteSize:_ 0=8×8, 1=8×8 double-size, 2=16×16, 3=16×16 double-size
  - _Keyclick:_ 0=off, 1=on
  - _Baudrate:_ 0=1200, 1=2400
  - _PrinterType:_ 0=MSX Printer, 1=No MSX printer (different for Arabic)
  - _InterlaceMode:_ (MSX2 or higher)
- `BASE <TableNumber>`: returns current address in VRAM of a VDP table.
  See [BASE()] for full info and default values.
  - Screen 0:  0=name             2=pattern
  - Screen 1:  5=name   6=color   7=pattern   8=sprite-attr   9=sprite-pat
  - Screen 2: 10=name  11=color  12=pattern  13=sprite-attr  14=sprite-pat
  - Screen 3: 15=name            17=pattern  18=sprite-attr  19=sprite-pat
- `VPEEK(a)`, `VPOKE a,n`. In screen modes 5-8 the adress is the offset
  from the starting address of the active page.

### Sound

- `BEEP`: Generate a short tone from the PSG. Same as `PRINT CHR$(7)`.
  (MSX2: `SET BEEP t,v` changes timbre (1-4) and volume (1-4).)
- `PLAY #dev,"mml_ch1","mml_ch2",...`: Play music. _dev_=0 for PSG (can be
  omitted) 1=midi, 2/3=MSX-AUDIO or MSX-MUSIC (after `CALL AUDIO` or `CALL
  MUSIC`. MML: `A-Ghop` note, _h_=`+#-`, _o_=ocatave 1-8, _p_=periods to
  increase length by 1/2. `Ll` length _l_ (1-64 of a note). `Oo` octave
  _o_. `Rlp` rest length _l_, periods _p_ extend by 1/2. `Tt` tempo _t_
  32-255. Much more.
- `PLAY(c)` returns -1 (true) if muisc is playing on channel _c_ (0=all).
- `SOUND reg,val`: Write _val_ to PSG register _reg_ (0-13).

Color codes:

    0 transparent    4 blue dark     8    red medium   12   green dark
    1 black          5 blue light    9    red light    13 magenta
    2 green medium   6  red dark    10 yellow dark     14    gray
    3 green light    7 cyan         11 yellow medium   15   white

### Utility

For `LIST`, `LLIST` and `DELETE` a `.` specifies the last line `LIST`ed.

- `LIST lineno`, `LIST start-end`: List program. `LLIST` to list on printer.
  Lists lines but then ends program run if used in a program.
- `DELETE lineno`, `DELETE start-end`
- `RENUM [new[,current[,incr]]]`: Renumber program lines, updating
  references in `GOTO`, `GOSUB`, `RESTORE` etc. Optional parameters:
  - _new_ (default 10) is the new starting line number (0-65529).
  - _current_ (default 0) is the (old) line number at which to start
    renumbering. _new_ must be at least this number.
  - _incr_ is the increment for each new line.
- `AUTO [start[,incr]]`. Prompt with next line number for next line of
  BASIC program text. Ctrl-C to end input. Prompt is followed by ` ` if
  line number is currently unused (Enter leaves line unused), or `*` if
  line number already has text (Enter leaves line as-is).

To "undelete" a program after `NEW` you can use the following.
There are also [BASIC extensions][unnew] to do this more easily.

    POKE &H8002,128
    SAVE"TEMP.BAS"
    LOAD"TEMP.BAS"
    SAVE"TEMP.BAS",A
    LOAD"TEMP.BAS"


References
----------

- MSX Wiki: [MSX-BASIC]
- MSX Wiki: [MSX-BASIC in alphabetical order][instr]. Does not include
  reserved words, localised-only instructions or those added with special
  hardware. Does give the original generation (MSX1, MSX2, MSX2+) and that
  of any updates.
- MSX Wiki: [Instructions by category][instrcat]
- MSX Wiki: [Extensions][extn]
- _MSX2 Technical Handbook_ (en) [Ch.2 BASIC][the.2.0] ([source][the.2.0src]).
  Starts with a complete list of BASIC keywords, functions and special vars,
  and continues with technical information on the internals of BASIC.
- _MSX2 Technical Handbook_ (ja), [Ch.3 BASICの内部構造][thj.kouzou].
- [_A Guide to MSX-BASIC Version 2.0_][guide] (en), Sony. Beginner-oriented.



<!-------------------------------------------------------------------->
[Hangul BASIC]: https://www.msx.org/wiki/Hangul_BASIC
[Kanji BASIC]: https://www.msx.org/wiki/Kanji_BASIC
[MSX-BASIC]: https://www.msx.org/wiki/Category:MSX-BASIC
[SCREEN]: https://www.msx.org/wiki/SCREEN
[clear-asm2]: https://msx.org/forum/msx-talk/development/musica-disassembly-and-adapting-it-for-pure-asm
[clear-asm]: https://www.msx.org/forum/msx-talk/development/how-to-call-msx-basic-clear-command-in-assembly
[extn]: https://www.msx.org/wiki/Category:MSX-BASIC_Extensions
[guide]: https://archive.org/stream/AGuideToMSXVersion2.0#page/n3/mode/1up
[instr]: https://www.msx.org/wiki/MSX-BASIC_Instructions
[instrcat]: https://www.msx.org/wiki/Category:MSX-BASIC_Instructions
[the.2.0]: https://konamiman.github.io/MSX2-Technical-Handbook/md/Chapter2.html
[the.2.0src]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter2.md/#3-internal-structure-of-basic
[thj.kouzou]: https://archive.org/stream/MSX2TechnicalHandBookFE1986#page/n68/mode/1up
[unnew]: https://www.msx.org/wiki/Category:Old_BASIC
