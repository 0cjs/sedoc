FM-7 BASIC
----------

References:
- [富士通 FM-7 F-BASIC 文法書][fm7bref]. Reference manual.
  (n-mm) references below are to this. For (3-n), PDF page is n+46.
- [富士通 FMシリーズ ユーザーズマニュアル F-BASIC入門][fm7bintro]
  Ch.6.2 p.159 is machine language info; ch.6.3 p.162 is monitor.

### History and Versions

BASIC runs in "ROM mode" or "DISK mode". ROM mode does not include disk
I/O; `LOADM "0:FOO"` will give `Device Unavailable` and `FILES "0:"`,
`Illegal Function Call`. `DSKINI 1` returns `Syntax Error`. Versions are:

    V1.0/ROM    FM-8    built-in ROM
    V1.0/DISK   FM-8    built-in ROM + system disk
    V2.0/5      FM-8    minifloppy disk
    V2.0/8      FM-8    "standard" floppy disk
    V3.0/ROM    FM-7    built-in ROM
    V3.0/DISK   FM-7    built-in ROM + system disk

- V2.0 adds
  - `CHAIN`, `COMMON`, `ERASE`
  - printer I/O support and `LLIST`, `LPRINT`, `LPOS`
  - `PRINT USING`
  - error behaviour of `TERM` is changed
  - user program auto-start
- V3.0 removes:
  - bubble memory I/O, `BUBINI`, `BUBR`, `BUBW`
  - and analogue I/O port support, `ANPORT`

### Memory

User program code starts at $0600; all memory below that is reserved for
BASIC housekeeping.

The default string heap is 300 bytes; use `CLEAR` to change this.

### General Notes

- Press `ESC` to pause listing after current line; again to print just next
  line; any other key to resume.
- Line numbers 0-63999. `.` is "current" line number, set by error etc.
- Comments may start anywhere with `'` (no preceeding `:` required)
- Use `&Hnn` for hex numbers; `&Onn` `&nn` for octal.
- Variables are 4-byte single precision float (`!`, `n.nE+n`) by default;
  `x` and `x!` are the same variable. Other suffixes are separate variables:
  `#` `n.nD+n` 8-byte double-precision float, `%` integer, `$` string.
  `DEFINT`, `DEFSNG`, `DEFDBL` `DEFSTR` available.
- Variable names are case-insensitive, significant to 16 chars plus suffix,
  and cannot start with a reserved word.
- Arrays are 0-based; `DIM X(3)` has indices `0`, `1`, `2`.

### Commands/Statements/Functions

Selected system commands:
- `MON` (3-35): Enter a simple monitor; see [ml](ml.md).
- `HARDC` (3-36): Print a hardcopy of the screen.
- `TERM` (3-38): Initiate a connection via serial option board.
- `KEY LIST` (3-145): List function key definitions
- `EDIT n`: Clear screen and edit line _n_ for with `←↓↑→`, `EL` etc.

Selected BASIC commands:
- `DEF FN`
- `ERROR n` (3-69): Generate error _n_ (1-255). Caught by `ON ERROR GOTO`,
  otherwise aborts execution and prints message (`Unprintable error` for
  unknown codes).
- `ON ERROR GOTO n` (3-70): Start executing at line number _n_ when any
  error occurs. `ERR` variable will contain the error code.
  - `RESUME` will re-execute the statement (not line) that caused the error.
  - `RESUME NEXT` will continue at statement (not line) after the error.
  - `RESUME n` will continue at line _n_.

Selected display-related commands:
- `WIDTH n,m` (3-104): Set screen width to _n_ (40 or 80) and number
  of lines to _m_ (20 or 25).
- `COLOR n,m`: Set forground color to _n_, inverting fg/bg for 8-15.
  Background color will become _m_ after next `CLS`.
- `SYMBOL (x,y),"c",hscale,vscale[,palette[,rot[,func]]]`. Write
  symbol _"c"_ (1-char string) at _(x,y)_ (0-640, 0-200), with
  horizontal and vertical scale (based on 80-col size).
  - _palette_ color number, defaults to `COLOR` foreground color
  - _rot_ `0`=no rotation, `1`=90° CCW, `2`=180°, `3`=270° CCW
  - _func_ `PSET`, `PRESET`, `AND`, `OR`, `XOR`, `NOT`
- `PRINT @ [(x,y),] code`
  - Optional _(x,y),_ is a graphics position (x=0-629, y=0-199); default
    automatically moves foward 16 pixels per char. (20 looks better.)
  - Add further kanji codes prefixed by `,` or `;`
  - Codes listed in [Appendix 3][a3]; &h2122-4F53 w/many blanks
- `CONSOLE` (3-105): Set scroll areas and other screen attributes.
- `SCREEN` (3-111): Select VRAM usage.
- `PSET(x,y[,p[,f]])`: Set/clear a point on the screen. _x,y_ ranges from
  (0,0) to (639,199). _p_ is a "pallette code," which is just the color as
  given to the  `COLOR` statement. (8-15 are the same colors as 0-7.)  _f_
  is the function to apply to the new and existing point: `AND`, `OR`, `XOR`.

Numeric functions:
- `¥` (2-13) floating point division, truncated result
- `MOD` (2-13) integer division remainder; inputs truncated first
- `NOT,AND,OR,XOR,IMP,EQV` all operate as expected on 16-bit ints
  - `IMP` is material implication; `1 IMP 0 = 0`, all else is 1
  - `EQV` is the inversion of `XOR`

String and data commands and functions:
- `VAL(a$)` (3-191): Parse _a$_ as a number. `&H` prefix parses as hex.
- `STR$(n)` (3-186): Return _n_ as its (decimal) string representation.
- `HEX$(n)` (3-179), `OCT$(n)` (3-183): Return _n_ as hexadecimal or octal
  representation (without `&H` or `&O` prefix).
- `PRINT USING "fmt";v₀[;v₁...]`: Formatted print.
  - `#` digit position (right justified in field)

Sound commands:
- `PLAY` (v3): Plays music macro langage (MML).
  - `A-G`,`R`: Notes and rests, optionally followed by `#` or `b`.
  - `On`: Octave, default `4`.
  - `Nn`: Note number (across all octaves)?
  - `Ln`: Note length. 1=whole note, 16=16th note, default 4.
  - `Tn`: Tempo, 32-255, default 120.
  - `Vn`: Volume? 0-15, default 8.
  - `Sn`, `Mn`: ???
  - `=`: Variable substitution, `I=8:PLAY "L=I;"`.
- `SOUND` (v3): Directly programs AY-3-8913 PSG.

Machine-language-related commands:
- `EXEC &Hnnnn`: Execute (JSR?) machine language code at address _nnnn_.


I/O and Disk
------------

### Protected Saves

F-BASIC files (only, not ML files) on tape and disk have a "protect" flag
that disables saves (to tape or disk). When set, $FF is written to location
$00D1 which disables the `SAVE` and `LIST` commands.

The protection can be disabled by writing `$D1: 00` and `$01E7: FF FF` to
RAM after the file has been loaded.

Source: Messages [[prot-ram]] and [[prot-flag]] from `@CaptainYS`
(`Soji#1323`) in the "FM TOWNS/FM7 Forever" Discord server.

### Devices

Devices (2-18) optionally precede filename arguments; case sensitive:

    KYBD:           keyboard
    SCRN:           screen
    LPT0:           printer
    COM0:           RS-232 port (1-4 also possible w/expansion unit)
    CAS0:           cassette tape (CMT) (ROM mode default)
    0: 1: 2: 3:     floppy drives (disk mode default is 0:)
    BUB0: BUB1:     bubble memory cartridge

These are specified in double quotes as device followed by "descriptor",
usually an 8-character case-sensitive filename except as specified below.
Leaving out the device assumes the default device for ROM or disk mode.
Additional attributes after the quoted device/filename are separated by
with a comma. BASIC programs are always type, with `B` format unless saved
with `,A` option to get `A` format.

    種類  しゅるい  type            0=BASIC  1=data  2=MLprog
    形式  けいしき  format          A=ASCII  B=BINARY
    編成  へんせい  organization    S=sequential  R=random-access
                    clusters used

`COMn:` and `TEMR` descriptors are 1-6 character character option strings
in parens, e.g. `COM0:(S8N2)` giving clock divisor (`S`=slow=1/64), bits,
parity, stop bits, duplex (default full) and auto-LF (default on).

Display descriptors are size (default 40×20), scroll start line (0), scroll
line (20), PFkey line (off), color (white). See `WIDTH` and `CONSOLE`
statements.

### File Formats

CMT and disk formats described in §2.10, starting page 2-21.

File type codes:

    00  BASIC program (binary or ASCII format)
    01  data (as read/written with BASIC OPEN etc. commands)
    02  machine-language program (maybe with addresss/length header?)

File attribute codes (taken from disk directory description):

    00  binary
    FF  ASCII

#### CMT ("Data Recorder")

CMT is alternating gaps and blocks, with blocks consisting of sequences
of bytes each framed by a `0` start bit and `11` stop bits.

    01
    3C
    nn   block type: 00=header 01=data block FF=end block
    nn   block length ($00-$FF)
    ...  data: 0-255 bytes
    nn   checksum

Header block data:

     1-8    filename, padded with spaces
     9      file format: 00=BASIC program, 01=data, 02=machine language
    10      ascii/binary attribute: 00=binary, FF=ASCII
    11-16   reserved?

End blocks have no data.

#### Bubble Cassette

Each 32 KB cartridge is 1024 blocks (0-1023) of 32 bytes each. Blocks can
be directly addressed by F-BASIC, which also supports a file system
initialized with `BUBINI` where block 0 is a volume label:

     0-7    volume name, e.g. "VOL00000"
     8-9    volume size (1024)
    10-11   first empty block (written at file close; initially 0001)
    12-31   00

and files use the following header:

     0-7    filename
     8      file type: 00=BASIC program, 01=data, 02=machine language
     9      attribute: 'A'=ASCII, 'B'=binary
    10-11   size: 2-1023 pages, includes page for file label
    12      byte count in last page (1-32)
    13-31   (empty? data?)

#### Floppy Disk

320 KB, 2 sides, 40 cylinders/tracks, 16 sectors/track, 32
sectors/cylinder. See [`floppy`](./floppy.md) for details.

### Commands, Statements, Functions

- `FILES ["dev:"][,L]` (3-23): Print file listing to screen (`,L`=printer)
  in four columns, giving name and other fields below (no organization/size
  for `CASn:`)
  - type: `0`=BASIC, `1`=data, `2`=machine-language
  - format: `A`=ASCII, `B`=binary
  - organization: `S`=sequential `R`=random
  - blocks/clusters: floppy=2K bubble=?
- `NAME "old" AS "new"`: Rename a file.
- `KILL "fname"`: Delete a file. Y/N prompt in direct mode.
- `DSKINI n` (3-29): Erases all files on a diskette in drive _n_. Y/N
  prompt in direct mode. Does not format; not clear if it re-creates
  dir/FAT structure.
- `DSKF(n)` (3-214): Return number of free clusters on drive _n_.
- `DSKI$(d, t, s)` (3-213): Sector read. Loads system random buffer (256
  bytes, must be set up with `FIELD` first) from the given drive, track,
  sector. Returns full buffer, as well as filling vars set up with `FIELD`.
  - _track_: 0-39 (0-76 for 8" floppies)
  - _sector_: 1-16 for side 0, 17-32 for side 1. (1-52 for 8" floppies).
- `DSKO$ d,t,s` (3-101): Sector write. Saves system random buffer to to
  given drive, track, sector. Set up `FIELD` as per `DSKI$()`.

Disk buffer setup:
- `FIELD #n, m₀ AS v₀[, m₁ as v₁ ...]` (3-98). Configure random access disk
  buffer for file descriptor _n_ (must already be open, or use `0` for
  `DSKI$`/`DSKO$`). Each field is length _m_ (≤255) in variable _v_ (always
  string?).
- `LSET v=w`, `RSET v=w` (3-67): Copy data in _w_ into `FIELD` variable _v_
  associated with random disk buffer (left and right justified, resp.).
  Used before `PUT`.
- `MKI$(n)`,`MKS$(n)`,`MKD$(n)` (3-209): Return bytes of binary
  representation of integer, single- and double-precision floats, resp.
- `CVI(a$)`,`CVS(a$)`,`CVD(a$)`: Create integer, single- or
  double-precision float value (resp.) from bytes of internal
  representation.

Operations on open files (_n_ = file number):
- `OPEN "mode",#n,"fname"`: _mode_ = `I`:input, `O`=output, `A`=append
  `R`=random.
- `LOF(n)`: length of diskfile. Might be just buffer length. May require
  reading first?



<!-------------------------------------------------------------------->
[a3]: https://archive.org/details/FM7FBASICBASRF/page/n270/mode/1up?view=theater
[fm7bintro]: https://archive.org/stream/F-BASICGettingStarted#page/n9/mode/1up
[fm7bref]: https://archive.org/stream/FM7FBASICBASRF#page/n7/mode/1up
[prot-flag]: https://discord.com/channels/944417460336070656/944628818822434867/1045848200944308306
[prot-ram]: https://discord.com/channels/944417460336070656/944628818822434867/1045796116643463178
