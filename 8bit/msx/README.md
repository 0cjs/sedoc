MSX
===

References:
- [Wikipedia (en)][wp-en]
- [Wikipedia (ja)][wp-ja]
- [msx.org wiki][mw] (MSX Resource Center)

Technical books:
- \[td1] [_MSX Technical Data Book_][td1] (en), Sony, 1984.
  MSX1 hardwre and software.
- \[yts] Yamaha Computer [_MSX Series Technical Summary_][yts] (en)
  (GB, for series AX-100, YIS-503F, CX-5M)
- \[tdR] [_MSX turbo Rテクニカル・ハンドブック_][tdR] (ja)
- \[mdp] [_MSX-Datapack_][mdp] (ja), 株式会社アスキー. MSX2+, MSX2, some MSX1.
  Wiki copy of a large, detailed reference published by ASCII.
  Possibly the best reference available; includes many peripherals.
- \[2thj] [MSX2テクニカル・ハンドブック][2thj] (ja), アスキー版局, 1986.
- \[2the] [_MSX2 Technical Handbook_][2the] (en). Trans. of above. Markdown.
- \[rbr] [_The Revised MSX Red Book_] (en), Avalon Software, 1985.
  Based on [[mdp]], [[2thj]], MSX Magazine.
  This version revised by by Cyberknight Masao Kawata 1998-2005.

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

Two types defined:
- __Type A:__ One button or indistinguishable buttons.
  All joysticks must be marked; software need not be.
- __Type B:__ Two independent trigger buttons.
  All joysticks must be marked; software requiring Type B must be marked.

Two DE-9F connectors, J3 (port 1) and optional J4 (port 2):
- TTL levels. Pinout [[td1 p.25]] and [`conn/joystick`](../conn/joystick.md).
- Schematics: [[td1 p.26]] switches only, [[td1 p.28]] paddle circuit.
- All pins have pullups to Vcc (typically 10 kΩ) except +5 (5) and GND (9).
  This is in addition to the (unspecified) on-chip pull-ups.
- AY-3-8910 PSG IOA 0-5 and IOB 0-6 used for interface.
  - Ports are either all pins input or all pins output; they cannot be split.
    - IOA is set to input and has nothing connected usable for ouput.
    - IOB is set to output and must be to avoid floating select input on
      the '157s. (Thus, pins 1/8 and 2/8, though wired to be input capable,
      can not be used for input without making IOA0-5 unusable.)
  - IOB6 switches 1.5× 74LS157 routing pins 1-4,6,7 to IOA0-5 from ports 1/2
  - IOB4/5 independent to pin 8 ports 1/2 w/pullup. (Spec says output-only,
    but from schematic could also be used as input.)
  - IOB0,1,2,3 → P1/6,7,P2/6,7 through 7407 non-inverting open-collector buffer
- Note pin 9=GND is different from Atari Joystick 8=GND, but outputs to pin
  8 (B4,B5) are normally low (except when querying paddles) so an Atari
  joystick can work.

Ports and pinout key:
- `Reg`=PSG register address to write to $A0. Write output at $A1;
  read input or output at A2. See also [`sound`](sound.md).
- `IO`=PSG I/O port and bit [[td1 p.44]].
- `pin`=connector pin; `s/#`=input switched by '157 (`B6`).
- `P`=pullup via resistor. `dir`=`i`:input,`o`:output.

Ports and pinout table:

    Reg IO pin P dir Description
    ──────────────────────────────────────────────────────────────────────────
             5        +5 VDC max 50 mA (per port)
             9        GND; short inputs to this to assert them
    ──────────────────────────────────────────────────────────────────────────
    R14 A0 s/1 *  i   fwd
        A1 s/2 *  i   back
        A2 s/3 *  i   left
        A3 s/4 *  i   right
        A4 s/6 *  i   TRG 1: only button on Type A joystick
        A5 s/7 *  i   TRG 2: 2nd button Type B joystick
        A6        i   Key layout select: 1=JIS 0=syllable
        A7        i   CSAR (CMT read)
    ──────────────────────────────────────────────────────────────────────────
    R15 B0 1/6 *   o  ouput drive for port 1 TRG 1 (set high when using input)
        B1 1/7 *   o    "     "    "  port 1 TRG 2   "   "    "     "     "
        B2 2/6 *   o    "     "    "  port 2 TRG 1   "   "    "     "     "
        B3 1/7 *   o    "     "    "  port 2 TRG 2   "   "    "     "     "
        B4 1/8     o  paddle query port 1 (hold low to use Atari joystick)
        B5 2/8 *   o  paddle query port 2 (hold low to use Atari joystick)
        B6         o  To S (A̅/B) on '157s. 0/1=port 1/2 select for pins 1-4,6,7
        B7         o  KLAMP (kana lamp) 0=on 1=off
    ──────────────────────────────────────────────────────────────────────────

Joystick schematic [[td1 p.27]] is NO switches on pins 1-4,6,7 common to 8.

Paddles [[td1 p.28]]:
- Calling `PDL` function sends query trigger pulse to pin 8 of a port
  (IOB4=port 1, IOB5=port 2). Not explictly stated, but pulse must be
  negative since there's a pull-up on the line and the paddle schematic
  shows an inverter on pulse input.
- Paddle responds with 10 μs to 3000 μs pulse (from start of trigger pulse)
  indicating position.
- Each paddle uses a [LS123][SN74LS122] or eqiv. monostable multivibrator:
  - Pin 8 → inverting buffer → `1A`: pulse input to query position
  - GND → `1B`, `1C̅L̅R̅`.
  - `1Q`: to pin 1 for paddle 1 (or 2-4,6,7 for other paddles).
  - 0.04 μF cap between `Cext` and `Rext/Cext`.
  - 150 KΩ potentiometer from Vcc to `Rext`.
- Also see [`8bit/conn/joystick`](../conn/joystick.md).

[JoyNet] is a standard for ring networks via joystick ports. The MSX end is
a DE-9M plug and the other end is a "send" DIN-5M and "recv" DIN-5F to
insert into the ring.
- Receive from up-ring: Read pins 1,2 as D0,D1, write acks on pin 8.
- Send to down-ring:    Write pins 6,7 as D0,D1, read acks on pin 3.
- Connecting just two gives you Konami's F1-Spirit 3D Special cable.

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



<!-------------------------------------------------------------------->

<!-- References -->
[mw]: https://msx.org/wiki
[wp-en]: https://en.wikipedia.org/wiki/MSX
[wp-ja]: https://ja.wikipedia.org/wiki/Msx

<!-- Technical books -->
[2the]: https://github.com/Konamiman/MSX2-Technical-Handbook/
[2thj]: https://archive.org/details/MSX2TechnicalHandBookFE1986/
[rbr]: https://www.angelfire.com/art2/unicorndreams/msx/RR-Intro.html
[td1]: https://archive.org/stream/MSXTechnicalHandbookBySony#page/n5/mode/1up
[tdR]: https://archive.org/details/MsxTurboR
[yts]: https://archive.org/details/yamahacx5myis503ts/mode/1up

<!-- body -->
[SN74LS122]: http://www.ti.com/lit/gpn/sn74ls122
[joynet]: https://map.grauw.nl/resources/joynet/
[mw cart]: https://www.msx.org/wiki/MSX_Cartridge_slot
