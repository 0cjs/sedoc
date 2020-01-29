Fujitsu FM-7 Notes
==================


Specs:
- CPU: 68B09, 2 MHz (8 MHz input clock, switchable to 4.9 MHz)
- Memory: 64K RAM, 32K basic interpreter ROM, 2 KB bootloader ROM
- Video: 68B09 coprocessor (8 MHz input clock, switchable to 4 MHz).
  48 KB "video" RAM, 8 KB CRT code ROM, 2 KB character ROM, +2KB +1KB RAM
- Text: 80×25, 80×20, 40×25, 40×20. 8×8 character cells.
- Graphics: 640x200.
- Colors: 8, not yet clear exactly how they map/are used in above modes.
- Sound: Buzzer, AY-3-8913 Programmable Sound Generator (PSG).
  Internal/external speaker switch. FM synth card option.

Documentation
-------------

- [富士通 FM-7 ユーザーズマニュアル システム仕様][fm7sysspec] (Fujitsu FM-7
  Users Manual System Specification), Fujitsu, 1982. Detailed technical
  information for hardware, timing diagrams, memory maps, I/O ports,
  video/keyboard controller communication, etc. _SS:n-m_ page refrences
  here refer to this.
- [ＦＭ－７ハードウェア回路図][fm7w-hw] has schematics, expansion slot
  connector pinouts.
- [Larry Green's FM-7 page][lgreen] is a useful English resource. It
  includes pinouts for the connectors and (limited) DIP switch
  descriptions.
- [富士通 FM-7 アブソリュートアセンブラ解説書][fm7assem] (assembler manual).


DIP Switches
------------

4-position switch at the right of the computer as viewed from the back.
Numbered 1-4 from left to right; up=ON, down=OFF.

    (1) ROM mode/DISK mode* (FBASIC mode)
    1=ON, 2=ON, 3=OFF
    *when external floppy disk is available

    (2)DOS Mode
    1=ON, 2=OFF, 3=OFF

    CLOCK Freq.
          MAIN CPU   SUB CPU
    4=ON   1.2Mhz    1.0Mhz (FM-8 compatible mode)
    4=OFF  2.0Mhz    2.0Mhz

When set to DOS mode, the FM-7 produces an immediate sustained
beep/tone at startup if no disk controller card is plugged in to the
chassis. If a disk controller card is plugged without drives attached,
the tone will be produced after about 15 seconds.

A pair of the DIP switches can be used to ground boot ROM A9/A10 lines,
which appear to have pullups otherwise. This gives a choice of four
different 480 byte sets of bootcode. The boot ROM C̅S̅ is selected by `AB9 ∧
#FCXX` to enable only during the upper 1/2 KB. (XXX But how do the vectors
get read from RAM?

Per SS:1-25, a flip-flop determines whether the top 31K is mapped to BASIC
ROM (`Q` high) or RAM (`Q` low). Reading `$fd0f` sets the flip-flip
selecting ROM; writing `$fd0f` clears the flip-flop, selecting RAM. At
startup the RESET signal clocks in the `D` input, which is low (selecting
RAM) if either of two DIP switches is open to bring the input low via a NOR
gate; if both are closed `D` will be high selecting ROM.


Memory Map
----------

SS:1-6; see that page for coprocessor memory map. Also see [FM-7 World
memory map][fm7w-mmap].

    $0000   32K  RAM
    $8000   31K  BASIC ROM or RAM
    $fc00  128   RAM
    $fc80  128   Shared RAM (graphics coprocessor)
    $fd00  256   I/O
    $fe00  480   Boot ROM
    $fff0   16   Vector area (ROM? RAM? XXX)

For boot and BASIC ROM select, see "DIP Switches" above.

IO ports: see SS:1-8.

BREAK key sends FIRQ.

F-BASIC firmware BIOS routines: see SS:2-1.


Character Set
-------------

SS:1-31.

    $00-$7f     Standard ASCII¹, but ¥ instead of backslash.
    $80-$8e     Low→high and left→right filled box
    $8f-$9f     Line drawing chars and high and right narrow fills
    $a0         Blank?
    $a1-$df     Japanese punctuation, katakana, dakuten/handakuten
    $e0-$f0     More line drawing, diagonal half-fills, circles, card suits
    $f1-$fd     Kanji: 円年月日時分抄〒市区町村人
    $fe-$ff     Blank?

¹ From the chart on SS:1-31 it's not clear if `$7b` and `$7d` are proper
left/right braces or weird vertical bars. Also not clear about `$7e` tilde.

The graphic, line drawing and kanji glyphs can be entered using the `GRAPH`
key. (SS:1-33)

A Kanji ROM option card is available. It has 256 KB of ROM (4×64 KB)
with 16×16 patterns (40×12 CRT cells) for 2965 JIS level 1 kanji (of
the 6,879 in JIS X 0208, presumably) and 453 non-kanji characters.
Addresses (SS:1-56):

    $FD20 write  ROM address select, high 8 bits
    $FD21 write  ROM address select, low 8 bits
    $FD22 read   ROM data left side 8 bits
    $FD23 read   ROM data right side 8 bits


Video Outputs
-------------

See [DIN Connectors](../hw/din-connector.md) for pin numbering
details. See SS:1-34 et seq. for even more details on video output,
including waveform and timing diagrams and schematics.
- Horizontal sync: 15.75 KHz (16.128 MHz/1024)
- Vertical sync: 60.1145 Hz (15.75 KHz/262)

#### Color CRT: 8-pin DIN 270° (horseshoe, not "U")

All levels below are TTL except for +12 V and ground. All are buffered
through a 7407 (open collector) with a 330 Ω which looks like it might
be a pull-up (but not sure).

    1   +12 V (for TV adapter)
    2   GND
    3   2 MHz video clock (for light pen interface)
    4   horizontal sync signal (TTL or video level?)
    5   vertical sync signal (TTL or video level?)
    6   red
    7   green
    8   blue


#### Monochrome CRT: 5-pin DIN 180°

    1   2 MHz video clock (for light pen interface)
    2   GND
    3   composite video signal
    4   horizontal sync signal (TTL)
    5   vertical sync signal (TTL)

This is generated from the RGB and sync signals above via some gates
and resistor ladders, giving eight steps of lumance from
black/blue/red/magenta/green/cyan/yellow/white. See schematic at
SS:1-37. (This would probably work to turn other digital RGB into
composite.)


Cassette Interface
------------------

8-pin 270° DIN. (SS:1-44)

    1   GND
    2   GND
    3   GND
    4    output (to MIC) (red)
    5    input (from earphone) (white)
    6   Remote (+) (black)
    7   Remote (-) (black)
    8   GND

The tape format (SS:1-45) uses 2400 Hz for `0` and 1200 Hz for `1`,
recorded as `0` start bit, bits 0-7, and `11` stop bits at 1600 bps.

I/O Ports:

    $fd00 bit 0      output high/low
    $fd00 bit 1     Remote relay, `0` = open, `1` = closed
    $fd02 bit 7      input

BASIC
-----

Section-page references below are to [富士通 FM-7 F-BASIC
文法書][fm7basic].

The FM-7 started with V3.0; 1.0 and 2.0 were FM-8 only. ROM BASIC does
not include disk I/O; `LOADM "0:FOO"` will give `Device Unavailable`
and `FILES "0:"`, `Illegal Function Call`. `DSKINI 1` returns `Syntax
Error`.

User program code starts at $0600; all memory below that is reserved
for BASIC.

- Use `&Hnn` for hex numbers; `&Onn` `&nn` for octal.
- Variables are single precision float (`!`) by default `x` and `x!`
  are the same variable. Other other suffixes (`%` integer, `#`
  double-precision FP, `$` string, `#` ??) are separate variables.

Selected system commands:
- `MON` (3-35): Enter a simple monitor; see [ml](ml.md).
- `HARDC` (3-36): Print a hardcopy of the screen.
- `TERM` (3-38): Initiate a connection via serial option board.
- `KEY LIST` (3-145): List function key definitions

Selected display-related commands:
- `WIDTH n,m` (3-104): Set screen width to _n_ (40 or 80) and number
  of lines to _m_ (20 or 25).
- `CONSOLE` (3-105): Set scroll areas and other screen attributes.
- `SCREEN` (3-111): Select VRAM usage.
- `PSET`: Set/clear a point on the screen.

Selected BASIC commands:
- `EDIT n`: Clear screen and edit line _n_ for with `←↓↑→`, `EL` etc.
- `EXEC &Hnnnn`: Execute (JSR?) machine language code at address _nnnn_.
- `DEF FN`



<!-------------------------------------------------------------------->
[fm7assem]: https://archive.org/details/FM7MC6809ASM
[fm7basic]: https://archive.org/details/FM7FBASICBASRF
[fm7sysspec]: https://archive.org/details/FM7SystemSpecifications
[fm7w-hw]: http://www23.tok2.com/home/fm7emu/ysm7/ysm72/ysm72.htm#TOP
[fm7w-mmap]: http://www23.tok2.com/home/fm7emu/ysm7/ysm7d/ysm7d.htm
[lgreen]: http://www.nausicaa.net/~lgreenf/fm7page.htm