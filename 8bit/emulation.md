8/16-bit Platform Emulation
===========================

This file contains generic information; for specific systems also see
`*/emulators.md`. ( [cbm](./cbm/emulators.md), [nec](./nec/emulation.md),
[trs-80](./trs-80/emulation.md), [msx](./msx/emulation.md).)

References:
-  Takeda Toshiya's [Common Source Code Project][cssp] contains many
   emulators for Japanese machines. His [国産マシン エミュレータリスト][tt]
   (Domestic machines emulators list) lists a fuller set of Japanese
   machines and emulators.


ROM Sources
-----------

- archive.org, [[mame-merged]]


RunCPM
------

[RunCPM] emulates a Z80 and CPM 2.2 (or runs real CP/M 2.2) that directly
uses the host filesystem, with options to support TPAs about as large as
possible.

It runs on Posix, MacOS, Windows, large Arduino systems, and some other
microcontroller systems. The API is a bit clunky, and different versions
(built-in emulated CCP vs. various external CCPs, etc.) require different
builds. (This is unlikely to change; see [issue #189][runcpm 189].)

The only dependency is the ncurses library (`libncurses-dev` on Debian).
Build with `(cd RunCPM && make posix build)` (or `rebuild` if any options
have changed).

Directories for the drives _must_ be under the directory in which the
executable resides (no other options are supported) and named
_drive-letter_/_user-area-number,_ e.g., `A/0/`. With the internal BIOS,
BDOS and CCP no files are required to boot, but the A drive user area 0
must exist.

The internal CCP has a built-in `exit` command, otherwise use `EXIT.COM`,
distributed with the emulator in `DISK/A.ZIP` (along with many other tools
and sources).

You can have CP/M 2.2 auto-run programs on boot by placing a `$$$.SUB` file
on your `A` drive. This contains a set of 128-byte records in reverse order
of execution; each record is a byte with the length of the command, the
command itself, and padded out to the end of the 128-byte record.
[[rcse 26080]]


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
[cssp]: http://takeda-toshiya.my.coocan.jp/common/index.html
[tt]: http://takeda-toshiya.my.coocan.jp/list.html

[RunCPM]: https://github.com/MockbaTheBorg/RunCPM
[rcse 26080]: https://retrocomputing.stackexchange.com/a/26080/7208
[runcpm 189]: https://github.com/MockbaTheBorg/RunCPM/issues/189

[mame-merged]: https://archive.org/download/mame-merged/mame-merged/

[mame-comp]: https://docs.mamedev.org/initialsetup/compilingmame.html#debian-and-ubuntu-including-raspberry-pi-and-odroid-devices
[mame-gh]: https://github.com/mamedev/mame
