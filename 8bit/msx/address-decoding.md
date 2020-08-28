MSX Address Decoding
====================

References:
- \[td1] [_MSX Technical Data Book_][th1], Sony, 1984.
  MSX1 hardwre and software.
- [RAM and Memory Mappers][mw ramm], msx.org wiki.

Though the hardware is described below, the MSX standard strongly suggests
using BIOS routines to change page and slot mappings, do cross-slot calls,
etc.

The MSX address space is divided into four 16 KB "pages."  PPI (i8255)
port A (PA0-PA7) at IO port $A8 determines which device select line from
`S̅L̅T̅S̅L̅0` through `S̅L̅T̅S̅L̅3` will be asserted when that page is accessed;
write 0-3 in the page's corresponding bits to set this.
(Schematic at [td1 p.30].)

      Page  Addr.range  $A8  Typical use
       3    C000-FFFF   7,6  RAM
       2    8000-BFFF   5,4  empty; additional RAM
       1    4000-7FFF   3,2  BIOS/BASIC ROM; expansion ROM
       0    0000-3FFF   1,0  BIOS/BASIC ROM

Devices responding to address space read/write requests are in one of four
"primary" slots, 0-3, corresponding to select lines `S̅L̅T̅S̅L̅0` through
`S̅L̅T̅S̅L̅3`. These are routed to onboard devices or `S̅L̅T̅S̅L̅` (slot select, pin
4) on the corresponding cartridge connector.

      Slot 0    System slot (onboard ROM, RAM)  required
      Slot 1    Cartridge slot 1                required
      Slot 2    Cartridge slot 2                optional
      Slot 3    Expansion bus connector         optional

Each primary slot may optionally support up to four "expansion" slots
associated with the primary slot. Expansion slot decoding is done by the
primary slot device (suggested scheamtic at [td1 p.35]). The standard
specifies that when a primary slot is selected for page 3, it should latch
any write to $FFFF and interpret it as:

    | 7 6 | 5 4 | 3 2 | 1 0 |  $FFFF bits
    |  3  |  2  |  1  |  0  |  Page # sub-slot setting (0-3)

Reads from $FFFF should return the latched value inverted (i.e., XOR $FF,
or 0 for 1 and 1 for 0 for all bits). This allows the BIOS (or any other
routines) to determine whether a primary slot has expansion slots.

#### Initialization

At startup the BIOS is presumably mapped into page 0 and 1. It scans
through the primary slots and their expanded slots, if present, at at
$8000, $C000 and, if the $C000 scan failed, $E000 (to support 8K systems)
to detect RAM, mapping in the first RAM that it finds for each page. It
then scans at $4000 and $8000 for pages starting $AB, which is the
cartridge ROM signature, and maps in the first one it finds.


I/O Address Map
---------------

[td1 p.40]. But all I/O is supposed to be done via BIOS calls, except VDP.
($0006 and $0007 contain VDP read/write register IO addrs.) FDC should
have a disable mechanism so multiple FDCs can be present.

    F8-FF

    F7      Audio/Video Control
              b7 video select  0=TV
              b6 Ys control    0=Super
              b5 Ym control    0=TV
              b4 AV control    0=TV

    F0-F6
    E0-F0
    D8-DF   Kanji ROM
    D0-D7   Floppy Disk Controller
    C0-CF
    B8-BF   Light pen interface (Sanyo)
    B5-B7
    B4      Calendar clock
    B0-B3   External memory (Sony)

    A8-AF   PPI (8255): A8
              A8:  w  port A: address slot select (CS0L, CS0H, CS1L, ...)
              A9: r   port B: keyboard matrix sense
              AA:  w  port C: [td1 p.43] Bits:
                          7  SOUND    software-controlled sound output
                          6  CAPS     CAPS lamp          0=on
                          5  CASW     CMT write signal
                          4  CASON    CMT motor control  0=on
                        3-0  KB3-KB0  keyboard matrix row select
              AB: rw  mode register

    A0-A7   PSG (AY-3-8910). [td1 p.44] for bit assignments
              A0: addr latch
              A1: data write
              A2: data read

    98-9F   VDP (TI 9918A)
              98: video ram data
              99: command/status reg.

    90-97   printer
              90: b0 (w) strobe, b1(r) busy state
              91: (w) print data

    88-8F
    80-87   RS-232C
    40-7F   Reserved
    00-3F   Unspecified



<!-------------------------------------------------------------------->
[mw ramm]: https://www.msx.org/wiki/RAM_and_Memory_Mappers
[th1]: https://archive.org/stream/MSXTechnicalHandbookBySony#page/n5/mode/1up
