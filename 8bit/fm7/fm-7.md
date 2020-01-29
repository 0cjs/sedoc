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


Parallel Printer Interface
--------------------------

(SS:1-39)


Expansion Interfaces
--------------------

Option slots ×2 (SS:1-55): Internal. 32 pins, 2×16 .1" female. These
bring out only 8 bits of address, so there must be some decoding going
on there. (Perhaps it's the $FD00 page?) They also offer ±12V power.
Only interrupt is /IRQ (and /RESET).

Z80 Card Slot (SS:1-64): Internal. 40-pins, 2×20 .1" female. For just
this slot an additional clock, `Φ`, is generated from `Q⊕E` (XOR).
There's also a `W̅A̅I̅T̅` signal used to halt the Z80 when the 6809 is
running and vice versa; a flipflop (on `D0`, address unknown) switches
between the two (also switching on/off bus buffers on each MPU),
qualified by `BA` and `BS`. (Someone's also made an 8088 card for
this.)

    A- 1  AB0       B- 1  DB0
       2  AB1          2  DB1
       3  AB2          3  DB2
       4  AB3          4  DB3
       5  AB4          5  DB4
       6  AB5          6  DB5
       7  AB6          7  DB6
       8  AB7          8  DB7
       9  AB8          9  Z80 Φ
      10  AB9         10  /RESET
      11  AB10        11  /IRQ
      12  AB11        12  /NMI
      13  AB12        13  GND
      14  AB13        14  GND
      15  AB14        15  /FIRQ
      16  AB15        16  E
      17  Z80W        17  +5V
      18  BS          18  /REFCK
      19  BA          19  +5V
      20  RW          20  Q

Expansion (拡張) Connector (SS:1-56): External on back. 50 pins, 2×25
.1" male. Looking into the connector on the back, pin 1 is at the
upper right; below is looking outward from the system unit.

     1  /RESET       2
     3               4  /IOREL
     5  /IRQ         6  D0
     7  /NMI         8  D1
     9  /FIRQ       10  D2
    11              12  D3
    13  BA          14  D4
    15  BS          16  D5
    17              18  D6
    19              20  D7
    21              22  /EXTDET
    23  R/W̅         24  GND
    25  GND         26  A0
    27  A1          28  A2
    29  A3          30  A4
    31  A5          32  A6
    33  A7          34  A8
    35  A9          36  A10
    37  A11         38  A12
    39  A13         40  A14
    41  A15         42
    43  /MRDY       44
    45  +5V         46  +5V
    47  Q           48  GND
    49  E           50  GND



<!-------------------------------------------------------------------->
[fm7assem]: https://archive.org/details/FM7MC6809ASM
[fm7sysspec]: https://archive.org/details/FM7SystemSpecifications
[fm7w-hw]: http://www23.tok2.com/home/fm7emu/ysm7/ysm72/ysm72.htm#TOP
[fm7w-mmap]: http://www23.tok2.com/home/fm7emu/ysm7/ysm7d/ysm7d.htm
[lgreen]: http://www.nausicaa.net/~lgreenf/fm7page.htm
