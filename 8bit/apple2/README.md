Apple II
========

References:
- \[a2ref] [_Apple II Reference Manual_][a2ref], 1979 edition.
- \[relay] [Jon Relay's Apple II Info Archives][relay]. Memory areas,
  zero page addresses, etc.
- \[sather] Jim Sather, [_Understanding the Apple II_][sather], 1983.
  Detailed hardare description.
- \[lanc84] Don Lancaster, [_Tearing Into Machine Code_][lanc84],
  referenced from [this 6502.org post][p67532]. A small book on Apple
  II architecture and reverse-engineering 6502 software.
- \[bados] Don Worth and Pieter Lechner, [_Beneath Apple DOS_], 1981.


Memory Map
----------

See [a2ref] Ch.4 pp.67-75. "Programmer's Aid #1" could go in $D000
socket. Applesoft uses all 10K of non-monitor ROM space.

    $F800   2k  ROM (Monitor), Language Card RAM
    $F400   1k  ROM Mini-assembler, etc.
    $E000   5k  ROM (Integer BASIC), Langauge Card RAM
    $D800   2k  ROM (empty socket), Language Card RAM Banks 1 and 2
    $D000   2k  ROM (empty socket), Language Card RAM Banks 1 and 2

    $C800   2k  I/O card ROM space (switched between cards)
    $C000   2k  I/O ($C100, $C200, etc. are slots 1, 2, etc.)

    $6000  24k  Free RAM
    $4000   8k  Screen: hi-res page 1 (secondary)
    $2000   8k  Screen: hi-res page 1 (primary)
    $0C00   5k  Free RAM
    $0800   1k  Screen: text/lo-res page 2 (secondary)
    $0400   1k  Screen: text/lo-res page 1 (primary)
    $0300   1p  Monitor vector locations ($3F0-$3FF only; see p.62)
    $0200   1p  GETLN input buffer
    $0000   2p  Zero page, stack

There are 64 undisplayed locations in each screen text/lo-res page; in
page 1 these are [reserved for I/O cards][jr-screenholes].

The Language Card had 16K of RAM. 8K could be mapped at $E000, and two
4K banks at $D000. Read the following soft switches (which have
[further aliases][relay-io]) to configure the mapping:

    $C080   read RAM (bank 2); write nothing
    $C081   read ROM; write RAM (bank 2)
    $C082   read ROM; write nothing
    $C083   read/write RAM (bank 2)
    $C088   read RAM (bank 1); write nothing
    $C089   read ROM; write RAM (bank 1)
    $C08B   read/write RAM (bank 1)


Video
-----

As described on [pp. 14-16][a2ref-14] of the _Apple II Reference Manual_,
the Apple II character ROM has 64 characters, the ASCII upper case sticks
(`@A…Z[\]^_`) and punctuation/number sticks (` !"#$%&'()*+,-./0…9:;<=>?`).
The may be displayed as normal, inverse or flashing characters:

    $00-$3F  inverse
    $40-$7f  flashing
    $80-$9F  normal alphabet (`@A…`)
    $A0-$BF  normal punctuation/numbers (` !…0…`)
    $C0-$DF  normal alphabet
    $E0-$FF  normal punctuation/numbers

Screen scan, from [this vapor lock description][vapor]:
- 65 cycles for for each of the 192 scan lines: 40 cycles of drawing
  and 25 cycles of hblank. (65th cycle is stretched.)
- 4550 cyles of vblank (70 scan lines).
- [Sync can be found][rcse 14027] by putting an appropriate pattern
  into the frame buffer and reading the select soft switch for the
  current mode (e.g., $C051 for text mode) which will usually return
  the data most recently read by the last video read φ1 cycle.


Memory Usage
------------

The monitor uses the following zero-page and page-3 locations:

    $20--$2F  $30--$3F  $40-$49 $4E $4F  $50-$55   $3F0-$3FF

See further tables in [a2ref] pp. 74-75 for Applesoft, DOS 3.2 and
Integer BASIC usage. Roughly, the only bytes left free by Applesoft
and DOS 3.2 are the following:

    $06-$09  $CE $CF  $D6 $D7  $E3  $EB-$EE $EF  $F9-$FF
    $06-$09                    $E3  $EB-$EE $EF  $F9-$FF  # +Integer BASIC
    $06-$09  $CE $CF                $EB-$EE      $FD $FE  # +ProDOS

SWEET16 uses `$00`-`$1F`.



<!-------------------------------------------------------------------->
[a2cref]: https://archive.org/details/Apple_IIc_Technical_Reference_Manual
[a2ref-14]: https://archive.org/details/Apple_II_Reference_Manual_1979_Apple/page/n24/mode/1up
[a2ref]: https://archive.org/details/Apple_II_Reference_Manual_1979_Apple
[bados]: https://archive.org/details/Beneath_Apple_DOS_OCR/page/n2/mode/1up
[jr-screenholes]: http://www.kreativekorp.com/miscpages/a2info/screenholes.shtml
[lanc84]: http://forum.6502.org/download/file.php?id=7848
[p67532]: http://forum.6502.org/viewtopic.php?f=3&t=5517&sid=f6734cd034b51b20dcd393f67a3c48fe&start=30#p67532
[rcse 14027]: https://retrocomputing.stackexchange.com/q/14027/7208
[relay-io]: https://www.kreativekorp.com/miscpages/a2info/iomemory.shtml
[relay]: https://www.kreativekorp.com/miscpages/a2info/index.shtml
[sather]: https://archive.org/details/Understanding_the_Apple_II_1983_Quality_Software/mode/1up
[vapor]: http://www.deater.net/weave/vmwprod/megademo/vapor_lock.html
