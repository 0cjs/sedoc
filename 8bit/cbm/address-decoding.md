CBM Address Decoding (Memory Maps)
==================================


MAX Machine
-----------

[Memory map][max-map]:

    $E000   8K  -           8K Kernal/BASIC/charROM for Mini and Max Basic
    $D000   4K  I/O
    $C000   4K  -
    $A000   8K  -
    $8000   8K  -           8K BASIC ROM for Max Basic
    $1000  28K  -
    $0800   2K  -           Cartridge RAM
    $0400   1K  screen RAM
    $0200   ½K  RAM         Mini Basic working RAM; Max Basic system area
    $0100   ¼K  RAMStack
    $0000   ¼K  Zero page

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


<!-------------------------------------------------------------------->
[6510]: http://archive.6502.org/datasheets/mos_6510_mpu.pdf
[max-map]: https://www.c64-wiki.com/wiki/Commodore_MAX_Machine#Memory_map
