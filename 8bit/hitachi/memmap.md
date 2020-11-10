Basic Master Jr. Memory Map, ROM, etc.
--------------------------------------

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
