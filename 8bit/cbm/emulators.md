Commodore Emulators
===================

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

The docs are incomplete, but [`gtk3_sym.vkm`] has the full standard
mapping.

#### C64 Symbolic Mappings

    Commodore   PC
    ---------------------
    CTRL        Tab
    C=          Left-Ctrl
    STOP/RUN    Esc
    CLR/HOME    Home
    RESTORE     PgUp

For F2/F4/F6/F8 use those keys; you may need to use SHIFT as well.


MAME
----

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



<!-------------------------------------------------------------------->
[`gtk3_sym.vkm`]: https://sourceforge.net/p/vice-emu/code/HEAD/tree/trunk/vice/data/C64/gtk3_sym.vkm
[vice]: http://vice-emu.sourceforge.net/index.html
[viceman]: http://vice-emu.sourceforge.net/vice_toc.html
