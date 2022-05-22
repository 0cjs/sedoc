Commodore Emulators
===================

#### Contents

- [VICE](#VICE): The Versatile Commdore Emulator
- [MAME/MESS](#MAME--MESS): Computer/console/arcade system emulator
- [ROMs](#ROMs): ROM images for Commodore machines
- [Disk, Tape and Cartridge Images](#disk-tape-and-cartridge-images)

VICE
----

[VICE] \([manual][viceman]) emulates all CBM models and has a
menu-driven interface for all options.

Windows versions usually come with ROMs; for Linux you need to
download and install them yourself. The ROMs have names like `basic`
and `kernal` and are installed into the `C64/`, `DRIVES/` etc.
subdirectories under `/usr/lib/vice/` or `~/.vice/`. See the "ROMs"
section below for more details.

### Key Mappings

Both symbolic (PC `"` gives `"`) and positional (Shift-2 gives `"`)
are supported, as well as user mappings.

The docs are incomplete, but the default mapping files can be found on the
local filesystem (under `/usr/share/vice/MACHINE/*.vkm` on Debian) or
online: [`C64/gtk3_sym.vkm`].

    Key         C64         PLUS4
    ───────────────────────────────
    CTRL        CtrlL       CtrlL
    C=          Tab         Tab
    RUN/STOP    Esc         End
    HOME/CLR    Home        Home
    RESTORE     PgUp        n/a
    £           \           \
    ←           _           `
    π           ~¹          ~
    ───────────────────────────────
    ¹ inconsistent behaviour on x64: sometimes π, sometimes ←

For F2/F4/F6/F8 use those keys; you may need to use SHIFT as well.

### Startup

- `-console`: Suppresses video display window. (Used for for music
  playback, emulator test programs.)

#### Files Interfaces

A `.prg` file contains a (little-endian) load address in the first two
bytes followed by data, usually a BASIC program or assembler code. With
`LOAD "…",8,n`, _n_=0 will load at the default BASIC start address ($801)
and _n_=1 will use the file's load address.

Tape and disk images may be explicitly attached at startup with `-1
foo.t64`  and `-[8|9|10|11] foo.d64`.

An image or `.prg` file given on the command line without an option (`x64
foo.prg`) is treated as `-autostart foo.prg`. This loads data or attaches
an image and injects appropriate `LOAD` and `RUN` commands (as if `-keybuf`
had been used) to start it. The exact behaviour can be tweaked with the
[Autostart command-line options (§6.3.2)][vm-autostart]; preceeding an
option with `+` instead of `-` will usually invert its sense.

The way the data are brought into memory depends on the autostart mode,
which will be the last-used mode for that file type unless overridden with
`-autostartprgmode N`:
- 0: VirtualFS: ??? (fails with `.prg`, same as 2 for `.d64`)
- 1: Inject: Read `.prg` file data directly into memory.
- 2: Disk image: Create a disk image (in-memory?) containing the `.prg`
  file and `LOAD "*",8,1` (at file-specified address).

Options:
- `-autoload <file>`: Suppress `RUN` command.
- `-autostartwithcolon`: Append `:` to `RUN` command; `+` to invert.
  Not clear how this is helpful since a CR still seems to be appended
  before a `-keybuf` string is injected.
- `-autostart <file>`: Same as just _file_.
- `-basicload`: Suppress secondary LOAD param `,1` (i.e., `LOAD "*",8:`) to
  load at standard BASIC text start address $801 as with `,0`. Invert with
  `+` to force `,1` to load at file-specified address.
- `-autostartprgdiskimage <file.d64>`: Applicable to `.prg` only. Create an
  on-disk copy of the generated disk image. Not removed after VICE exits.
  Forces mode 2 (disk image).
- `-autostart-warp`: Enable wrap mode during autostart (for faster loads);
  invert with `+` to disable.
- `-autostart-delay FRAMES`

You may also inject your own keyboard commands at startup with `-keybuf
STR`. Add further delay with `-keybuf-delay N` if necessary.


MAME / MESS
-----------

[MESS], an emulator for consoles and computer systems, was merged
based on the MAME (an arcade machine emulator) core. It was merged
into MAME on 2015-05-27.

Harder to set up.


ROMs
----

The C64 has three ROMs, and the disk drives have their own as well.
VICE and MAME use different names for these:

     SIZE   VICE        MAME                Notes
     8192   basic       901226-01.u3
     8192   kernal      901227-03.u4
     4096   chargen     901225-01.u5
      245               906114-01.u17       PLA
    16384   dos1541
     8192               325302-01.uab4      dos1541 lower half
     8192               901229-06 aa.uab5   dos1541 upper half MAME default
     8192               901229-02.uab5      dos1541 upper half (older?)

The 1541 ROM `901229-06 aa.uab5` file that MAME loads by default does
not match the top half of the VICE `dos1541` ROM image I have but an
alternate top-half image `901229-02.uab5` does. Probably not
important.

For MAME, install in the `c64/` and `c1541/` subdirectories of a ROM
directory. Check the output of `mame c64 -showconfig` for paths or use
the `-rompath` option. You can verify the ROMs are all present and
correct with `-verifyroms`.


Disk, Tape and Cartridge Images
--------------------------------

- The [D64 image format documentation][d64] also explains the original
  media.

### VICE

Images can be attached from the command line with, e.g., `x64 -8
disk1.img -9 disk2.img` or from the status line menu in the emulator.
When attached the image is cached in memory, so you must detach it
before reading or writing it with an external program such as `c1541`.

#### c1541

[c1541] is a stand-alone program distributed with VICE that
manipulates Commodore disk and tape (`.t64`) images in the same way as
can be done within VICE emulators. The usual format/extension for
image files is [`.d64`][vm-d64], even for VIC-20s; this actually
specifies the [image format][vm-imgfmt]:

    x64         64-byte header followed by another format, usually d64
    d64         VC1541/2031
    g64         VC1541/2031 but in GCR coding
    d71         VC1571
    g71         VC1571 but in GCR coding
    d81         VC1581
    d80         CBM8050
    d82         CBM8250/1001

Run without command-line arguments it will enter an interactive mode.
Command line usage is:

    c1541 [img₁ [img₂]] [command ...]

If _img_ arguments are provided before commands, these will be
attached as "drives" 8 and 9, respectively. Commands given on the
command line are the same as in interactive mode except that they are
prefixed with a hyphen. The `help` command or `-help` argument will
print a summary of commands.

Disks have a 16-character disk name and two-character disk ID; both
of these default to spaces when specified as comma-separated empty
strings in a format command:

    c1541 -format , d64 disk.d64

Other commonly used commands are:

    c1541 disk.d64 -dir [pattern]
    c1541 disk.d64 -write pcr.prg pcr       # Copy file to image
    c1541 disk.d64 -read pcr pcr.prg        # Extract file from image
    c1541 disk.d64 2.d64 -copy pcr @9       # Copy between images
    c1541 disk.d64 -tape file.t64           # Copy tape image to disk

    #   Below given as in interactive mode
    attach name                     # additional param is optional unit number
    rename foo 'foo bar'
    delete foo
    block <track> <sector>          # Dump disk block in hex and ASCII


See also the [Disk Drive Commands][doscmd] used from BASIC.

### diskamge.c

[diskimage.c] is an ANSI C library for manipulating Commodore disk images.
The last release was 0.95 on 2006-04-25, and it seems unmaintained since
2009-01-11.

It supports `.D64` (single-sided 1541, ignores error info), `.D71`
(double-sided 1571) and `.D81` (.35" 1581, root directory only).

The operations are open/read/write/close file (`$` reads directory),
delete/rename file, format disk, and allocate/deallocate sector.



<!-------------------------------------------------------------------->
[MESS]: https://en.wikipedia.org/wiki/Multi_Emulator_Super_System
[`C64/gtk3_sym.vkm`]: https://sourceforge.net/p/vice-emu/code/HEAD/tree/trunk/vice/data/C64/gtk3_sym.vkm
[c1541]: http://vice-emu.sourceforge.net/vice_13.html
[d64]: http://unusedino.de/ec64/technical/formats/d64.html
[diskimage.c]: https://paradroid.automac.se/diskimage/
[doscmd]: https://www.c64-wiki.com/wiki/Commodore_1541#Disk_Drive_Commands
[vice]: http://vice-emu.sourceforge.net/index.html
[viceman]: http://vice-emu.sourceforge.net/vice_toc.html
[vm-autostart]: https://vice-emu.sourceforge.io/vice_6.html#SEC46
[vm-d64]: http://vice-emu.sourceforge.net/vice_16.html#SEC308
[vm-imgfmt]: http://vice-emu.sourceforge.net/vice_16.html#SEC294
