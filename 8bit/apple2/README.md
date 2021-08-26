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
    $0300 308b  Free, or used by programs
    $03D0  32p  DOS 3.3 vector locations
    $03F0  16b  ROM/Monitor vector locations (see p.62)
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

### Zero-page Usage

The monitor uses the following zero-page and page-3 locations:

    $20--$2F  $30--$3F  $40-$49 $4E $4F  $50-$55   $3F0-$3FF

See further tables in [a2ref] pp. 74-75 for Applesoft, DOS 3.2 and
Integer BASIC usage. Roughly, the only bytes left free by Applesoft
and DOS 3.2 are the following:

    $06-$09  $CE $CF  $D6 $D7  $E3  $EB-$EE $EF  $F9-$FF
    $06-$09                    $E3  $EB-$EE $EF  $F9-$FF  # +Integer BASIC
    $06-$09  $CE $CF                $EB-$EE      $FD $FE  # +ProDOS

SWEET16 uses `$00`-`$1F`.


Video
-----

As described on [pp. 14-16][a2ref 14] of the _Apple II Reference Manual_,
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
- [mmphosis] has sample code to do this.
- The [Apple II Mouse Card][mouse] used a similar technique except that it
  had a flip-flop that would capture `D0` during Φ1; the test would read
  that to figure out a value for the 6522 timer.


Other I/O
---------

#### Paddles/Joystick (Mouse/Hand Controller)

Apple II uses a DIP-16 socket ([techref] p.23, p.100), Apple IIc and
others a DE-9 female jack ([IIc techref] pp.199, 284, 287 ). Paddle
resistors should be 150 KΩ pots connected to +5V. Paddles are numbered
from 0 to 3.

    5 4 3 2 1     Looking into female jack on motherboard.
     9 8 7 6

    DIP DE9
      1  2   +5V            max 100 mA
      2  7   PB0,GAMESW     paddle 0 button ($C061 b7)
         7   M̅S̅W̅            (IIc) mouse button
      3  1   PB1,GAMESW1    paddle 1 button ($C062 b7)
         1   M̅O̅U̅S̅E̅I̅D̅        (IIc) assert to disable paddles (556 paddle timer)
      4      PB2            paddle 2 button ($C063 b7)
         6   n/c            (IIc) may be paddle 2 button on GS?
      5      C̅0̅4̅0̅ ̅S̅T̅R̅O̅B̅E̅    .5 μs low strobe on read from $C040 (2× on write)
      6  5   GC0,PDL0       paddle 0 pot, joystick 0 X
             XMOVE          (IIc) movement interrupt
      7      GC2            paddle 2 pot, joystick 1 X
      8  3   GND
      ₉                     (GS only) paddle 3 button; not on Apple II
     10  8   GC1,PDL1       paddle 1 pot, joystick 0 Y
         8   YDIR,PDL1      Direction indicator, paddle 1 resistor
     11      GC3            paddle 3 pot, joystick 1 Y
     12                     annunciator 3 ($C05E off, $C05F on)
     13                     annunciator 2 ($C05C off, $C05D on)
     14                     annunciator 1 ($C05A off, $C05B on)
     15                     annunciator 0 ($C058 off, $C059 on)
     16      n/c
         4   XDIR           (IIc only) Direction indicator
         9   YMOVE          (IIc only) Movement interrupt

#### Other

System timing is from a 14.318 MHz master oscillator `14M`, divided
down to `7M`⁼, `COLOR REF`, `Q3`⁼ (2.046 MHz, 60% high duty cycle),
`Φ0`⁼/`Φ2` (1.023 MHz) and `Φ1`⁼ (inverted Φ2). Those marked ⁼ are
available on the peripheral slots.

- Expansion slot pinout and signal descriptions: [a2ref 106].
- [Diskette controllers and drives.](disk.md)



<!-------------------------------------------------------------------->
[IIc techref]: https://archive.org/stream/Apple_IIc_Technical_Reference_Manual
[a2cref]: https://archive.org/stream/Apple_IIc_Technical_Reference_Manual
[a2ref]: https://archive.org/stream/Apple_II_Reference_Manual_1979_Apple#page/n3/mode/1up
[bados]: https://archive.org/stream/Beneath_Apple_DOS_OCR#page/n2/mode/1up
[jr-screenholes]: http://www.kreativekorp.com/miscpages/a2info/screenholes.shtml
[lanc84]: http://forum.6502.org/download/file.php?id=7848
[mmphosis]: http://web.archive.org/web/20151021120320/http://hoop-la.ca/apple2/2015/vbl/
[mouse]: https://www.folklore.org/StoryView.py?project=Macintosh&story=Apple_II_Mouse_Card.txt
[p67532]: http://forum.6502.org/viewtopic.php?f=3&t=5517&sid=f6734cd034b51b20dcd393f67a3c48fe&start=30#p67532
[rcse 14027]: https://retrocomputing.stackexchange.com/q/14027/7208
[relay-io]: https://www.kreativekorp.com/miscpages/a2info/iomemory.shtml
[relay]: https://www.kreativekorp.com/miscpages/a2info/index.shtml
[sather]: https://archive.org/stream/Understanding_the_Apple_II_1983_Quality_Software#page/n0/mode/1up
[vapor]: http://www.deater.net/weave/vmwprod/megademo/vapor_lock.html

[a2ref 106]: https://archive.org/stream/Apple_II_Reference_Manual_1979_Apple#page/n116/mode/1up
[a2ref 14]: https://archive.org/stream/Apple_II_Reference_Manual_1979_Apple#page/n24/mode/1up
[a2ref 90]: https://archive.org/stream/Apple_II_Reference_Manual_1979_Apple#page/n100/mode/1up
