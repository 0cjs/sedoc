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

Five-pin, eight-pin 270° and eight-pin 268°, looking into female jack
on device:

        DIN-3,5a        DIN-5b,6         DIN-7,8a         DIN-8b
           ∪               ∪                ∪                ∪
                       5       1         7     6        8         7
      3         1          6           3    8    1      3    6    1
        5     4         4     2          5     4          5     4
           2               3                2                2

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
    Blu  Pnk   1   GND/cmt1   Vcc/12V; dot clock; audio; vsync/blank; GND
    Blk  Blk   2   GND        GND
    Yel  Yel   3   GND/cmt3   CVBS; clock; AVC-TTL
    Red  Wht   4   rec/mic    hsync (trad. gray); GND
    Grn  Gry   5   play/ear   vsync (trad. black); GND
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
- C8 colors on any breakouts; C5 colours may be used on some DIN-5 breakouts
- DIN-5 breakout can be used for CMT if remote relay not required.
- Pin 1 varies widely between machines; take care for +12V!
- `cmt1/cmt3` are unknown PC-6001 "control" thing; PC-8801 may have Vcc, INT5
- Yamaha and Victor MSX1 have audio on pin 1 and use AVC-TTL as a control
  signal to JP-21 connectors to set aspect ratio (SCART pin 11 (8?), 0-12V).
- Sync cable colors changed from standard gray/black due to GND conflict

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

Using Ethernet cable. `Dsub` are my [DB-25/DE-9 colors](./dsub.md); `Eth`
is Ethernet cable colors. Orange and green stripe are tied together for
ground.

     Dsub  Eth    pin dir  sig  description
     orn   blue    1  out  DTR  Data Terminal Ready (orange on DB-25/DE-9)
     blk   stripe  2   -   GND
     yel   brown   3  in   DSR  Data Set Ready; input to DCD on ACIA (yel on DB-25/9)
     red   orange  4  out  TD   Transmit Data (red on DB-25/DE-9)
     grn   green   5  in   RD   Receive Data

For [ADTPro], use a cable with hardware handshaking disabled by tying
together DTR and DSR (1 and 3, DIN numbering) on the Apple side, and
RTS and CTS (7 and 8) on the PC side. Here's the DE-9 pinout, looking
into the male connector on the PC and the female connector on the IIc:

    1 2 3 4 5       PC    Apple IIc        ∪
     6 7 8 9                          3         1
             /-- DCD 1 ←                5     4
             |    RD 2 ←  4 TD             2
             |    TD 3  → 5 RD
             +-- DTR 4  →
             |   GND 5    2 GND
             \-- DSR 6 ←
             /-- RTS 7  →
             \-- CTS 8 ←
                 RI  9 ←
                        ← 1 DTR -\
                        → 3 DSR -/

#### DIN-7

         ApIIc     520ST
    1   +15 VDC   +5  VDC
    2    CGND      NC
    3    SGND      GND
    4   +15 VDC   +12 VDC
    5    SGND     -12 VDC
    6    NC       +5  VDC
    7    NC        GND

- Apple IIc power jack (male) from [apple2/iic](apple2/iic.md).
- Atari 520ST power jack (male) from [[sgntomcat]].


#### CMT (Cassette Tape) 8-pin DIN

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
connection otherwise must see enough impedence to be detected; a
resistor in series with the CMT output can help with this. See below
for values.

                    GALAXY¹ SAMSUNG
    tip     left    green   green
    ring 1  right   blue    red
    ring 2  ground  copper  copper
    sleeve  mic     red     black

¹The Galaxy colours are also the ones in my white TRRS extension
cables. Obviously these vary.

On the [Apple iPhone-style pinout][pru-iphone], the headset button
also shorts mic. to ground. CMT resistor 1.6 KΩ.

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
[adtpro]: http://adtpro.com/connectionsserial.html#DIN5
[c64w av]: https://www.c64-wiki.com/wiki/A/V_Jack
[hosiden-wb]: https://web.archive.org/web/20180516230412/http://www.hosiden.com:80/product/pdf/e_din.pdf
[hosiden]: https://www.hosiden.com/product/pdf/e_din.pdf
[mini-DIN]: https://en.wikipedia.org/wiki/Mini-DIN_connector
[pru-htc]: https://pinoutguide.com/HeadsetsHeadphones/htc_hd2_headphone_pinout.shtml
[pru-iphone]: https://pinouts.ru/HeadsetsHeadphones/iphone_headphone_pinout.shtml
[rc 12255]: https://retrocomputing.stackexchange.com/a/12255/7208
[sgntomcat]: http://retrospec.sgn.net/users/tomcat/miodrag/Atari_ST/Atari_ST.htm

[MIDI]: https://en.wikipedia.org/wiki/MIDI#Electrical_specifications
[e2k/din]: https://www.electronics2000.co.uk/pin-out/dincon.php
[euaudio]: https://en.wikipedia.org/wiki/DIN_connector#Analog_audio
