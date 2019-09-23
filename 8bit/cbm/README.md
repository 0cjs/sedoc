Commodore (CBM) Computer Information
====================================

Documentation here:
- [PETSCII](petscii.md)
- [CBM Address Decoding (Memory Maps)](address-decoding.md)
- [Machine Language](machlang.md)
- [Commodore Serial (IEC) Bus](serial-bus.md)
- [Commodore BASIC](basic.md)
- [Emulators](emulators.md)


Summary of Machines
-------------------

- 1980-06 __VIC-1001__: Japanese VIC-20; same hardware except
  charom/keyboard. (Another alternate name is "VC-20" in Germany.)
- 1981-?? __[VIC-20]__: 5K; no bitmap graphics, programmable charset
  - 22×23×2 (8×8 cells = 176×184)
  - 20×20×2 (8×8 cells = 160×160) "bitmap" w/1 programmed char/cell
  - 11×23×4 (4×8 cells = 88×184)
- 1982-?? __[MAX Machine]__: 2K, no ROM; additional RAM/ROM supplied on
  carts. No IEC serial, user ports. Otherwise C64 hardware (but
  different memory map).
- 1982-08 __[Commodore 64][c64]__: 64K
  - Text: text 40x25×16 (8x8 cells = 320×200), programmable charset
  - Bitmap: 160×200×4, 320×200×2, sprites


Commodore 64
-------------

General documentation:
- [Commodore 64 Programmer's Reference Guide][c64progref], 1982, CBM.
- [Commodore C64/C64C Service Manual][c64service], March 1992 PN-314001-03
- [Zimmers CBM Archive][zimmers] (software, mags, books, etc.)

### Cartridge/Expansion Port

The [cartridge/expansion port][64w-cport] pins are, left to right,
`22`-`1` on the top edge and `Z`-`A` on the bottom edge.
`●` = input, `→` = ouput.

     →   1      GND
     →   2-3    +5 V (450 mA max)
    ●    4      I̅R̅Q̅
     →   5      R/W̅
     →   6      Dot clock; NTSC = 8.181816 MHz, PAL = 7.881984 MHz
     →   7      I̅O̅1̅; low when accessing page $DExx
    ●    8      G̅A̅M̅E̅
    ●    9      E̅X̅R̅O̅M̅; disables internal RAM at $8000-$9FFF
     →  10      I̅O̅2̅; low when accessing page $DFxx
     →  11      R̅O̅M̅L̅; low when RAM off, accessing 8K @ $8000
    ??  12      BA; VIC bus available (see below)
    ●   13      D̅M̅A̅; assert to make CPU release bus after next read cycle
    ●→  14-21   Data bus lines 7 to 0
     →  22-A    GND
     →   B      R̅O̅M̅H̅; low when RAM off, accessing 8K @ $A000 / 8K @ $E000
    ●    C      R̅E̅S̅E̅T̅
    ●    D      N̅M̅I̅
     →   E      φ2 clock; NTSC = 1.02272714 MHz, PAL = 0.98524861 MHz
     →   F-Y    Address bus lines 15 to 0
     →   Z      GND

[64w-cport] says that pin 12 BA is an input signal, but this appears
to be incorrect. According to the schematic the CPU's RDY line
(indicating that it can continue running) is high only when both BA
asserted and D̅M̅A̅ are 1. The BA line appears to be an output from the
VIC II sent to the RDY gate, PLA and cartridge port.


MAX Machine
-----------

Like a C64, but missing:
- All ROM (KERNAL, BASIC, CHAROM).
- All RAM except lowest 2K.
- Second CIA chip and the User and IEC Ports it controlled.
- Monitor port (RF output only, plus separate 3.5mm audio jack).

The ROMH in carts is always mapped to 8K @ `$E000`; the optional ROML
to 8K @ `$8000`. The cartridge may supply 2K of RAM to be mapped into
`$0800`.

4K @ `$F000` is mapped into the VIC II address space at `$3000`,
allowing it to see character data, sprite shapes, etc. in that area of
the cartridge ROM. (On the C64 the VIC sees the onboard CHAROM at 4K @
`$1000`.)

Cartridge port pin 7 is the external RAM enable signal, asserted when
accessing `$0800`-`$0FFF`. (This is I̅O̅1̅ for page `$DExx` on the C64.)

Pin 8 on cartridges is grounded, thus asserting G̅A̅M̅E̅ on the C64
to put it into MAX mode.

The [MultiMAX] cart connects 9 E̅X̅R̅O̅M̅ being connected to 10 I̅O̅2̅; this
would allow you to access the top 256 bytes (32 char definitions) of
CHAROM on the C64. Not sure what use that might be. Perhaps cartridge
port pins 9 and 10 have other purposes on the MAX.


Transferring Data to CBM Machines
----------------------------------

The [Data Transfers with Commodore Computers][transfer] page in
[Zimmers CBM archive][zimmers] has a lot of good options for getting
stuff on to a C64, some of them much faster than the disk drive.


<!-------------------------------------------------------------------->
[MAX Machine]: https://www.c64-wiki.com/wiki/Commodore_MAX_Machine
[VIC-20]: https://www.c64-wiki.com/wiki/VIC-20
[c64]: https://www.c64-wiki.com/wiki/C64

[64w-cport]: https://www.c64-wiki.com/wiki/Expansion_Port
[c64progref]: https://archive.org/details/c64-programmer-ref
[c64service]: https://www.retro-kit.co.uk/user/custom/Commodore/C64/manuals/C64C_Service_Manual.pdf

[multimax]: http://www.multimax.co/hardware/

[transfer]: http://www.zimmers.net/anonftp/pub/cbm/crossplatform/transfer/transfer.html
[zimmers]: http://www.zimmers.net/anonftp/pub/cbm/
