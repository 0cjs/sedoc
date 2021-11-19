Video Connectors
================

Early Japanese video connectors (composite and DRGB) are often
[DIN] and later ones [DE-9, DA-15 or DE-15](dsub.md); see those
file for additional information, pin numbering and breakouts.

Contents:
- JP-21 / "RGBマルチ" (RGB-21, SCART)
- DIN (CVBS, RGB)
- S1308 (8-color Digital RGB)
- DA-15 (Analog RGB)
- 0.1" Pin Headers, Dupont Shrouds, BT224 IDC connectors, Breakouts

### To-do

- DIN: Composite and DRGB DIN, currently under [DIN].
- DIN: Analogue RGB DIN started below
- 25-pin analogue: [FM77AV40SX][fm77].


JP-21 / "RGBマルチ" (RGB-21, SCART)
-----------------------------------

[JP-21] is a [SCART] connector with a slightly different pinout.
It's used by the [FM77AV][fm77] series.

SCART and JP-21 do not use straight-through cables; for signals marked
"input" or "output," these are always the signals on the device connector
and the cable is expected to swap them. (I.e., the computer sends audio on
pin 2 which is connected to the monitor's receive pin 1.)

- Signals below are referenced from the computer to the display, i.e.,
  "output" is a signal sent by the computer and recieved by the display.
- Some of the following has been checked on my [FM77AV][fm77]; that file
  notes what has and hasn't.

                          ______________________________
                          \ 20 18 16 14 12 10 8 6 4 2  |
      chassis ground "21" →\ 19 17 15 13 11  9 7 5 3 1 |

      Clr Pins       Dir  Description

           1,5       in   audio left,right
      WR   2,6       OUT  audio left,right
           3         in   audio GND
           4         OUT  audio GND
           7         in   composite GND
           8         OUT  composite GND
           9         in   composite video
      Y   10         OUT  composite video (sync only on FM77)
      W   11         ???  AV control signal
      W   12          ↔   Ym (RGB mask): low <0.4V, high >1V, 75Ω
                          (switches RGB to half brightness for video overlay)
          14          ↔   Ym,YS GND
      W   16          ↔   Ys (RGB switch). RGB direction? FM77 +3.4 V out.
          13,17,18    ↔   R,G,B ground
      RGB 15,19,20    ↔   R,G,B I/O; 0.7 Vp-p, 75Ω (Ys low=output, high=input)
          21          ↔   shield

####  Breakout Board

`Clr` above has pin header colors on the JP-21 breakout board (excepting
black). In pin order (grounds marked with `=`):

        1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21
        _  W  =  =  _  R  =  =  _  Y  W  W  =  =  R  W  =  =  G  B  _

The cables I have are color coded as follows, with "end 1" and "end 2"
picked arbitrarily. ("End 1" was used in the first breakout board attempt.)
The wires are aluminum and cannot be soldered; they must be crimped.

        Pin   End 1             End 2
         1    brown/white
         2    brown
         3    orange/white
         4    red/white
         5    orange
         6    red
         7    yellow
         8    red/black
         9    green
        10    green/white
        11    blue
        12    blue/white
        13    purple
        14    purple/white
        15    gray
        16    pink
        17    black
        18    black/white
        19    cyan
        20    white
        21    bare

#### References

- ja Wikipedia: [RGB21ピン]. Includes a table with both JP-21 and
  SCART pinouts.
- [OLD Hard アナログ２１ピン][oh-a21]
- [FM-77AV用TOWNSモニター接続アダプター][fmavtw]. Cable to connect
  FM77 output to FM TOWNS monitor; [FM Towns Video pinout][towns] may
  be of help decoding the interface.


DIN (CVBS, RGB)
---------------

Most systems are listed in their individual documentation.
Some are also still listed in [conn/din.md](din.md).

Sources:
- [OLD Hard Connector Information デジタル８ピン][oh-d8]
- Retrocomputing [Common Japanese 8-bit DIN pinouts][rc 12255] community
  wiki answer: common pinouts covering CMT, composite/DRGB video.

### PC Engine RGB Mod

This is a mod on M's PC Engine, possibly done by "doujindance." Output is
DIN-8 270°. The JP-21 column gives the pin to which it should be connected
at the monitor.

    DIN-8   Desc                JP-21
      1     audio left          1
      2     GND                 3,7,14,13,17,18
      3     CBVS                9
      4     audio right         5
      5     AV control/blanking 11,16
      6     red                 15
      7     green               19
      8     blue                20


S1308 (8-color Digital RGB)
---------------------------

Japanese 8-bit computers often use DIN-8 for digital RGB and RGBI;
these often use an S1308 (female) 8-pin rectangular connector on the
monitor side (P1308 male on cable). One set of pins is separated from
the others by a larger gap (exaggerated below). The standard pin
numbering is (ref. [minicon1300] and printing on Jr.200 video cable):

              +-----------+     +-----------+
    male plug ! 1 7 6   5 !     ! 5   6 7 8 ! female jack
      (cable) ! 4 3 2   1 !     ! 1   2 3 4 ! (monitor)
              +-----------+     +-----------+

The pinout of the S1308 connector seems to be fairly standardized to one
of two standards (MSX is given per standard numbering above):

        Pin  JP 8-bit   MSX                               Color†
        ────────────────────────────────────────────────────────────
         1   varies†    blue                               cop
         2   red        green                              vio
         3   green      red                                orn
         4   blue       vsync                              blu
         5   GND        hsync                              cop
         6   GND        c.cont (intensity bit)             cop
         7   hsync      GND                                grn
         8   vsync      n/c, 14.318 MHz video clock        yel

        † From NEC PC-8001 cable. Copper shield split to 1,5,6
          JR-200 cable also has ground on 1,5,6.

For non-MSX systems, pin 1 may be:
- GND: NEC. D8A, D8A (MB-S1)
- C.CONT (intensity): D8A2 (PC-6001mkII/SR/6601/SR 15-color)
- +12 V: D8B (FM-77)
- N/C: FM-7
- Unconnected?: D8C (X1 except turbo40)
- Video clock (14.318 MHz): some MSX (others N/C)

Pin assignment sources:
- [OLD Hard Connector Information デジタル８ピン][oh-d8]
- [Larry Green's FM-7 page][lgreenf]
- [MSX Wiki][msxw-drgb]. Uses reversed pin numbering scheme.


DA-15 (Analog RGB)
------------------

This connector is used on:
- NEC PC-8801: V2 graphics only, R series onward
- NEC PC-9801
- Sharp X68000, X1 Turbo Z, MZ-2500
- FM Towns

Female jack on computer; male plug on cables. Numbering per [[dsub]]:

        DA-15F (computer)              DA-15M (cable)
      8  7  6  5  4  3  2  1       1  2  3  4  5  6  7  8
       15 14 13 12 11 10 9           9 10 11 12 13 14 15

Pins on computer side are all outputs. `†` indicates important notes.

    Pin  Common         Sharp     PC88      PC98      Towns
    ────────────────────────────────────────────────────────────
      1  Red
      2  GND R
      3  Green
      4  GND G
      5  Blue
      6  GND B
      7                 Ys        YS†       Ys        csync
      8  GND
      9                 NC        csync     Ys        Ys
     10                 Aud L     Aud L     Mode      Mode
     11                 Aud R     Aud R     AV Ctrl   AV Ctrl
     12  GND
     13                 NC        AVC†      dotclk    dotclk
     14  H̅S̅Y̅N̅C̅ TTL-
     15  V̅S̅Y̅N̅C̅ TTL-

Notes:
- General:
  - `YS`/`Ys` appears to be a "video output is active" signal; some
    monitors do not display unless high. Also might be used to supply power
    to some RGB→CVBS→RF conversion boxes along the lines of Hitachi MP-9780
    "VHF Color Converter."
  - (12) Designated analog ground on PC88, Sharp, sync ground on Towns.
  - (13) dotclk: Dot clock; no specific frequencies given.
  - (14,15): VSYNC, HSYNC are negative-going TTL signals
- PC88:
  - (2,4,6,8,12): Common GND: all tested continuous.
  - (7†): "カラーテレビ用信号の切換制御信号　75オーム" in NEC user manual.
    PC-8801mkII SR (with good CVBS on CVBS on "B/W" DIN-5) gives steady
    +4V. (FR also steady high, not sure if +4V.)
  - (13†): "AVコントロール: カラーテレビ用ビデオ入力端子の制御信号　TTL" in
    NEC user manual. Measured +5V output.

The DA-15 breakout is currently as follows.

    Red/Grn/Blu/3×Blk   RGB signals and their grounds
    Yellow/Black        YS, YS ground
    Orange/Black        csync, ground
    White/Red/2×Blk     left/right audio, grounds
    White/Grey/2×Blk    hsync/vsync, grounds

Possibly this should be rewired to move yellow to csync and add pin 13.

Sources:
-  PC-8801mkIIFR user manual, p.7
- [[gamesx-rgb-15]],
- [[oh-a15]]
- [[VA018718]], p.7:

[gamesx-rgb-15]: https://gamesx.com/wiki/doku.php?id=av:japanese_rgb-15
[VA018718]: http://hp.vector.co.jp/authors/VA018718/towns/connect/pinasgn.htm
[oh-a15]: https://www14.big.or.jp/~nijiyume/hard/jyoho/connect/a15.htm


DE-15 (VGA)
-----------

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


0.1" Pin Headers, Dupont Shrouds, BT224 IDC connectors, Breakouts
-----------------------------------------------------------------

Note that all dupont 2×n shrounds are marked for male; pin 1 will be at the
other end from the marking when using female inserts. All outputs should be
female to help prevent shorts; inputs are thus male. See [header](header.md)
for more numbering and organization details.

                  ▼  ▄             ▄  ▼
     looking      1 3 5 7       7 5 3 1    looking   (pin 1 mark at opposite
     into FEMALE  2 4 6 8       8 6 4 2  into MALE    end on dupont shrouds)

For DIN-8 breakouts, see [DIN].

#### Breakout Headers

This is the breakout header assignment for a cable from a computer (or
other video source). All headers on the cable are female.

`wclr` is the wire insulation color. The pin numbers on the computer
connector are given for PC-8801 (`88`) and JP-21 (`21`). Pin `=` refers to
a short on the connectors; pin `g` refers to ground shorted amongst some
combination of the following computer pins (not all may be connected):
- PC-8801: 8, 12, shield
- JP-21: 3, 4, 7, 8, 14, shield

The JP-21 colors are for one end of a random SCART cable; keep in mind the
other will have input and output signals swapped.


    Connector   wclr  Pin/Signal            88   21
    ─────────────────────────────────────────────────────────────────────

    RGB         blk   1  red GND             2   13 pur
    2×3         red   2  red signal          1   15 gry
                blk   3  green GND           4   17 blk
                grn   4  green signal        3   19 wht
                blk   5  blue GND            6   18 /blk
                blu   6  blue signal         5   20 cyn

    hvsync      blk   1  GND                 g
    2×2         wht   2  hsync              14
                blk   3  GND                 =
                gry   4  vsync              15

    csync       blk   1  GND                 g
    1×2         org   2  csync               9

    CVBS        blk   1  GND                 g    8 /red
    1×2         yel   2  CVBS (YS)           7   10 /grn

    audio out   blk   1  GND                 g    4 /orn
                wht   2  left audio out     10    2 /brn
                blk   3  GND                 =    =
                red   4  right audio out    11    6 /yel

The RGBS connector can be rotated left 90° (looking out the female) to plug
into a GND, CVBS/csync (pins 2, 1) male header on a board.




<!-------------------------------------------------------------------->
[din]: ./din.md
[fm77]: ../fm7/fm77.md

[RGB21ピン]: https://ja.wikipedia.org/wiki/RGB21ピン
[SCART]: https://en.wikipedia.org/wiki/SCART
[fmavtw]: http://dempa.jp/rgb/drug/fmavtw01.html
[jp-21]: https://en.wikipedia.org/wiki/SCART#JP-21
[lgreenf]: http://www.nausicaa.net/~lgreenf/fm7page.htm
[minicon1300]: https://www.datasheetarchive.com/pdf/download.php?id=c2e30b8b00214f56db8359b4d5ca3227d3034f&type=M&term=S1308SB
[msxw-drgb]: https://www.msx.org/wiki/Digital_RGB_connector
[oh-a21]: https://www14.big.or.jp/~nijiyume/hard/jyoho/connect/a21.htm
[oh-d8]: http://www14.big.or.jp/~nijiyume/hard/jyoho/connect/d8.htm
[pru-vga]: https://pinouts.ru/Video/VGA15_pinout.shtml
[rc 12255]: https://retrocomputing.stackexchange.com/a/12255/7208
[towns]: http://www.hardwarebook.info/FM_Towns_Video
