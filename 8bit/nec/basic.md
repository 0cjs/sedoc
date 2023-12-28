N80 and N88 BASIC
=================

See also:
- [`rom`](rom.md) for ROM and BASIC versions, startup messages and
  lower-level machine technical details.
- [`programs`](programs.md) for sample programs

BASIC Langauge References:
- \[basic-80mkII] [_PC-8001mkII N₈₀-BASIC Reference Manual_][basic-80mkII]
  NEC, 1983.
- \[mr] [NEC PC-8801mkIIMR N88-BASIC / N88-日本語BASIC REFERENCE MANUAL][mr],
  PC-8801MR-RM.


Usage
-----

`ESC` pauses listings, program operation, etc. (Works in monitor, too.)

Commands below may be marked ⁿ/⁰/⁸/ᵈ for
N-BASIC (PC-8001 BASIC), N80-BASIC, N88-BASIC and Disk BASIC.

#### Extensions

- `BEEP`: Short beep; add `1` to turn on, `0` to turn off.
- `HEX$(n)`
- `MON`: Enter monitor (see [`README`](README.md) for commands).
- `MOTOR`: Toggle cassette motor relay. Add `1` to turn on, `0` to turn off.
- `STRING$(n,c)`: _n_ copies of character code _c_.
- `SWAP`: Exchange values of two vars.
- `TERM bpdl`ⁿ⁰: Act as terminal via (RS-232) serial interface.
  - `b` bits: `A`=8 bit  `J`=7 bit
  - `p` parity: `0`=none  `1`=odd  `2`=even
  - `d` baud rate divisor: `0`=64  `1`=16
  - `l` auto-LF: `0`=off  `1`=on
  - Exit with Graph-B (0) or Ctrl-B (N)ⁿₙ
- `TERM`⁸: (mr 2-228). First arg required.
  - `"[COM:]pbsxz",mode,rbsize`: parity `E,O,N`; bits `7,8`;
    stop-bits `1,2,3` = 1, 1.5, 2; xon,xsoff `X,N`; s-parameter `S,N`.
  - S-parameter (`z` above) related to 7-bit char code translation.

Untested/unresearched:
- `CMD ...`: Extension commands via table in RAM, though ROM may provide
  some too.
- `INP(p)`,`OUT p,x`: Peek/poke for I/O ports.

#### Text/Graphics

Also see Table 2 (p.80) in [Byte] for summary and [asahi] for more details.

The following are all the non-printing control characters in BASIC. ($08
does not backspace, but prints control picture `␈`. However, `DEL` key sends
backspace.)

    Dec  Hex  Ctrl Key       Function
    ───────────────────────────────────────────────────────────────────────
      7  $07  BEL            beeps speaker?
      9  $09  TAB            cursor to next multiple of 8 columns
     10  $0A  LF             cursor down one line
     11  $0B  VT   HOME      cursor to upper left of screen
     12  $0C  FF   CLR       clear screen and cursor to upper left
     13  $0D  CR   RETURN    cursor to beginning of current line
     28  $1C       →         cursor right
     29  $1D       ←         cursor left
     30  $1E       ↑         cursor up
     31  $1F       ↓         cursor down

- `WIDTH h,v`: _h_ = 80, 72, 40, 36; 72 and 36 are same char cell size as
  80 and 24, with narrower lines. Optional _v_ = 25, 20. Use v=25 if using
  160×96 (with status line) or 160×100 graphics.
- `CONSOLE top,len,fkey,cbw`ⁿ⁰: At least one arg required.
  - _top_: this many lines at top of screen do not scroll
  - _len_: this many lines in the scroll area (lines below do not scroll)
  - _fkey_: 0=last line usable; 1=last line shows fkeys.
  - _cbw_: 0=b/w mode, 1=color mode (greyscale on mono output)
- `PRINT CHR$(12);`ⁿ. `CMD CLS`⁰, `CLS`⁸: clear screen.
- `COLOR f,c,g,m`ⁿ⁰: Takes effect after clearing screen.
  - _f_ function code: see color codes below
  - _c_ new character code: (below?)
  - _g_ 0=char mode, 1=graphic mode
- `CMD COLOR fg,bg`⁰, `COLOR fg,bg,gr`⁸: all args optional but at least 1
  must be present.
  - _fg_ color of following output.
  - _bg_ background attribute to fill on next screen clear (does not change
    background color in color mode).
  - _gr_ 0=character mode, 1=graphic mode.
- `LOCATE x,y,csr`: Optional _csr_ 0=cursor off 1=cursor on.
- `GET @(x₀,y₀)-(x₁,y₁), arr`: Store chars from screen into array _arr_.
- `PUT @(x₀,y₀)-(x₁,y₁), arr`: Put chars from array _arr_ onto screen.
- `PSET (x,y),c`, `PRESET (x,y)`: Draws dot at 0-based _x,y_. _c_ is
  optional color (PC-6001 only?). _x,y_ > (159,95) will set "pixel" at edge
  of screen.
- `LINE ln,mode`: Color mode only; mono mode is syntax error. Screen line
  _ln_ is changed to mode: 0=normal 1=blink 2=reverse 3=reverse blink.
- `LINE (x₀,y₀)-(x₁,y₁), "ch", color, b, f`.  _ch_ (required) is character
  to draw or `PSET`/`PRESET`. _color_ is optional. Adding `B`,`F` params at
  end (no commas needed) draw a block (square) and filled square.

Color codes (for `COLOR`, `LINE`, `PSET`). Monochrome mode (`CONSOLE,,,0`)
default is `COLOR 0,0`; color mode (`CONSOLE,,,1`) default is `7,0`.

    Code    Color Mode      Monochrome Mode (char attributes)
    ────────────────────────────────────────────────────────────────
      0      黒  black              normal
      1      青  blue               secret (non-printing text)
      2      赤  red                blink
      3      紫  magenta            secret
      4      緑  green      reverse
      5     水色 cyan       reverse secret
      6      黄  yellow     reverse blink
      7      白  white      reverse secret

#### Peripheral I/O

- `CLOAD "fn"`, `CLOAD? "fn"`, `CSAVE "fn"`ⁿ⁰: CMT load/verify/save

Serial port I/O per [[kuniser]] but untested:
- `PRINT%1,…`: Print to serial port 1 (also `%2` for 2nd port).
- `INPUT%1,…`
- `INIT%1,mode,cmd`: Init with mode and command bytes. E.g. `&h4E,&h37` for
  9600 (7E1 or N81?).
- `PORT n`: "get number of buffer inputs"
- `INPUT$(len,%port)` "get specified long characters"

Floppy Disk I/O (_dn_ = drive number 1-4):
- `MOUNT [n[,n…]]`: Prepares diskette(s) in given drive numbers (default
  all drives) for use by reading FAT into memory.
- `REMOVE [n[,n…]]`: Writes FAT back to given drive numbers to allow
  removal of diskette(s). (FAT _is not updated on disk until this command
  is run._)
- `SAVE "[dn:]fname[.ext][,a]"`: _dn_ is 1-4, default 1. _fname_
  max 6 chars. _ext_ 3 chars, default `.BAS` when saving BASIC files.
- `LOAD "[dn:]fname[.ext]"`
- `MERGE "[dn:]fname[.ext]"`: _fname_ must be an ASCII save.
- `FILES [dn]`, `LFILES [dn]`: _dn_ default 1; `L` version is to printer.
- `NAME old AS new`: rename files
- `KILL "[dn:]fname[.ext]"`
- `SET "[dn:]fname[.ext]","attr"`: Attibute set: `R`=read-after-write,
  `P`=write-protect, any other char (or empty) cancels current attr.
  Can also be given drive number (1-4)to set for entire diskette, and file
  number (? `#n` maybe?) for temporary setting while file open.
- `RUN "BACKUP"`: Image copy tool on system diskette.

#### Machine-language Interface

- `DEFUSRn=m`:
- `a=USR(n)`: _n_ = 0-7


BASIC Extensions
----------------

[[techknow80] p.243] The original PC-8001 ROM BASIC (from at least v1.01)
has keywords/tokens for many Disk BASIC commands and functions (`FILES`,
`EOF()`, …) and changed versions of existing functions (`OPEN`, …) that are
dispatched through a table of `JP` instructions in RAM starting at $F0E1. .
The ROM BASIC initialises all these to `C3 75 18`/`JP $1875` which which is
a routine that prints a "Disk BASIC Feature" error.

`CMD` was incuded with these as a prefix for unanticipated commands. We need
a PC-8001 Disk BASIC reference manual to determine what it was used for there,
but the [PC-8001mkII N₈₀-BASIC Reference Manual][basic-80mkII] (released
four years later in 1983) lists the following as using the `CMD` prefix:

    BLOAD   CLS     COPY    LINE    PRESET  SCREEN
    BSAVE   COLOR   GET@    PAINT   PSET    VIEW
    CIRCLE  COLOR@  INIT    POINT   PUT@

### Using the CMD Hook

[[techknow80] p.178] gives examples of taking over the `CMD` hook to add
commands. The first example given changes $F0FC to `JMP $FF40` where he
places a small program:

                    ; SCREEN COPY 'CMD'
    FF40 E5             PUSH HL
    FF41 CD 4A 12       CALL $124A      ; SCREEN COPY ROUTINE
    FF44 E1             POP  HL
    FF45 C9             RET             ; RETURN TO BASIC

It's not clear why he preserves HL; the second example doesn't do this,
though that one returns to BASIC via one of the following two mechanisms:

                        JP   $3C82      ; JUMP TO BASIC

                        LD   E,5        ; Illegal function call
                        JP   $3BF9      ; Error message output routine


Technical Information
---------------------

Reserved word map: [[hb68]] pp.96-97.



<!-------------------------------------------------------------------->
[asahi]: https://archive.org/details/PC8001600100160011982
[byte]: https://tech-insider.org/personal-computers/research/acrobat/8101.pdf
[hb68]: https://archive.org/stream/PC8001600100160011982#page/n5/mode/1up
[kuniser]: https://kuninet.org/2020/01/25/pc-8001-%e5%a4%96%e4%bb%98%e3%81%91232c%e3%83%9c%e3%83%bc%e3%83%89/
[mr]: https://archive.org/stream/NECPC8801mkIIMRN88BASICN88BASICREFERENCEMANUAL1986L#mode/1up
[techknow80]: https://archive.org/details/pctechknow8000
[basic-80mkII]: https://archive.org/details/PC-8001mk-II-n-80-basic-reference-manual
