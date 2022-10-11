MSX System Emulation
====================

Contents:
- Common Hardware; ROM Sources
- OpenMSX
  - Installation and Setup
  - Invocation
- OpenMSX Usage
  - Key Bindings / MSX Key Mappings
  - Selected Console Commands and Settings
  - External Control
- Other Emulators


Common Hardware; ROM Sources
----------------------------

### ROM Image Sources

- file-hunter.com: [`System ROMs/machines/`][fh srom].
- file-hunter.com: [`System ROMs/extensions/`][fh erom].

### Common Hardware

The names given below for common hardware are the openMSX names (as passed
to `-machine` and `-ext` parameters) except where specified otherwise.
Machine and extension ROMs go in `.openMSX/share/systemroms/`. Options that
use extensions, such as `-diska` on machines without a built-in drive, must
come _after_ the `-ext` option on the command line.

Common MSX2 machines (all have built-in 720K FDD):
- [`Sony_HB-F1XD`][f1xd]
  - ROM: `hb-f1xd_*.rom`.
- [`Panasonic_FS-A1F`][fs-a1f]
  - ROM: `fs-a1f_*.rom`, `Panasonic_FS-A1F_DA1024D0365R.rom`.
  - Slow startup, and starts at a menu, but this might be fixed with a
    switch setting.

Common MSX1 machines (nC = _n_ cartridge slots):
- `Canon_V-8`:          JA 16K 2C.
- `Sony_HB-55P`:        EU 16k 2C.
- `National_CF-2700`:   JA 32k 2C.
- `National CF-3000`:   JA 64k 2C.
- `National CF-3300`:   JA 64k 2C. 360K (1DD) floppy drive.

Accessories:
- FM Sound cartridges:
  - `fmpac` (Panasoft SW-M004 FM-PAC): [`fmpac.rom`][fh erom]
- Floppy Disk Systems:
  - `Sony_HBD-F1` DSDD 3.5" 720K: [`hbd-f1.rom`][fh erom]


OpenMSX
-------

[openMSX][omsx] ([Wikipedia][wp], [GitHub][gh]) seems to be the best
emulator out there currently, and the only one that supports control
by an external process.

Documentation:
- [openMSX manuals][man]
- [openMSX Setup Guide][setup]
- [openMSX User's Manual][userman]
- [openMSX Console Command Reference][cmdref]
- [Diskmanipulator][dm]

### Installation and Setup

Installation:
- Debian and Ubuntu Linux:
  - Install: `sudo apt-get install openmsx`
  - ROM images go in `~/.openMSX/share/systemroms/`.
- Windows:
  - Install: download using links at left-hand side of [home page][omsx].
  - ROM images go in `C:\Users\<username>\Documents\openMSX\share\systemroms\`.

ROM image notes:
- For copyright reasons, openMSX comes with the open-source C-BIOS ROM.
  This does not include BASIC (and often has other compatibility issues)
  and so can't be used to run this game.
- See above for download locations for ROMs.
- There are two directories for ROM images under `~/.openMSX/share/`. In
  both of these filenames are unimportant; ROMs are identified by the SHA1
  of their contents.
  - `systemroms/` for built-in BASIC/BIOS/etc. ROM and devices such as
    sound and floppy controller cards.
  - `software/` is the pool for software cartridges. The appropriate ROM
    will be automatically attached when loading a save state made when a
    cart was inserted.

Share directories (under `~/.openMSX/share/`):
- `settings.xml`: Configuration file; current config saved at emulator exit.
- `systemroms/`, `software/`: ROM files; see above.
- `machines/`, `extensions/`: XML machine and extension definitions.
- `scripts/`, `skins/`: ???

### Invocation

Typical startup for a manually run machine, mounting the contents of
`disk/` as the internal drive, is: `openmsx -machine Sony_HB-F1XD -diska
disk/`. `F10` will bring up the console for configuration and management.
See User's Manual [2. Starting the Emulator][starting] for more details.

Command-line options are console commands as well except where noted; just
Tab completion in the console is usually the best way of finding out what
valid arguments to these options are.

Selected options:
- `-h`, `--help`
- `-v`, `--version`: (Not available in console.)
- `-machine M`: e.g. `-machine Sony_HB-F1XD`
- [`-ext E`][ext]: e.g., `-ext fmpac`.
- `-diska FD`: _FD_ is a file or directory. Directories with more than
  720 KB of files (360 KB for single-sided drives) will print a warning for
  each file dropped due to hitting the size limit.


OpenMSX Usage
-------------

### Key Bindings / MSX Key Mappings

- On MSX the STOP key pauses output; Ctrl-STOP does a break.
- OSD menu also toggled by clicking the upper-left-hand window corner.

The [default MSX key mappings][keymap] are:

    MSX key/Emulator func.  PC          Mac
    ──────────────────────────────────────────────────────────────────────────
    CTRL                    L-Ctrl      L-Ctrl
    dead (accent) key       R-Ctrl      R-Ctrl
    GRAPH                   L-Alt       L-Alt
    CODE/KANA               R-Alt       R-Alt
    取消 (cancel)           L-Win
    実行 (execute)          R-Win
    SELECT                  F7          F7
    STOP                    F8          F8
    INS                     Insert      Cmd+I       (BASIC: also Ctrl-R)
    ──────────────────────────────────────────────────────────────────────────
    Pause emulation         Pause       Cmd+P
    Quit                    Alt-F4      Cmd+Q
    Toggle console          F10         Cmd+L
    Full screen mode        F11         Cmd+F       (PC: also Alt+Enter)
    Audio mute toggle       F12         Cmd+U
    Quick loadstate         Alt+F7      Cmd+R
    Quick savestate         Alt+F8      Cmd+S
    OSD Menu                ≡ (Menu)    Cmd+M       (≡ is next to R-Ctrl)
    Copy screen text        Ctrl+Win+C  Cmd+C
    Paste to MSX            Ctrl+Win+V  Cmd+V
    ──────────────────────────────────────────────────────────────────────────

Bindings are changed with the console [`bind`] and `unbind` commands. On
exit, all current bindings are saved to `.openMSX/share/settings.xml`.

- [`bind`] will show all bindings.
- Modifier names are case-insensitive; combine with key names using `+`.
  `Shift`, `Ctrl`, `Alt`, `Win` (Windows only), `Meta` (Windows key on Linux).
- `bind KEYS,release …` binds a separate action on key release. If combined
  with a modifier, the modifier must be down during release.
- [`keymatrixdown`] and `keymatrixup` are used to generate keyboard input.
  Params are _row_ and _mask_ ([key matrix layouts]), e.g., `7 0x10` for STOP.

Suggested bindings:

    bind Meta+A toggle mute
    bind Meta+N toggle console
    bind Meta+M main_menu_toggle
    bind Meta+P toggle pause
    bind Meta+O set fastforward on
    bind Meta+O,release set fastforward off

    #   STOP key; note that this doesn't doesn't pass modifiers e.g. Ctrl+STOP
    bind Meta+K keymatrixdown 7 0x10
    bind Meta+K,release keymatrixup 7 0x10

### Selected Console Commands and Settings

The console has case-sensitive tab-completion and a `help` command.

    machine MACHNAME            # Set emulation to a particular machine.
    toggle fullspeedwhenloading # For faster loads from disk
    reset                       # reset computer
    diska DIR                   # Set disk directory; may also be .dsk image

### External Control

See [Controlling openMSX from External Applications][control] and the
[openMSX Console Command Reference][cmdref].

Sample session; `»` prefix indicates lines typed by the user:

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

The undocumented `tabcompletion` will return completion information for
external consoles. Examples:

    tabcompletion ""                    «returns all commands»
    tabcompletion osd                   osd  osd_menu::
                                        osd
    tabcompletion "osd "                configure create destroy exists info
                                        osd
    # for command w/o subcommands:
    tabcompletion "volume_control "     volume_control


Other Emulators
---------------

- [blueMSX][bl wp] Windows-only. Seems to be dying or dead; last release
  was 2009 and the `bluesmx.com` site is gone.
- [fMSX][fm wp]. Little known about this?
- Many others [listed in the MSX FAQ][msxnet].



<!-------------------------------------------------------------------->

<!-- Common Hardware; ROM Sources -->
[f1xd]: https://msx.org/wiki/Sony_HB-F1XD
[fh erom]: https://download.file-hunter.com/System%20ROMs/extensions/
[fh srom]: https://download.file-hunter.com/System%20ROMs/machines/
[fs-a1f]: https://msx.org/wiki/Panasonic_FS-A1F

<!-- OpenMSX -->
[gh]: https://github.com/openMSX/openMSX
[wp]: https://en.wikipedia.org/wiki/OpenMSX

<!-- OpenMSX Manuals -->
[`bind`]: https://openmsx.org/manual/commands.html#bind
[`keymatrixdown`]: https://openmsx.org/manual/commands.html#keymatrix
[cmdref]: https://openmsx.org/manual/commands.html
[control]: https://openmsx.org/manual/openmsx-control.html
[dm]: https://openmsx.org/manual/diskmanipulator.html
[ext]: https://openmsx.org/manual/commands.html#ext
[filepool]: https://openmsx.org/manual/commands.html#filepool
[key matrix layouts]: https://map.grauw.nl/articles/keymatrix.php#layouts
[keymap]: https://openmsx.org/manual/user.html#keyboard
[man]: http://openmsx.org/manual/
[omsx]: https://openmsx.org/
[setup]: https://openmsx.org/manual/setup.html
[starting]: https://openmsx.org/manual/user.html#starting
[userman]: https://openmsx.org/manual/user.html

<!-- Other Emulators -->
[bl wp]: https://en.wikipedia.org/wiki/BlueMSX
[fm wp]: https://en.wikipedia.org/wiki/FMSX
[msxnet]: https://faq.msxnet.org/msxemu.html
