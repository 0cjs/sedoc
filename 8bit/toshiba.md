Toshiba Pasopia
===============

All have:
- Z80A @ 4 MHz. 64K RAM.
- Joystick ports.

Models:
- PA7010, PA7012: __Pasopia__ (1981)
  - 64K RAM, 16K VRAM
  - Graphics: 160×100/8, 640×200/2
  - PA7010: T-BASIC (MS-BASIC). PA7012: OA-BASIC.
- PA7010U: __T100__
  - NA version. Improved keyboard layout, RS-232 added. T-BASIC 1.1.
  - Back panel (_very_ different from Japanese models):
    - RESET (pushbutton). VOLUME (recessed trim pot). CASSETTE (DIN-8F).
      COLOR (DIN-8F). LCD (MiniDIN-8F). B/W (RCA). EXT.BUS (DD-50F). PRINTER
      (DB-25M). ??? (recessed jumper?). RS-232C (DB-25F). AC IN.
- PA7007: __Pasopia 7__ (1983)
  - T-BASIC7.  48K VRAM, 2× [SN76489] sound chips.
  - Hardware dithering for 27 colors (each pixel 1 of 8 colors).
  - Partly compatible w/PA???
- __Pasopia 700__ (1985)
  - Based on PA7007. Two FDDs, separate keyboard, 2 cart slots.
- PA7005: __Pasopia 5__ (1985)
  - Low-cost version of PA7010.

The __Pasopia IQ__ series were MSX machines, incompatible with the above.
Three series: HX-10, HX-20, HX30, each with multiple models for different
features and different countries. MSX2 machines: HX-23, -23F, -33, -34 and
FMS-TM1.

PC-compatibles:
- PA7020: __Pasopia 16__ (1982)
   - 6 MHz 8088-2, 192-256 KB.
   - _Color Graphic Card_ better than CGA; _Extended Graphic Card_ had 256K
     VRAM, 640×500/400/200 and 320×200, 16 of 256 colors.
  - US: T300, EU: PAP
- PA7030: __Pasopia 1600__ (1984)
  - 8 Mhz, 384K VRAM, mouse.
  - TS100/300 variant w/'286.


### References
- [Toshiba T100 Computer and Floppy Drive Owners Manual and Programmers
  Reference Manual][t100-own-progref], Toshiba America, 1982.
- [Toshiba T100 Owners Manual][t100-own-aus], Toshiba Australia, 1982.
- [Toshiba T100 Technical Reference Manual (English)][t100-techref].
  Photocopy of handwritten document.
- [Toshiba T100 (Pasopia) Maintenance Manual][t100-maint], Toshiba America,
  1983.
- [Toshiba 8-bit system IC reference][tosh8]. ROM, DRAM, CPU, PIA, USART
  etc. IC desginations.
-  Vogons.org thread, [Toshiba T-100 - the US counterpart to the Japanese
   Pasopia][vog95487]. Includes pics of the T-100 and links to various
   references.


Peripherals
-----------

PASOPIA周辺機器 (Peripheral equipment) list from the web.
Sources: マイコン1983-1, I/O 1982.12, I/O 1982.3　広告より (adverts).

    PA7150 グリーンディスプレイ                     ¥ 45,000
    PA7160  カラーディスプレイ                      ¥ 79,000
    PA7161 ファインカラーディスプレイ               ¥168,000
    PA7170 液晶ディスプレイ                         ¥ 40,000
    PA7200 ミニフロッピーディスクユニット 280kb x2  ¥290,000
    PA7201 増設フロッピーディスクユニット280kb x2   ¥266,000
    PA7202 片面ミニフロッピーディスクユニット       ¥ 79,000
    PA7210 8インチフロッピーディスクユニット        ¥375,000
    PA7240 4Kバイト RAM PAC2                        ¥ 14,000
    PA7242 16Kバイト RAM PAC2                       ¥ 28,000
    PA7244 32Kバイト RAM PAC2 未定
    PA7246 漢字 ROM PAC2                            ¥ 40,000
    PA7250 ドットプリンタI                          ¥ 69,000
    PA7251 ドットプリンタII                         ¥153,000
    PA7300 拡張ユニット                             ¥ 78,000
    PA7370 カラーTVアダプタ                         ¥ 13,000
    PA7419 ユニバーサルカード                       ¥  4,800
    PA7426 RS-232Cケーブル
    PA7500 CP/M                                     ¥ 34,000
    PA7504 ジェネラルプログラムローダー             ¥  5,000
    PA7520 T-BASIC(ROM PAC1)                        ¥ 33,000
    PA7521 T-DISK BASIC                             ¥ 18,000
    PA7522 OA-BASIC(ROM PAC1)                       ¥ 33,000
    PA7523 OA-DISK BASIC                            ¥ 18,000
    PA7540 MINI-PASCAL(ROM PAC1)                    ¥ 33,000

Peripheral details:
- __PA7370__ DIN-8 DRGB to RF (no CVBS output). Powered from DIN-8.
  Color/BW switch.
- __PA7373__ DIN-8 DRGB to CVBS and RF. Powered from DIN-8.


BASIC
-----

Error messages:

    DN  ファイル装置の指定が誤っている。
        システムに つながっていない装置を指定した。
        "Number"? Possibly when controller not present.

    DO  指定した装置がつながっていない。
        "Offline"? Seems to be when controller present, media not.



<!-------------------------------------------------------------------->
[SN76489]: https://en.wikipedia.org/wiki/Texas_Instruments_SN76489

[t100-maint]: https://archive.org/details/toshiba-t-100-maintenance-manual
[t100-own-progref]: https://archive.org/details/toshiba-t-100-manuals/Toshiba%20T100%20Owners%20Manual/
[t100-techref]: https://archive.org/details/toshiba-t-100-tech-ref-eng/
[tosh8]: https://datasheet.datasheetarchive.com/originals/distributors/Datasheets-X2/DSA12010006539.pdf
[vog95487]: https://www.vogons.org/viewtopic.php?f=46&t=95487
