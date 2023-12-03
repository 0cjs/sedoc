MSX Memory Cartridges
=====================


RBSC MultiMapper MSX Cartridge (Flash MegaROM)
----------------------------------------------

Jumpers:
- `PRG`: shorted to prevent programming; open to allow it.
- `K4`, `K5`, `A8`, `A16`: sets cartridge MegaROM emulation mode.
  - `K4`: Konami4 mapper (`FLK4.COM`)
  - `K5`: Konami5 ([SCC]) mapper (`FL.COM`)
  - `A8`: [ASCII8] mapper (`FL8.COM`)
  - `A16`: [ASCII16] mapper (`FL16.COM`)
  - None, or more than one: disabled; all `FL*.COM` programs will say
    "MegaFlashRom not found!"

To program, remove `PRG` jumper and jumper two of the above to disable the
cart. After booting into MSX-DOS, remove one jumper, leaving shorted the
jumper for the mode you want, and run the approprate [FL] program listed
above. Command line is `FL romfile.rom` with optional `/R` to reboot after.
(Use `/E` alone to erase the cart.)

Using an `FL` program that does not match the mapper type chosen will find
the cart and claim to erase successfully (though it may not boot properly
after) but then produce an error when trying to program it. Generally, if
you've done this and it goes into a reset loop on boot, you can change the
type (to `A8`?) and the machine will boot ignoring the ROM.



<!-------------------------------------------------------------------->
[ASCII16]: https://www.msx.org/wiki/MegaROM_Mappers#ASCII16_.28ASCII.29
[ASCII8]: https://www.msx.org/wiki/MegaROM_Mappers#ASCII8_.28ASCII.29
[FL]: https://github.com/gdx-msx/FL/tree/master
[SCC]: https://www.msx.org/wiki/MegaROM_Mappers#Konami.27s_MegaROMs_with_SCC
