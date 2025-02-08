PC-8001 Hardware Setup and Interfaces
=====================================


DIP Switches and Jumpers
------------------------

The PC-8001 has no switches, but an internal jumper to select a pair
of serial port baud rates. See "Serial / RS-232" below.

### PC-8001mkII

From the _PC-8001mk II User's Manual_ [p.3-4 P.38][m2um.38]:

8 DIP switches: up=on, down=off.
- 0-7: ???
- 8: up/on=N-BASIC; down/off=N80-BASIC

8×2 header for jumpering RS-232 baud rate.


Connector Pinouts
-----------------

See [DIN Connectors](../conn/din.md) for pin numbering details.

#### Board Power Connectors

I don't know the names of these, but NEC often uses a power connector with
3 mm dia. pins about 10 mm high, 9 mm between pin 1 (ground) and pin 2 (for
keying) and 7 mm between addtitional pins. Pinouts include:

    Pin 1 ─── 2 ── 3 ── 4 ── 5
       GND   +5  +12  -12           PC-8001, PC-8001mkII
       GND   +5  +12   -5  +12      PC-8031-2W (mainboard power)
       GND   +5  +12                PC-8031-2W (FDD supply)

(With the PC-8801 NEC switched to JST VH (?) with a missing key pin.

#### Speaker

Internal.

8001, 8001mkII:
- Internal 45mm: NEC 63001005 8Ω 8Ω 0.1W JAPAN 24I.
- 2-pin crimped connector, polarised.

#### RGBI (8-pin 270° DIN)

Sources:
- [PC-8001 Manual][vcf 1375656]
- [デジタル RGB コンポーネント・アダプタ][nr-drgb]
- [PC-8001用RGBケーブルを作成してみよう！！ ][hkjunk0], which also has
  information on converting it via passive parts only to analogue RGB.
- [デジタルRGB(8ピン）はアナログRGBの夢を見れるか？ ][def_int].
- Leaded Solder, [A mystical journey...][ls-pc88cv]

    ＃      PC-8001mkII     備考
    1       VDD (+12V)      N/C
    2       GND
    3       Clock(14MHz)    N/C
    4       HSync           水平同期信号 (TTL or video level?)
    5       VSync           垂直同期信号 (TTL or video level?)
    6       Red
    7       Green
    8       Blue
    GND     GND             外周のシールド

Roughly, the passive conversion described above and in
[X1のデジタルRGB出力をSONYのTVのAVマルチ入力端子につなぐ実験][kenko858] is:
- To get composite sync, run hsync and vsync each into a 1N4148, tie the
  ouputs together with a 200Ω pulldown. 330Ω works too.
- Run R, G, B through 150Ω resistors, per [x1/rgb21]?

See also [RGBコンバータ(11)][sb-rgb11] (and updates [here][sb-rgb13] for an
FPGA-based RGB converter project.

#### B/W Composite (5-pin 180° DIN)

2/3 seem to be GND/CVBS on most systems; tested on PC-8xxx and FM-7.

    1: +12V     2: GND      3: CVBS     4: NC       5: LPEN

References:
- Old Hard [デジタル８ピン][oh-d8]
  has "M5A モノクロ (PC-8001/8801)" at the bottom of the page.
- The [Byte review][byte] claims that the 5-pin connector provides +12V.

#### CMT/Cassette (8-pin 270° DIN)

600 bps FSK Kansas City (1200/2400 Hz).

Motor relay included. (Toggle w/`MOTOR` in Basic.)

This pinout from [PC-8001 Manual][vcf 1375656] and [Enri's PC-8001][EnrPc]:

    1   GND
    2   GND           Signal ground
    3   GND
    4   CMTOUT  out   Cassette record (red)
    5   CMTOUT  in    Cassette playback (white)
    6   REM+    out   Remote signal (black)
    7   REM-    out   Remote signal (black)
    8   GND           Signal ground

The pinout for the PC-6001mkII in [NEC PC-6001mkII 取扱説明書][pc6001]
is the same except:

    1   CMT1    out   Cassette control signal 1
    3   CMT2    out   Cassette control signal 2

PC-8801 pins 1 and 3 are `VCC` and `/ INT5`.

#### Printer

PC-8001 is standard centronics-style on 2×17P edge connector.
`←` indicates input from printer.
([PC-8001 Manual][vcf 1375656], [Enri's PC-8001][EnrPc].)

                  pin │ pin
              ────────┼────────
             /STB   1 │ 2   GND
              PD0   3 │ 4   GND
              PD1   5 │ 6   GND
              PD2   7 │ 8   GND
              PD3   9 │ 10  GND
              PD4  11 │ 12  GND
              PD5  13 │ 14  GND
              PD6  15 │ 16  GND
              PD7  17 │ 18  GND
         ←   /ACK  19 │ 20  GND
         ← /READY  21 │ 22  GND
              N/C  23 │ 24  N/C
              N/C  25 │ 26  HIGH
              N/C  27 │ 28  N/C
             HIGH  29 │ 30  HIGH
              GND  31 │ 32  N/C
              N/C  33 │ 34  N/C

PC-8001mkII is a 14-pin mini-ribbon. ([Enri's PC-8001][EnrPc])

        P1: /PSTB
     P2-P9: PDB0 - PDB7
        10: N/C
        11: BUSY (/READY)
        12: N/C
        13: N/C
        14: GND

#### Serial / RS-232

On the original PC-8001 there's an on-board 8251 USART that's apparently
used for both CMT and the terminal mode. There is no external connector;
you need a PC-8062 cable to bring out the internal connector and do level
conversion from TTL to RS-232. [[sb8001]]. The PC-8062 cable has a DIP-16N
ribbon cable connector at one end (connection pictured in the PC-8001B
manual) for the DIP socket below; a picture of the full device
(unconnected) is in the PC-8801mkII manual [ターミナルモード][um01ii c9]
chapter.

There's also the PC-8062-1 "terminal firmware"; not clear how this is
different from the standard ROM BASIC `TERM` command.

The internal connector is TTL [[sb8001] with the following pinout. (`i`/`o`
indicates input to/output from the computer. ([PC-8001 Manual][vcf 1375656],
[[EnrPc]]):

    1:   GND     16:   GND
    2:o /TxD     15:o  VBB -12V
    3:i /RxD     14:   GND
    4:o  RTS     13:o  VDD +12V
    5:i  CTS     12:   GND
    6:i  DSR     11:o  VCC +5V
    7:i  CD      10:   GND
    8:o  DTR      9:   GND

There is an internal jumper block for baud rate [[hb68]] p.91:

                                         ×16     ×64
             CN8                1-2     4800    1200
       ┌─────────────┐          1-3     2400     600
     1 │ ○ ○ ○ ○ ○ ○ │ 6        1-4     1200     300
       └─────────────┘          1-5      600     150
                                1-6      300      75

Mods exist to allow programmatic setting of the jumpers.

__PC-8001mkII__

The PC-8001mkII has the PC-8062 built in and brought to a DB-25F on the
back. The bps rate jumper block is also now an external 2×8 .1" header on
the back; jumper the top and bottom pins of _one_ column to set the rate.

    │········│             ×16/×64 UART divisor
    │········│  8:9600/2400    6:2400/600   4:600/150   2:150/-
     87654321   7:4800/1200    5:1200/300   3:300/75    1:75/-

#### Floppy Disk

- [Hardware interface and commands](floppyif.md).
- [Disk data format](floppy.md).

#### Expansion Connector and Cards

The expansion connector is a 50-pin edge connector. ([PC-8001
Manual][vcf 1375656], [[EnrPc]]) The [PC-8001_SD] project has schematics
and a board layout that supports either a 50-pin header (for use with a
cable) or a 50-conductor female edge connector (to plug in directly) in the
same position. The data bus signals are bidirectional, all others are
outputs except where marked.

                  pin │ pin
              ────────┼────────
          +5V Vcc   1 │ 2   +12V
              DB0   3 │ 4   -12V
              DB1   5 │ 6   R̅O̅M̅D̅I̅S̅0̅ (input)
              DB2   7 │ 8   R̅O̅M̅D̅I̅S̅1̅ (input)
              DB3   9 │ 10  R̅O̅M̅D̅I̅S̅2̅ (input)
              DB4  11 │ 12  R̅O̅M̅D̅I̅S̅3 (input)
              DB5  13 │ 14  I̅N̅T̅     (input)
              DB6  15 │ 16  N̅M̅I̅     (input)
              DB7  17 │ 18  E̅X̅T̅O̅N̅   (input)
              AB0  19 │ 20  AB8
              AB1  21 │ 22  AB9
              AB2  23 │ 24  AB10
              AB3  25 │ 26  AB11
              AB4  27 │ 28  AB12
              AB5  29 │ 30  AB13
              AB6  31 │ 32  AB14
              AB7  33 │ 34  AB15
               R̅D̅  35 │ 36  R̅E̅S̅E̅T̅
               W̅R̅  37 │ 38  W̅A̅I̅T̅    (input)
             M̅R̅E̅Q̅  39 │ 40  W̅E̅
             I̅O̅R̅Q̅  41 │ 42  M̅U̅X̅
             R̅F̅S̅H̅  43 │ 44  R̅A̅S̅0̅
               M̅1̅  45 │ 46  R̅A̅S̅1̅
           SCLOCK  47 │ 48  GND
                ϕ  49 │ 50  GND

The card pinout is documented at [【コネクタ】 PC-8001,PC-8801シリーズ
拡張スロット][er519]. It varies slightly between the PC-8012 expansion
unit, PC-8001mkII and PC-8801. That page refs a 1984-10 I/O magazine
article, [「マイクロプロセッサを比較する10：BUSについて３」][IO8410p238],
that covers the expansion buses for all three systems.

See [PC-8001mk2 拡張ボード][er78] for an example of a homebrew
expansion card on protoboard adding a parallel port, ROM writer and FM
sound generator.

                 solder │ component side
              all   pin │ pin  all    8012   8801        8001mkII
              ──────────┼─────────────────────────────────────────
              GND    A1 │ B1   GND
              GND    A2 │ B2   GND
              +5V    A3 │ B3   +5V
              +5V    A4 │ B4   +5V
              AB0    A5 │ B5   I̅N̅T̅0          N.C.
              AB1    A6 │ B6   I̅N̅T̅1          N.C.
              AB2    A7 │ B7   I̅N̅T̅2          M̅W̅A̅IT̅̅
              AB3    A8 │ B8   I̅N̅T̅3          I̅N̅T̅4
              AB4    A9 │ B9   I̅N̅T̅4          I̅N̅T̅3
              AB5   A10 │ B10         I̅N̅T̅5   INT2        M̅W̅A̅I̅T̅
              AB6   A11 │ B11         I̅N̅T̅6   F̅D̅I̅N̅T̅1      F̅D̅I̅N̅T̅1
              AB7   A12 │ B12         I̅N̅T̅7   F̅D̅I̅N̅T̅2      F̅D̅I̅N̅T̅2
              AB8   A13 │ B13  DB0
              AB9   A14 │ B14  DB1
              AB10  A15 │ B15  DB2
              AB11  A16 │ B16  DB3
              AB12  A17 │ B17  DB4
              AB13  A18 │ B18  DB5
              AB14  A19 │ B19  DB6
              AB15  A20 │ B20  DB7
                R̅D̅  A21 │ B21  M̅E̅M̅R̅
                W̅R̅  A22 │ B22         I̅O̅W̅R̅   POWER       POWER
              M̅R̅E̅Q̅  A23 │ B23  I̅O̅W̅
              I̅O̅R̅Q̅  A24 │ B24  I̅O̅R̅
                M̅1̅  A25 │ B25         N.C.   M̅E̅M̅W̅        M̅E̅M̅W̅
              R̅A̅S̅0̅  A26 │ B26         N.C.   D̅M̅A̅T̅C̅       D̅M̅A̅T̅C̅
              R̅A̅S̅1̅  A27 │ B27         N.C.   F̅D̅R̅D̅Y̅       F̅D̅R̅D̅Y̅
              R̅F̅S̅H̅  A28 │ B28         N.C.   D̅R̅Q̅1̅/D̅R̅Q̅2̅   D̅R̅Q̅1̅/D̅R̅Q̅2̅
               M̅U̅X̅  A29 │ B29         N.C.   D̅A̅C̅K̅1̅/D̅A̅C̅K̅2̅ D̅A̅C̅K̅1̅/D̅A̅C̅K̅2̅
                W̅E̅  A30 │ B30         N.C.   4CLK        4CLK
           R̅O̅M̅K̅I̅L̅L̅  A31 │ B31  N̅M̅I̅
             R̅E̅S̅E̅T̅  A32 │ B32  W̅A̅I̅T̅
            SCLOCK  A33 │ B33  +12V
                 Φ  A34 │ B34  -12V
                V1  A35 │ B35  V1
                V2  A36 │ B36  V2


<!-------------------------------------------------------------------->
<!-- duplicated from README.md -->
[vcf 1375656]: https://forum.vcfed.org/index.php?threads/searching-for-nec-pc-8001a-software-hardware.36037/post-1375656

<!-- Switches and Jumpers -->
[m2um.38]: https://archive.org/details/PC8001mk-II-users-manual/page/n37/mode/1up

<!-- Connector Pinouts -->
[IO8410p238]: https://archive.org/details/Io198410/page/n238/mode/1up?view=theater
[PC-8001_SD]: https://github.com/yanataka60/PC-8001_SD
[def_int]: https://web.archive.org/web/20191127114212/blogs.yahoo.co.jp/def_int/34113679.html
[er519]: https://electrelic.com/electrelic/node/519
[er78]: https://electrelic.com/electrelic/node/78
[hkjunk0]: https://hkjunk0.com/computer/hardware-and-maintenance/pc8001-rgb-output.html
[kenko858]: http://kenko858.blog.fc2.com/blog-entry-4.html
[ls-pc88cv]: https://www.leadedsolder.com/2018/09/24/pc88-colour-video.html
[nr-drgb]: http://tulip-house.ddo.jp/DIGITAL/DIGITAL_RGB_COMPONENT/
[oh-d8]: https://www14.big.or.jp/~nijiyume/hard/jyoho/connect/d8.htm
[pc6001]: https://archive.org/details/PC6001mkII
[sb-rgb11]: http://sbeach.seesaa.net/article/450572908.html
[sb-rgb13]: http://sbeach.seesaa.net/article/450981469.html
[we-pc8000]: https://en.wikipedia.org/wiki/PC-8000_series
[wj-pc8000]: https://ja.wikipedia.org/wiki/PC-8000シリーズ
[x1/rgb21]: http://www.retropc.net/mm/x1/rgb21/index.html
