Small Stand-alone Displays
==========================

For video display information, see [`8bit/video`](../8bit/video.md).


ST7066 Controller
-----------------

Used for many different LCD displays of typ. 1-2 lines, 8-20 chars/line (>8
chars/line requires extension driver chip), 5×8 and 5×10/5×11 matrix
support. Some controllers suport 20 chars × 4 lines, which fits into 80
bytes but you lose scrolling support (or maybe scrolls just rotate the
display lines).

[ST7066] has many compatible controllers inc. KS0066U, [HD44780U], SED1278.
See [[flcd-st7066]] for comparisons and programming information.

Specs:
- 4/8-bit parallel interface.
- Some controllers offer SPI, too.
- 5×8 and either 5×10 or 5×11 character cells supported.
- DDRAM (Display data RAM): 80 bytes. (Usu. 1-2 rows; some controllers 4.)
  RAM unused for display can be used as general data RAM.
- CGROM stores built-in charset. 236-240 chars, most 5×8 dot, 32 5×11 dot.
  - CGRAM charsets may be different, esp. between Japan and US/Europe.
- 64-byte CGRAM allows custom characters: 8 for 5×8 cells, 4 for 5×10/11.

Pins:
- `GND`
- `Vcc`: typ. range 2.7 – 5.5 V, but varies w/controller.
- `RS`: Register select:
  - 0 = instruction register (write) and address counter (read)
  - 1 = data register (write/read)
- `R/W̅`: 0=write 1=read. Many applications wire this low and guess the delays.
- `E`: enable, high starts write/read
- `DB4-7`: high-order data pins, r/w/tristate. `DB7` can be used for busy flag.
- `DB0-3`: low-order data pins; not used for 4-bit operation.

Resets at power-on, with busy flag on for 150-450 ms. Reset state is
display clear, 8-bit interface, 1 line display, 5×8 font,
display/cursor/blinking off, entry mode inrement and no shift. But see
datasheet for init procedure; seems more complex than just starting to use
it.

The address counter determines where in the internal display RAM the next
byte will be written, and is incremented after ever write. Some commands
can reset it. The blinking cursor, if enabled, displays at the address
counter position.

The display RAM itself starts at a head position that can be set by the
user (default 0). The second line starts 40 bytes after the head position,
regardless of the display's line length.

Different commands have different execution times. Always read busy
flag before sending commands, or use a _lot_ of delay (maybe much more
than the datasheet gives for command execution times).

Instruction register write commands (binary, x=ignored):
- `0000.0001`: Clear display (all DRAM ← $20; addr ← $00)
- `0000.001x`: Return home (preserve DRAM; addr ← $00)
- `0000.01ds` Entry mode set
  - `d` addr/cursor auto-inc direction: 0=increment, 1=decrement
  - `s` display shift: 0=off, 1=on (in direction of `d`)
- `0000.1dcb`: Display on/off
  - `d` display:      0=off 1=on
  - `c` cursor:       0=off 1=on
  - `b` cursor blink: 0=off 1=on
- `0001.sdxx`: Cursor or display shift
  - `s` select cursor/screen: 0=cursor shift 1=display shift
  - `d` direction: 0=left 1=right. Cursor follows display shift.
- `001d.nfxx`: Function Set
  - `d` data length: 0=4-bit 1=8-bit
  - `n` lines: 0=1 line display, 1=2 line display
  - `f`: font: 0=5×8, 1=5×11
- `01aa.aaaa`: Set CGRAM Address
- `1aaa.aaaa`: Set DDRAM address
  - 1-line mode: $00-$4F
  - 2-line mode: $00-$27 line 1, $40-$67 line 2

Reading the instruction register returns busy flag (1=busy) in b7, and
b6-b0 are the current address.

Data register writes write to same RAM (CGRAM or DDRAM) as most recent set
address instruction, with location auto-incrementing (per entry mode) from
Reads work the same way. (Reads not valid without a previous addr set
instruction; also many other not completely understood caveats.)

Character sets (codes are ASCII except where indicated otherwise):

    Codes 7066-0A       7066-0B
          (Japan)       (Europe)
    ────────────────────────────────────────────────────────────────────
    $00   CG RAM
    $08   (repeated)
    $10   blank         spec.punct.
    $20   punctuation
    $30   nubmers/punct.
    $40   upper case
    $60   lower case
    $80   blank         EU chars
    $A0   katakana      EU chars
    $E0   greek/etc.    greek/syms
    $FF   black block   inv."P" block

### 1602A Display

16×2 LCD w/backlight.
Contacts on board edge, pin 1 furthest from centre of board.

    │  1   2  3  4   5  6 7  8  9  10 11 12 13 14 15 16                  │
    │ GND Vcc Vo RS R/W̅ E D0 D1 D2 D3 D4 D5 D6 D7  A  C                  │

- 3 `Vo`: voltage input for for contrast control. ??? voltage 0 - Vcc?
- 15 `A`, 16 `C`: anode and cathode for backlight

### Vishay LCD-020N004L

[Datasheet.][vishay] 20×4 LCD (5×8 cells) w/backlight.



<!-------------------------------------------------------------------->
<!-- ST7066 -->
[ST7066]: https://www.sparkfun.com/datasheets/LCD/st7066.pdf
[flcd-st7066]: https://focuslcds.com/character-lcd-controller-compatibility-st7066/
[HD44780U]: https://www.sparkfun.com/datasheets/LCD/HD44780.pdf

<!-- ST7066 Displays -->
[vishay]: https://www.vishay.com/docs/37314/lcd020n004l.pdf
