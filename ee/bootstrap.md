Bootstrapping a CPU
===================

Aside from the obvious way of programming a ROM:

- Microcontroller holds CPU in reset while it loads RAM or programs EEPROM.
  Various implementations can be found in the links below.
- CPLD has a tiny amount (usu. 32-64 bytes) of ROM programmed into it that
  loads bootstrap from first sector of CF card. Plasmo's [CRC65] extends
  this slightly to load instructions from serial port of CF card has no
  bootstrap on it.
- On reset read instructions from USB to parallel FIFO (FT240X or FT245R):
  ["Z80 EEPROM Programmer"][ecstatic], [plasmo's Prog65, a ROM-less
  6502-based EPROM programmer][prog65]. See more notes below.
- Dr Jefyll, [Ultra-minimal 3-wire Interface boots up 65xx CPUs][f6 5231].
  Based on a similar scheme for the Z80. Microcontroller with only three
  outputs (so actually 4-wire, with GND): CLK, a chip enable/reset
  combination, D7 and pull-down resistors on the rest of the data bus.
  Extremely complex.
- Various threads and posts in forum.6502.org:
  - [Bootloader terminology][f6 6756]
    - [plasmo's post][f6 p86618] to the above has two for 6502 and four
      more for other CPUs
  - [Bootstrapping an SBC][f6 1526]


USB Parallel FIFO Boot
======================

Typical devices: [FT240X], [FT245RN].

Boot can be done by decoding a USB FIFO into the boot address space
($0000〜 on Intel, $FFFD-$FFFE and where it points to on Motorola) so that
the CPU reads from the FIFO and is held in a wait state when data are not
available. Load up FIFO with boot vector (Motorola only) followed by
instructions to execute.

Startup control for read can work in several ways:
- Switch that sets boot address space to ROM or FIFO. [[prog65]]
- Check the FIFO switch to FIFO mapping if data is available from it. (May
  interfere with use of FIFO as a console port if there's still data there
  on reset.) This could be done by:
  - Default to ROM mapping and code in ROM checks FIFO and changes mapping.
  - Flip-flop that inits to FIFO mapping if data present and has disable
    input to force ROM mapping from that point on. [[ecstatic]]

FT245R breakout board pinout. Timings from §3.5, §3.6, pp.11-12 of datasheet.
- `VCCIO` ×2:  not clear relationship w/USB power input, 3V3/5V jumper, and
  chip VCCIO, 3V3OUT→ and VCC pins.
- `GND` ×2
- `D0`-`D7`↔
- `NC`, `NC`
- `RST#`: Active low; unconnected or Vcc pull-up if not required.
- `PWREN#`→: low after dev configured by USB host; high on suspend. Suggest
  connect to external pMOSFET. Should be pulled to VCCIO w/10kΩ?
- `TXE#`→: When high, do not write FIFO. When low, data available.
- `RXF#`→: When high, do not read FIFO. When low, data available.
- `WR#`←: Write data byte on D0-7 to FIFO on ↓.
  - Set up data 20 ns before ↓. Min 50 ns pulse. TX# inactive min. 80 ns.
    after write cycle.
- `RD#`←: Low enables current FIFO data byte on D0-7; ↓ fetches next byte
  from FIFO.
  - Min pulse width 50 ns. Data valid 20-50 ns after low. Min. 130 ns
    between up and down again (RXF# not active for min. 80 ns).
- Above is basic protocol; also available are sync and async bit-bang
  modes, programmable EEPROM, etc.

For [prog65][] ([schematic][prog65-sch]):
- `PWREN#`, `TXE#` have only 4k7 pull-ups. (No flow control for write.)
- `RXF#`:
  - Connected directly 6502 /IRQ line (4k7 pull-up). 
    (Used for terminal mode; guess initial boot must immediately do `SEI`.)
  - Connected to UP1 on DPDT switch pole C1.
- DPDT switch:
  - C1 Up=buffered/inverted `TXE#`; connects to 6502 `RDY`.
  - C2 Down=N/C.
  - C2 Up=GND; inverted to ROM `O̅E̅` entirely disabling ROM read.
  - C2 Down=A14,n inverted to ROM `O̅E̅` for $C000-$FFFF enable.
- `RD#` From inverter, in turn from 3-input NOR of 6502 signals
  (all the following logic results must be low):
  - `R/W̅` NAND `RDY`: both must be high
  - `A15` NAND `ϕ2`: both must be high
  - C2 must below: from GND in prog mode, A14 in run mode.
    (T1/JUMP3 same connections, but why? Must be left unjumpered.)

On the [ecstatic] the input to Z80 `W̅A̅I̅T̅` is not just inverted `RXF#`, but
it's OR'd with `RD#` (the latter driven by Z80 `R̅D̅` and the "chip select"
synthesized for the FIFO) so that if `RXF#` goes high during the read cycle
the CPU will not be halted until the read cycle is complete. though
according to the datasheet, `RXF#` is never released until `RD#` is
released, so this doesn't seem to be necessary. (Timing on 240X is same as
245.)


<!-------------------------------------------------------------------->
[CRC65]: https://www.retrobrewcomputers.org/doku.php?id=builderpages:plasmo:crc65
[f6 1526]: http://forum.6502.org/viewtopic.php?f=6&t=1526
[f6 5231]: http://forum.6502.org/viewtopic.php?f=4&t=5231
[f6 6756]: http://forum.6502.org/viewtopic.php?f=4&t=6756
[f6 p86618]: http://forum.6502.org/viewtopic.php?f=4&t=6756#p86618

<!-- USB Parallel FIFO Boot -->
[FT240X]: https://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT240X.pdf
[FT245RN]: https://ftdichip.com/wp-content/uploads/2022/07/DS_FT245RN.pdf
[ecstatic]: https://www.ecstaticlyrics.com/electronics/Z80/EEPROM_programmer/
[prog65-sch]: https://www.retrobrewcomputers.org/lib/exe/fetch.php?media=builderpages:plasmo:6502:prog65:prog65r2:prog65_rev1_scm.pdf
[prog65]: https://www.retrobrewcomputers.org/doku.php?id=builderpages:plasmo:6502:prog65:prog65r2:prog65r2home
