8/16-bit Platform Emulation
===========================

This file contains generic information; for specific systems also see
`*/emulators.md`. ( [cbm](./cbm/emulators.md), [nec](./nec/emulation.md),
[trs-80](./trs-80/emulation.md), [msx](./msx/emulation.md).)


MAME
----

Source at [[mame-gh]]. Debian requires the following to build: [[mame-comp]]

    sudo apt-get install git build-essential python3 libsdl2-dev \
      libsdl2-ttf-dev libfontconfig-dev libpulse-dev qtbase5-dev \
      qtbase5-dev-tools qtchooser qt5-qmake

`make` command line variables:
- `-jN`: Parallel builds.
- `REGENIE=1`: Regenerate project files after changing build params, adding
  tools to the compile list, changing system source drivers, etc. Done
  automatically if the `makefile` is touched.
- `TOOLS=1`: Adds tools such as `chdman`.
- `SUBTARGET`, `SOURCES`: Build for subset of supported systems.

### Platforms

`pc8001`:
- v0.251 (Debian 12) has all the versions of the system ROM marked
  `BAD_DUMP` and will refuse to use these (though the internal SHA1 hashes
  are of perfectly fine dumps).



<!-------------------------------------------------------------------->
[mame-comp]: https://docs.mamedev.org/initialsetup/compilingmame.html#debian-and-ubuntu-including-raspberry-pi-and-odroid-devices
[mame-gh]: https://github.com/mamedev/mame
