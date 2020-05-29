RAM/ROM/etc. Pinouts, Specs
===========================

JEDEC (I think) pinouts, from Ciarcia, "Build an Intelligent Serial
EPROM Programmer," _BYTE_ Oct. 1986, [p.106][byte-8610-106].

- Plain suffixes are for 23xxx PROMs and 27xxx EPROMS/EEPROMS.
- 28xxx series is 5V programmable, except for ID area.
  Pins notably different from JEDEC marked with `●`.

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

#### AT28C notes

- No writes for 5 ms after Vcc reaches 3.8V.
- Device identification memory: 32 bytes, $1FE0-$1FFFF. Raise `A9¶`
  to 12V ±0.5V to read/write in the same way as regular memory.
- Chip clear:
  - '64: `C̅E̅` low, `O̅E̅¶` 12V, 10 ms low pulse on `W̅E̅`.
  - '256: 6-byte software code.
- Software data protection (SDP): enable/disable with special 3-byte
  command sequence. Write timers still active when SDP enabled, but the
  data is not actually written.


Data Sheets
-----------

- Microchip [27C256]
- Winbond [27C512]
- Catalyst Semiconductor [CAT28F512]; 12 V programming/erase
- Amtel [AT28C64], [AT28C256]; 5 V programming/erase


<!-------------------------------------------------------------------->
[byte-8610-106]: https://archive.org/details/byte-magazine-1986-10/page/n117/mode/1up

[27C256]: http://esd.cs.ucr.edu/webres/27c256.pdf
[AT28C256]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf
[AT28C64]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0001h.pdf
[CAT28F512]: https://datasheet.octopart.com/CAT28F512PI-90-Catalyst-Semiconductor-datasheet-1983.pdf
[W27C512]: https://datasheet.octopart.com/W27C512-45Z-Winbond-datasheet-13695031.pdf
