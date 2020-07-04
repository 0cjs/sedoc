Video Connectors
================

Early Japanese video connectors (composite and DRGB) are often
[DIN](./din.md); see that file for additional information, pin numbering
and breakouts.

Sources for DIN, D-sub, etc. pinouts:
- [OLD Hard Connector Information デジタル８ピン][ohd8]
- Retrocomputing [Common Japanese 8-bit DIN pinouts][rc 12255] community
  wiki answer: common pinouts covering CMT, composite/DRGB video.

TODO
----

- DIN: Composite and DRGB DIN, currently under [DIN](din.md).
- 15-pin analogue: PC-8801 post-mkII/FR systems?
- 25-pin analogue: [FM77AV40SX][fm77].


JP-21 / "RGBマルチ" (RGB-21, SCART)
-----------------------------------

[JP-21] is a SCART-like connector with a slightly different pinout; it's
used by the [FM77AV][fm77].

"CVBS" means composite video. "Output" appears to mean "from computer"; it
does for what's been checked on my [FM77].

The following is FM77AV-specific, for the moment.

                        ______________________________
                        \ 20 18 16 14 12 10 8 6 4 2  |
    chassis ground "21" →\ 19 17 15 13 11  9 7 5 3 1 |

    Clr Pins        Description

         1,5        audio left,right input (possibly vice versa)
    WR   2,6        audio left,right output
         3,4        audio input,output ground
         7,8        video input,output ground
         9          composite/sync input (1 Vp-p, 75Ω, negative sync)
    Y   10          composite sync output (no video)
    W   11          AV control input
    W   12          Ym input; low <0.4V, high >1V, 75Ω
                    (switches RGB to half brightness for video overlay)
        14          ground
    W   16          Ys input; low=ground, high=1V or more
        13,17,18    R,G,B ground
    RGB 15,19,20    R,G,B I/O; 0.7 Vp-p, 75Ω (Ys low=output, high=input)
        21          shield

####  Breakout Board

`Clr` above has pin header colors on the JP-21 breakout board (excepting
black). In pin order:

        1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21
        _  W  _  _  _  R  _  _  _  Y  W  W  _  _  R  W  _  _  G  B  _

#### References

- ja Wikipedia: [RGB21ピン]. Includes a table with both JP-21 and
  SCART pinouts.
- [OLD Hard アナログ２１ピン][oh-a21]
- [FM-77AV用TOWNSモニター接続アダプター][fmavtw]. Cable to connect
  FM77 output to FM TOWNS monitor; [FM Towns Video pinout][towns] may
  be of help decoding the interface.


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
- [Larry Green's FM-7 page][lgreenf]
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
[fm77]: ../fm7/fm77.md

[ohd8]: http://www14.big.or.jp/~nijiyume/hard/jyoho/connect/d8.htm
[rc 12255]: https://retrocomputing.stackexchange.com/a/12255/7208

[lgreenf]: http://www.nausicaa.net/~lgreenf/fm7page.htm
[minicon1300]: https://www.datasheetarchive.com/pdf/download.php?id=c2e30b8b00214f56db8359b4d5ca3227d3034f&type=M&term=S1308SB
[msxw-drgb]: https://www.msx.org/wiki/Digital_RGB_connector
[pru-vga]: https://pinouts.ru/Video/VGA15_pinout.shtml

[RGB21ピン]: https://ja.wikipedia.org/wiki/RGB21ピン
[fmavtw]: http://dempa.jp/rgb/drug/fmavtw01.html
[jp-21]: https://en.wikipedia.org/wiki/SCART#JP-21
[oh-a21]: https://www14.big.or.jp/~nijiyume/hard/jyoho/connect/a21.htm
[towns]: http://www.hardwarebook.info/FM_Towns_Video
