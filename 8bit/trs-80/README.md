TRS-80 Model I Family
=====================

References:
- classiccmp.org [TRS-80 Model I Internals][ccmp-1-int]
- Console5 Tech Wiki, [TRS80 Cap Lists][c5-cap]. Lists capacitors
  for a dozen different TRS-80 models.


Case Screws
-----------

The bottom of the case is held on with six long screws of three different
lengths, 39, 45 and 52 mm:


           52    52

    45   LABEL        45

           39    39


Power
-----

5-pin DIN:

    1   14 VAC, 1 A (from transformer)
    2   19.8 VDC, 350 mA
    3   14 VAC, 1 A (from transformer)
    4   GND
    5   n/c

N.B. My own Model I (modified) does not use this! It's been internally
changed to use a custom external PSU providing +5/+12/-5 VDC.


Keyboard
--------

The Japanese keyboard replaces the wide `Enter` key with two
regular-size keys and remaps as follows:

    Row     US              JP
    top     :*   -=         -=, ¥
    2nd     ←    →          Enter  ←
    3rd     Enter  Clear    :*  Clear  →
    bottom  Right-Shift     英数/カナ


I/O Ports
---------

### Video, 5-pin DIN

    1   5 VDC (30 mA max.)
    4   Composite video
    5   GND

### Cassette, 5-pin DIN

    1   Motor Relay
    2   GND
    3   Motor Relay
    4   Cassette In (to earphone jack on recorder)
    5   Cassette Out (to mic. jack on player)

### Expansion connector

See [classiccmp.org page][ccmp-1-int].



<!-------------------------------------------------------------------->
[c5-cap]: https://wiki.console5.com/wiki/TRS80
[ccmp-1-int]: http://www.classiccmp.org/cpmarchives/trs80/mirrors/kjsl/www.kjsl.com/trs80/mod1intern.html
