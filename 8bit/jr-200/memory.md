National/Panasonic JR-200 Memory and I/O
========================================

Much of this from [[Reunanen]].

### Overall Memory Map

    $e000   8K  BIOS ROM
    $d800   2K  Cartridge area (if $D800=$7E, BIOS jumps there on boot)
    $d000   2K  Character set ROM (Reunanen says "VRAM" on diagram?)
    $c800   4K  I/O area
    $c000   4K  VRAM
    $a000   8K  BASIC ROM (disabled via "!kill" signal on expansion bus)
    $8000   8K  unmapped
    $0000  32K  RAM

### i/o map

    $c081 r     Last key pressed (no key-up information)

### video RAM Map

    $d800
    $d000  2K   character bitmaps
    $c800  4K   I/O area
    $c500  3p   character colors
    $c400  1p   ???
    $c100  3p   character positions
    $c000  1p   ???

The alternate area for character bitmaps (color cell bit 6 set to 1) is
$C000. This overlaps with the character position and colour maps, but it
looks like you can use the two ??? pages above for alternate character
bitmaps.

### ram map

    $0800   BASIC program start address
    $07ff   default stack

    $016f   ╲
    $0152   STICK(1) data
    $0151   STICK(1) data
    $0150   32-byte keyboard buffer / STICK(0) data

    $0116₂  keyboard buffer pointer
    $0114₂  (?) xfer buffer from 1544
    $010e₂  user hook: 1 second timer
    $010c₂  user hook: 0.1 second timer
    $010a₂  user hook: unknown
    $0108₂  user hook: unknown
    $0106₂  user hook: unknown
    $0104₂  IRQ ┐
    $0102₂  SWI  user-provided interrupt handlers; $0000 = unused
    $0100₂  NMI ┘

    $  FF   ┐
       │    Looks unused, from glancing at a dump in the monitor.
    $  D0   ┘
    $  CF   ┐
       │    Bits appear to be used here and there.
    $  3A   ┘
    $  39   ┐
       │    Sound generation data; see [Reunanen].
    $  2c   ┘
    $  2b   Tape load speed: 0=2400 bps  1=600 bps
    $  2a   ┐
       │    ???
    $  0e   ┘
    $  0d   Unhandled keypress counter, other 1544 comm purposes
    $  0c   ┐
       │    Unused?
    $  08   ┘
    $  06 ₂ 16-bit 1-second down counter
    $  05   8-bit 0.1 second down counter running from 10 to 1
    $  04   8-bit 0.1 second down counter
    $  03   ┐
    $  02   Direct kbd/joystick call data area.
    $  01   ┘
    $  00   Key click ($0=off, $40=on) (JP: $C0=on, $80=off?)



<!-------------------------------------------------------------------->
[Reunanen]: http://www.kameli.net/marq/?page_id=1270
