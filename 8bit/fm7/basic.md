FM-7 BASIC
----------

References:
- [富士通 FM-7 F-BASIC 文法書][fm7bref]. Reference manual.
  (n-mm) references below are to this. For (3-n), PDF page is n+46.
- [富士通 FMシリーズ ユーザーズマニュアル F-BASIC入門][fm7bintro]
  Ch.6.2 p.159 is machine language info; ch.6.3 p.162 is monitor.

The FM-7 started with V3.0; 1.0 and 2.0 were FM-8 only. ROM BASIC does
not include disk I/O; `LOADM "0:FOO"` will give `Device Unavailable`
and `FILES "0:"`, `Illegal Function Call`. `DSKINI 1` returns `Syntax
Error`.

User program code starts at $0600; all memory below that is reserved
for BASIC.

- Use `&Hnn` for hex numbers; `&Onn` `&nn` for octal.
- Variables are single precision float (`!`) by default `x` and `x!` are
  the same variable. Other suffixes (`%` integer, `#` double-precision
  float, `$` string) are separate variables.
- Arrays are 0-based; `DIM X(3)` has indices `0`, `1`, `2`.

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
- `COLOR n,m`: Set forground colour to _n_, inverting fg/bg for 8-15.
  Background colour will become _m_ after next `CLS`.
- `SYMBOL (x,y),"c",hscale,vscale[,palette[,rot[,func]]]`. Write
  symbol _"c"_ (1-char string) at _(x,y)_ (0-640, 0-200), with
  horizontal and vertical scale (based on 80-col size).
- `CONSOLE` (3-105): Set scroll areas and other screen attributes.
- `SCREEN` (3-111): Select VRAM usage.
- `PSET`: Set/clear a point on the screen.

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

Devices (optionally precede filename arguments):

    0: 1: 2: 3:     floppy drives
    CAS0:           cassette tape (CMT)
    KYBD:           keyboard

Files have 8-character case-sensitive names and the following additional
attributes. BASIC programs are always type, with `B` format unless saved
with `,A` option to get `A` format.


    種類  しゅるい  type            0=BASIC  1=data  2=MLprog
    形式  けいしき  format          A=ASCII  B=BINARY
    編成  へんせい  organization    S=sequential  R=random-access
                    clusters used

- `FILES ["dev:"][,L]` (3-23): Print file listing to screen (`,L`=printer)
  in four columns, giving name/type/format/organization/clusters used
  (disk) or name/type/format (`CAS0:`).
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
- `OPEN "mode",#n,"fname"`: _mode_ = `R`, `W`, ???
- `LOF(n)`: length of diskfile. Might be just buffer length. May require
  reading first?



<!-------------------------------------------------------------------->
[fm7bintro]: https://archive.org/stream/F-BASICGettingStarted#page/n9/mode/1up
[fm7bref]: https://archive.org/stream/FM7FBASICBASRF#page/n7/mode/1up
