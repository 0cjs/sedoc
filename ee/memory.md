ROM and RAM Pinouts, Data
=========================

Terminology:
- PROM: (Field-)programmable once only.
- UV EPROM, EE EPROM: Erasable only as a whole (electrically or via UV).
- EEPROM: Always byte-erasable.

References:
- JEDEC (I think) pinouts, from Ciarcia, "Build an Intelligent Serial
  EPROM Programmer," _BYTE_ Oct. 1986, [p.106][byte-8610-106].
- [JDEC Standard No. 21-C §3.7.5][JDEC-3.7.5] has standard pinouts for
  byte-wide and TTL MOS SRAM.
- A [search for "memory dip" on the JDEC site][JDEC-memory-dip] gives
  standards and pinouts for various kinds of memory chips.
- MESS [Dump 2364 Mask ROMs][mess2364] gives 2364/2764 pinouts and adapter.
- 64Copy [ROM & EPROM Pinouts][64copy]: nice individual pinout diagrams of
  2316/32/64, 2716/32/64/128/256/512/010

JEDEC RAM and ROM pinouts are very similar but not quite identical. The
chart below marks with `●` the RAM pins standardised differently from the
ROM pins.
- Plain suffixes are for 23nnn PROMs and 27nnn EPROMS.
  - 23nn replaces `Vpp` with CS (2316 has act.hi `CE` on 18)
- 61nn and 62nnn are JEDEC SRAM standard.
- 28nnn are 5V-programmable EEPROM using JEDEC RAM pinouts.
- See also the [maskrom-pinouts](sch/maskrom-pinouts.png) diagram.

Standard Part Numbers:
- 23xx: PROM (16=2K, 32=4K, 64=8K)
- 27xx: PROM (16=2K, 32=4K, 64=8K)
- 28Cxx: EEPROM
- 6116: RAM 2K
- 6264: RAM 8K


#### 28-pin Device Pin Diagram

         ¶  Pin addt'ly uses high-V for prog/erase/ID area or similar
       RBN  RDY/B̅U̅S̅Y̅ or NC

          2K  4K  8K  2K──2K  4K  8K───────8K  16K  32K───────32K  64K
    ────────────────────────────────────────────────────────────────────────
          23──────23  61  27──────27  62  28C────────────28C   62   27
          16  32  64  16  16  32  64  64   64  128  256  256  256  512
    ┌──∪                                                               ┌───∪
    │1                           Vpp  NC  RBN● Vpp  Vpp  A14● A14● A15 │1
    │2                           A12 ───────────────────────────── A12 │2
    │3    A7 ─────────────────────────────────────────────────────  A7 │3
    │4    A6 ─────────────────────────────────────────────────────  A6 │4
    │5    A5 ─────────────────────────────────────────────────────  A5 │5
    │6    A4 ─────────────────────────────────────────────────────  A4 │6
    │7    A3 ─────────────────────────────────────────────────────  A3 │7
    │8    A2 ─────────────────────────────────────────────────────  A2 │8
    │9    A1 ─────────────────────────────────────────────────────  A1 │9
    │10   A0 ─────────────────────────────────────────────────────  A0 │10
    │11   D0 ─────────────────────────────────────────────────────  D0 │11
    │12   D1 ─────────────────────────────────────────────────────  D1 │12
    │13   D2 ─────────────────────────────────────────────────────  D2 │13
    │14  GND ───────────────────────────────────────────────────── GND │14
    └───                                                               └────
          16  32  64  16  16  32  64  64   64  128  256  256  256  512
          23──────23  61  27──────27  62   28C───────────28C   62   27
          16  32  64  16  16  32  64  64   64  128  256  256  256  512
    ∪──┐                                                               ∪──┐
     28│                         Vcc  ──────────────────────────── Vcc  28│
     27│                         P̅G̅M̅  W̅E̅   W̅E̅  P̅G̅M̅  A14   W̅E̅●  W̅E̅● A14  27│
     26│ Vcc ──────────────────┤  NC C̅E̅2̅   NC  A13 ─────────────── A13  26│
     25│  A8 ─────────────────────────────────────────────────────  A8  25│
     24│  A9 ────────────────────────────── ¶ ──────────── ¶  ────  A9  24│
     23│ C̅S̅3̅ ──┤ A12  W̅E̅ Vpp A11 ───────────────────────────────── A11  23│
     22│ C̅S̅1̅ ───────┤ O̅E̅ ────────────────── ¶ ──────────── ¶  ────  O̅E̅  22│
     21│ A10 ───────────────────────────────────────────────────── A10  21│
     20│ C̅S̅2̅ A11 ───┤ C̅E̅ ─────────────────────────────────────────  C̅E̅  20│
     19│  D7 ─────────────────────────────────────────────────────  D7  19│
     18│  D6 ─────────────────────────────────────────────────────  D6  18│
     17│  D5 ─────────────────────────────────────────────────────  D5  17│
     16│  D4 ─────────────────────────────────────────────────────  D4  16│
     15│  D3 ─────────────────────────────────────────────────────  D3  15│
    ───┘                                                               ───┘
          16  32  64  16  16  32  64  64   64  128  256  256  256  512
          23──────23  61  27──────27  62  28C────────────28C   62   27
    ──────────────────────────────────────────────────────────────────────
          2K  4K  8K  2K   2K   4K   8K   8K  16K  32K        32K  64K

#### JEDEC Common Pin Diagram:

                        ┌─────────∪─────────┐
                ────────│1                32│──────── (Vcc)
          (A16) ────────│2                31│──────── (A15)
     (A14, Vpp) ────────│3  1          28 30│──────── (Vcc, CS2)
          (A12) ────────│4  2          27 29│──────── (P̅G̅M̅, W̅E̅, A14)
                   A7 ━━│5  3  1    24 26 28│──────── (Vcc, A13)
                   A6 ━━│6  4  2    23 25 27│━━ A8
                   A5 ━━│7  5  3    22 24 26│━━ A9
                   A4 ━━│8  6  4    21 23 25│──────── (C̅S̅, W̅E̅,  A11, Vpp, A12)
                   A3 ━━│9  7  5    20 22 24│━━ O̅E̅¶ ─ (C̅S̅)
                   A2 ━━│10 8  6    19 21 23│━━ A10 ─ (CS)
                   A1 ━━│11 9  7    18 20 22│━━ C̅E̅ ── (CE, A11)
                   A0 ━━│12 10 8    17 19 21│━━ D7
                   D0 ━━│13 11 9    16 18 20│━━ D6
                   D1 ━━│14 12 10   15 17 19│━━ D5
                   D2 ━━│15 13 11   14 16 18│━━ D4
                  GND ━━│16 14 12   13 15 17│━━ D3
                        └───────────────────┘
                   JEDEC Common Pin Diagram by cjs
        https://github.com/0cjs/sedoc/blob/master/ee/memory.md

Chip Data
---------

_DIPnn_ is 0.3" wide dual-inline package, _nn_ pins;
_WDIPnn_ is = 0.6" wide.

### EPROM/EEPROM

Winbond [W27C512-45Z] 64K×8 (45 ns., Z=lead free)
- TTL and CMOS compatible
- Packaging: WDIP28, .33" 32-pin PLCC
- 28 Pins: 14=Vss, 28=Vcc, 20=/CE, 22=/OE,Vpp
  -   D0-7: 11 12 13 .. 15 16 17 18 19  ("Q" pins in datasheet)
  -  A0-A7: 10 9 8 7 .. 6 5 4 3
  - A8-A15: 25 24 21 23 .. 2 26 27 1
- Erase/program:
  - For Vcc=5V, /CE pulse 100 ms. (95 min 105 max)
  - Erase (to all-ones): Vpp=14V, A9=14V, A=low, D=high; /CE to erase.
  - Program: Vpp=12V, A=address, D=data; /CE write.
  - Erase verify, program verify: ??? Vpp=14V,12V, VCC=3.75V, /OE=lowV
  - See data sheet waveforms, flowcharts for details.
- Pricing: ¥80~¥120 on aliexpress.com

Microchip [27C256]

Catalyst Semiconductor [CAT28F512]; 12 V programming/erase

Atmel Parallel EEPROM [AT28C256] 32K×8, [AT28C64] 8K×8, [AT28C16A] 2K×8 \(24p)
- TTL and CMOS compatible; speeds -12, -15, -20, -25
- No writes for 5 ms after Vcc reaches 3.8V.
- Erase:
  - '64: `C̅E̅` low, `O̅E̅¶` 12V, 10 ms low pulse on `W̅E̅`.
  - '256: 6-byte software code.
- Write: no special voltages; completion poll /DATA (takes 1 ms)
  - /DATA poll: D7 returns complement of data during write
  - Open-drain READY,/BUSY pulled low during write cycle
  - AT28C64E has 200 μsec write
- Device identification memory: 32 bytes, $1FE0-$1FFFF. Raise `A9¶`
  to 12V ±0.5V to read/write in the same way as regular memory.
- Software data protection (SDP): enable/disable with special 3-byte
  command sequence. Write timers still active when SDP enabled, but the
  data is not actually written.

### SRAM

Hitachi [HM62256A] series 32K×8 high-speed CMOS
- TTL compatible.
- Speed: -8 (85 ns), -10, -12, -15
- L/L-SL indicates low-power (5 μW standby, 40 mW @ 1 MHz)
- Packaging: P→WDIP28, SP→DIP28, FP=.45" SOP, T=TSOP
- 28 Pins: 14=Vss, 28=Vcc, 20=/CS, 27=/WE, 22=/OE
  -   D0-7: 11 12 13 .. 15 16 17 18 19  ("I/O" pins in datasheet)
  -  A0-A7: 10 9 8 7 .. 6 5 4 3
  - A8-A14: 25 24 21 23 .. 2 26 1
- Function table (/CS=L where not specified):
  - /CS=H: standby, low power (all other inputs ignored)
  - /WE=H /OE=H: output disabled
  - /WE=H /OE=L: D out, read cycle (diag. 1-3, dep. on signal order)
  - /WE=L /OE=H: D in, write cycle (diag. 1, /OE clock, /CS before /WE)
  - /WE=L /OE=L: D in, write cycle (diag. 2, /OE low fixed)

Renesas [IDT6116SA/LA] 2K×8 CMOS Static RAM
- LA is low power version for 2V battery backup

SRAM can be battery-backed when the system power is off; see [this EDN
article](sch/simpleCMOS_RAMbackup.jpg) (from [this message][f65 32004]) for
CMOS switch and single-transistor designs. [Robert Sprowson's EPROM
Emulator][ee sprow] design also has much useful information.

### FRAM

Reading as well as writing wears out cells; keep an eye on endurance and
consider moving tight frequent loops (e.g., wait for character input) to
traditional RAM. (On 6502, below stack can work well.)
-         2003-03 rev 2.3: 10^10 read/writes (Windfall [[f65 6380]])
- FM1608  2007-05 rev 3.2: 10^12 read/writes (datasheet)
- FM1808  2007-08 rev 3.3: 10^12 read/writes (datasheet)
- FM18L08 2007-07 rev 3.4: unlimited read/write cycles

Ramtron FM1608 (8K×8), [FM1808][] (32K×8) Nonvolatile RAM
- Critical point: "Asserting /CE low causes the address to be latched
  internally. Address changes that occur after /CE goes low will be ignored
  until the next falling edge occurs." Thus for 6502 `C̅E̅` should be
  qualified with φ2. See [forum.6502.org thread][f65 6380] for more.

### DRAM

References:
- pcbjunkie.net [RAM Info and Cross Reference Page][pcbj-ram]
  (Includes many static RAM pinouts as well. Another page has
  a few [PROM/EPROM pinouts][pcbj-rom].)

Standard pinouts:

    4116 │ 4164         4164 │ 4116 │ MK4096
         │      ┌──∪──┐      │      │
     -5V │   NC │1  16│ GND  │      │
         │    D │2  15│ C̅A̅S̅  │      │
         │    W̅ │3  14│ Q    │      │
         │  R̅A̅S̅ │4  13│ A₆   │      │ C̅S̅
         │   A₀ │5  12│ A₃   │      │
         │   A₁ │6  11│ A₄   │      │
         │   A₂ │7  10│ A₅   │      │
    +12V │  +5V │8   9│ A₇   │ +5V  │
         │      └─────┘      │      │

    Vss = GND    Vcc = +5V   Vbb = -5V   Vdd = +12V


<!-------------------------------------------------------------------->
[64copy]: https://ist.uwaterloo.ca/~schepers/roms.html
[JDEC-3.7.5]: https://www.jedec.org/system/files/docs/3_07_05R12.pdf
[JDEC-memory-dip]: https://www.jedec.org/document_search/field_committees/25?search_api_views_fulltext=memory+dip
[byte-8610-106]: https://archive.org/details/byte-magazine-1986-10/page/n117/mode/1up
[mess2364]: http://mess.redump.net/dumping/2364_mask_roms

[27C256]: http://esd.cs.ucr.edu/webres/27c256.pdf
[AT28C16A]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0001h.pdf
[AT28C256]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf
[AT28C64]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0001h.pdf
[CAT28F512]: https://datasheet.octopart.com/CAT28F512PI-90-Catalyst-Semiconductor-datasheet-1983.pdf
[FM1808]: https://docs.isy.liu.se/pub/VanHeden/DataSheets/fm1808.pdf
[HM62256A]: https://datasheet.octopart.com/HM62256ALP-10-Hitachi-datasheet-115281844.pdf
[IDT6116SA/LA]: https://www.renesas.com/jp/en/document/dst/6116sala-data-sheet
[W27C512-45Z a]: http://www.kosmodrom.com.ua/pdf/W27C512-45Z.pdf
[W27C512-45Z]: https://datasheet.octopart.com/W27C512-45Z-Winbond-datasheet-13695031.pdf

[ee sprow]: http://www.acornelectron.co.uk/eug/25/a-epro.html
[f65 32004]: http://forum.6502.org/viewtopic.php?p=32004#p32004
[f65 6380]: http://forum.6502.org/viewtopic.php?f=4&t=6380

[pcbj-ram]: http://pcbjunkie.net/index.php/resources/ram-info-and-cross-reference-page/
[pcbj-rom]: http://pcbjunkie.net/index.php/resources/prom-eprom-info-page/
