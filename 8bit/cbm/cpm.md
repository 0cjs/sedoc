CP/M on C128
============

Here we constently substitute 6502 (the processor architecture) where other
documents may say 8502.

### References

- [_Commodore 128 Programmer's Reference Guide_][PRG C] (abbreviated _PRG_).
  Bantam, 1986.
  - [[PRG 404]] Kernal jump table calls
  - [[PRG 458]] C128 Memory Management details
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

- [_Commodore 128 CP/M User's Guide_][Ab C] (abbrev. _Ab_), Data
  Becker/Abacus Software, 1986. Despite the name, lots of deep technical
  information.
  - [[Ab 124]] Assemblers MAC and RMAC (and other tools); macro libraries
    `Z80.LIB` (Z80 instructions) and `X6502.LIB` (6502 instructions).
  - [[Ab 137]] `SUBMIT` command
  - [[Ab 156]] CP/M boot sector listing
  - [[Ab 157]] Z80 ROM listing

### Memory Organization

The TPA (Transient Program Area) is in bank 1 $0000-$E000, with common
system memory and memory-mapped I/O above that. Bank switching is done
using the memory-mapped C128 MMU registers in the usual way
([[sedoc][c128mem]], [[PRG 458]]) to access Z80 ROM and RAM bank 0
containing the majority of OS code and screen buffers. Below is the memory
map of the non-TPA bank. [[PRG 490]],[[PRG 710]],[[Ab 155]]

    E000        common system memory
    D000  4.0k  I/O locations (CIAs etc.)
    6000        banked system (OS?)
    4000        free area
    3000  4.0k  CCP buffer ($C80 used)
    2C00  1.0k  VIC screen
    2600  1.5k  8502 BIOS (kernal?)
    2400  0.5k  params block (0.5K)
    1C00        40-col logical screen color RAM
    1400        40-column logical screen (2×80×25 = 4000/$FA0)
    1000  1.0k  key tables (3 × 256 blocks used)
    1000        VIC color memory when IO$0 selected
    0000  4.0k  Z80 ROM

[[Ab 154]] The Z80 ROM can be made available at $D000-$DFFF in the 6502
address space. See [[Ab 154]] for some specific useful locations in the
$2400-$2417 and $FD01-$FD18 ranges in above address space.

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

Drive `E:` is a "virtual drive" (RAM disk?)

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

MFM format sides/sectors are detected; if multiple formats use this a box
will pop up at lower left of screen for left/right-arrow selection.

Most CP/M formats put the OS on reserved tracks 0 and 1, which are copied
to another diskette with the `COPSYS` command. The C128 instead puts it in
a regular file, `CPM+.SYS` (and `CCP.COM`); the Z80 ROM BIOS knows how to
find and load this. [Ab 104]

### Z80 ROM

A listing of the ROM is given in [[Ab 157]], but it does not use any
symbols. The following address list may help when reading it. Entries
without a leading 0 may be mid-routine, not entry points.

    0000    RST 0: system reset start
    0008    RST 8: entry point when Z80 re-enabled after 6502 run
    0008    RST 10h
    0008    RST 18h
    0008    RST 20h
    0008    RST 28h: Jump to $100 + L
    0030    RST 30h: non-executable data ("05/12/85")
    0038    RST 38h: continues at $FDFD
    003B    ...continue RST 0 boot
    0054    restart in C64 mode
    00EE    text "CPM+    SYS",00
    0059    ...continue RST 0 boot
    0100    table of jump addrs for RST 28h
    018C    ...continue RST 8
     1F0    print "BOOTING CP/M PLUS" message
    020F    call $02D2 to get boot sector
    02D2    read track 1 sector 0
     2E0    call $044F to read track/sec
     2E3    call $046B to test boot sector
    036D    load data from $3400 + offset
    044F    read track $FD04 (1-based?) sector $FD03 to mem ($FD18)
    046B    test block loaded at $FE00 for `CBM` magic at start
    0526    print 0-term text following call
    052C    print 0-term text at (DE)
    0534    print 0-term text at (HL)
    058C    print trk/sec to read ($FD03/$FD04) at line 24, col 74/34
    06AB    set 80-col cursor pos to DE
    09BC    set 40-col cursor pos to DE
    0F04    tables
    0FAA    MMU register initialzation values
    0FB5    sector skew table

Code copied up to RAM. 6502 except where marked.

    0D1A 1100  reset into C-128 mode: MMU ctl=$00, JMP (reset-vec)
    0D22 3000  read disk block
    0D5A 3038  read sector
    0DB2 3090  read data from file
    0E53 3131  read track/sector
    0E71 314F  wait until SDR (serial data reg) is done, then get data byte
               «further IEC bus routines»
    0EE5 FFD0  switch to Z80, on return to 6502 JMP $3000
    0EF5 FFE0  (Z80 code) switch to 6502, on return to Z80 RST $08;
               RST → RTS mod by $1B1

These bits of ROM code copied up to RAM are equivalant. Note that on the
Z80 the I/O instructions use 16-bit values from BC on the data bus when
using the `OUT (C),r` instruction.

    FFD0: 78        SEI             ; disable interrupts
    FFD1: A9 3E     LDA #$3E        ; MMU conf: all RAM, IO page $D000 enabled
    FFD3: 8D 00 FF  STA $FF00       ; MMU config register
    FFD6: A9 B0     LDA #$B0        ; mode: Z80 enabled
    FFD8: 8D 05 D5  STA $D505       ; mode config register
    FFDB: EA        NOP             ; sit here while Z80 runs
    FFDC: 4C 00 30  JMP $3000       ; continue with 6502 code
    FFDF: EA        NOP             ; filler

    FFE0: F3        DI              ; disable interrupts
    FFE1: 3E 3E     LD A,$3E        ; MMU conf: all RAM, IO page $D000 enabled
    FFE3: 32 00 FF  LD ($FF00),A    ; MMU config register
    FFE6: 01 05 D5  LD BC,$D505     ; mode config register
    FFE9: 3E B1     LD A,$B1        ; mode: 8502 (6502) enabled
    FFEB: ED 79     OUT (C),A       ; ??? where does high addr byte come from?
    FFED: 00        NOP             ; sit here while 6502 runs
    FFEE: CF        RST $08         ; continue with Z80 code
                                    ;   (or may be modified to a RET)



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
[PRG C]:   https://archive.org/stream/C128_Programmers_Reference_Guide_1986_Bamtam_Books#mode/1up

[Ab 104]: https://archive.org/stream/Commodore_128_Book_8_CPM_Users_Guide#mode/1up/page/n115
[Ab 124]: https://archive.org/stream/Commodore_128_Book_8_CPM_Users_Guide#mode/1up/page/n135
[Ab 137]: https://archive.org/stream/Commodore_128_Book_8_CPM_Users_Guide#mode/1up/page/n148
[Ab 154]: https://archive.org/stream/Commodore_128_Book_8_CPM_Users_Guide#mode/1up/page/n165
[Ab 155]: https://archive.org/stream/Commodore_128_Book_8_CPM_Users_Guide#mode/1up/page/n166
[Ab 156]: https://archive.org/stream/Commodore_128_Book_8_CPM_Users_Guide#mode/1up/page/n167
[Ab 157]: https://archive.org/stream/Commodore_128_Book_8_CPM_Users_Guide#mode/1up/page/n168
[Ab C]:   https://archive.org/stream/Commodore_128_Book_8_CPM_Users_Guide#mode/1up/

[c128mem]: ./address-decoding.md#commodore-128
