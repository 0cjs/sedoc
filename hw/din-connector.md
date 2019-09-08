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



<!-------------------------------------------------------------------->
[DIN]: https://en.wikipedia.org/wiki/DIN_connector
[mini-DIN]: https://en.wikipedia.org/wiki/Mini-DIN_connector

[MIDI]: https://en.wikipedia.org/wiki/MIDI#Electrical_specifications
[e2k/din]: https://www.electronics2000.co.uk/pin-out/dincon.php
[euaudio]: https://en.wikipedia.org/wiki/DIN_connector#Analog_audio
