Basic Master Jr. Memory Map, ROM, etc.
--------------------------------------

Page numbers refer to the [MB-6885 ﾍﾞｰｼｯｸﾏｽﾀｰJr.][ar-bmj] system manual.

### General Memory Map (p.124)

    $0000-$00FF  Zero page; system stuff?
    $0100-$03FF  Screen RAM (text mode)
    $0900-$20FF  VRAM page 1 (graphics mode)
    $2100-$38FF  VRAM page 2 (graphics mode)
    $4000-$AFFF  Empty or RAM expansion
    $B000-$DFFF  BASIC ROM
    $E000-$E7FF  プリンター ROM (MT-2 OS for 1200 baud cassette?)
    $E800-$EDFF  外部 I/O (expansion devices)
    $EE00-$EFFF  システム I/O (internal devices)
    $F000-$FFFF  Monitor ROM
    $FFF8-$FFFF  IRQ/SWI/NMI/reset

The address ranges with available RAM depend on the amount of memory in the
system, whether it's in text or graphics mode, and which ROMs are
enable/disabled. The first three modes below give the BASIC work area (text
and variables; see below) presumably $400-$9FF is also used by the
interpreter for housekeeping, stack etc.

    Mode                  16K RAM                 64K RAM
    ────────────────────────────────────────────────────────────────
    Text                $0A00 $3FFF  13,824     $0A00 $AFFF  42,496
    1-page Graphics     $2200 $3FFF   7,680     $2200 $AFFF  36,352
    2-page Graphics     $3A00 $3FFF   1,536     $3A00 $AFFF  30,208
    BASIC ROM disabled                          $0400 $DFFF  56,320
    Printer ROM diabled                         $0400 $EDFF  59,904
    Monitor ROM disabled                        $0000 $EDFF  and
                                                $F000 $FFFF  65,024

Memory Map Details
------------------

### BIOS (Monitor) Low Memory (p.159):

$00-$71 is the "Monitor work area."

    $00  USRNMI    vector                           $F0C6 (RTI instr.)
    $02  USRIRQ    vector                           $F06E (see below)
    $04  BREAKV    vector for NMI from BREAK key    B:$BB7E M:$F0D0
    $06  TIMERV                                     $F06E
    $08  RAMEND    highest RAM address              $3FFF on 16K system
    $0A  TIME 1,2  16-bit seconds since start
    $0C  TIME 3    0-50; inc. every 1/60 sec

    $28  ASCIN                                      JMP $FA55  ($F012)
    $2B  ASCOUT                                     JMP $F7AB  ($F015)
    $2E  BYTIN                                      JMP $F71F  ($F018)
    $31  BYTOUT                                     JMP $F619  ($F01B)

    $3B  RECTOP,LDTOP,MSTTOP    start of memory block; parameter for
                                CMT write/read and memory move routines
    $3D  RECEND,LDMAX,MSTEND    end of memory block (last byte + 1)
    $3F  CPYTOP
    $41  CPYEND
    $43  FNAME                  filename parameter for CMT write/read routines

Notes:
- $F06E is the exit code in the IRQ routine.
- For JMP addrs, parenthesised number is address in BIOS routine jump table
  starting at $F000.

### BASIC

BASIC uses $72-$FF and $400-$9FF as work area.

BASIC program text starts at $0A00 and grows up. Variable space starts
at top of user program area and, grows down. `SIZE` will show the free
addresses after program end and before variables start, as well as the size
of the free space from the former through the latter. Each BASIC line is
two bytes lineno, one byte size-2, size bytes text/tokens.

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


ROM Routines
------------

### Monitor (BIOS) Subroutines (p.160)


- `$0028` ASCIN: calls CHRGET
- `$002B` ASCOUT: calls CHROUT
- `$002E` BYTIN
- `$0031` BYTOUT


- `$B000`: BASIC warm start; keeps program text but kills var space
  (but not DIMs; these are now broken!).
- `$C000`: BASIC cold start

- `$F000`: Monitor cold entry (clears screen; prints banner)
- `$F003 ADDIXB`: (IX) ← (IX) + (ACCB)
- `$F009 MOVBLK`: copy memory: $3B (MSTTOP) start addr, $3D (MSTEND) end
  addr, $3F (CPYTOP) destination.
- `$F00F KBIN`: Carry set if no key down, otherwise carry clear and char of
  key (modified by shift codes) in ACCA.
- `$F012 CHRGET`: ♠A♡BX clear screen (?), print char in A and flash it,
  wait for character to be typed, then return it.
- `$F015 CHROUT`: ♡ABX print character in A to display



<!-------------------------------------------------------------------->
[ar-bmj]: https://archive.org/details/Hitachi_MB-6885_Basic_Master_Jr/
