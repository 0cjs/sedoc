DIN Connectors
==============

Physical Compatibility
----------------------

Lower-pin-count [DIN] plugs can usually (not always) be plugged into
higher-pin-count sockets. One notable bug is that there exist 268°
(Commodore) and 270° (Japanese 8-bit) 8-pin DIN sockets that are
nearly, but not quite, physically compatible.

_Standard_ [mini-DIN] are keyed so different pincounts are not
physically compatible. However, there are non-standard mini-DIN
plugs/sockets that are compatible or, worse yet, nearly but not quite
compatible.


Pin Numbering
-------------

Certain DIN plugs always use the same numbers for the same positions,
so that e.g. pin 3 will be in the same place on any connector from 3
to 8 pins. Others simply number "going around" with the centre pin
last. By [Hosiden-wb][] (p.3) designations:
- Positional: DIN-3, -5a, -7, -8a (270°), -8b (268°)
- "Around": DIN-4, -5b, -6

Five-pin, eight-pin 270° and eight-pin 268°, looking into female jack:

        DIN-3,5a        DIN-5b,6         DIN-7,8a         DIN-8b
           ∪               ∪                ∪                ∪
                       5       1         7     6        8         7
      3         1          6           3    8    1      3    6    1
        5     4         4     2          5     4          5     4
           2               3                2                2

There is also a "DIN-6/5" (my name for it) or "domino DIN" which appears to
be a DIN-6 with pin 3 removed (or a DIN-5b with 3 replaced by 6). I can't
find a standard mentioning this, but it's used for the BBC Micro serial
jack.

References:
- [Hosiden DIN Connectors][hosiden-wb] ([original][hosiden]) (PDF): Catalog
  with pin numbering and references to standards.
- Retrocomputing [Common Japanese 8-bit DIN pinouts][rc 12255] community
  wiki answer: common pinouts covering CMT, CVBS and DRGB video.


Breakouts
---------

CVBS is baseband composite video, usually color.

#### DIN-5 and DIN-8 (cjs v1)

    C5   C8   Pin  CMT        Video
    ───────────────────────────────────────────────────────────────────────
    Blu  Pnk   1   GND/cmt1   Vcc/12V; dot clock; audio; Ys/blank; GND
    Blk  Blk   2   GND        GND
    Yel  Yel   3   GND/cmt3   CVBS; csync, clock; AVC-TTL, DRGB C.CONT/I
    Red  Wht   4   rec/mic    hsync (trad. gray); GND
    Grn  Gry   5   play/ear   vsync (trad. black); LPEN (NEC); GND
         Red   6   rem+       DRGB red
         Grn   7   rem-       DRGB green
         Blu   8   GND        DRGB blue

Orange may be substituted for pink where pink not available.

0.1" header breakouts (see [header](header.md), [video](video.md))
use four or five female connectors:

    Looking into female connector
    ▼           DIN pins
    1 2 3       6 7 8           red, green blue     rem+ rem- gnd
    1 2         4 5             hsync, vsync        rec/mic play/ear
    1           3               CVBS or sync
    1           2               GND                 GND
    1           1               (optional)

Notes:
- [Old Hard DIN-8][oh d8] gives many JP pinouts;
  DIN-5 B/W output (at bottom of page) has 2=GND 3=CVBS on all models
- C8 colors on any breakouts; C5 colours may be used on some DIN-5 breakouts
- DIN-5 breakout can be used for CMT if remote relay not required.
- Pin 1 varies widely between machines; take care for +12V!
- `cmt1/cmt3` are unknown PC-6001 "control" thing; PC-8801 may have Vcc, INT5
- Yamaha and Victor MSX1 have audio on pin 1 and use AVC-TTL as a control
  signal to JP-21 connectors to set aspect ratio (SCART pin 11 (8?), 0-12V).
- Sync cable colors changed from standard gray/black due to GND conflict

#### DIN-8a (270°) Analogue

Super Cassette Vision:
- 1=+5V  2=GND  3=audio  4=CSYNC  5=N/C  5=Red  6=Green  7=Green  8=Blue

#### CBM (Commodore 64, VIC-20) A/V DIN-5 RCA

    Pin Wire    C64         RCA             VIC-20
    ─────────────────────────────────────────────────────────────
     1  Grn     luminance   Black           ● 6 VDC 10 mA (for RF modulator)
     2  Blk     GND         Shields (all)   GND
     3  Wht     audio out   White           audio out
     4  Yel     CVBS        Yellow          CVBS (standard level)
     5  Red     audio in    Red             CVBS (higher level)

- Reference: c64-wiki.com [A/V Jack][c64w av]
- Chromanance is pin 6, not available on above breakout, at higher than
  standard voltage (use 300R-2K if checkered pattern appears in colored
  areas).

#### Apple IIc Serial DIN-5 (cjs v1)

See [serial](./serial.md).

#### DIN-4

- National/Panasonic JR-100 power, from bad pic in my collection.

       color    JR100
    1          +7.8 VDC
    2          -8 VDC
    3           GND
    4          +17 VDC

#### DIN-6

`CBM`: CBM serial bus (female) from [cbm/serial-bus](cbm/serial-bus.md).

`日立BM`: Hitachi Basic Master Jr. (MB-6885), experimentally determined.

       color    CBM     日立BM
    1   blk     S̅R̅Q̅I̅N̅   relay
    2   red     GND     GND
    3   orn     A̅T̅N̅     OUT/rec
    4   yel     C̅L̅K̅     relay
    5   grn     D̅A̅T̅A̅    IN/play
    6   blu     R̅E̅S̅E̅T̅   n/c

The `S1` pinout from [Old Hard CMT][oh cmt] may be the Hitachi Basic Master
S1; if it uses the same pinout he's just counting the pins backwards,
having misinterpreted his diagram as looking into female rather than male.

#### DIN-7

         AIIc      520ST
    1   +15 VDC   +5  VDC
    2    CGND      NC
    3    SGND      GND
    4   +15 VDC   +12 VDC
    5    SGND     -12 VDC
    6    NC       +5  VDC
    7    NC        GND

- `AIIc`: Apple IIc power jack (male) from [apple2/iic](apple2/iic.md).
- `502ST`: Atari 520ST power jack (male) from [[sgntomcat]].


#### DIN-8: CMT (Cassette Tape)

      2  GND        Computer usu. also 1, 3, 8; cable usu. unconnected.
      4  REC        CMT microphone; output from computer
      5  PLAY       CMT playback; input to computer
    6,7  REM+,REM-  Relay open for stop; closed for motor run

Manufacturer cables I have invariably connect only 2 to ground, leaving 1,
3, 8 and shield unconnected. Also invariably, relay ring is 6 and relay tip
is 7. (All came with used equipment, one with a Panasonic JR-200, one with
a NEC PC-DR311 data recorder, one from unknown source.)

__Smartphone Connections__

Apple standard headphone connectors and most (?) Android use the
following TRRS, but some other phones swap ground and mic. In all cases,
shorting mic and ground makes the device output only. The mic
connection otherwise must see enough impedance to be detected; a
resistor in series with the CMT output can help with this. See below
for values.

                    GALAXY¹ SAMSUNG
    tip     left    green   green
    ring 1  right   blue    red
    ring 2  ground  copper  copper
    sleeve  mic     red     black

- ¹ The Galaxy colours are also the ones in my white TRRS extension cables.
  Obviously these vary.

On the [Apple iPhone-style pinout][pru-iphone], the headset button
also shorts mic. to ground. CMT resistor 1.6 kΩ.

2.2 kΩ tested to work on ThinkPad T510 built-in headset socket. pavucontrol
displays "unplugged" when JR-200 directly connected; "plugged in" when
unconnected or series resitor in place.

queuebert's Mercari DIN-8 to smartphone cable (works with FM-8):

    TRRS     DIN-8   Notes
    ───────────────────────
    tip     5 PLAY
    ring 1  3 GND   right channel shorted to ground
    ring 2  3 GND   relies on computer having GND on pin 3
    sleeve  4 REC   2k2 inline; 12k to ground

On the [Apple iPhone-style pinout][pru-iphone], the headset button also
shorts mic. to ground. Series 1k6 resistor between computer and sleeve
suggested.

[HTC pinout][pru-htc] (including many Android models, such as Nexus
One) is the same, but Apple mics often don't work. Standard mic/gnd
resistance with no button pressed 47 KΩ on Nexus One, 33 KΩ on
Desire S. Multi-button remotes use various resistances between mic and
ground for signalling, e.g. play=1Ω, back=220Ω, next=600Ω.


Common Pinouts
--------------

A large number of different applications, particularly audio, are
[given here][e2k/din]. Note that page is looking into the male plug,
not the female jack as above.

#### [MIDI] current loop (usu. +5 V):

    1   N/C
    2   GND/shield on output; N/C on input
    3   N/C
    4   Current source
    5   Current sink controlled by UART

#### IBM PC, PC/XT, PC/AT Keyboard

    1   Clock
    2   Data
    3   Reset (PC, XT only)
    4   GND
    5   VCC (+5 V from computer)

##### European-standard Analogue Audio

See [euaudio].

    2   GND


Mini-DIN
--------

The following is a mini-DIN-4 connector, looking into the female jack
on a device, with the Y/C (S-Video) pinout.

     /¯¯¯U¯¯¯\      1   GND (Y)
    |  4   3  |     2   GND (C)
    | 2     1 |     3   Y Luma (intensity)
     \_|■■■|_/      4   C Chroma (color)

Common DE-15 (VGA) to 3×RCA + mini-DIN-4 cables converters have pins 2,
3 and 4 cabled, but leave pin 1 unconnected at the mini-DIN end.



<!-------------------------------------------------------------------->
[DIN]: https://en.wikipedia.org/wiki/DIN_connector
[c64w av]: https://www.c64-wiki.com/wiki/A/V_Jack
[hosiden-wb]: https://web.archive.org/web/20180516230412/http://www.hosiden.com:80/product/pdf/e_din.pdf
[hosiden]: https://www.hosiden.com/product/pdf/e_din.pdf
[mini-DIN]: https://en.wikipedia.org/wiki/Mini-DIN_connector
[oh cmt]: https://www14.big.or.jp/~nijiyume/hard/jyoho/connect/cmt.htm
[oh d8]: https://www14.big.or.jp/~nijiyume/hard/jyoho/connect/d8.htm
[oh top]: https://www14.big.or.jp/~nijiyume/hard/jyoho/connect.htm
[pru-htc]: https://pinoutguide.com/HeadsetsHeadphones/htc_hd2_headphone_pinout.shtml
[pru-iphone]: https://pinouts.ru/HeadsetsHeadphones/iphone_headphone_pinout.shtml
[rc 12255]: https://retrocomputing.stackexchange.com/a/12255/7208
[sgntomcat]: http://retrospec.sgn.net/users/tomcat/miodrag/Atari_ST/Atari_ST.htm

[MIDI]: https://en.wikipedia.org/wiki/MIDI#Electrical_specifications
[e2k/din]: https://www.electronics2000.co.uk/pin-out/dincon.php
[euaudio]: https://en.wikipedia.org/wiki/DIN_connector#Analog_audio
