MSX
===

### Contents

- Introduction
  - References
  - Technical Books
- Usage Notes
  - Startup
  - BASIC
- Standard Specifications
  - Keyboard
  - Joysticks
  - Parallel Printer Output (optional)
  - Cartridge Slot Pinout
- Optional Peripherals
  - RS-232
  - Floppy Disk
  - Audio/Music
- Modifications
  - Adding a Third Slot

### References

- [Wikipedia (en)][wp-en]
- [Wikipedia (ja)][wp-ja]
- [msx.org wiki][mw] (MSX Resource Center)

### Technical Books

- \[td1] [_MSX Technical Data Book_][td1] (en), Sony, 1984.
  MSX1 hardwre and software.
- \[yts] Yamaha Computer [_MSX Series Technical Summary_][yts] (en)
  (GB, for series AX-100, YIS-503F, CX-5M)
- \[tdR] [_MSX turbo Rテクニカル・ハンドブック_][tdR] (ja)
- \[mdp] [_MSX-Datapack_][mdp] (ja), 株式会社アスキー. MSX2+, MSX2, some MSX1.
  Large, detailed referenced published by ASCII.
  Possibly the best reference available; includes many peripherals.
  Wiki copy at above link, original scans:
  - [Volume 1][mdp-v1]: 1 Hardware. 2 System Software. 3 MSX-DOS.
    4 VDP (V9938 and V9958).
  - [Volume 2][mdp-v2]: 5 Slots and Cartridges. 6 Standard Peripherals.
    7 Optional Peripherals. Appendix BIOS, Work Area, etc.
- \[2thj-fe] [MSX2テクニカル・ハンドブック][2thj-fe], 1st ed. (ja),
  アスキー版局, 1986. Poor scan, poor OCR. 60 or 16 MB.
- \[2thj] [MSX2テクニカル・ハンドブック][2thj], 7th ed. (ja),
  アスキー版局, 1988. Better scan and OCR, though OCR still not perfect.
  200 MB. Not clear what the updates are.
- \[2the] [_MSX2 Technical Handbook_][2the] (en). Trans. of above. Markdown.
- \[rbr] [_The Revised MSX Red Book_] (en), Avalon Software, 1985.
  Based on [[mdp]], [[2thj-fe]], MSX Magazine.
  This version revised by by Cyberknight Masao Kawata 1998-2005.
- \[hanso] [`/Technical/Hans Otten/`][hanso] on file-hunter.com contains
  an enormous pile of technical information (thousands of files).


Usage Notes
-----------

### Startup

- Use STOP to pause/restart output, Ctrl-STOP to break.
- Holding down `Shift` during the post-reset initialization sequence will
  avoid loading DOS, generally leaving with you with about 5384 more bytes
  of memory available to BASIC (around 28K instead of 23K).
- Holding down `Ctrl` will enable only one drive and leave you with about
  1558 bytes of free memory available to BASIC (around 25K instead of 23K).

### BASIC

Handy screen-editor keys:
- `^B`/`^F`: cursor back/forward one word
- `^N` move to EOL
- `^E`: erase to EOL
- `^U` erase current line
- `^R` enter/exit insert mode (cursor movement also exits)

See msx.org wiki [MSX Characters and Control Codes][codes] for a full list
of the control codes, which seem to work the same on input as output where
that makes sense.


Standard Specifications
-----------------------

See [`models/README.md`](models/README.md) for specs for specific models.
Some do not have all standard specs (e.g., 8K RAM or no CMT port).

MSX systems include [td1 p.8]:
- Z80A-compatible CPU at 3.579545 Mhz (NTSC color subcarrier freq)
- 32K of system ROM with the BIOS and MSX-BASIC
- 16K min. of RAM; grows downward from $FFFF
- VDP (Video Display Processr): TI TMS-9918A compatible
- [PSG (Programmable Sound Generator)](sound.md):
  GI AY-3-8910 compatible 1.7897725 Mhz (1/2 CPU clock).
- PPI (Programmable Peripheral Interface) Intel i8255 compatible.
- 0 as "on-board" slot; 1 or more cartridge slots
- CMT: 1200 bps 1200/2400 Hz; 2400 bps 2400/4800 Hz.
  0 = 1 cycle low, 1 = 2 cycles high. Standard JP DIN-8. [td1 p.15]

### Keyboard

See [`keyboard.md`](./keyboard.md).

### Joysticks

- Two DE-9F connectors, J3 (port 1) and optional J4 (port 2).
- Two types, "Type A" single-button and "Type B" two-button, as well as
  paddle support. Type B can damage Atari systems.
- Mostly Atari-compatible; see details for caveats.
- See [`joystick.md`](./joystick.md) for details.

### Parallel Printer Output (optional)

[td1 p.19] Pins number 1-7 across top then 8-14 across bottom, from right
to left (??? confirm) looking into connector on computer.

        1 out  P̅S̅T̅B̅
      2-9 out  PDB0-PDB7
       10      n/c
       11 in   BUSY
    12-13      n/c
       14      GND

### Cartridge Slot Pinout

Lots more details, including timings and physical dimenions, at MSX Wiki
[MSX Cartridge Slot][mw cart].

When looking at cart from front:
- Alignment hole at lower left.
- Even pin numbers right to left on front side, odd on back side.
- Max power draw for all slots: +5 V 300 mA, ±12 V 50 mA (some have no ±12)
 - Suggested min 20 mA/slot to support existing sound, RS-232 carts

Pinout:

         ($8000-$BFFF)  /CS2   2 1   /CS1  ($4000-$7FFF)
         slot select  /SLTSL   4 3   /CS12 ($4000-$BFFF)
                       /RFSH   6 5   Reserved
                        /INT   8 7   /WAIT
                     /BUSDIR  10 9   /M1
                       /MERQ  12 11  /IORQ
                        /RD   14 13  /WR
                    Reserved  16 15  /RESET
                         A15  18 17  A9
                         A10  20 19  A11
                         A6   22 21  A7
                         A8   24 23  A12
                         A13  26 25  A14
                         A0   28 27  A1
                         A2   30 29  A3
                         A4   32 31  A4
                         D0   34 33  D1
                         D2   36 35  D3
                         D4   38 37  D5
                         D6   40 39  D7
         3.579545 MHz  CLOCK  42 41  GND
                         SW1  44 43  GND
                         SW2  46 45  +5V
                        +12V  48 47  +5V
                        -12V  50 49  SOUNDIN (-5 dBm @ 600Ω)

- `SOUNDIN` unconnected on Casio PV-7, General PCT-50, Hitachi MB-H1,
  Victor HC-30, Yamaha SX-100, all Korean machines.


Optional Peripherals
--------------------

### RS-232

[td1 p.20] i8251 USART, i8253 Programmable Interval Timer @1.8432 Mhz, 4K ROM.

    80 rw   8251 data port
    81 rw   8251 command/status port
    82 r    status sense for CTS, timer/counter 2, RI, CD
    82  w   interrupt mask register
    83      reserved for manufacturer use
    84 rw   8253 counter 0
    85 rw   8253 counter 1
    86 rw   8253 counter 2
    87  w   8253 mode register

Port $82 read. CTS is here because some 8251s have buggy CTS detection.

      7  CTS 0=asserted 1=negated
      6  i8253 Ch. 2
    5-2  reserved
      1  RI 0=asserted 1=negated (optional, must be present if CD present)
      0  CD 0=asserted 1=negated

Port $82 write: interrupt enables. All are 1=mask (initial value) and 0=enable.

    7-4  reserved
      3  i8253 timer 2 (optional)
      2  sync char/break detect (optional)
      1  Tx ready (optional)
      0  Rx ready

The 8253 input clock is 1.8432 Mhz. Timers 0, 1 and 2 are Rx clock, Tx
clock and free for applications, respectively. Divisors (x16) are 6=19200
bps, 12=9600, etc.

### Floppy Disk

[td1 p.18] Interface has 16K ROM at $4000-$7FFF with MSX-DOS kernel, MSX
DISK BASIC extensions and a "physical disk I/O driver" supplied by the
manufacturer. No particular FDC is required.

The format is MS-DOS compatible. Standard physical media include:
- 8": SD (128 bytes/sec) or DD (1024 bytes/sec) (really?)
- 5.25" 512 bytes/sec: 1D 180 KB; 2D 360 KB
- 3.5" 512 bytes/sec: 1DD 360 KB; 2DD 720 KB
- 3.5" HD used only in option for Daisen Sangyo MX-2021 (v.rare factory
  automation system)

Systems (1DD = single sided 360 KB; 2DD = double sided 720 KB; all 80 track)
- Toshiba HX-F100: 3.5" 1D, Disk BASIC v1
- Toshiba HX-F101 series: 3.5", Disk BASIC v1.1
  - HX-F101: 2DD, JP, Ivory
  - HX-F101AA: 1DD, Europe, Black
  - HX-F101PE: 1DD, Europe, Black
  - HX-F101GB: 2DD, UK, Black
- Toshiba HX-F103: 3.5" 2DD bare drive for HX-34

### Audio/Music

See [MSX Sound Chips (`sound.md`)](sound.md).


Modifications
-------------

### Adding a Third Slot

There are various setts of instruction for adding a third slot to MSX
computers.
- [Third slot for MSX computers][mod-slot3] contains instructions for
  adding a third slot to MSX systems with the S3537 engine, such as the
  VG8235/45, NMS8250/55/80 and presumably MPC-25FD and similar; this
  includes some helpful general information for all systems.
- [How to make a third slot for NMS 8250 with the unused connector
  MY][mod-vanson-2008] by Erik van Son, 2008-09.
- The [HansO documents][hanso] may contain something related to this.
- There may be a video on this somewhere in the [Repair-Bas (Bas
  Kornalijnslijper)][repair-bas] YouTube channel.

There's further discussion of all of these in the MSX.org forums, [Add to
NMS8250 third SLOT][mod-slot3-nms8250].



<!-------------------------------------------------------------------->

<!-- References -->
[mw]: https://msx.org/wiki
[wp-en]: https://en.wikipedia.org/wiki/MSX
[wp-ja]: https://ja.wikipedia.org/wiki/Msx

<!-- Technical books -->
[2the]: https://github.com/Konamiman/MSX2-Technical-Handbook/
[2thj-fe]: https://archive.org/details/MSX2TechnicalHandBookFE1986/
[2thj]: https://archive.org/details/Msx2TechnicalHandBook/
[hanso]: https://download.file-hunter.com/Technical/Hans%20Otten/
[mdp-v1]: https://archive.org/details/MSXDatapackVolume1
[mdp-v2]: https://archive.org/details/MSXDatapackVolume2
[mdp-v3]: https://archive.org/details/MSXDatapackVolume31991OCRTabajara
[mdp]: http://ngs.no.coocan.jp/doc/wiki.cgi/datapack
[rbr]: https://www.angelfire.com/art2/unicorndreams/msx/RR-Intro.html
[td1]: https://archive.org/stream/MSXTechnicalHandbookBySony#page/n5/mode/1up
[tdR]: https://archive.org/details/MsxTurboR
[yts]: https://archive.org/details/yamahacx5myis503ts/mode/1up

<!-- body -->
[SN74LS122]: http://www.ti.com/lit/gpn/sn74ls122
[joynet]: https://map.grauw.nl/resources/joynet/
[mw cart]: https://www.msx.org/wiki/MSX_Cartridge_slot

<!-- Modifications: Adding a Third Slot -->
[mod-slot3-nms8250]: https://msx.org/forum/msx-talk/hardware/add-nms8250-third-slot?page=0
[mod-slot3]: http://www.msxarchive.nl/pub/msx/mirrors/hanso/hwmodsetc/philipsnms82xxslot3.pdf
[mod-vanson-2008]: https://download.file-hunter.com/Technical/Hans%20Otten/3rdslotNMS8250.pdf
[repair-bas]: https://www.youtube.com/@repair-basbaskornalijnslij9245/videos
