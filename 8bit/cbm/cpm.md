CP/M on C128
============

Here we constently substitute 6502 (the processor architecture) where other
documents may say 8502.

### References

- [_Commodore 128 Programmer's Reference Guide_][PRG C] (abbreviated _PRG_).
  Bantam, 1986.
  - [[PRG 404]] Kernal jump table calls
  - [[PRG 477]] CP/M user guide
  - [[PRG 490]] CP/M memory map
  - [[PRG 491]] Disk format details
  - [[PRG 575]] Z80 hardware overview, including bus interface and hardware
    side of processor switching.
  - [[PRG 677]] C128 CP/M BIOS routines.
  - [[PRG 685]] 6502 BIOS routines called via CP/M BIOS routine 30 `USERF`.
  - [[PRG 702]] Examples of how to call above routines.
  - [[PRG 705]] disk format table
  - [[PRG 710]] Listing of `CXEQU.LIB`, the CP/M memory map.
  - [[PRG 719]] Symbols indexed by location.

### Memory Organization

The TPA (Transient Program Area) is in bank 1 $0000-$E000, with common
system memory and memory-mapped I/O above that. Bank switching is done
using the memory-mapped C128 MMU registers in the usual way
([[sedoc][c128mem]], [[PRG 458]]) to access Z80 ROM and RAM bank 0
containing the majority of OS code and screen buffers. Per the memory
maps at [[PRG 490]] and [[PRG 710]], the non-TPA bank is:

    E000        common system memory
    D000  4.0k  I/O locations (CIAs etc.)
    6000        banked system (OS?)
    4000        free area
    3000  4.0k  CCP buffer ($C80 used)
    2C00  1.0k  VIC screen
    2600  1.5k  8502 BIOS (kernal?)
    2400  0.5k  params block (0.5K)
    1400        40-column logical screen (2×80×25 = 4000/$FA0)
    1000  1.0k  key tables (3 × 256 blocks used)
    1000        VIC color memory when IO$0 selected
    0000  4.0k  ROM

### Screen

[[PRG 498]] Z80 ROM has screen display routines.

CP/M BIOS does ADM-3A emulation (origin 1,1 at upper left). Some
Kaypro, ADM-31 and custom extensions have been added for underline,
colours, etc., details at [[PRG 498]].

    Position Cursor     1B 3D 20+ 20+       ESC row+32 col+32
    Cursor Left         08                  ^H
    Cursor Down         0A                  ^J
    Cursor Up           0B                  ^K
    Cursor Right        0C                  ^L
    Home/Clear          1A                  ^Z
    CR                  0D                  ^M
    ESC                 1B                  ^[
    Bell                07                  ^G

### Keyboard

[[PRG 496]] `KEYFIG` program can redefine codes. Alt mode sends $80-$FF codes.

### Disk Support

Tracks and sectors here always start at 0.

Many formats supported [[PRG 491]]:
- 1s __Commodore GCR__ (C64 CP/M 2.2) [[PRG 493]]
  - FCB: 32 tracks (offset +2) of 17 sectors (outer track sectors 17-20 unused)
  - BIOS adds 1 to tracks ≥ 18 to skip the CBM format directory track
  - Tracks 0, 1 sectors 0-16 reserved for boot blocks
- 1s/2s __C128 CP/M Plus__ (uses full disk capacity) [[PRG 494]]
  - Virtual: 1 side, 638 tracks (offset 0) of 1 sector
  - See [[PRG 491]] for virtual→physical mapping, [[PRG 494]] for sector skew.
  - Boot block: T0 S0. Unused: T0 S5. Disk DOS directory: T18 S0.
  - 2s version also available on 1571
- MFM formats (1571 only):
 - __Epson QX10:__ 2 sides 10 sectors of 512 bytes
 - __IBM-8 SS/DS (CP/M 86):__ 1/2 sides 8 sectors of 512 bytes
 - __Kaypro II/IV:__ 1/2 sides 10 sectors of 512 bytes
 - __Osoborne DD:__ 1 side 5 sectors of 1024 bytes

MFM format sides/sectors are detected; if multiple formats use this a box will
pop up at lower left of screen for left/right-arrow selection.



<!-------------------------------------------------------------------->
[PRG 404]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n413
[PRG 458]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n467
[PRG 477]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n486
[PRG 490]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n499
[PRG 491]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n500
[PRG 493]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n502
[PRG 494]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n503
[PRG 496]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n505
[PRG 498]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n507
[PRG 575]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n584
[PRG 677]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n686
[PRG 685]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n694
[PRG 702]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n711
[PRG 705]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n714
[PRG 710]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n719
[PRG 719]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up/page/n728
[PRG C]: https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up

[c128mem]: ./address-decoding.md#commodore-128
