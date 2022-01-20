JST Connectors
==============

All JST connectors are keyed.

Summary (pin pitch in mm, wire size range in AWG). All are 1-row, shrouded.

    Series  Pitch  Wire   Lock  Type
    ───────────────────────────────────────────────────────────────────
      XH    2.50   30-22   no   Wire-to-board; inline female, PCB male
      SM    2.50   28-22  yes   Wire-to-wire;  inline male and female
      PH    2.0    32-24¹  no   Wire-to-board, inline female, PCB male

    ¹ 30-24, 28-24, 32-28 depending on connector


JST XH
------

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


JST SM
------

2.50 mm wire-to-wire connectors.


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
- [Hilitand] pre-crimped power connectors (SM)



<!-------------------------------------------------------------------->
[wp jst]: https://en.wikipedia.org/wiki/JST_connector
[jst xh]: https://www.jst-mfg.com/product/pdf/eng/eXH.pdf
[jst sm]: http://www.jst-mfg.com/product/pdf/eng/eSM.pdf

[hilitand]: https://www.amazon.com/dp/B07DL4FNTF
[packronics]: https://www.pakronics.com.au/products/jst-2-pin-power-connector-ss321050009
[sparkfun]: https://learn.sparkfun.com/tutorials/connector-basics/all#power-connectors
[woodland]: https://www.amazon.com/dp/B07YKHV46N
