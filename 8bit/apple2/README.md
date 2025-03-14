Apple II
========

References:
- \[a2ref] [_Apple II Reference Manual_][a2ref], 1979 edition.
- \[a2cref] [_Apple IIc Technical Reference Manual_][a2cref]
- \[relay] [Jon Relay's Apple II Info Archives][relay]. Memory areas,
  zero page addresses, etc.
- \[sather] Jim Sather, [_Understanding the Apple II_][sather], 1983.
  Detailed hardare description.
- \[lanc84] Don Lancaster, [_Tearing Into Machine Code_][lanc84],
  referenced from [this 6502.org post][p67532]. A small book on Apple
  II architecture and reverse-engineering 6502 software.
- \[bados] Don Worth and Pieter Lechner, [_Beneath Apple DOS_], 1981.


Foreign Versions
----------------

__Apple II j-Plus:__
- Char ROM and input method code switched with annunciator 2 soft switch.
  - $C05C (-16292) = katakana; ^T switches romaji/katakana.
  - $C05D (-16291) = original English mode.
- PSU tweaked for 100 V 50/60 Hz.

See also apple2history.org, [12 - The Apple II Abroad/Clones][abroad].


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


Other I/O
---------

For video, see [`video.md`](./video.md).

#### Paddles/Joystick (Mouse/Hand Controller)

Apple II uses a DIP-16 socket ([a2ref] p.23, p.100), Apple IIc and
others a DE-9 female jack ([a2cref] pp.199, 284, 287 ). Paddle
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
[a2cref]: https://archive.org/stream/Apple_IIc_Technical_Reference_Manual
[a2ref]: https://archive.org/stream/Apple_II_Reference_Manual_1979_Apple#page/n3/mode/1up
[abroad]: https://www.apple2history.org/history/ah12/#04
[bados]: https://archive.org/stream/Beneath_Apple_DOS_OCR#page/n2/mode/1up
[jr-screenholes]: http://www.kreativekorp.com/miscpages/a2info/screenholes.shtml
[lanc84]: http://forum.6502.org/download/file.php?id=7848
[mmphosis]: http://web.archive.org/web/20151021120320/http://hoop-la.ca/apple2/2015/vbl/
[mouse text]: https://mirrors.apple2.org.za/apple.cabi.net/FAQs.and.INFO/A2.TECH.NOTES.ETC/A2.CLASSIC.TNTS/mouse006.html
[mtuni]: https://www.kreativekorp.com/charset/map/mousetext/
[p67532]: http://forum.6502.org/viewtopic.php?f=3&t=5517&sid=f6734cd034b51b20dcd393f67a3c48fe&start=30#p67532
[relay-io]: https://www.kreativekorp.com/miscpages/a2info/iomemory.shtml
[relay]: https://www.kreativekorp.com/miscpages/a2info/index.shtml
[sather]: https://archive.org/stream/Understanding_the_Apple_II_1983_Quality_Software#page/n0/mode/1up

[a2ref 106]: https://archive.org/stream/Apple_II_Reference_Manual_1979_Apple#page/n116/mode/1up
[a2ref 90]: https://archive.org/stream/Apple_II_Reference_Manual_1979_Apple#page/n100/mode/1up
