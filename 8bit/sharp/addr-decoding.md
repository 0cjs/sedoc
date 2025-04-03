Sharp Address Decoding
======================

Holding Ctrl during reset or typing `#` in IPL/Monitor will switch to
all-RAM configuration and jump to location $0000. [[ssm] p.5]

MZ-700 version; probably applies to all of the MZ-80K series.
VRAM is static RAM; all other ram is DRAM.


    F000        Floppy controller ROM
    E800        Expansion ROM
    E000        I/O keyboard and timer ports (to $E400? or just 9 bytes?)
    D800    2k  VRAM color data
    D000    2k  VRAM character data (50 lines, view 25 from any start point)
    ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
    D000   12k  → $FFFF DRAM when paged in, otherwise as above
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

The MZ-700 CRTC and memory controller are in a custom LSI (M60719). [[ssm]
p. 8 P.9] This generates `INH1` through `INH3` signals controlled via
writing to I/O ports $E0 through $E8; send any value to these to set.
These determine the mapping of the two changable banks. [[ssm] p.7 P.8]

The initial state at reset is as $E4 below (IPL ROM and VRAM/IO), but
holding down the Ctrl key during reset will switch to all-RAM and jump to
location $0000.

Port writes:

    OUT  INH123   Action
    ────────────────────────────────────────────────
    $E0  0 - -    $0000–$0FFF → DRAM
    $E1  - 0 -    $D000–$FFFF → DRAM
    $E2  1 - -    $0000–$0FFF → IPL (Monitor) ROM
    $E3  - 1 -    $D000–$FFFF → VRAM, I/O (8255 keyboard PPI, 8253 timer)
    $E4  1 1 1    $0000–$0FFF → IPL ROM, $D000–$FFFF → VRAM, I/O
    $E5  - - 0    $D000–$FFFF → Inhibit access
    $E6  - - 1    $D000–$FFFF → Restore access

References:
- MZ-700 User's Manual, p.127
- MZ-700 Service Manual, p.k
- sharpmz.org, [MZ-700 Bank switching][so-700banksw]

### I/O Ports

    Port   IO   Description
    ────────────────────────────────────────────────────
    E0-E6   o   memory banking control (see above)
    FE     io   printer?
    FF     ?o   printer?

Memory mapped I/O:

    8255 Programmable Peripheral Interface (PPI):
      E000  PA  output: 0-3=keyboard strobe 10 cols, 7=cursor blink timer reset
      E001  PB  input:  D₀-D₇ rows 18-11 from keyboard
      E002  PC  output: 0=unused
                        1=WDATA  CMT data write
                        2=INTMSK timer interrupt disable
                        3=M-ON   motor rotate control
                input:  4=MOTOR  motor rotation check
                        5=RDATA  CMT data read
                        6=556OUT cursor blink timer input
                        7=VBLNK  vertical blank sense
      E003  control

    8253 Programmable Interval Timer (PIT):
      E004  C0  mode 3 square wave rate generator (sound, 895 kHz)
      E005  C1  mode 2 rate generator (BLNK 15.6 kHz)
      E006  C2  mode 0 terminal counter
      E007  control

    LS367 Hex Bus Drivers, 3-State:
      E008  tempo, joystick, HBLNK input

    Other
      E8A3  Screen 0=blank 1=display (MZ-80K), helpful for preventing snow



<!-------------------------------------------------------------------->
[som 127]: https://archive.org/details/sharpmz700ownersmanual/page/n128/mode/1up?view=theater
[ssm]: https://archive.org/details/sharpmz700servicemanual/page/n7/mode/1up?view=theater
[so-700banksw]: https://original.sharpmz.org/mz-700/coremain.htm#banksw
