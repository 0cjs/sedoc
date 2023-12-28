ROM Emulators
=============

#### emurom

[Home page][emurom], [GitHub repo][emurom-g]. Includes [PDF
schematic][emurom-s], PCB layouts (main board w/24,28 pin headers, two
daughterboards for sockets).

- Host: ATmega328P, MCP2221 for USB
- Memory: 61512 SRAM (64K)
- Host/mem address: 2× '595 shift registers
- Host/mem data: ATmega PIO
- Host control: '157
- Host/target switching: 3× '244 octal tri-state buffers
schematic, PCB

[emurom-g]: https://github.com/jtsiomb/emurom
[emurom-s]: http://nuclear.mutantstargoat.com/hw/emurom/emurom-schematic.pdf
[emurom]: http://nuclear.mutantstargoat.com/hw/emurom/
