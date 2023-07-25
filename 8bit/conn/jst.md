JST Connectors
==============

All JST connectors are keyed.

Summary (pin pitch in mm, wire size range in AWG). All are 1-row, shrouded.

    Series  Pitch  Wire   Lock  Type
    ───────────────────────────────────────────────────────────────────
      VH    3.96   22-16  yes   Wire-to-board, inline female, PCB male
      XH    2.50   30-22   no   Wire-to-board; inline female, PCB male
      PH    2.0    32-24¹  no   Wire-to-board, inline female, PCB male
      SM    2.50   28-22  yes   Wire-to-wire;  inline male and female

    ¹ 30-24, 28-24, 32-28 depending on connector

Also see:
- Matt's Tech Pages [Common JST Connector Types][mtp-jst]
- jst.co.uk [Proudcts page][jstcouk]


[JST VH]
--------

Large, square pins at 3.96 mm pitch; locking connector. Popular for PCB
power supplies and old data connectors. Unshrouded board connectors more
common. Do not confuse with [Molex KK 396 / KK .156][kk386], which have
same pitch but a curvy "hump" in the board connector tab.

Wire Connectors (female; 2=no. of pins):
- `VHR-2N` N type (more common?)
- `VHR-2M` M type
- `VHS-2V` retainer mountable type

Board connectors (male; 2=no. of pins):
- `B2P-VH` top entry
- `B2PS-VH` side entry
- `B2P-VH-B` top entry PBT
- `S2P-VH` side entry w/PCB stabilizer
- `B2P-VH-FB-B` top-entry shrouded
- `B6P7-VH` is 7-position, 6th pin omitted; see data sheet for more

Pin 1 at left:
- looking into female wire connector with pin openings at botom.
- looking down on male board connector w/latch at top, wide area at bot.


[JST XH]
--------

2.50 mm wire-to-board connectors:
- Female wire connectors; male shrouded PCB connectors.
- All connectors are single-row.
- 250 V 3 A per pin
- Many sources give 2.54 pin spacing, which is indeed pretty close (6-pin
  connectors fit fine in 2.54 mm spaced breadboards)

### XH Pin Numbering

Looking into the female connector with the guide tab(s) down (metal pin
locking tabs up) there will be a "Circuit No.1 mark" on top at the left;
the leftmost pin in this orientation is pin 1. (This might be considered
upside down from .1" headers, where one looks at them with the guide tab(s)
up.)

References:
- Wikipedia, [JST connector][wp jst]
- JST, [XH Connector][jst xh] datasheet.
- JST, [SM Connector][jst se] datasheet.


[JST SM]
--------

2.50 mm wire-to-wire connectors. Commonly used for LED strip power
connectors. Plug has female pin entries; receptacle has shroud/male pins.

Holding the receptacle with pins facing away locking tab up, pin 1 is at
left. Only receptacle has pin numbers marked, at wire entry.

Pin assignments vary, a lot. Common ones are:

             1    2    3   4    cjs others
    ──────────────────────────────────────────────────────────
    2-pin   BLK  RED             ✓  lots
    ──────────────────────────────────────────────────────────
    3-pin   YEL  GRN  RED           sparkfun
    3-pin   RED  BLK  YEL           pcboard.ca
    3-pin   BLK  YEL  RED           bc-robotics.com
    3-pin   BLK  GRN  RED           aliexpress.com random
    ──────────────────────────────────────────────────────────
    4-pin   RED  BLU  GRN  YEL      sparkfun
    4-pin   GRN  RED  BLU  BLK      pcboard.ca
    4-pin   BLK  BLU  GRN  RED      aliexpress.com random

References:
- [Sparkfun JST-SM][sparkfun-SM] (2-, 3-, 4-pin LED Strip Pigtail Connectors)


Power Connectors
----------------

Power seems to be informally standardized as:

    Pin 1  Red  +5V
    Pin 2  Blk  GND
    Pin 3  Yel  +12V

Examples:
- [Sparkfun] connectors page (XH)
- [Packronics] pre-crimped power connectors (XH)
- [Woodland] lights/3D printer (XH)
- [Hilitand] pre-crimped power connectors ("JST")



<!-------------------------------------------------------------------->
[jstcouk]: https://www.jst.co.uk/products.php?cat=30&nm=JST+Wire-to-Board+Connectors+%28Crimp+Style%29
[mtp-jst]: https://www.mattmillman.com/info/crimpconnectors/common-jst-connector-types/

[jst sm]: http://www.jst-mfg.com/product/pdf/eng/eSM.pdf
[jst vh]: https://www.jst-mfg.com/product/pdf/eng/eVH.pdf
[jst xh]: https://www.jst-mfg.com/product/pdf/eng/eXH.pdf
[kk386]: https://www.mattmillman.com/info/crimpconnectors/#kk156
[wp jst]: https://en.wikipedia.org/wiki/JST_connector

<!-- JST SM -->
[sparkfun-SM]: https://www.sparkfun.com/categories/tags/jst-sm

[hilitand]: https://www.amazon.com/dp/B07DL4FNTF
[packronics]: https://www.pakronics.com.au/products/jst-2-pin-power-connector-ss321050009
[sparkfun]: https://learn.sparkfun.com/tutorials/connector-basics/all#power-connectors
[woodland]: https://www.amazon.com/dp/B07YKHV46N
