Hitachi BASIC Master
====================

[ja Wikipedia page][wj-bm]. No en Wikipedia page.

The MB-6880 was the first "home" computer (i.e., not a dev board)
released in Japan, and Hitachi the first to move from ｢ﾏｲｺﾝ｣ to
｢ﾊﾟｰｿﾅﾙｺﾝﾋﾟｭｰﾀｰ｣ terminology. The series with the PC-8001 and MZ-80,
was considered part of the [パソコン御三家][gosanke] until around 1980,
when it became comparatively less popular (eventually to be replaced
by Fujitsu FM-7/FM77). The release of those and the PC-6001 at the end
of 1981 (after the Jr.) spelled the end of home user popularity.

A list of all models, with photos, descriptions and references, can be
found at ["Hitachi Basic Master Family"][randoc].

6800 models all had monochrome 32×24 (768 bytes) text and 64×48
character-based "graphics" (except Jr. added 256×192). These used
Hitchi's BASIC.

- Basic Master __MB-6880__ (1978-09, ¥188k): 0.75 MHz, 4K RAM, 8K ROM.
  300 bps cassette. 64×48 monochrome graphics. Level I BASIC; no FP.
- Basic Master Level 2 __MB-6880L2__ (1979-02, ¥228k): 8K RAM, 16K ROM.
  Level II BASIC; adds floating point.
- Basic Master Level 2 II __MB-6881__ (1980): 16K RAM, 16K ROM.
  MZ080 and PC-8001 become noticably more popular.
- Basic Master Jr. __MB-6885__ (1981): ROM/RAM 18K/16K (63.5K).
  Smaller case; VRAM for 256×192 b/w graphics (no ROM BASIC support).
  - Post-release ROM upgrade increased cassette speed to 1200 baud.
  - MP-9785 64K RAM exapnsion; actually gives 63.5K because the I/O area
    of address space cannot be switched to RAM.
  - MP-1710 Color Adapter (on expansion bus) allows 8-color graphics.
  - MP-1803/MP-3370 3" floppy controller/drive. (MA-5380 Disk BASIC.)

6809 Models (predates FM-8 by one year, FM-7 by 2.5 years). These use
Level III BASIC, which is a Microsoft BASIC.

- Basic Master Level 3 __MB-6890__ (1980-05 ¥298k, post-FM-7 ¥198k):
  640×200 b/w, 320×200×8 (per-byte color bits, FB in main addr space).
  600 bps cassette; optional floppies. First PC to offer kanji.
- Mark II __MB-6891__ (1982-04 ¥198k):
- Mark 5 __MB-6892__ (1983-04 ¥118k): Programmable character generator.
- Mark II-A __AB-6896__ (?): little known about this

Non-composite video output may also be available.

Cassette is 300/1200 baud Kansas City standard. 1200 baud and program
auto-start added in ROM update for Jr.; see p.162.

The [MAME bml3 source][mame] has some technical information embedded in it,
and mentions a service manual.

### Peripherals

688x Peripherals:
- MB-ROM (?): Level 2 ROMs and board (¥40k)
- MP-1010 放電 Printer (¥138k)
- MP-1010A, MP-1010B "I/O Adapter" (see [6880.md](6880.md)) (¥60k).
- MP-1041 printer
- MP-1802/MP-3550 floppy controller/drive (5.25" DS/DD)
- MP-1803/MP-3370 3" floppy controller/drive. (MA-5380 Disk BASIC.)
- MP-1805 floppy controller: 3" or 5.25" SS/SD
- MP-3520(?): "Interface Expansion"
- MP-3530(?): Mini-floppy
- MP-3540(?): Mini-floppy (expansion unit; no controller)
- MP-9780: [VHF Color Converter](./video.md)
- MP-9785: 64K expansion RAM for MB-6885 (Jr.)
- C14-1180: color display
- K12-2060G: monochrome display

### References

- [MB-6885 ﾍﾞｰｼｯｸﾏｽﾀｰJr.][ar-bmj] system manual.
- [Basic master Jr.][rash] specs and tech. info
- [zu2/BASICMASTER] repo has lots of good software, including
  for conversion of files (presumably character-set conversion).

Emulators: see [`emulation`](./emulation.md).


Usage Notes
-----------

- `BREAK` interrupts a running BASIC program, otherwise does nothing.
  `カナ記号+BREAK` resets the machine.
- Modifier (シフト) keys. Also hold to slow printouts, from least to most.
  (Multiple modifiers held at the same time slows even more.)
  - `英数`: Tap to enter mode for left keytop letter.
  - `英記号`: Hold for top keytop symbol.
  - `カナ`: Tap to enter mode for bottom keytop kana.
  - `カナ記号`: Hold for right keytop symbol.

See [`basic`](./basic.md) and [`monitor`](./monitor.md) for further details.

### CMT Load and Filenames

The impedance of the tape output seems to vary in ways that confuse TRRS
mic inputs if no series resistance is used: the input will signal that a
mic is connected for some blocks and not for others, causing recording
programs to record silence (or input from another mic). Try a 2K resistor
in series or see the notes on smartphone connections in
[`conn/din`](../conn/din.md).

The input level when recording should be quite high; it's ok (usually
required) to clip the tops of the square waveform.

CMT filenames are six characters (letters, numbers, punctuation, kana)
followed by `.B` for binary programs or `.S` for BASIC programs. The user
should not specify the `.B`/`.S`; this will be added by the monitor/BASIC
load/save commands. Filenames shorter than six characters are padded with
spaces. Six spaces is also a filename, not a wildcard, and will be loaded
or skipped as specified with the name to the command. (`LOAD` followed by
return in BASIC or `L` followed by space or return in the monitor specifies
the six-space filename.)

When loading or verifying, a filename printed alone on a line (with no
trailing numbers) indicates a block read and ignored because it's not
from the file specified. Blocks that are not ignored are followed by a
number or hyphen and number.

BASIC files are saved only in ASCII format. The BASIC `LOAD`, `SAVE` and
`VERIFY` commands do not use quotes around the filename; quotes will
instead be treated as characters that are part of the filename. Zero, one
or more spaces may be inserted between the command and filename; they will
be ignored. `ERROR 3` is given if the filename is more than 6 characters.

The BASIC `LOAD` command will load both `.S` and `.B` files. The monitor
`L` command will print `ERROR` if you try to load a `.S` file. (And also
if the level is too low.)

When loading `.B` files, if a block errors out on load you can rewind and
play blocks back in again to try to reload them.


Software
--------

- Basic Master Level-3 MB-6890 [Assembler Manual V.1.1][asm]. Hitachi,
  1983. (Sales distributor: Delta Software Co., Melbourne.)


Connectors
----------

MB-6885 [Basic Master Jr.][ar-bmj]:
- ビデオ1 (RCA): Composite output
- ビデオ2 (DIN-8 270°): Analog RGB on at least MB-6891.
- カセット (DIN-6): Supports 2 units?
- Printer: 36-pin mini-ribbon
- Expansion: 50-pin mini-ribbon (color video adapter, etc.)

MB-6890 Basic Master Level 3 (and probably later models):
- PRINTER (36 pin micro-ribbon)
- RS-232C (female DB-25)
- (Unlabled) RCA: Composite output
- COLOR (DIN-8 270°): Analog RGB on at least MB-6891.
- L/PEN (DIN-5)
- CASSETTE (DIN-6): Supports 2 units?
- Internal expansion slots w/panels on back (6?).

### CMT DIN-6

1,4=relay, 2=GND, 3=out/rec, 5=in/play, as tested on MB-6885.
See [`conn/din`](../conn/din.md#DIN-6) for breakout.



<!-------------------------------------------------------------------->
[ar-bmj]: https://archive.org/details/Hitachi_MB-6885_Basic_Master_Jr/
[gosanke]: https://ja.wikipedia.org/wiki/8ビット御三家
[mame]: https://github.com/mamedev/mame/blob/master/src/mame/hitachi/bml3.cpp
[randoc]: https://randoc.wordpress.com/2021/04/02/hitachi-basic-master-family/
[rash]: http://fuckin.rash.jp/wikihome/index.cgi/p6?page=Basic+Master+Jr.
[wj-bm]: https://ja.wikipedia.org/wiki/ベーシックマスター
[zu2/BASICMASTER]: https://github.com/zu2/BASICMASTER

[asm]: https://archive.org/stream/Hitachi_Basic_Master_Level_3_MB-6890_Assembler_Manual_1983#page/n3/mode/1up
