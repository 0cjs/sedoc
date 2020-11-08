FM77 System/etc. Diskette Usage/Contents
==================================

- Filenames are 8 characters, case-sensitive.
- Types are: `0`=BASIC (use `LOAD`), `1`=binary (use `LOADM` and `EXEC`),
  `2`=text. (unconfirmed)

F-BASIC v3.0 in ROM (w/o diskette boot):
- Appears to support `FILES`, but never returns trying to read disk 0.


FM77AV System Diskettes
-----------------------

Floppy access cover is marked

    ━━━━━━━━━
     FUJITSU
    ━━━━━━━━━

     Floppy Disk 2D
          256 Bytes
            67.5TPI

Both marked with FM77AV (_AV_ in italics) and a red diagonal strip printed
on the label. Both have write-protect notches that may be switched to allow
writing.

### F-BASIC V3.3 L10

Further marked "B273A010".

Contents of an original diskette (hopefully never modified; source: queuebert):

    SYSDSK   0 B S  3  MCOPYV   2 B S  1  FCOPY    0 B S  1  AUTOUTY  0 B S  1
    SYSUTY   0 B S  5  SETTIME  0 B S  1  VOLCOPY  0 B S  1  DFMCD    2 B S  1
    v3.0sys  1 A R  3  FCOPYEB  2 B S  1  SYS3.3   0 B S 13  CLKSETEB 2 B S  1
    MCOPY    2 B S  1  README   0 B S  3  PIC.D1   2 B S  8  PIC.D2   2 B S  8

### FM77AV デモ・プログラム

Further marked "Music & Sound Effect: Akiko KOSAKA".


Fujitsu F-BASIC Version 3.3 (Disk OS) Usage
-------------------------------------------

### User-oriented Commands

#### `SYSDSK` (BASIC)

Formats floppies and installs the OS, (also making them bootable?).
- `*** FLOPY DISK FORMATTING ***`: prompt `DISK FORMATTING ?`. `Y` to
  format, anything else to skip to next stage. Then drive (`0`-`3`), then
  `READY ?` (`Y`).
- `*** DISK BASIC SYSTEM COPY ***`: prompt `WHAT GENERATION SYSTEM DISK
  VERSION(0/3)?`. Pick a destination drive; source system disk drive
  assumed to be on drive 0.

v3.3 85/9/24, 85/9/27. Uses `MCOPY`, `DFCMD`, `v3.0sys`.

#### `VOLCOPY` (BASIC)

Block copy of one diskette to another. Target diskette must already be
formatted. Prompts for source and destination drives (`0`-`3`, defaults `0`
and `1`), then prints `READY` requiring a `Y`/`y` response. Copies 8-tracks
at a time, displaying sets of 8 track numbers as it goes.

v3.3 85.10.06. Uses `MCOPYV`.

#### `FCOPY` (BASIC)

File copy program. Does not accept `KYBD:` for source file.

v3.3 85.09.20. Uses `FCOPYEB`. Top address is $6E00; two entry points at
$6E06 and $6E08. No obvious params passed; perhaps the machine code
searches out the `SDF$`/`DFD$` source/dest file descriptor vars? Maybe
sets `ERR` to an integer code, too. (See lines 300-450.)

#### Misc

- `README`: (BASIC, 85.10.05). Intro loads pics from disk (`PIC.D1`,
  `PIC.D2`), plays music. Then loops forever showing some errata to the
  manual. Among these:
  - To use F-BASIC V3.3 `BREAK RESET` you must have the boot switch set to
    DOS mode.


### Plumbing Commands

#### `DFCMD` (binary)

Information taken from `SYSDSK` BASIC code.

    LOADM"DFCMD"
    ...
    INPUT"WHAT DISK DRIVE(0-3)";DRV2
    ...
    POKE &h5400,0
    LDRV=&hFC30+DRV2
    DRV4=PEEK(LDRV) AND &h0F
    POKE &H5401,DRV4
    EXEC &H5000

#### `MCOPYV` (binary)

Used by `VOLCOPY`.

    CLEAR ,&h1FFF,512
    LOADM "MCOPYV"
    CLEAR ,&h6FFF,512           at program exit

    LDRV1=&hFC30+DRV1           DRV1 is 0-3
    DRV3=PEEK(LDRV1) AND &h0F
    POKE &h2002,DRV3
    POKE &h2003,DRV4            produced same way as DRV3
    EXEC &h2000
