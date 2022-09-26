CBM Address Decoding (Memory Maps)
==================================

Contents:
- Commodore 64
- MAX Machine
- Commodore 128
- VIC-20


Commodore 64
------------

See also:
- [C64 Wiki: Bank Switching][64w-bank]
- [C64 Service Manual][c64servman]
- [Christian Bauer's VIC-II article][vic-ii]

Onboard memory devices are 64K RAM, 512 bytes color RAM (cRAM), 8K
KERNAL ROM and 8K BASIC ROM. The cartridge may additionally supply two
8K ROM banks, LOW and HIGH.

### C64 Memory map

Devices have two sources: internal (RAM, IntROM, I/O + color RAM) or
external (CartROM, unmapped). When a range is unmapped internally, the
device on the cartridge/expansion port may respond to read/write
requests in that range. Thus, CartROM low and high mappings are the
same thing as unmapped, except that the R̅O̅M̅L̅ and R̅O̅M̅H̅ signals are
asserted. So the cartridge can respond to any address except in 4K @
`$0000` (RAM) and 4K @ `$D000` (RAM/CHAROM/IO+cRAM).

All writes to any address also pass through to RAM, regardless of
what's mapped there. So this can be used to, e.g., copy ROM to RAM by
simply reading a location and writing it back, but it can also cause
problems if you are trying to write something else at an area of RAM
in use by the VIC.

    Address Size    RAM  IntROM  internal  Cartridge
    ----------------------------------------------
    $E000    8K     RAM  KERNAL            ROMH
    $D000    4K     RAM  CHAROM  I/O+cRAM
    $C000    4K     RAM          unmapped  ✓
    $A000    8K     RAM  BASIC   unmapped  ROMH
    $8000    8K     RAM                    ROML
    $1000   28K     RAM          unmapped  ✓
    $0000    4K     RAM

### I/O and Color RAM Map

    Start   End    Size  Device
    ------------------------------------
    $DF00 - $DFFF   256   I/O 2 (cartridge)
    $DE00 - $DEFF   256   I/O 1 (cartridge)
    $DD00 - $DD0F    16   CIA 2
    $DC00 - $DC0F    16   CIA 1
    $D800 - $DBFF  1024   Color RAM (cRAM)
    $D400 - $D7FF  1024   SID
    $D000 - $D02E    47   VIC

The color RAM (cRAM) stores only the low four bits per byte of the
data written; the high four bits will read as random data.

### PLA Inputs and Outputs

The PLA takes several inputs and outputs various chip selects based on
those, thus determining the current memory map.

Below: Bits 0-2 of the CPU I/O port (locations `$0000` data, `$0001`
direction; bits 3-5 are `CASS WRT/SENSE/MOTOR`). cartridge/expansion
port (44 pins) input pins 8 and 9 (3K3 pullups) and output pins B and 11.

    in   0  L̅O̅R̅A̅M̅    8K @ $A000    0 = RAM        1 = BASIC
    in   1  H̅I̅R̅A̅M̅    8K @ $E000    0 = RAM        1 = KERNAL
    in   2  C̅H̅A̅R̅E̅N̅   4K @ $D000    0 = IO+cRAM    1 = CHAROM
    in   8  G̅A̅M̅E̅
    in   9  E̅X̅R̅O̅M̅
    out 11  R̅O̅M̅L̅     8K @ $8000 chip select
    out  B  R̅O̅M̅H̅     8K @ $A000/$E000 chip select

Here's the full map of modes.

    Signals:  E G c h l = E̅X̅R̅O̅M̅ G̅A̅M̅E̅ C̅H̅A̅R̅E̅N̅ H̅I̅R̅A̅M̅ L̅O̅R̅A̅M̅
              0 = low (asserted) . = high (not asserted)
    Internal: _ = RAM  k = kernal  b = basic  c = charom  i = i/o
    External: * = unmapped  L = cart rom low  H = cart rom high

Asserting G̅A̅M̅E̅ without E̅X̅R̅O̅M̅ is just a single mode: MAX emulation.
This gives 4K RAM at the bottom (but with the upper 2K supplied by the
C64 instead of the cart) C64 IO and the rest is always just cart rom
in the MAX locations. C64 L̅O̅R̅A̅M̅/H̅I̅R̅A̅M̅/C̅H̅A̅R̅E̅N̅ is completely ignored.
Note that _only_ G̅A̅M̅E̅ unmaps `$1/$A/$C` blocks, and while you're
supplying ROML/ROMH blocks from the cart, you can never supply the
`$0` RAM or `$D` IO from the cart.

This is the only mode in which the VIC-II can access external memory,
$F000-$FFFF on the cart appearing at $3000 in the VIC-II address space.
[[max]] (This is why you must copy $F000-$FFFF to $3000 when runing a MAX
cart dump from RAM.)

    E G c h l   $0 $1 $8 $A $C $D $E
    . 0 x x x    _  *  L  *  *  i  H

The "no-cart" modes allow you to have all internal ROM+IO, remove just
BASIC, remove BASIC+KERNAL, or remove BASIC+KERNAL+IO, and
independently swap IO for CHAROM.

    E G c h l   $0 $1 $8 $A $C $D $E
    . . . . .    _  _  _  b  _  i  k       Default mode (no cart)
    . . . . 0    _  _  _  _  _  i  k       L̅O̅R̅A̅M̅ banks out BASIC
    . . . 0 .    _  _  _  _  _  i  _       H̅I̅R̅A̅M̅ banks out BASIC+KERNAL
    . . . 0 0    _  _  _  _  _  _  _       L̅O̅R̅A̅M̅+H̅I̅R̅A̅M̅ banks out IO too
    . . 0 . .    _  _  _  b  _  c  k       C̅H̅A̅R̅E̅N̅ changes only IO/CHAROM area
    . . 0 . 0    _  _  _  _  _  c  k
    . . 0 0 .    _  _  _  _  _  c  _
    . . 0 0 0    _  _  _  _  _  _  _       L̅O̅R̅A̅M̅+H̅I̅R̅A̅M̅ banks out CHAROM too

Asserting E̅X̅R̅O̅M̅ is the same as the "no-cart" modes but with ROML
banked in when BASIC is banked in.

    E G c h l   $0 $1 $8 $A $C $D $E
    0 . . . .    _  _  L  b  _  i  k       E̅X̅R̅O̅M̅ brings in only ROML
    0 . . . 0    _  _  _  _  _  i  k       L̅O̅R̅A̅M̅ banks out ROML+BASIC
    0 . . 0 .    _  _  _  _  _  i  _       H̅I̅R̅A̅M̅ banks out ROML+BASIC+KERNAL
    0 . . 0 0    _  _  _  _  _  _  _       L̅O̅R̅A̅M̅+H̅I̅R̅A̅M̅ banks out IO too
    0 . 0 . .    _  _  L  b  _  c  k       E̅X̅R̅O̅M̅+C̅H̅A̅R̅E̅N̅ changes only CHARROM
    0 . 0 . 0    _  _  _  _  _  c  k
    0 . 0 0 .    _  _  _  _  _  c  _
    0 . 0 0 0    _  _  _  _  _  _  _

Asserting G̅A̅M̅E̅ _with_ E̅X̅R̅O̅M̅ moves ROMH down to BASIC area, does _not_
bank it out with L̅O̅R̅A̅M̅, and H̅I̅R̅A̅M̅ only still doesn't bank out IO, but
(inconsistently) does lose CHAROM if C̅H̅A̅R̅E̅N̅ is set.

    E G c h l   $0 $1 $8 $A $C $D $E
    0 0 . . .    _  _  L  H  _  i  k
    0 0 . . 0    _  _  _  H  _  i  k
    0 0 . 0 .    _  _  _  _  _  i  _
    0 0 . 0 0    _  _  _  _  _  _  _
    0 0 0 . .    _  _  L  H  _  c  k
    0 0 0 . 0    _  _  _  H  _  c  k
    0 0 0 0 .    _  _  _  _  _  _  _
    0 0 0 0 0    _  _  _  _  _  _  _

### Hints on Using Memory (Tricks)

Things can get difficult if the $Dxxx area is switched out, since that
has all IO. But if memory gets tight, you can [put your character and
sprite info there][rc 5715] if it doesn't change often, since the VIC
will still have that RAM mapped even when the CPU does not.


MAX Machine
-----------

[Memory map][64w-maxmap]:

    $E000   8K  -           8K Kernal/BASIC/charROM for Mini and Max Basic
    $D000   4K  I/O
    $C000   4K  -
    $A000   8K  -
    $8000   8K  -           8K BASIC ROM for Max Basic
    $1000  28K  -
    $0800   2K  -           Cartridge RAM
    $0400   1K  screen RAM
    $0200  .5K  RAM         Mini Basic working RAM; Max Basic system area
    $0100  .2K  RAMStack
    $0000  .2K  Zero page

- 2K onboard RAM is mapped at `$0000-$7fff`.
- 0.5K of color RAM is mapped at `$d800-$dbff`; see below.
- First ROM from cart is mapped at `$e000`. Must be 8K to set vectors.
  Also mapped at `$8000`?

Bus and cartridge port signals:
- `R̅O̅M̅L̅`, `R̅O̅M̅H̅` asserted for low/high 4K parts of cartridge ROM access.
- `E̅X̅R̅A̅M̅/I̅O̅1̅` asserted for 2K cartridge RAM access
- Rest of address bus (A14+ ROM, A10+ RAM) ignored by MultiMAX cart.

I/O map:

    $fffe           IRQ vector
    $fffc           Reset vector
    $fffa           NMI vector
    $dc00-$dcff     CIA
    $d800-$dbff     Color RAM (lower 4 bits per byte only?)
    $d400-$d7ff     SID
    $d000-$d3ff     VIC
    $0001           [6510] input/output register
    $0000           [6510] data direction register


Commodore 128
-------------

Uses an 8502; has but 7-bit IO at $00 (DRR) and $01 (DR).
MMU can remap zero-page and stack page to anywhere in memory.

The C128 has "128 mode," "64 mode," and "CP/M" mode. This discusses
only 128 mode. Reset clears $02-$FF; hold down RUN/STOP during reset
to avoid running RAMTAS routine that clears this and instead drop to
the monitor.

See also:
- Ottis R. Cowper, [_Mapping the Commodore 128_][map128]. COMPUTE!, 1986.

The memory management unit and PAL map:
- KERNAL ROM, character ROM and IO+color RAM (2×1K banks) in the same
  positions as the C64.
- BASIC ROM 28k@`$4000`, machine language monitor 4k@`$B000` screen
  editor routines 4k@`$C000`.
- 4×64K RAM blocks. 0, 1 installed in 128; neither board nor MMU
  support 2, 3.
- 32K @ `$8000` internal and external "function ROM" banks. Internal
  is a socket on the mobo, external is a special ROM cartridge.
- Cartridge etc.

The 128 KB 1700 and 256 KB 1750 RAM expansion modules are not mapped
by this; they use a separate REC (RAM Expansion Controller).

In all 6502 mappings the following are constant.

    $FF00   5b  MMU registers
    $0001   1b  8502 DR (data register)
    $0000   1b  8502 DDR (data direction register); 1=output

The memory mappings for the Z80 are the same except:
- Reads from $0000-$0FFF are remapped to ROM at $D000-$DFFF. (??? Even when
  I/O mapped? Always use `LD BC,$Dnnn; OUT (C),A` for I/O?)
- ??? What's up with I/O space? Not separate? Always uses $D000-$DFFF I/O
  even when it's not mapped into the memory address space?

### Memory Management Unit (MMU)

Registers:

    $FF04   load preconfig D by writing any value
    $FF03   load preconfig C
    $FF02   load preconfig B
    $FF01   load preconfig C
    $FF00   configuration register

    $D50B   version register (7..4:memsize in 64K blocks, 3..0:version)
    $D50A   page 1 pointer HI
    $D509   page 1 pointer LO
    $D508   page 0 pointer HI
    $D507   page 0 pointer LO
    $D506   RAM configuration register
    $D505   mode configuration register
    $D504   preconfig D (write value to store)
    $D503   preconfig C
    $D502   preconfig B
    $D501   preconfig A
    $D500   configuration register

The MMU Configuration Register at $D500 is mirrored at $FF00 so it's
accessible when $D000-$DFFF is not mapped to the I/O ports. On system reset
the value is set to $00.

       7  No effect (would be for RAM blocks 3/4)
       6  RAM Block   0=64K bank 0      1=64K bank 1    (*see RAM conf reg)
     5-4  $C000 16k: 00=kernal/charom  01=int funcrom
                     10=ext funcrom    11=RAM
     3k2  $8000 16k: 00=BASIC/MLMON    01=int funcrom
                     10=ext funcrom    11=RAM
       1  $4000 16k:  0=BASIC (low)     1=RAM
       0  $D000  4k:  0=I/O block       1=RAM/ROM (bits 4-5)

The RAM configuration register ($D506) specifies common (shared) RAM
mappings (bank 0 used to all banks regardless of current bank setting) and
which bank is used by the VIC. This register is set to $00 on reset.

     7-6  VIC RAM           00=bank 0   01=bank 1
     4-5  -
       3  Common RAM high   0=off     1=on                enables $C/E/F000-top
       2  Common RAM low    0=off     1=on                enables 0-$3FF/FFF
     0-1  Common RAM amt    00=" 1K"  0-$03FF  $F000-top
                            01=" 4K"  0-$0FFF  $F000-top
                            10=" 8K"  0-$03FF  $E000-top
                            11="16K"  0-$0FFF  $C000-top

The page pointers allow moving pages 0 and 1 to any other pages in memory.
Mapped RAM at the destination is "swapped" back to pages 0/1; ROM and I/O
are not back-translated. Write to the "high byte" register first; it will
not take effect until the corresponding "low byte" register is written. The
relocation does not affect addresses $00 and $01 (the PIA registers).

    High byte ($D508, $D50A)       bit 0: RAM bank (unless in common RAM)
                                bits 3,1: ignored
    Low byte  ($D507, $D509)    bits 7-0: page (address MSB, bits 8-15)

The mode configuration register or MCR ($D505) specifies processor (8502,
Z80A) and OS mode (C128 C64). The `/EXROM` and `/GAME` registers read the
value set by the cartridge in the expansion port; both lines have pullups.
In C128 mode they can be used as I/O lines.

       7  40/80 key     0=key down    1=key up
       6  OS mode       0=C128 mode   1=C64 mode (MMU inaccessible)
       5  /EXROM sense
       4  /GAME sense
       3  FSDIR         0=fast in     1=fast out      (*fast serial direction)
     2-1  -
       0  /Select CPU   0=Z80A        1=8502 (6502)

### Built-in PIA

8502 PIO Register ($00 data, $01 direction):

      7     Unconnected; always 0 when read (or retains value?)
      6 i   Caps Lock; 1=up/off, 0=down/on
      5     CASS MTR; 1=off
      4 i   CASS SENSE; 1 = any button pressed on Datasette
      3     CASS WRT
      2     VIC C̅H̅A̅R̅E̅N̅: 0=RAM 1=ROM, but screen editor copies shadow at $D9
      1     cRAM block seen by VIC (0=text, 1=graphics)
      0     cRAM block seen by processor

### Cartridge Auto-start Headers

See C128 PRM p.472.


VIC-20
------

    Addr   Size Description
    ---------------------------------------------
    $E000   8K  KERNAL
    $C000   8K  BASIC
    $A000   8K  Cartridge ROM (BLK5); may contain autostart signature
    $9C00   1K  IO 3
    $9800   1K  IO 2
    $9400   1K  Color RAM
    $9000   1K  Internal VIA ports
    $8000   4K  Character ROM
    $6000   4K  Expansion RAM/ROM BLK3
    $4000   4K  Expansion RAM/ROM BLK2
    $2000   4K  Expansion RAM/ROM BLK1
    $1000   4K  Internal RAM
    $0400   3K  Expansion RAM area (/RAM1, /RAM2, /RAM3 lines enable)
    $0200   2p  KERNAL and BASIC working area
    $0000   2p  Zero page, stack

Carts may put ROM only in $2000-$7FFF, in which case they require a
`SYS` to start (e.g., Scott Adams adventures).

In the KERNAL/BASIC working area, $33C-3FF ($C4/194 bytes) is the
cassette tape buffer, free for other purposes when not using the
cassette.

The character ROM's four 1K blocks are:
$8000 graphics, $8400 reversed graphics, $8800 text, $8A00 reversed text.

The screen and BASIC memory areas vary based on the size of RAM
expansion beyond the on-board 5K. `bstart` marks the start of BASIC
RAM (text), `screen` the 512 bytes of screen RAM, and `color` the 512
bytes (nybbles, actually?) of color RAM. This setup is not done for
autostart carts.

    Addr    0K        3K        8K+
    ------------------------------------
    $9600   color     color
    $9400                       color
    $1E00   screen    screen
    $1200                       bstart
    $1000   bstart              screen
    $0400   -         bstart    -

References:
- [_VIC-20 Programmer's Reference Guide_][v20-prg]:
  - Memory map: pp.114 et seq.
  - BASIC memory formats, pp.119-122.
  - KERNAL/BASIC RAM locations: pp.170 et seq.
  - KERNAL routines: pp.183 et seq.
  - KERNAL startup: p.211
- DenialWIKI [Memory Map][dw-memmap]
- Zimmers.net [`/pub/cbm/src/vic20/`][z-src-vic20] has ROM disassemblies.


<!-------------------------------------------------------------------->
[64w-bank]: https://www.c64-wiki.com/wiki/Bank_Switching
[64w-maxmap]: https://www.c64-wiki.com/wiki/Commodore_MAX_Machine#Memory_map
[6510]: http://archive.6502.org/datasheets/mos_6510_mpu.pdf
[c64servman]: https://archive.org/details/C64-C64C_Service_Manual_1992-03_Commodore
[max]: https://www.floodgap.com/retrobits/ckb/secret/ultimax.html
[rc 5715]: https://retrocomputing.stackexchange.com/a/5715/7208
[vic-ii]: https://www.cebix.net/VIC-Article.txt

[map128]: https://archive.org/details/Compute_s_Mapping_the_Commodore_128

[dw-memmap]: https://sleepingelephant.com/denial/wiki/index.php?title=Memory_Map
[v20-prg]: https://archive.org/details/VIC-20_Programmers_Reference_Guide_1983_Commodore_fourth_printing
[z-src-vic20]: http://www.zimmers.net/anonftp/pub/cbm/src/vic20/
