NEC PC-8001 Series
==================

Contents:
- Product Line
  - Specifications
  - Peripherals and Software
- Documentation
- User Interface Notes

Product Line
------------

The Z80-based __PC-8001__ was one of the first non-kit micros introduced
into Japan, announced in 1979-05 and released in 1979-09, preceeded only by
the Hitachi Basic Master. (The Sharp MZ-80K semi-kit was released in
1978-12.)  On the original 8001 the PC-8011 expansion unit or PC-8033
adapter is required to connect the floppy drive unit. Internal memory was
16K expandable to 32K; with further RAM expansion from a PC-8011 or PC-8012
it could run CP/M.

- 1981-08 __PC-8001A:__ US release. Katakana replaced with Greek.
- 19??-?? __PC-8001B:__ European/Australian release (240V).
  Keyboard changes: `カナ` → `SHIFT LOCK`, keypad-`=` → `ALT CHAR`
  (gives greek/math characters); rest of JP layout (`^\@[]‾`) as-is.
  [Pictures][retropc.net/404].
- 19??-?? __PC-8001BE:__ UK release. As PC-8001B but `3/#` key replaced
  with `3/£`; [pictures][80s_john].
- 1981-12 PC-8801: series run in parallel until end of PC-8001. BE model
  also available.
- 1983-03 __PC-8001mkII:__ Improved graphics (V1?), many expansion modules
  (including FDC) built-in, two expansion slots. Perhaps closer to an
  8801mkII than the original 8001.
- 1983-10 PC-8801mkII: First machine with FDC/FDDs in system unit
- 1985-01 PC-8801mkII xR: V2 graphics mode
- 1985-03 __PC-8001mkIISR:__ Improved graphics again.

### Specifications

Also see [[rcp80spc]].

- CPU: μPD780C-1 (Z80 clone), 4 MHz.
  - Actually runs ~2.3 MHz due to DMA interrupt wait [[sb8001]]
- Memory: 16/32 KB (sockets for 32K); mkII: 64 KB.
  - VRAM inclusive on PC-8001, later models separate.
- ROM: 24 KB + 1 empty 8 KB 2716 PROM socket
- Video: μPD2301, b/w composite, DRGB. Programmable CRTC; 4K VRAM (mkII: 32K).
- Text: 80/72/40/36 × 25/20. "Graphics" can be intermixed.
  - 8 colors: black, blue red, magenta, green, cyan, yellow, white.
  - Monochrome output attrs: standard, reverse, blink, "secret" (blank).
- Graphics: 160x100/8, 4×2 pixels per character cell; one color per cell.
  (mkII: add 320x200/4, 640×200/2.)
- CMT: 600 baud, FSK, 1200/2400 Hz.
- BASIC: N-BASIC, variant of MS Disk BASIC 4.51
  - No disk support in ROM version, but hooks there
  - Not clear if `TERM` support in ROM version (see PC-8062-1)
  - mkII: N80-BASIC, kanji support.
- TOD clock (access w/`TIME$` in BASIC)
- Back panel:
  - PC-8001: power cord, POWER, RESET, TAPE (DIN-9), B/W (DIN-5), COLOR
    (DIN-8), PRINTER (keyed edge connector), EXT BUS (keyed edge connector)
  - PC-8001mkII:
    - Upper: power cord (captive), power switch, 2× expansion slots
    - Lower: reset button
     - DIN-8F COLOR, DIN-5F B&W, DIN-8F CMT, DB-25F RS-232C
     - 8×2 .1" jumpers 8-1 RS-232C, DIP sw (up=on) 1-8 MODE SELECT
     - micro-ribbon-36F FLOPPY DISK, DE-9M PORT, micro-ribbon-14F PRINTER
  - PC-8001mkIISR:
    - Upper row: expansion slot, power switch, power cord.
    - Lower row: printer (micro-ribbon), RS-232 (DB-25F), FDD? (micro-ribbon),
      switches, knob, RCA, DIN, DIN, DIN, DIN, RESET (button).

### Peripherals and Software

'Ⅱ' marks mkII items. See also [[hb68]] p.73, [[rcp8000]], [[rcp80mn]].

- __PC-8001mkII-01:__ Kanji board for mkII dedicated connector (not exp. slot)
- __PC-8005:__ 16K RAM expansion for PC-8001 or PC-8011
               (8× μPD416C-3, 150 ns), ¥24,500
- __PC-8006:__ Same as PC-8005, but revised price of ¥9,800
- __PC-8011:__ Expansion unit: [[hb68]] p.75
  - Low-profile (~10 cm?), ¥148,000
  - 32K RAM sockets ($0000-$7FFF when ROM disabled; CP/M, UCSD Pascal, etc.)
  - 8K ROM socket (how different from onboard?)
  - RS-232C interface (DB-25F?) (×2? [[sb8001]])
  - FDC I/O port (i8255 parallel interface to FDC control/drive unit)
  - GPIO (8 and 4 bit output ports, 8 and 4 bit input ports)
  - IEEE-488 interface
  - Expansion I/O bus for user-supplied devices (card slots?)
  - Interrupt controller (8 interrupts, 16 levels)
  - Interval timer (for RS-232C, prob., also "RTC")
  - "Real-time Interrupts": every 1.66 ms; from Interval timer?
  - All edge connectors so custom cables req'd. (PC-8095, PC-8098, PC-8096)
  - Connectors:
    - Front lower: PC-8001 CPUバス, SW1, SW3, SW2, power-switch
    - Back upper: AC in, 2× AC out, fuse
    - Back lower: IEEE-488, RS-232C2, RS-232C1, FDCバス, I/Oボード
- __PC-8012:__ I/O unit: [[hb68]] p.76
  - Tall (~25 cm?), ¥84,000
  - 7 sockets (slots?) for additional cards (up to 4× 32K RAM boards)
  - 2K PROM socket
  - FDC I/O Port
  - Interrupt controller
  - "Real-time Interrupts": every 1.66 ms; from Interval timer?
- __PC-8012-01:__ 8012 universal board (for making boards)
- __PC-8012-02:__ 32K RAM board. Up to 4 bank-switched into ROM area.
  Read and write may be separate banks, and 2 or more banks may be written
  at the same time.
- __PC-8012-03:__ Voice recognition board.
- __PC-8013:__ "I/O Unit" 7-slot expansion chassis w/FDC port. Looks very
  much like an 8012; differences unknown.
- __PC-8023:__ 80-column dot-matrix printer
- __PC-8031-1W:__ 2× 5.25" SSSD 143K 35-track FDD unit w/controller ¥310k/¥198k
               (not marked -1W on back sticker on most? models)
               (-1V is one-drive unit, ¥168k; -FDI is 2nd drive for it ¥78k)
- __PC-8032:__ 2× 5.25" expansion unit for 8031 (¥268k)
- __PC-8031-2W:__ 2× 5.25" DSDD 320K FDD unit w/controller
- __PC-8032-2W:__ 2-drive expansion unit for 8031-2W
- __PC-80S31:__ Ⅱ2× 5.25" 2D FDD with controller
- __PC-80S32:__ Ⅱ2× 5.25" 2D FDD w/o controller (expansion unit)
- __PC-8033:__ "FDD I/F" (standalone version of that included in PC-8011/12).
- __PC-8034:__ Disk BASIC (1D) (¥5000)
- __PC-8034-2W:__ Disk BASIC (2D) (¥5000)
- __PC-8041:__ 12" green display (JB-120M ¥48,800)
- __PC-8042:__ 12" color display (DRGB, low-res, but 80 char) (JC-121D ¥109,000)
- __PC-8043:__ 12" high-res color display (JC-1202DH ¥219,000)
- __PC-8044:__ TV color adapter (RF modulator) (¥13,500)
- __PC-8045:__ Light pen
- __PC-8046:__ 9" green display (JB-902M ¥35,800)
- __PC-8047:__ 12" amber yellow display (JB-1202M ¥46,800)
- __PC-8048:__ 12" color display (.63mm JC-1202D ¥88,000)
                PC-8048K (JC-1203D ¥67,800), PC-8048N (JC-1204D ¥59,800)
- __PC-8049:__ 12" high resolution color display (.31mm JC-1204DH ¥188,000),
                PC-8049K (JC-1205DH ¥158,000), PC-8049N (JC-1206DH ¥158,000)
- __PC-8062:__ RS-232C level converter for PC-8001 internal I/F (¥18,700)
- __PC-8062-1:__ Terminal firmware (¥6500)
- __PC-8064:__ Network Interface Board (¥110,000)
- __PC-8087:__ N₈₀-DISK BASIC System Disk
- __PC-8087SR:__ N₈₀SR-DISK BASIC System Disk
- __PC-8091:__ Color display cable
- __PC-8092:__ Monochrome display cable
- __PC-8093:__ CMT cable
- __PC-8094:__ Printer cable
- __PC-8095:__ RS-232C cable for PC-8011 (¥7500)
- __PC-8096:__ IEEE-488 cable
- __PC-8097:__ GP-IB Interface Set (¥56,000)
- __PC-8097mkII:__ GP-IB Interface Board (¥68,000)
- __PC-8098:__ PC-80S31 cable
- __PC-8104:__ PC-8012 users manual
- __PC-8106:__ PC-8011 users manual
- __PC-8108:__ PC-8012-03 users manual
_ __RM-210:__ Cassette tape recorder
- __PC-8801-11:__ ⅡFM sound; SR compatibility for 8001mkII, 8801, 8801mkII.
- __PC-8881:__ ["FDC8"][el-fdc8] 8" floppy controller expansion cards (no
  on-board data separator; needs external "VFO")

The specs (SS/DS and SD/DD) for the various drive units, and whether any
had just one drive installed rather than two, are not clear, and ja/en
Wikipedia don't entirely agree with each other.

### Monitor Pricing

The exchange rate for the given date taken from [macrotrends.net].
The Purchasing Power Parity for given date from [ceicdata.com].


    PC-Model  Description     Model         Price Year      Exchg. PPP
    ──────────────────────────────────────────────────────────────────
    PC-8041   12" green       JB-120M     ¥48,800 ?1979     $195  $196
    PC-8042   12" color       JC-121D    ¥109,000 ?1979     $436  $439
    PC-8043   12" high-res    JC-1202DH  ¥219,000 ?1979     $876  $883
    ──────────────────────────────────────────────────────────────────
    PC-8046   9" green        JB-902M     ¥35,800  1980-09  $169  $147
    PC-8047   12" amber       JB-1202M    ¥46,800  1980-09  $221  $193
    PC-8048   12" color .63mm JC-1202D    ¥88,000 ?1980     $415  $362
    PC-8048K                  JC-1203D    ¥67,800  1982-03  $288  $314
    PC-8048N                  JC-1204D    ¥59,800
    PC-8049   12" HR .31mm    JC-1204DH  ¥188,000  1980-12  $887  $787
    PC-8049K                  JC-1205DH  ¥158,000
    PC-8049N                  JC-1206DH  ¥158,000  1982-08  $601  $715
    ──────────────────────────────────────────────────────────────────

[macrotrends.net] https://www.macrotrends.net/2550/dollar-yen-exchange-rate-historical-chart
[ceicdata.com]: https://www.ceicdata.com/en/japan/exchange-rate-forecast-oecd-member-quarterly/jp-purchasing-power-parity-national-currency-per-usd


Documentation
-------------

- [`interfaces`](./interfaces.md) Hardware Setup and Interfaces.
  DIP switch and jump settings; connector pinouts.
- [`memory-map`](./memory-map.md) Memory.
  Memory layout (including locations used by ROM), bank switching,
  I/O port assignments.
- [`rom`](./rom.md) ROM Notes.
  (But also see [ROM and BASIC](../rom.md) in parent directory.)

#### Manuals

- __[PC-8101B]:__ _PC-8001 Micro Computer User's Manual_ (NEC, en, 1981)
- __[PC-8102B]:__ _PC-8001 N-Basic Reference Manual_ (NEC, en, 1981)
- __[PC-8105B]:__ _PC-8031B/32B Mini Disk Unit Reference Manual_ (NEC, en)
- [This VCF forum message][vcf 1375656]: contains a PDF with photos of
  pages 80–89 of the Japanese PC-8001 manual (PC-8101) PC-8001 manual,
  including connector, serial and expansion bus pinouts.
- \[um01ii] [_PC-8001mkII User's Manual_][um01ii] (ja, PC-8001MK2-UM, PTS-120A)

#### Books

- \[hb68] [パソコンPCシリーズ 8001 6001 ハンドブック][hb68]. Covers PC-8001
  and PC-6001 BASIC, memory maps, disk formats, peripheral lists, and all
  sorts of further technical info.
- \[tk80] 牟田 et al. [PC-Techknow8000][tk80], Systemsoft, 1982-04-01.
- \[km82] Kiyoshi Kawamura, [PC-8001 マシン語活用ハンドブック 初級編][km82].
  Hardware and N-BASIC interfaces (including disk); utility programs.

#### Magazines

- [Byte Magazine review][byte], Jan. 1981. w/block diagram, chip names.

#### Internet

- \[EnrPc] [ＰＣ－８００１][EnrPc]. Extensive internals info and
  memory/interrupt maps, including [PC-8011][Enr11], [PC-8012][Enr12],
  [PC-80S31][Enr31], [PCG8100][Enr81], serial mouse.
- [electric.com][er] has many posts on various PC-8001 topics.
- [PC-8001でマシン語 : VRAMアドレス取得のテストコード][expgig]
- \[rcp80] [Retro Computer People PC-8001 Models/Parts Lists/specs/etc.][rcp80]
- \[kuni] [KUNINET BLOG: 1970年代のマイコンとか電子工作とか][kuni].
  Details schematics etc. for recreation of many PC-8001 peripherals.
- \[sb8001] starbrother.net [PC-8001 ※1979年発売][sb8001]
  General discussion of system and peripherals, and lists of both NEC
  and third-party peripherals.
- VCF Forum, ["Searching for NEC PC-8001A software & hardware"][vcf 36037].
  English discussion of PC-8001A by several owners.


User Interface Notes
--------------------

If `STOP` key is being held down while the reset button is pushed, the
system will warm start (like `RST 8`) instead of cold start (`RST 0`).

### Character Set and Colors

![NEC PC-8001 character set](../img/PC-8001_character_set.png)

RGBI colors (0-7): black, blue, red, magenta, green, cyan, yellow, white.

B/W composite output colors are:
- Bit 0: 0 = visibile, 1 = invisible.
- Bit 1: 0 = no flash, 1 = flash.
- Bit 2: 0 = normal, 1 = reverse.



<!-------------------------------------------------------------------->
[PC-8101B]: https://archive.org/details/pc-8001b-micro-computer-users-manual-nec-en-1981
[PC-8102B]: https://archive.org/details/pc-8001b-n-basic-reference-manual-nec-en-1981
[PC-8105B]: https://archive.org/details/pc-8031b-32b-mini-disk-unit-reference-manual-nec-en
[um01ii]: https://archive.org/details/PC8001mk-II-users-manual/
[um01ii c9]: https://archive.org/details/PC8001mk-II-users-manual/page/n170/mode/1up?view=theater
[vcf 1375656]: https://forum.vcfed.org/index.php?threads/searching-for-nec-pc-8001a-software-hardware.36037/post-1375656

<!-- References: Books -->
[hb68]: https://archive.org/stream/PC8001600100160011982#page/n5/mode/1up
[km82]: https://archive.org/details/pc-8001
[tk80]: https://archive.org/details/pctechknow8000

[80s_john]: https://vintagecomputers.sdfeu.org/nec/index.html
[Enr11]: http://cmpslv2.starfree.jp/Pc80/Pc8011.htm
[Enr12]: http://cmpslv2.starfree.jp/Pc80/Pc8012.htm
[Enr31]: http://cmpslv2.starfree.jp/Pc80/Pc80s31.htm
[Enr81]: http://cmpslv2.starfree.jp/Pc80/Pc80pcg.htm
[EnrPc]: http://cmpslv2.starfree.jp/Pc80/EnrPc.htm
[EnrPc_old]: http://www43.tok2.com/home/cmpslv/Pc80/EnrPc.htm
[asahi]: https://archive.org/details/PC8001600100160011982
[byte]: https://tech-insider.org/personal-computers/research/acrobat/8101.pdf
[er]: https://electrelic.com/
[expgig]: https://expertgig.jp/2021/02/22/pc-8001でマシン語-vramアドレス取得のテストコード/
[kuni]: https://kuninet.org/
[rcp8000]: https://retrocomputerpeople.web.fc2.com/NEC/List8000.html
[rcp80]: https://retrocomputerpeople.web.fc2.com/machines/nec/8001/
[rcp80mn]: https://retrocomputerpeople.web.fc2.com/machines/nec/8001/mdl80.html
[rcp80spc]: https://retrocomputerpeople.web.fc2.com/machines/nec/8001/spc80.html
[retropc.net/404]: http://www.retropc.net/mm/archives/404
[sb8001]: https://www.starbrother.net/pc-8001-nec-2/
[vcf 36037]: https://forum.vcfed.org/index.php?threads/searching-for-nec-pc-8001a-software-hardware.36037

<!-- Peripherals and Expansion Boards -->
[PC-8881]: https://electrelic.com/electrelic/node/208
