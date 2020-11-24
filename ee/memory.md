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

Notes:
- Plain suffixes are for 23xxx PROMs and 27xxx EPROMS.
- 28xxx (5V programmable) notably non-JEDEC marked with `●`.

Chart:

         ¶  Pin addt'ly uses high-V for prog/erase/ID area or similar
       RBN  RDY/B̅U̅S̅Y̅ or NC

                        28C            28C
          16  32A   64   64  128  256  256  512
    ┌──∪                                           ┌───∪
    │1             Vpp  RBN● Vpp  Vpp  A14● A15    │1
    │2             A12 ──────────────────── A12    │2
    │3    A7 ──────────────────────────────  A7    │3
    │4    A6 ──────────────────────────────  A6    │4
    │5    A5 ──────────────────────────────  A5    │5
    │6    A4 ──────────────────────────────  A4    │6
    │7    A3 ──────────────────────────────  A3    │7
    │8    A2 ──────────────────────────────  A2    │8
    │9    A1 ──────────────────────────────  A1    │9
    │10   A0 ──────────────────────────────  A0    │10
    │11   D0 ──────────────────────────────  D0    │11
    │12   D1 ──────────────────────────────  D1    │12
    │13   D2 ──────────────────────────────  D2    │13
    │14  GND ────────────────────────────── GND    │14
    └───                                           └────
          16  32A   64   64  128  256  256  512
                        28C            28C
          16  32A   64   64  128  256  256  512
    ∪──┐                                           ∪──┐
     28│           Vcc  Vcc  Vcc  Vcc  Vcc  Vcc     28│
     27│           P̅G̅M̅   W̅E̅  P̅G̅M̅  A14   W̅E̅● A14     27│
     26│ Vcc  Vcc   NC   NC  A13 ────────── A13     26│
     25│  A8 ──────────────────────────────  A8     25│
     24│  A9   A9   A9   A9¶  A9   A9   A9¶  A9     24│
     23│ Vpp  A11 ───────────────────────── A11     23│
     22│  O̅E̅   O̅E̅   O̅E̅   O̅E̅¶  O̅E̅   O̅E̅   O̅E̅¶  O̅E̅     22│
     21│ A10 ────────────────────────────── A10     21│
     20│  C̅E̅ ──────────────────────────────  C̅E̅     20│
     19│  D7 ──────────────────────────────  D7     19│
     18│  D6 ──────────────────────────────  D6     18│
     17│  D5 ──────────────────────────────  D5     17│
     16│  D4 ──────────────────────────────  D4     16│
     15│  D3 ──────────────────────────────  D3     15│
    ───┘                                           ───┘
          16  32A   64   64  128  256  256  512
                        28C            28C


Chip Data
---------

_DIPnn_ is 0.3" wide dual-inline package, _nn_ pins;
_WDIPnn_ is = 0.6" wide.

### ROM

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

Amtel Parallel EEPROM [AT28C256] 32K×8, [AT28C64] 8K×8, [AT28C16A] 2K×8 \(24p)
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



<!-------------------------------------------------------------------->
[JDEC-memory-dip]: https://www.jedec.org/document_search/field_committees/25?search_api_views_fulltext=memory+dip
[byte-8610-106]: https://archive.org/details/byte-magazine-1986-10/page/n117/mode/1up
[JDEC-3.7.5]: https://www.jedec.org/system/files/docs/3_07_05R12.pdf

[27C256]: http://esd.cs.ucr.edu/webres/27c256.pdf
[AT28C16A]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0001h.pdf
[AT28C256]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf
[AT28C64]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0001h.pdf
[CAT28F512]: https://datasheet.octopart.com/CAT28F512PI-90-Catalyst-Semiconductor-datasheet-1983.pdf
[HM62256A]: https://datasheet.octopart.com/HM62256ALP-10-Hitachi-datasheet-115281844.pdf
[W27C512-45Z a]: http://www.kosmodrom.com.ua/pdf/W27C512-45Z.pdf
[W27C512-45Z]: https://datasheet.octopart.com/W27C512-45Z-Winbond-datasheet-13695031.pdf
