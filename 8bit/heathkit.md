Heathkit Computers
------------------

Heathkit H8
-----------

Base unit was a PSU, 50-pin backplane (pins numbered 0 through 49!), front
panel, and CPU card with monitor program (PAM) in ROM. An 8K (4K populated)
static RAM card had to be purchased separately.

The backplane was two inline sets of 25-pin .1" male headers; the cards had
female connectors on them; there's a slight space between the connectors.
The PSU provided unregulated ±18 V and +8 V; each board had its own
regulators.

### Front Panel

Four LEDs, nine (three groups of three digits) 7-segment displays, a 16-key
keypad and a header for the speaker (which is actually at the back of the
case near the PSU).

LEDs:
- `ION`: EI signal (interrupts enabled)
- `MON`: port 0260 ($B0) bit 5 set written in last 2 ms.
- `RUN`: M1 signal (200 ns) stretched to 4.7 μs by a one-shot.
•- `PWR`: lit by +8V power bus

The 7-segment displays were in three groups of three; two marked "ADDRESS"
and the last marked "DATA/REGISTER".

The original (8080) and Z80 keypad layouts:

    8080                                 Z80 (†=RADIX key)
    ┏━━━━━━━┯━━━━━━━┯━━━━━━━┯━━━━━━━┓    ┏━━━━━━━┯━━━━━━━┯━━━━━━━┯━━━━━━━┓
    ┃       │       │       │       ┃    ┃SI     │LOAD   │DUMP   │NEXT   ┃
    ┃   7   │   8   │   9   │   +   ┃    ┃   7   │   8   │   9   │   A   ┃
    ┃     SI│   LOAD│   DUMP│       ┃    ┃     IR│    AF'│    BC'│+   DE'┃
    ┠───────┼───────┼───────┼───────┨    ┠───────┼───────┼───────┼───────┨
    ┃DE     │HL     │PC     │       ┃    ┃GO     │IN     │OUT    │LAST   ┃
    ┃   4   │   5   │   6   │   -   ┃    ┃   4   │   5   │   6   │   B   ┃
    ┃     GO│     IN│    OUT│       ┃    ┃     HL│    IX │    IY │-   HL'┃
    ┠───────┼───────┼───────┼───────┨    ┠───────┼───────┼───────┼───────┨
    ┃SP     │AF     │BC     │       ┃    ┃PRI  47│SEC  67│RDX† 37│CANCEL ┃
    ┃   1   │   2   │   3   │   *   ┃    ┃   1   │   2   │   3   │   C   ┃
    ┃       │       │       │ CANCEL┃    ┃174  AF│270  BC│274  DE│*      ┃
    ┠───────┼───────┼───────┼───────┨    ┠───────┼───────┼───────┼───────┨
    ┃       │REG    │MEM    │ALTER  ┃    ┃BOOT 17│REG    │MEM    │ALTER  ┃
    ┃   0   │   .   │   #   │   /   ┃    ┃   0   │   F   │   E   │   D   ┃
    ┃       │       │  RTM/0│  RST/0┃    ┃170  SP│.    PC│# RTM/0│/ RST/0┃
    ┗━━━━━━━┷━━━━━━━┷━━━━━━━┷━━━━━━━┛    ┗━━━━━━━┷━━━━━━━┷━━━━━━━┷━━━━━━━┛

No hardware debouncing. Hardware used an AND gate on some keys to generate:
- `0`+`/`: RESET
- `0`+`#`: /INT10 (re-entered monitor via RST1)

2.048 MHz bus clock used for:
- 2048 divider: 1000 Hz square wave ANDed with port 0360 ($F0) bit 8 and sent
  to speaker.
- 4096 divider: front panel-generated 2 ms clock interrupt. Sets flip-flop
  which is ANDed with port 0360 ($F0) bit 6 to assert /INT10.

The front panel board was offset from the backplane with 2× 25-pin cables
to connect to the backplane and an additional 5-pin cable to the CPU board
(carrying `/INT20`, `/IE`, `/INT10` and `RESIN`).

Ports (also see [[wallace]]):
- 0260 ($B0):
  - bit 5 W: enables `MON` LED when written; automatically disabled after 2 ms.
- 0360 ($F0):
  - bit 7: speaker enable (1000 Hz tone).
  - bit 6: enable /INT10 every 2 ms.
  - bit 4: single-step enable (/INT20 two M1 cycles after interrupts enabled;
    automatically deasserted two M1 cycles after interrupts disabled).
  - bits 3-0 W: 7-segment display select (enabled with write to this and next
    port; each display all-segments disabled automatically after 2 ms).
- 0361 ($F1):
  - bits 7-0 W: 7-segment display segment enable bits

### CPU Cards

Original 8080:
- 8080A processor, 8224 clock generator, 8228 system controller.
- 8-input priority encoder to convert eight interrupt lines to RSTn instr.
- ROMS (EPROM?):
  - 444-13: 2708, original PAM-8
  - 444-60: 2716, PAMGO (requires mods)
  - 444-70: 2716, XCON (mods, including ROM disable mod)

HA-8-6 Z80:
- All XCON enchancements.
- Significantly different interrupt circuitry.
- Much more at [[wallace]].

### Other Cards

- H8-1 Memory Board: 8K static RAM (4K populated)
- H8-2 Parallel Interface: three 8-bit interfaces (i8255?).
  For paper tape reader/punch, line printer, etc.
- H8-3 Chip Set: 4K static RAM chips (for H8-1 expansion)
- H8-5 Serial I/O and Cassette Interface.
  - Header for cable to back panel for RS-232 and current loop.
  - Two RCA jacks on card for CMT in/out.
  - Header for CMT motor relay.

### Peripherals and Media

- H8-13: 1200 baud auto cassette
- H8-14: Fan-fold paper tape
- HM-800: Manual set (hardware, assembly, software)
- H10: Paper tape reader/punch
- H10-2: Three 8" dia rolls paper tape (min 900 ft)
- H10-3: Three boxes fan-fold paper tape (approx 100 ft)

### Monitor Usage

For full details see [[pam8]] and [[wallace]].

On reset/init, PAM-8 determines the top of memory and sets SP to that. PAM-8
uses the 2 ms front panel clock interrupt to check for some keyboard commands,
check for user program breakpoints and to refresh the front panel displays.
Thus, user programs must maintain a valid stack pointer into RAM and front
panel services are not available when interrupts are disabled.

The monitor runs in two modes:
- Monitor mode: MON light is on, no user program is running, and all front
  panel commands are available except RTM.
- User mode: MON light is off and user program is running. The display will
  continue to be updated if interrupts are enabled (e.g., if you were last
  displaying the register or memory contents, this will be updated every
  2 ms with any changes). Only RTM and RST commands are valid. This uses
  about 10% of the computer's resources.
- In user mode with interrupts disabled the RTM command will not work and
  you can only break out of this by resetting the machine with RST.

Address entry and display is in offset octal (separate groups per byte),
i.e., 377.377 for $FF. Entering 4-7 for high digit just drops 9th bit.

The keypad has 1-char/second autorepeat (particularly useful with `+`/`-`).
Keypad keystrokes are verified with a short beep. Medium beeps indicate
data entry complete, and long beeps indicate error.

Monitor mode has three sub-modes:
- Command: Executes the command given at the lower right (Z80: upper left)
  of the keypad. Also allows switching to ???.
- Memory: entered from command mode with the `MEM` key.
- Register: entered from command mode with the `REG` key.

- `0`+`/`: RST ("master clear")
- `0`+`#`: RTM (return to monitor): generates an INT10 via hardware,
  executing an RST1 instruction.
- `MEM`: enter memory address mode (all decimal points light) and enter six
  digits of address. All decimal points clear, address and current value at
  that address displayed. Any non-octal key during address entry signals an
  error (long beep) and aborts memory entry mode.
- `+`/`-`: Increment/decrement current address.
- `* CANCEL`: Cancel input.
- `ALTER`: Enter memory alter mode indicated by decimal point rotating
  thorugh all nine digits. Type three octal digits, beep indicates data
  were accepted and address is incremented, ready to accept another value.
  In ALTER mode, `+`/`-` will increment/decrement address. Leave ALTER mode
  with `ALTER`, `MEM` or `REG`.
- `REG`: Select register for display. Six decmial points light and register
  is chosen by marking on key (1-6, marked on upper left). Here `ALTER`
  will alter the register value instead of memory; exits are the same as
  `ALTER` above. `SP` is display-only and cannot be altered from front
  panel (run SPHL instruction instead).


### References

- David Wallace, [H-8 Technical details][wallace]. Bus pinouts, card
  descriptions.
- [Heathkit Catalog, Fall 1977][hk77]
- Heath, [Front Panel Monitor PAM-8][pam8], 1979.



<!-------------------------------------------------------------------->
[hk77]: https://heathkit.garlanger.com/catalogs/1977/Heathkit_Catalog_817.pdf
[pam8]: https://bitsavers.org/pdf/zenith/z89/595-2348_H8_Front_Panel_Monitor_PAM-8_1979.pdf
[wallace]: https://web.archive.org/web/20110723052102/http://davidwallace2000.home.comcast.net/~davidwallace2000/h8/technical.htm#z80%20cpu
