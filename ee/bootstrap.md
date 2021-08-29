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
  ["Z80 EEPROM Programmer"][ecstatic]. See more notes below.
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

### Read Instructions from USB to Parallel FIFO

Wire up an FT240X or FT245R USB FIFO so that when your microcomputer resets
it checks to see if there's data available in the FIFO and, if so, it
switches from the usual mapping to having all reads in the ROM area instead
read a byte from the FIFO. So basically you send a big chunk of
instructions down the USB, reset the computer, and it starts executing that
pile of instructions you sent down.

Doing flow control to pause the Z80 with its WAIT line may be essential to
this.

[[ecstatic]] uses this to put a little EEPROM programmer program and ROM
data into RAM and then executes that, which programs the EEPROM so that it
boots up with your new code next time you boot. With his scheme you can't
send data from the host to the FIFO without being executed, so you can't
use that as your terminal. But I think it would not be too difficult to
make this mode switchable.



<!-------------------------------------------------------------------->
[CRC65]: https://www.retrobrewcomputers.org/doku.php?id=builderpages:plasmo:crc65
[ecstatic]: https://www.ecstaticlyrics.com/electronics/Z80/EEPROM_programmer/
[f6 1526]: http://forum.6502.org/viewtopic.php?f=6&t=1526
[f6 5231]: http://forum.6502.org/viewtopic.php?f=4&t=5231
[f6 6756]: http://forum.6502.org/viewtopic.php?f=4&t=6756
[f6 p86618]: http://forum.6502.org/viewtopic.php?f=4&t=6756#p86618
