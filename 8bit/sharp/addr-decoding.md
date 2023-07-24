Sharp Address Decoding
======================

MZ-700 version; probably applies to all of the MZ-80K series.
VRAM is static RAM; all other ram is DRAM.

    F000        DRAM
    E000        I/O keyboard and timer ports
    D800    2k  VRAM color data
    D000    2k  VRAM character data (2 pages, 50 lines)
    D000        DRAM to $F000 when paged in
    1200  47½k  DRAM system and text area.
    1000   .5k  DRAM monitor work area.
    0000    4K  ROM/DRAM: ROM at startup.

I/O ports:


    ## io   description
    E6  o   $D000-$FFFF uninhibit (?)
    E5  o   $D000-$FFFF inhibit
    E4  o   $0000-$0FFF=ROM, $D000-$FFFF=VRAM/key/timer (reset?)
    E3  o   $D000-$FFFF=VRAM/key/timer
    E2  o   $0000-$0FFF=ROM
    E1  o   $D000-$FFFF=DRAM
    E0  o   $0000-$0FFF=DRAM (write any value)


<!-------------------------------------------------------------------->
[som 127]: https://archive.org/details/sharpmz700ownersmanual/page/n128/mode/1up?view=theater
