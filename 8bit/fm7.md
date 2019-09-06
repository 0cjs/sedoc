FM-7 Notes
==========

[Larry Green's FM-7 page][lgreen] is a very useful resource. It
includes pinouts for the connectors and (limited) DIP switch
descriptions.

Video Outputs
-------------

This is copied directly from lgreen's page; he in turn received it
from a Japanese FM-8 user on the Internet.

    COLOR CRT (DIN8):

           x
        7     6
           8
      3         1

        5     4
           2

    1: +12V
    2: GND
    3: Video clock (2Mhz)
    4: horizontal sync signal
    5: vertical sync signal
    6: red
    7: green
    8: blue

    MONOCHROME CRT (DIN5):

           x

      3         1

        5     4
           2

    1: +12V
    2: GND
    3: composite video signal
    4: horizontal sync signal
    5: vertical sync signal

The above pin numbering is looking at the female socket on the
computer. This monochrome output is a 180° 5-pin DIN connector, the
same same physical format as:
- MIDI, but MIDI cables cannot be used because they don't use pins 1
  and 3, and the composite output is on 3.
- [European-standard analog audio][euaudio]: where 2 is ground. The
  composite output on pin 3 is on the amplifer left audio in/tape
  recorder left audio out.

There is a seemingly standard-in-Japan 8-pin rectangular connector for
RGBI on monitors. Viewed looking at the CRT connector, an I-shaped
8-pin connector S1308-SB:

    +--------------------------------+
    ! 5:GND  6:GND  7:HSYNC  8:VSYNC !
    ! 1:N/C  2:RED  3:GREEN  4:BLUE  !
    +--------------------------------+


DIP Switches
------------

4-position switch at the right of the computer as viewed from the back.

    (1) ROM mode/DISK mode* (FBASIC mode)
    1=ON, 2=ON, 3=OFF, 4=OFF
    (ON=UP, OFF=DOWN.  Number is sequential from left to right)
    *when external floppy disk is available

    (2)DOS Mode
    1=ON, 2=OFF, 3=OFF, 4=OFF

    CLOCK Freq.
          MAIN CPU   SUB CPU
    4=ON   1.2Mhz    1.0Mhz (FM-8 compatible mode)
    4=OFF  2.0Mhz    2.0Mhz



<!-------------------------------------------------------------------->
[euaudio]: https://en.wikipedia.org/wiki/DIN_connector#Analog_audio
[lgreen]: http://www.nausicaa.net/~lgreenf/fm7page.htm
