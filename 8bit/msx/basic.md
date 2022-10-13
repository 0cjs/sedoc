MSX BASIC Reference
===================

Additional notes "(KH: …)" below refer to functions from [Kanji BASIC]
and [Hangul BASIC] with extended functionality.

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
- `INSTR([start,] str$, sub$)`: Return the 1-based offset of _sub$_ in
  _str$,_ returning 0 if _sub$_ is not found. Optional _start_ is the
  1-based offset into _str$_ to start searching. (KH: `CALL KINSTR(…)`)

### Screen, Graphics, Sound

- `CLS`: Clear screen. Valid in all screen modes.
- `COLOR [foreground][,background][,border]`. Set color of all character
  cells on the screen. All parameters optional, one must be given. The `F6`
  default programming sets the default startup colours: 15,4,7 for JP,
  15,4,4 for all others.
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
[Hangul BASIC]: https://www.msx.org/wiki/Hangul_BASIC
[Kanji BASIC]: https://www.msx.org/wiki/Kanji_BASIC
[MSX-BASIC]: https://www.msx.org/wiki/Category:MSX-BASIC
[extn]: https://www.msx.org/wiki/Category:MSX-BASIC_Extensions
[guide]: https://archive.org/stream/AGuideToMSXVersion2.0#page/n3/mode/1up
[instr]: https://www.msx.org/wiki/Category:MSX-BASIC_Instructions
[the.2.0]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter2.md/#3-internal-structure-of-basic
[thj.kouzou]: https://archive.org/stream/MSX2TechnicalHandBookFE1986#page/n68/mode/1up
