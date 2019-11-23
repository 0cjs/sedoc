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


Pin Numbering and Breakouts
---------------------------

DIN plugs always use the same numbers for the same positions, so that
e.g. pin 3 will be in the same place on any connector from 3 to 8
pins.

Five-pin, eight-pin 270° and eight-pin 268°, looking into female jack:

           ∪                 ∪                 ∪
                          7     6         8         7
      3         1       3    8    1       3    6    1
        5     4           5     4           5     4
           2                 2                 2

References:
- [Hosiden DIN Connectors][hosiden] (PDF): Catalog with pin numbering and
  references to standards.
- Retrocomputing [Common Japanese 8-bit DIN pinouts][rc 12255] community
  wiki answer: common pinouts covering CMT, composite/DRGB video.

#### DIN-8 Breakout (cjs v1)

    1-Orange  2-Black   3-Yellow  # [V+/audio], GND, [clock]
    4-White   5-Grey              # hsync/vsync (usu. grey/black); MIC/EAR
    6-Red     7-Green   8-Blue    # TTL RGB; 6/7 cassette relay

#### DIN-5 Breakout (cjs v1)

                # CMT       video
    1-Blue      # "CMT1"    dot clock, audio
    2-Black     # "CMT2"    GND
    3-Yellow    # GND       composite video, A/V+5V on Yamaha/Victor MSX
    4-Red       # REC       hsync
    5-Green     # PLAY      vsync

#### Apple IIc Serial DIN-5 Breakout (cjs v1)

Using Ethernet cable; orange and green stripes tied together for ground.

     blue   1  out   DTR  Data Terminal Ready
     stripe 2   -    GND
     brown  3  in    DSR  Data Set Ready; input to DCD on ACIA
     orange 4  out   TD   Transmit Data
     green  5  in    RD   Receive Data

For [ADTPro], use a cable with hardware handshaking disabled by tying
together DTR and DSR (1 and 3, DIN numbering) on the Apple side, and
RTS and CTS (7 and 8) on the PC side. Here's the DB-9 pinout, looking
into the male connector on the PC and the female connector on the IIc:

    1 2 3 4 5       PC    Apple IIc        ∪
     6 7 8 9                          3         1
                 DCD 1 ←                5     4
                  RD 2 ←  4 TD             2
                  TD 3  → 5 RD
                 DTR 4  →
                 GND 5    2 GND
                 DSR 6 ←
             /-- RTS 7  →
             \-- CTS 8 ←
                 RI  9 ←
                        ← 1 DTR -\
                        → 3 DSR -/

#### CMT (Cassette Tape) 8-pin DIN

      4  REC        CMT microphone; output from computer
      5  PLAY       CMT playback; input to computer
    6,7  REM+,REM-  Relay open for stop; closed for motor run

Apple standard headphone connectors and most (?) Android use the
following TRRS, but some other phones ground and mic. In all cases,
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


Related Notes
-------------

Japanese 8-bit computers often use DIN-8 for digital RGB and RGBI;
these almost invariably hook up to a standard 8-pin rectangular
connector on the monitor. Viewed looking at the CRT connector, an
I-shaped 8-pin connector S1308-SB:

    +--------------------------------+
    ! 5:GND  6:GND  7:HSYNC  8:VSYNC !
    ! 1:N/C  2:RED  3:GREEN  4:BLUE  !
    +--------------------------------+

#### VGA Pinout

DDC2 pinout here just for quick reference; see [pinouts.ru VGA
pinout][pru-vga] for more details. Facing the male DE-15 plug on the
cable, pins are numbered in three rows left to right 1-5, 6-10, 11-15.

     1  red (75 ohm, 0.7 V p-p)
     2  green
     3  blue
     4  reserved (DDC1: ID2)
     5  ground
     6  red ground
     7  green ground
     8  blue ground
     9  key (no pin); optionally 5 V output from graphics card
    10  sync ground
    11  ID0 monitor ID bit 0 (optional)
    12  SDA I2C serial data (DDC1: ID1)
    13  hsync or csync
    14  vsync; also used as a data clock
    15  SCL: I2C data clock (DDC1: ID3)



<!-------------------------------------------------------------------->
[DIN]: https://en.wikipedia.org/wiki/DIN_connector
[adtpro]: http://adtpro.com/connectionsserial.html#DIN5
[hosiden]: https://www.hosiden.com/product/pdf/e_din.pdf
[mini-DIN]: https://en.wikipedia.org/wiki/Mini-DIN_connector
[pru-htc]: https://pinoutguide.com/HeadsetsHeadphones/htc_hd2_headphone_pinout.shtml
[pru-iphone]: https://pinouts.ru/HeadsetsHeadphones/iphone_headphone_pinout.shtml
[rc 12255]: https://retrocomputing.stackexchange.com/a/12255/7208

[MIDI]: https://en.wikipedia.org/wiki/MIDI#Electrical_specifications
[e2k/din]: https://www.electronics2000.co.uk/pin-out/dincon.php
[euaudio]: https://en.wikipedia.org/wiki/DIN_connector#Analog_audio

[pru-vga]: https://pinouts.ru/Video/VGA15_pinout.shtml
