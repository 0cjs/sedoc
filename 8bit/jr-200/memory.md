National/Panasonic JR-200 Memory and I/O
========================================

Much of this from [[Reunanen]].

### Overall Memory Map

    $e000   8K  BIOS ROM
    $d800   2K  Cartridge area (if $D800=$7E, BIOS jumps there on boot)
    $d000   2K  Character set VRAM (loaded at boot)
    $c800   4K  I/O area
    $c000   4K  Character and attribute VRAM
    $a000   8K  BASIC ROM (disabled via "!kill" signal on expansion bus)
    $8000   8K  unmapped
    $0000  32K  RAM

### I/O map

    $c081 r     Last key pressed (no key-up information)

### Video RAM Map

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

### RAM Map

    $0800   BASIC program start address
    $07FF   default stack

    $016F   ╲
    $0152   STICK(1) data
    $0151   STICK(1) data
    $0150   32-byte keyboard buffer / STICK(0) data

    $01FF   ┐
       │    Unused by BIOS.
    $01E0   ┘
    $01DF   ┐
       │    Buffer for BIOS read line routine ($E927)
    $018E   ┘
    $016F   ┐
       │    Ring buffer for BIOS keyboard scan routine (filled by IRQ handler)
    $0140   ┘

    $0116₂  keyboard ring buffer input pointer
    $0114₂  keyboard ring buffer output pointer
    $010E₂  user hook: 1 second timer
    $010C₂  user hook: 0.1 second timer
    $010A₂  user hook: unknown
    $0108₂  user hook: unknown
    $0106₂  user hook: unknown
    $0104₂  IRQ ┐
    $0102₂  SWI  user-provided interrupt handlers; $0000 = unused
    $0100₂  NMI ┘

    $  FF   ┐
       │    Looks unused, from glancing at a dump in the monitor.
    $  E0   ┘
    $  DF   ┐
       │    Possibly used by tape routines.
    $  D0   ┘
    $  CF   ┐
       │    Bits appear to be used here and there.
    $  46   ┘
    $  45   prb_quiet: non-0 suppresses some print routines
    $  44   ┐
       │    Bits appear to be used here and there.
    $  3A   ┘
    $  39   ┐
       │    Sound generation data; see [Reunanen].
    $  2C   ┘
    $  2B   Tape load speed: 0=2400 bps  1=600 bps
    $  1C   tmp2 ─┐
    $  1A   tmp1  temporary storage not used across BIOS calls
    $  18   tmp0 ─┘
    $  0D   keyboard ring buffer fill count
    $  0C   ??? (related to keyboard)
    $  0B   nmi_enabled: 0=NMI handler returns immediately
    $  0A   curlin (lower 5 bits: 0-23)
    $  09   curcol (lower 5 bits: 0-31)
    $  08   ??? (related to printing)
    $  06 ₂ 16-bit 1-second down counter
    $  05   8-bit 0.1 second down counter running from 10 to 1
    $  04   8-bit 0.1 second down counter
    $  03   ┐
    $  02   Direct kbd/joystick call data area.
    $  01   ┘
    $  00   Key click ($0=off, $40=on) (JP: $C0=on, $80=off?)



<!-------------------------------------------------------------------->
[Reunanen]: http://www.kameli.net/marq/?page_id=1270
