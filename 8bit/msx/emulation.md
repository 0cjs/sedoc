MSX System Emulation
====================

[openMSX][omsx] ([Wikipedia][wp], [GitHub][gh]) seems to be the best
emulator out there currently, and the only one that supports control by an
external process.

Documentation:
- [openMSX manuals][man]
- [openMSX Setup Guide][setup]
- [openMSX User's Manual][userman]
- [openMSX Console Command Reference][cmdref]
- [Diskmanipulator][dm]

### Default Key Bindings / MSX Key Mappings

The [default MSX key mappings][keymap] are as follows.
Note that on MSX the STOP key pauses output; Ctrl-STOP does a break.

    MSX key             PC          Mac
    CTRL                L-Ctrl      L-Ctrl
    dead (accent) key   R-Ctrl      R-Ctrl
    GRAPH               L-Alt       L-Alt
    CODE/KANA           R-Alt       R-Alt
    取消 (cancel)       L-Win
    実行 (execute)      R-Win
    SELECT              F7          F7
    STOP                F8          F8
    INS                 Insert      Cmd-I

In the BASIC screen editor, Ctrl-R will also execute the toggle insert mode
function.


Setup
-----

Installation:
- Debian and Ubuntu Linux:
  - Install: `sudo apt-get install openmsx`
  - ROM images go in `~/.openMSX/share/systemroms/`.
- Windows:
  - Install: download using links at left-hand side of [home page][omsx].
  - ROM images go in `C:\Users\<username>\Documents\openMSX\share\systemroms\`.

For copyright reasons, openMSX comes with the open-source C-BIOS ROM.
This does not include BASIC (and often has other compatibility issues)
and so can't be used to run this game. ROM images for other machines
can be downloaded from [`file-hunter.com`][srom].

Suggested machines for testing (MSX2):
- [`Sony_HB-F1XD`][f1xd]: ROM images `hb-f1xd_*.rom`.
- [`Panasonic_FS-A1F`][fs-a1f]: ROM images `fs-a1f_*.rom` and
  `Panasonic_FS-A1F_DA1024D0365R.rom`. Slow startup, and starts at a menu,
  but this might be fixed with a switch setting.

Typical startup for a manually run machine, mounting the contents of
`disk/` as the internal drive, is: `openmsx -machine Sony_HB-F1XD -diska
disk/`. `F10` will bring up the console for configuration and management.
See User's Manual [2. Starting the Emulator][starting] for more details.

Neither of these include FM sound, but an FM-PAC cart can be added with
[`ext fmpac`][ext]; this requires `fmpac.rom` from the [extension
ROMs][erom].

#### Selected Console Commands and Settings

The console has case-sensitive tab-completion and a `help` command.

    machine MACHNAME            # Set emulation to a particular machine.
    toggle fullspeedwhenloading # For faster loads from disk
    reset                       # reset computer
    diska DIR                   # Set disk directory; may also be .dsk image

#### External Control

See [Controlling openMSX from External Applications][control]. 

Sample session, with lines prefixed by `»` typed by the user:

    » $ openmsx -machine Sony_HB-F1XD -control stdio
      <openmsx-output>
    » <openmsx-control>
    » <command>set renderer sdl</command>
      <reply result="ok">sdl</reply>
    » <command> set power on</command>
      <reply result="ok">true</reply>
    » <command>exit</command>
      <reply result="ok"></reply>
      </openmsx-output>
      $


Other Emulators
---------------

- [blueMSX][bl wp] Windows-only. Seems to be dying or dead; last release
  was 2009 and the `bluesmx.com` site is gone.
- [fMSX][fm wp]. Little known about this?
- Many others [listed in the MSX FAQ][msxnet].


<!-------------------------------------------------------------------->
[cmdref]: https://openmsx.org/manual/commands.html
[dm]: https://openmsx.org/manual/diskmanipulator.html
[gh]: https://github.com/openMSX/openMSX
[keymap]: https://openmsx.org/manual/user.html#keyboard
[man]: http://openmsx.org/manual/
[omsx]: https://openmsx.org/
[setup]: https://openmsx.org/manual/setup.html
[userman]: https://openmsx.org/manual/user.html
[wp]: https://en.wikipedia.org/wiki/OpenMSX

[erom]: https://download.file-hunter.com/System%20ROMs/extensions/
[f1xd]: https://msx.org/wiki/Sony_HB-F1XD
[fs-a1f]: https://msx.org/wiki/Panasonic_FS-A1F
[srom]: https://download.file-hunter.com/System%20ROMs/machines/

[control]: https://openmsx.org/manual/openmsx-control.html
[ext]: https://openmsx.org/manual/commands.html#ext
[filepool]: https://openmsx.org/manual/commands.html#filepool
[starting]: https://openmsx.org/manual/user.html#starting

[bl wp]: https://en.wikipedia.org/wiki/BlueMSX
[fm wp]: https://en.wikipedia.org/wiki/FMSX
[msxnet]: https://faq.msxnet.org/msxemu.html
