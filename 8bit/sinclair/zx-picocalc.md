zx-picocalc ZX Spectrum Emulator
================================

The ohm69's [zx-picocalc] for Clockwork PicoCalc is a port of antirez's
[zx2040] for Pico RP2040, which is in turn a port of the floooh's [chips]
generic C code.

`.z80` files should be saved into `/zxspectrum/` on the SD card.
This is allegedly good for "smaller" games only, at the moment.

### Controls

The bootloader ([uf2loader]) loads straight in to whatever's loaded into
Flash. Holding down `↑`/`F1`/`F5` at power-up brings up the bootloader
menu. (Holding `F3` enters BOOTSEL mode.)

Emulator Control Keys:
- `Esc`: Enter/exit menu
- `↑ ↓ ← →`: select parameter, change parameter
- `Enter`,`F5/Fire`: Load game and exit menu.

ZX Spectrum Control Keys (S: is Spectrum key):
- `↑ ↓ ← → F5`: Kempston joystick emulation
- `F1`: Edit        (S:Shift-1)
- `F2`,`Tab`: Extend Mode (S:Shift-Symbol Shift)
- `F3`: ←           (S:Shift-5)
- `F4`: →           (S:Shift-8)
- `F6`: Graphics    (S:Shift-9)
- `F7`: Caps Lock   (S:Shift-2). Separate from Pi CapsLK.
- `F8`: True Video  (S:Shift-3)
- `F9`: Inv Video   (S:Shift-4)
- `Del, Back`: Delete (S:Shift-0)
- `Shift-↑`/`Shift-↓`: ↑ (S:Shift-6), ↓ (S:Shift-7)
- `0`–`9` `A`–`Z`: Standard keywords, letters, symbols.
- `Shift` (green): PicoCalc shifted (green) characters, lowercase letters.
- `Ctrl`: ZX Shift (lowercase letters, white symbols)
- `Alt`: Symbol Shift: symbols and red keywords.

An Atari-style joystick can be connected to the GPIO ports:
- GP2–GP5: left/right/up/down (P3,4,1,2)
- GP21: fire (P6)
- GND: (P8)



<!-------------------------------------------------------------------->
[chips]: https://github.com/floooh/chips/
[uf2loader]: https://github.com/pelrun/uf2loader
[zx-picocalc]: https://github.com/ohm69/zx-picocalc
[zx2040]: https://github.com/antirez/zx2040
