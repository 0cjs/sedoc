Commodore (CBM) Computer Information
====================================

Documentation here:
- [PETSCII](petscii.md)
- [PET](pet.md)
- [C64 Address Decoding (Memory Maps)](address-decoding.md)
- [Machine Language](machlang.md)
- [Commodore Serial (IEC) Bus](serial-bus.md)
- [Peripherals](peripherals.md)
- [BASIC](basic.md)
- [DOS Wedge](doswedge.md)
- [Emulators](emulators.md)


Summary of Machines
-------------------

Dates from the [commodore.ca PET history][pet-history]. This may nto
be entirely reliable. See [PET index - versions][pi-ver] for more
details on individual modules and how they mixed into each other.

- 1977-10 __PET 2001__: Chiclet keyboard. $600 (4K) $800 (8K).
- 1979-spring: Graphics keyboard, BASIC 1.1, 16/32K.
- 1979-fall __CBM 3000__: European name for PET 2001.
- 1980-summer __PET 4016, 4032__: 16/32K, BASIC4, disk commands.
- 1980/1981: __PET 8032__: Business keyboard, 80 cols, 12" screens.
- 1981-summer: "FAT-40" adds 12" screens to 40 col. models, too.
- 1981-summer __SuperPET__: Adds 6809, serial, UWaterloo software.

By 1980 the Business keyboard was backported to the 2001/30xx series,
given designation 2001/B.

Non-PET models:

- 1980-06 __VIC-1001__: Japanese VIC-20; same hardware except
  charom/keyboard. (Another alternate name is "VC-20" in Germany.)
- 1981-?? __[VIC-20]__: 5K; no bitmap graphics, programmable charset
  - 22×23×2 (8×8 cells = 176×184)
  - 20×20×2 (8×8 cells = 160×160) "bitmap" w/1 programmed char/cell
  - 11×23×4 (4×8 cells = 88×184)
- 1982-?? __[MAX Machine]__: 2K, no ROM; additional RAM/ROM supplied
  on carts. No IEC serial, user ports. Otherwise C64 hardware (but
  different memory map).
- 1982-08 __[Commodore 64][c64]__: 64K
  - Text: text 40x25×16 (8x8 cells = 320×200), programmable charset
  - Bitmap: 160×200×4, 320×200×2, sprites
- 1984? __[Commodore Plus/4][plus4]__: 64K


Commodore 64
-------------

General documentation:
- [Commodore 64 Programmer's Reference Guide][c64progref], 1982, CBM.
- [Commodore C64/C64C Service Manual][c64service], March 1992 PN-314001-03
- [Zimmers CBM Archive][zimmers] (software, mags, books, etc.)

### 6510

The [6510 data sheet][6510] shows three versions; 6510, 6510-1 and
6510-2. The C64 uses the first of these. (The second and third replace
`RDY` and `NMI` pins with PIO pins `P₆` and `P₇`.)

Unlike the 6502, `A₀`-`A₁₅`, `D₀`-`D₇` and `R/W̅` can be tri-stated by
bringing `AEC` (Address Enable Control) low. Not clear what the CPU
actually sees when this happens; maybe the design is to test a pin on
the I/O port? Or perhaps the `RDY` must be used to pause the CPU.
Possibly the [REU documentation][reutech] offers insight.

### A/V Jack

The [A/V jack][cw-av] is a DIN-8b 268° (U, not horseshoe shaped). Note
that the pin numbering on the -8b connector is different from [the
DIN-8a 270° connector][din]; pin the center pin is 6 instead of 8. The
diagram below uses 8a numbering, however, for compatibility with the
DIN-5 plug that also fits it. The five pins on the DIN-5 have the same
function on both jacks, and is incompatible with the VIC-20 DIN-5
video output.

                        1   Luminance out
          ∪             2   GND
     8         7        3   Audio out
     3    6    1        4   Composite video out
       5     4          5   Audio in
          2             6   Chroma out
                        7   n/c
                        8   +5 V (usually)

The cjs DIN-5 adapter is wired as follows:

    DIN   RCA       C64            Plus/4                VIC-20
     1    black     luminance      luminance             +6 VDC, 10 mA
     2    sleeve    ground         ground                ground
     3    white     audio out      audio out (1V pp)     audio out
     4    yellow    comp. video    comp. video           VLOW video low
     5    red       audio in       audio out (.5V pp)    VHIGH video high

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
to be incorrect. According to the schematic the CPU's `RDY` line
(indicating that it can continue running) is high only when both `BA`
asserted and `D̅M̅A̅` are 1. The `BA` line appears to be an output from
the VIC II sent to the `RDY` gate, PLA and cartridge port.

[rc 10850] and its answers make some good points:
- Except when asserting `G̅A̅M̅E̅` and not asserting `E̅X̅R̅O̅M̅`, without
  knowing the internal state of the C64 (i.e., someone else's software
  is running) you must use the `I̅O̅n̅` (and sometimes `R̅O̅M̅x̅`) lines to
  determine whether internal memory or your cart is being accessed.
- The address bus is actually bidirectional when DMA is being used;
  carts can read/write system RAM.


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
accessing `$0800`-`$0FFF`. (This is `I̅O̅1̅` for page `$DExx` on the C64.)

Pin 8 on cartridges is grounded, thus asserting `G̅A̅M̅E̅` on the C64 to
put it into MAX mode.

The [MultiMAX] cart connects `E̅X̅R̅O̅M̅` (9) to `I̅O̅2̅` (10); this would
allow you to access the top 256 bytes (32 char definitions) of CHAROM
on the C64. Not sure what use that might be. Perhaps cartridge port
pins 9 and 10 have other purposes on the MAX.


Plus/4
------

- CBM BASIC 3.5 ($8000-$BFFF) and newer KERNAL ($D800-$FFFF)
- Second bank of ROM ($8000-$FFFF) for office software suite

### Cartridge/Expansion Port

50-pin, labeled 1-25 and A-Z,AA-CC skipping G, I, O, Q.

     1      GND
     2-3    +5 V
     4      IRQ
     5      R/W̅
     6      C1 HIGH
     7      C2 LOW
     8      C2 HIGH
     9      C̅S̅1̅
    10      C̅S̅0̅
    11      C̅A̅S̅
    12      MUX
    13      BA
    14-21   D7-D0
    22      AEC
    23      EXT AUDIO
    24      Φ2
    25      GND
     A      GND
     B      C1 LOW
     C      B̅R̅R̅E̅S̅E̅T̅
     D      R̅A̅S̅
     E      Φo
     F-Y    A15-A0
     Z      n/c (also marked "RAMEN" on schematic)
    AA      n/c
    BB      n/c
    CC      GND


Transferring Data to CBM Machines
----------------------------------

The [Data Transfers with Commodore Computers][transfer] page in
[Zimmers CBM archive][zimmers] has a lot of good options for getting
stuff on to a C64, some of them much faster than the disk drive.


<!-------------------------------------------------------------------->
[MAX Machine]: https://www.c64-wiki.com/wiki/Commodore_MAX_Machine
[VIC-20]: https://www.c64-wiki.com/wiki/VIC-20
[c64]: https://www.c64-wiki.com/wiki/C64
[pet-history]: https://www.commodore.ca/commodore-products/commodore-pet-the-worlds-first-personal-computer/
[pi-ver]: http://www.6502.org/users/andre/petindex/versions.html
[plus/4]: https://www.c64-wiki.com/wiki/Commodore_Plus/4

[64w-cport]: https://www.c64-wiki.com/wiki/Expansion_Port
[6510]: http://archive.6502.org/datasheets/mos_6510_mpu.pdf
[c64progref]: https://archive.org/details/c64-programmer-ref
[c64service]: https://www.retro-kit.co.uk/user/custom/Commodore/C64/manuals/C64C_Service_Manual.pdf
[cw-av]: https://www.c64-wiki.com/wiki/A/V_Jack
[din]: ../../../hw/din-connector.md
[rc 10850]: https://retrocomputing.stackexchange.com/q/10850/7208
[reutech]: https://codebase64.org/doku.php?id=base:thirdparty#reu

[multimax]: http://www.multimax.co/hardware/

[transfer]: http://www.zimmers.net/anonftp/pub/cbm/crossplatform/transfer/transfer.html
[zimmers]: http://www.zimmers.net/anonftp/pub/cbm/
