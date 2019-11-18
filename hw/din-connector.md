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

DIN plugs always use the same numbers for the same positions, so that
e.g. pin 3 will be in the same place on any connector from 3 to 8
pins.

Five-pin and eight-pin, looking into female jack:

           ∪                 ∪
                          7     6
      3         1       3    8    1
        5     4           5     4
           2                 2

#### cjs's DIN-8 Breakout

    1-Orange  2-Black   3-Yellow  # [V+/audio], GND, [clock]
    4-White   5-Grey              # hsync/vsync (usu. grey/black); MIC/EAR
    6-Red     7-Green   8-Blue    # TTL RGB; 6/7 cassette relay

#### cjs's Apple IIc Serial Breakout

Using Ethernet cable; orange and green stripes tied together for ground.

     blue   1  out   DTR  Data Terminal Ready
     stripe 2   -    GND
     brown  3  in    DSR  Data Set Ready; input to DCD on ACIA
     orange 4  out   TD   Transmit Data
     green  5  in    RD   Receive Data

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
[mini-DIN]: https://en.wikipedia.org/wiki/Mini-DIN_connector
[pru-htc]: https://pinoutguide.com/HeadsetsHeadphones/htc_hd2_headphone_pinout.shtml
[pru-iphone]: https://pinouts.ru/HeadsetsHeadphones/iphone_headphone_pinout.shtml

[MIDI]: https://en.wikipedia.org/wiki/MIDI#Electrical_specifications
[e2k/din]: https://www.electronics2000.co.uk/pin-out/dincon.php
[euaudio]: https://en.wikipedia.org/wiki/DIN_connector#Analog_audio

[pru-vga]: https://pinouts.ru/Video/VGA15_pinout.shtml
