Sharp Address Decoding
======================

Ctrl-RESET or `#` in IPL/Monitor will boot RAM? XXX [[ssm] p.5]

MZ-700 version; probably applies to all of the MZ-80K series.
VRAM is static RAM; all other ram is DRAM.


    F000        Floppy controller ROM
    E800        Expansion ROM
    E000        I/O keyboard and timer ports (to $E400? or just 9 bytes?)
    D800    2k  VRAM color data
    D000    2k  VRAM character data (2 pages, 50 lines)
    ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
    D000        DRAM to $FFFF when paged in, otherwise as above
    ───────────────────────────────────────────────────────────────────────
    1200  47½k  DRAM system and text area.
    1000   .5k  DRAM monitor work area.
    ───────────────────────────────────────────────────────────────────────
    0000    4K  ROM/DRAM: ROM at startup.

### Expansion ROM

External devices may provide ROM at $E800, which will be started
automatically by the IPL ROM. Expansion ROM at $F000 is started with the
`F` command. (MZ-700)

### Memory Banking Control

The MZ-700 CRTC and memory controller are in a custom LSI (M60719).
[[ssm] p. 8 P.9] This generates `INH1` through `INH3` signals controlled
via I/O ports $E0 through $E8; send any output to these to set. These
determine the mapping of the two changable banks. [[ssm] p.7 P.8]

    D000 - FFFF     INH2: 0=DRAM 1=VRAM, 8255 keyboard PPI, 8253 timer I/O
    1000 - CFFF     ───── always DRAM ─────
    0000 - 0FFF     INH1: 0=DRAM 1=ROM

Port writes:

    E0: INH1=0 (low DRAM)   E1: INH2=0 (high DRAM)  E4: INH3=0 (no access?)
    E2: INH1=1 (low ROM)    E3: INH2=1 (high VRAM   E6: INH3=1 (prev state?)

    E4: INH1=1 INH2=1 INH3=1 (reset state)

### I/O Ports

    Port   IO   Description
    ────────────────────────────────────────────────────
    E0-E6   o   memory banking control (see above)

Memory mapped I/O:

    8255 PPI:
      E000  PA  output: 0-3=keyboard strobe, 7=cursor blink timer reset
      E001  PB  input: 0-7 from keyboard
      E002  PC  output: 0=unused
                        1=WDATA  CMT data write
                        2=INTMSK timer interrupt disable
                        3=M-ON   motor rotate control
                input:  4=MOTOR  motor rotation check
                        5=RDATA  CMT data read
                        6=556OUT cursor blink timer input
                        7=VBLNK  vertical blank sense
      E003  control

    8253 Timer:
      E004  C0  mode 3 square save rate generator
      E005  C1  mode 2 rate generator
      E006  C2  mode 0 terminal counter
      E007  control

    LS367 Hex Bus Drivers, 3-State:
      E008  tempo, joystick, HBLNK input



<!-------------------------------------------------------------------->
[som 127]: https://archive.org/details/sharpmz700ownersmanual/page/n128/mode/1up?view=theater
[ssm]: https://archive.org/details/sharpmz700servicemanual/page/n7/mode/1up?view=theater
