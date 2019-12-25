Hitachi BASIC Master
====================

[ja Wikipedia page][wj-bm]. No en Wikipedia page.

The MB-6880 was the first "home" computer (i.e., not a dev board)
released in Japan, and Hitachi the first to move from ｢ﾏｲｺﾝ｣ to
｢ﾊﾟｰｿﾅﾙｺﾝﾋﾟｭｰﾀｰ｣ terminology. The series with the PC-8001 and MZ-80,
was considered part of the [パソコン御三家][osanke] until around 1980,
when it became comparatively less popular (eventually to be replaced
by Fujitsu FM?). The release at the end of 1981 (after the Jr.) of the
PC-6001 etc. spelled the end of home user popularity.

6800 models all had monochrome 32×24 (768 bytes) text and 64×48
character-based "graphics":

- Basic Master __MB-6880__ (1978-09): 0.75 MHz, ROM/RAM 16K/4K.
  300 bps cassette.
- Basic Master Level 2 __MB-6880L2__ (1979-02): ROM/RAM 16K/8K.
  BASIC adds floating point.
- Basic Master Level 2 II __MB-6881__ (1980): ROM/RAM 16K/16K.
- Basic Master Jr. __MB-6885__ (1981): ROM/RAM 18K/16K (63.5K).
  Smaller case; VRAM for 256×192 b/w graphics. ROM upgrade increased
  cassette speed to 1200 baud. Peripherals:
  - MP-9785 adds expanded RAM (64K?) allowing full RAM address space
    excepting I/O area.
  - MP-1710 Color Adapter (on expansion bus) allows 8-color graphics.
  - MP-1803/MP-3370 3" floppy controller/drive. (MA-5380 Disk BASIC.)

6809 Models (predate FM-8):

- Basic Master Level 3 __MB-6890__ (1980-05): 1 MHz. 640×200 b/w,
  320×200×8. 600 bps cassette; optional floppies.
- Mark II __MB6891__ (1982-04):
- Mark 5 __MB6892__ (1983-04): Programmable character generator.

Non-composite video output may also be available.

Cassette is 300/1200 baud Kansas City standard. 1200 baud and program
auto-start added in ROM update for Jr.; see p.162.

References:
- [MB-6885 ﾍﾞｰｼｯｸﾏｽﾀｰJr.][ar-bmj] system manual.
- [Basic master Jr.][rash] specs and tech. info

Emulators:
- [日立ベーシックマスターJr.エミュレータ bm2][emu-bm2]
- [マーク５エミュレータ(MARK5 Emulator)][emu-mk5]
- [6800IDE][emu-6800ide]: Windows-based 6800 IDE/emulator


Connectors
----------

[Basic Master Jr.][ar-bmj]:
- ビデオ1 (RCA): Composite output
- ビデオ2 (DIN-8 270°):
- カセット (DIN-6): Supports 2 units?
- Printer: 36-pin mini-ribbon
- Expansion: 50-pin mini-ribbon (color video adapter, etc.)


Usage Notes
-----------

### Keyboard

- `BREAK` interrupts a running BASIC program, otherwise does nothing.
  `カナ記号+BREAK` resets the machine.
- Modifier (シフト) keys. Also hold to slow printouts, from least to most.
  - `英数`: Tap to enter mode for left keytop letter.
  - `英記号`: Hold for top keytop symbol.
  - `カナ`: Tap to enter mode for bottom keytop kana.
  - `カナ記号`: Hold for right keytop symbol.

### BASIC

Characteristics:
- Use `$FF`/`$FFFF` notation for hex input; `HEX(n)` for conversion to
  16-bit unsigned int.
- FP numeric range is approx 3e-329 to 1.7e38.
- Variables have 1-2 letter names.
- Arrays are 1-based, only 1 or 2 dimensions.
- High-res graphics not supported by Level 2 BASIC.

Character codes:
- Chart on p.47. Block graphics, greek/math, ASCII through `z`,
  graphics, kana, kanji, grahpics.
- Char codes <16 control screen, cursor, etc.
  - For ROM glyphs 0-15 print `CHR$(1)` followed by code.
  - $04: cursor home (doesn't work?)
  - $07: bell
  - $08,$09,$10,$11: cursor left, right, down, up
  - $0C: clear screen and home cursor
  - $0E: shift-out; swap text/background color
  - $0F: shift-in; cancel above?
  - $7F: move cursor back; rubout previous char

Commands:
- Use `,`, not `,` to separate args to `LIST`.
- `SEQ n,k` to auto-generate line numbers at which to type.
- `RESEQ n,k` to renumber existing lines. Destroys numbering.

Etc.
- `A$=INKEY$` returns `A$<CHR$(1)` on no input.
- Supports `DEF FNF(P)=…`.
- `MUSIC ﾄﾚﾐ` to play do-re-me. (p.81)
- `POKE addr,v0,v1,…`

I/O support (p.83) includes user-level drivers, e.g. `OPEN
log,phy,"name",drv`. _log_ is the logical device number chosen by the
programmer. _phy_ is the physical device: 1=screen, 2=keyboard, 3=CMT1
out, 4=CMT1 in, 5=CMT2 out, 6=CMT2 in, 7-15=user devices. For 7-15
specify a driver with the _drv_ parameter. (_phy_ 7-15 without a third
parameter gives `ERROR 6`.)

The _drv_ parameter is the address of the data block for the driver,
e.g., `$5000`. This is a 9-byte block of three `JMP` (`$7E`)
instructions to the open, I/O and close routines. See p.87 for an
example of this with JMP to an RTS (`$39`) for open/close and to
`$F00C` for I/O which is some sort of `MUSIC` thing? Also example on
p.104 using $E200 (jump tables to $E224, $E280, $E217) and several
examples using $E209 (JMP $E271, $E169 and start of actual routine at
$E20F).

pp.100- has info on saving machine-language code along with BASIC (or
separately?) using some $F682 routine (maybe monitor ML load/save?)
Looks like they `DIM` an array first thing for the space, and look up
top of BASIC variable area from $08/$09 (default $3FFF).

Beyond that 

### Monitor

Type `MON` or `MONITOR` at BASIC prompt.

Enter aborts the current command, even if you've typed something.
Space enters the current input, or keeps the default value if you've
entered nothing. Many commands start their own input mode.

    E   Escape (jumps to BASIC; cold start)

    R   Register display/change
    D   Display 128 bytes of memory
    M   edit Memory (can also view byte-by-byte; seems to confirm writes)
    F   Fill memory
    T   Transfer (copy) memory

    G   Go (seems to be a trace command or something like that?)
    B   create breakpoint
    S   Step

    L   Load from tape
    P   Punch to tape
    V   Verify tape


Basic Master Jr. Machine Infomation
-----------------------------------

### Memory Map (p.124)

    $0000-$00FF  Zero page; system stuff?
    $0100-$03FF  Screen RAM
    $0400-$3FFF  BASIC workspace
    $0900-$20FF  VRAM page 1
    $2100-$38FF  VRAM page 2
    $4000-$AFFF  Empty or RAM expansion
    $B000-$DFFF  BASIC ROM
    $E000-$E7FF  ﾌﾟﾘﾝﾀｰ ROM (MT-2 OS for 1200 baud cassette?)
    $E800-$EDFF  I/O (external)
    $EE00-$EFFF  I/O (internal devices)
    $F000-$FFFF  Monitor ROM
    $FFF8-$FFFF  IRQ/SWI/NMI/reset

BASIC Memory:
- Work area $400-$9FFF.
- Program text starts at $0A00, grows up.
- Variable space starts at $3FFF, grows down.
- `SIZE` to show program top/variable bottom/remaining space between.
- Each lines is two bytes lineno, one byte size-2, size bytes text/tokens.

Monitor memory (p.159): $00-$0C, $28-$4A contain monitor and system
vectors etc.

### I/O

    $E890   rw  Tile color (MP-1710)
    $E891   rw  Background color (MP-1710)
    $E892   rw  Monochrome/color setting (MP-1710)
    $EE00   r   stop tape (read 2x)
    $EE20   r   start tape
    $EE40    w  Screen reverse: $00=normal $FF=reverse
    $EE80   rw  tape I/O
    $EEC0   rw  keyboard
                bits 7-4: カナ記号, カナ, 英記号, 英数
                bits 3-0: key code strobe setting
    $EF00   r   timer
    $EF40   r   "unknown/$30"
    $EF80   r   "unknown/$FF"
    $EFE0    w  screen mode
                $00: text
                $40: text + graphics page 1 (flickers massively)
                $4C: text + graphics page 2
                $C0: graphics page 1
                $CC: graphics page 2

### Hi-res (256×192) Graphics

(pp.114 et seq.) Two pages of 256×192 monochrome graphics starting at
$0900 and $2100. Bits 7-0 set pixels from left to right; 32 bytes per
row and 6144 bytes per page. See I/O above for screen mode switch.

ROM routines:
- `$E37E`: Move BASIC program text start from $0A00 to $2200.
- `$E383`: Move BASIC program text start to $3A00 (1.5K left!)
- `$E38D`: Zero page 1.
- `$E39C`: Zero page 2.

### Vectors

    $FFF8   IRQ         $F04D
    $FFFA   SWI         $F0FF
    $FFFC   NMI         $F07A
    $FFFE   reset       $F15F

### ROM Routines (p.160)

- `$0028` ASCIN: calls CHRGET
- `$002B` ASCOUT: calls CHROUT
- `$002E` BYTIN
- `$0031` BYTOUT

- `$B000`: BASIC warm start; keeps program text but kills var space
  (but not DIMs; these are now broken!).
- `$C000`: BASIC cold start

- `$F003 ADDIXB`: (IX) ← (IX) + (ACCB)
- `$F009 MOVBLK`: copy memory: $3B (MSTTOP) start addr, $3D (MSTEND)
  end addr, $3F (CPYTOP) destination.
- `$F00F KBIN`: Carry set if no key down, otherwise carry clear and
  char of key (modified by shift codes) in ACCA.
- `$F012 CHRGET`:

XXX more to fill in.



<!-------------------------------------------------------------------->
[ar-bmj]: https://archive.org/details/Hitachi_MB-6885_Basic_Master_Jr/
[osanke]: https://ja.wikipedia.org/wiki/8ビット御三家
[rash]: http://fuckin.rash.jp/wikihome/index.cgi/p6?page=Basic+Master+Jr.
[wj-bm]: https://ja.wikipedia.org/wiki/ベーシックマスター

[emu-6800ide]: http://www.hvrsoftware.com/6800emu.htm
[emu-bm2]: http://ver0.sakura.ne.jp/pc/index.html#bm2
[emu-mk5]: http://s-sasaji.ddo.jp/bml3mk5/
