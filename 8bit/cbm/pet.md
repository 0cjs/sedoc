PET
===

Models:
- (1977) __2001-4, 2001-8__ 4/8 KB SRAM; calculator keyboard, white 9"
  display, 2×6520, 1×6522, BASIC 1.0, graphics/business charsets swapped in
  ROM.
- (1979) __2001-N8, 2001-N16, 2001-N32__ 8/16/32 KB DRAM (8K soon dropped),
  business keyboard, green 9" display, no CMT, BRK enters monitor.
- BASIC 2.0?
- __3008, 3016, 3032__ European rename to avoid Phillips PET trademark
  issue.
- BASIC 4.0 in later 3000 models.
- (1980) 4000 series.
- __Commodore PET 600__ (Handic, nordic countries) relabeled 8296.
  Separable keyboard (like 8032-SK/8086-SK). 128K RAM.


ROM Versions
------------

Three versions (per [pi-roms]):

1. Original (16k@`$c000`): Power-up is `*** COMMODORE BASIC ***`.
   Very broken; IEEE-488 doesn't work. BASIC `peek` cannot read out
   ROM values.
2. Upgrade (16k@`$c000`): Power-up is `### COMMODORE BASIC ###`.
   Also known as "2.0" or "3.0." Fixes bugs (varying by specific
   version) and adds machine code monitor.
3. 4.0 (20k@`$b000`): Power-up is `*** COMMODORE BASIC 4.0 ***`.
   Adds disk commands. Faster GC.

The 2k@`$e000` is the screen editor ROM, deals with keyboard scan and
screen I/O. Differs for Business vs. Graphics keyboard and with or
without CRTC. Nationalized versions may include additional code in
3.75k@`$e900`.

2k character ROM is not in CPU's address space. Inverted chars are not
stored in ROM; instead ROM bits are XOR'd.


Addresses
---------

Memory map, from [SJ Gray's PET/CBM Editor ROM Project][editrom]:

    $f000    4k   KERNAL
    $e000    4k   Editor and I/O (see below)
    $b000   12k   BASIC 4                               ┐ >64K RAM
    $a000    4k   Option ROM #2                         ┘ banks 2/4
    $9000    4k   Option ROM #1 (or external diag clip) ┐ >64K RAM
    $8000    4k   Screen RAM + empty                    ┘ banks 1/3
    $0000   32k   RAM

I/O map, from [`petmem.txt`][petmem]:

    $e900    7p   Mirrors of below or ROM, depending on system
    $e880   32b   CRTC on systems that have it
    $e840   16b   VIA
    $e820    4b   PIA 2
    $e810    4b   PIA 1

The 8096 adds four 16k banks ([PET index - 8x96][pi-8x96]). Blocks 0
and 1 map into `$8000` and blocks 2 and 3 map into `$c000`, controlled
by a write-only register at `$fff0`, write `1` to enable:

    7   Enable
    6   I/O peek-through $e800-$efff
    5   Screen peek-through $8000-$8fff
    4   Reserved
    3   Select  0=block 2  1=block 3
    2   Select  0=block 0  1=block 1
    1   Write protect $c000 block (does not protect peek-through)
    0   Write protect $8000 block (does not protect peek-through)



<!-------------------------------------------------------------------->
[editrom]: http://www.6502.org/users/sjgray/projects/editrom/
[petmem]: http://www.classiccmp.org/dunfield/pet/petmem.txt
[pi-8x96]: http://www.6502.org/users/andre/petindex/8x96.html
[pi-roms]: http://www.6502.org/users/andre/petindex/roms.html
