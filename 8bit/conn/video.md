Video Connectors
================

Early Japanese video connectors (composite and DRGB) are often
[DIN](./din.md); see that file for additional information, pin numbering
and breakouts.

Sources for DIN, D-sub, etc. pinouts:
- [OLD Hard Connector Information デジタル８ピン][ohd8]
- Retrocomputing [Common Japanese 8-bit DIN pinouts][rc 12255] community
  wiki answer: common pinouts covering CMT, composite/DRGB video.


Other Connectors
----------------

### S1308

Japanese 8-bit computers often use DIN-8 for digital RGB and RGBI;
these often use an S1308 (female) 8-pin rectangular connector on the
monitor side (P1308 male on cable). One set of pins is separated from
the others by a larger gap (exaggerated below). The standard pin
numbering is (ref. [minicon1300] and printing on Jr.200 video cable):

              +-----------+     +-----------+
    male plug ! 1 7 6   5 !     ! 5   6 7 8 ! female jack
      (cable) ! 4 3 2   1 !     ! 1   2 3 4 ! (monitor)
              +-----------+     +-----------+

Pin assignments vary wildly. Sources include:
- [OLD Hard Connector Information デジタル８ピン][ohd8]
- [Larry Green's FM-7 page][fm7]
- [MSX Wiki][msxw-drgb]

### VGA Pinout

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
[fm7]: http://www.nausicaa.net/~lgreenf/fm7page.htm
[minicon1300]: https://www.datasheetarchive.com/pdf/download.php?id=c2e30b8b00214f56db8359b4d5ca3227d3034f&type=M&term=S1308SB
[msxw-drgb]: https://www.msx.org/wiki/Digital_RGB_connector
[ohd8]: http://www14.big.or.jp/~nijiyume/hard/jyoho/connect/d8.htm
[pru-vga]: https://pinouts.ru/Video/VGA15_pinout.shtml
[rc 12255]: https://retrocomputing.stackexchange.com/a/12255/7208
