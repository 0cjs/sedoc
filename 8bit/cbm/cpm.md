CP/M on Commodore
=================

Commodore 64
------------

### References

- Zimmers.net CP/M disk images: [`/pub/cbm/demodisks/c64/cpm/`][zim]
- [[ctools]] reads/writes C64/C128 CP/M disk images to `.D64`, `.D71` etc.
- [CP/M 2.2 disc formats][format22] has generic format information.
- [[seasip]] has extensive deep technical info on CP/M 2.2 and 3.0,
  including [BIOS calls by version][seasip bios].
- The [z80.eu C64 page][z80.eu] has a limited amount of good technical
  information and further references, and the source for the C64 6502 boot
  loader, Z80 boot loader, BIOS and .
- [devili.iki.fi C64 CP/M][devili] page: source code and links.
- [[baltissen]]: hardware information about the card.
- [Getting Programs For The C64 CP/M Cartridge][biosrhythm] has six `.D64`
  images with various programs and games.

### Enabling/Disabling the Z80

The card responds to all addresses in $DE00-$DEFF.
- Writing LSbit=0 eanbles the card, which asserts `/DMA` to pause the 6510
  and enables its address/data bus buffers.
- Writing LBbit=1 disables the card by asserting the `BUSRQ` input of the
  Z80. This is acknowledged by BUSAK, which signal is used to disable the
  address and data bus buffers.
- The VIC-II, when it needs the bus, also sends `BA` that asserts `BUSRQ`.
- Reference: [[baltissen]]

### Memory Map

Apparently the map is "rotated down" by 4 KB so that the ZP is at $F000,
memory mapped I/O moves from $D000 to $C000 and so on. [[cbmserver]] This
would let the 6510 set up the Z80's reset code at $1000 before turning the
Z80 on.

### Disk Format

Good references for the low-level disk format are given in the __Commodore
GCR__ section of the C128 CP/M disk formats list below. Remember that the
Commodore DOS directory (track 18) and BAM are generally present.

For generic information on CP/M disk formats see [[format22]], and system
generation and bootstrap process see [Section 6: CP/M Alteration][z80.eu
cpmalt] in the _CP/M Operating System Manual_.

The C64 has two reserved tracks for the OS:
- Boot sector: Not used on C64 CP/M disks.
- CCP: 16 sectors after the boot sector.
- BDOS: 28 sectors after the CCP.
- BIOS: 6 sectors after the BDOS.

The bootstrap seqeuence seems to start with a 6502 boot loader loaded as a
`.PRG` file, which then loads a Z80 boot loader and starts the Z80 CPU.
From that point, presumably the Z80 boot loader loads the BIOS and BDOS.
Source for these loaders is on [[z80.eu]] and [[devili]].


Commodore 128
-------------

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

For generic CP/M 3.1 format information see [[format31]].

Drive `E:` is a "virtual drive" (RAM disk?)

Tracks and sectors here always start at 0.

Many formats supported [[PRG 491]]:
- 1s __Commodore GCR__ (C64 CP/M 2.2) [[PRG 493]]
  - FCB: 32 tracks (offset +2) of 17 sectors (outer track sectors 17-20 unused)
  - BIOS adds 1 to tracks ≥ 18 to skip the CBM format directory track
  - Tracks 0, 1 sectors 0-16 reserved for boot blocks
  - See [[D64.TXT]] for sector offsets within a `.D64` image file.
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
    0008    RST 8: usual entry point when Z80 re-enabled after 6502 run
                   Also boot entry point; see below.
    0008    RST 10h
    0008    RST 18h
    0008    RST 20h
    0008    RST 28h: Jump to $100 + L
    0030    RST 30h: non-executable data ("05/12/85")
    0038    RST 38h: continues at $FDFD
    003B    ...continue RST 0 boot
    0054    restart in C64 mode
    00B4    call $036D to load block, then stuff about load addr?
    00EE    text "CPM+    SYS",00
    0059    ...continue RST 0 boot
    0100    table of jump addrs for RST 28h
    018C    ...continue RST 8
    02FA    some sort of data copy
    036D    load data from $3400 + offset
    044F    read track $FD04 (1-based?) sector $FD03 to mem ($FD18)
    046B    test block loaded at $FE00 for `CBM` magic at start
            failure: NX; success: Z and last byte of sector in A
    04FF    At line 19 col 5 print "NO"
    0507    At line ? col ? print "CPM+.SYS FILE", goto $04B8
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
    0E85 3163  IRQ/NMI/Reset handler
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
    FFEB: ED 79     OUT (C),A
    FFED: 00        NOP             ; sit here while 6502 runs
    FFEE: CF        RST $08         ; continue with Z80 code
                                    ;   Z80 ROM may modify to RET
                                    ;   6502 boot block may modify to JP $0008

#### CP/M Boot Process

After reset and then finding no C64 cartridge inserted, the Z80 ROM reset
code loads track 1 sector 0 (the first track and sector) and checks it for
a `CBM` signature at the start. If it's there, it loads that as the boot
block and executes its (6502) code. The CP/M boot block simply switches
back to the Z80 and jumps to location $0008. [[bootblock]].

The ROM CP/M boot code at $0008 does the following:
- 000B: Set MMU config to all-RAM, IO off
- 018C: Continue here
- 018F: Zero all RAM $3000-$FEFF
- 019B: Copy $0D22-$EE4 to $3000 (6502 code for disk I/O)
- 01A6: Copy $0EE5-$0F04 to $FFD0 (6502, Z80 code for CPU switch)
- 01B1: Set $FFEE (return from 6502 mode) to RET (replacing RST 8)
        When switching to 6502 mode from now on, we will CALL $FFE0
        so it will return to the caller when done.
- 01B6: Call 6502 $3000
        - 3000: ??? Not clear what this does.
        - 30D7: If it reaches this (I think yes), uses logical file #15
        - 30F1: SETNAM $31B8 len 4 "U0L",$00
- 01B9: Load MMU regs $D500-$D50A w:
        -    config: 0D = block 0, $C000 ROM, $8000 RAM, $4000 ROM, I/O off
        - preconf A: 3F = block 0, $C000 RAM, $8000 RAM, $4000 RAM, I/O off
        - preconf B: 7F = block 1, $C000 RAM, $8000 RAM, $4000 RAM, I/O on
        - preconf C: 3E = block 0, $C000 RAM, $8000 RAM, $4000 RAM, I/O off
        - preconf D: 7E = block 1, $C000 RAM, $8000 RAM, $4000 RAM, I/O on
        - mode: B0 = C128 mode, fast in, Z80A CPU
        - ram config: 0B = bank 0, common RAM high=on low=off, boundry $C000
        - page 0 pointer: 00 00 = bank 0, $00nn
        - page 1 pointer: 01 00 = bank 0, $01nn
- 01C9: Zero-fill $1000-$2FFF
- 01D5: VDC and VIC setup
- 01F0: Clear screen and print "BOOTING CP/M PLUS" message
- 020F: Call $02D2 to read/check boot sector (again?!)
        On failure, call $04FF
- 0215: Use table at 0FB2 for ??? (sector skew?)

- ------
- 02D2: read track 1 sector 0
- 02E0: call $044F to read track/sec
- 02E3: call $046B to test boot sector
- 02E7: INC A from $FF → $00 (if disk with CP/M installed)
- 02E8: prepare to load 32 sectors to $3800
- 02ED: if A is not $00 (i.e., $FF before INC), return
- 02EF: prepare to load 64 sectors to $3C00
- 02F2: store load addr in $3C07, block count in $3C06
- 02F8: clear A and flags (important, says Abacus comment) and return
- ------
- 04B8: print "HIT RETURN TO RETRY" etc., wait for KB input
        on CR goto $049B (immediate RST $08), on DEL RST $00

RAM addresses used by ROM:
- 3800: load address for 32 sectors for non-$FF diskette
- 3C00: load address for 64 sectors for $FF diskette
- 3C06: sector count for 2nd stage bootstrap
- 3C07: load address for 2nd stage bootstrap
- 3C33: ??? (word, copied to FD09 by $0260)
- FD03: track to read
- FD04: sector to read
- FD09: ??? (word)
- FD18: target address for disk read data
- FE00: disk sector data read buffer


<!-------------------------------------------------------------------->

<!-- C64 -->

[baltissen]: http://www.baltissen.org/newhtm/c64_cpm.htm
[biosrhythm]: http://biosrhythm.com/?p=1220
[cbmserver]: https://www.commodoreserver.com/BlogEntryView.asp?EID=FE373254289C48869A4B59222EFE5C21
[ctools]: https://github.com/mist64/ctools
[devili]: http://www.devili.iki.fi/Computers/Commodore/C64/CPM/
[format22]: https://www.seasip.info/Cpm/format22.html
[seasip bios]: https://www.seasip.info/Cpm/bios.html
[seasip]: https://www.seasip.info/Cpm/index.html#archive
[z80.eu cpmalt]: http://www.z80.eu/c64/CPM-Alteration.htm
[z80.eu]: http://www.z80.eu/c64.html
[zim]: http://www.zimmers.net/anonftp/pub/cbm/demodisks/c64/cpm/index.html


<!-- C128 -->

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

[D64.TXT]: http://ist.uwaterloo.ca/~schepers/formats/D64.TXT
[bootblock]: https://gitlab.com/retroabandon/cbm/-/tree/master/ctools-bootblock
[c128mem]: ./address-decoding.md#commodore-128
[format31]: https://www.seasip.info/Cpm/format31.html
