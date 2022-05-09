FM-7/77 Floppy Disk Information
===============================

References:
- [富士通 FM-7 ユーザーズマニュアル システム仕様][fm7sysspec]. _SS:n-m_
  references refer to section-page numbers in this.
- [FM-7 F-BASIC 解析マニュアル][shuwa83]. Shuwa System Trading Co., Ltd.,
  1983-12. Has deep technical detail about BASIC and disk support, though
  only for systems through FM-7. Also includes Z80/serial/etc. card
  schematics.

The external disk unit contains the controller as well as the drives; the
card in the computer ([MB22603] box for FM-8, MB22407 card for FM-7) seems
just to do a bit of decoding and bus buffering. External disk units:
- MB27601
- MB27605
- MB27607
- MB27611 (MB27612 is expansion box?)
- MB27631(H)
- MB27631: 2× 3.5" drives (uses same MB22407 interface card)
- Epson TF-10 (its own I/F card, but looks similar to MB22407)

(Note the Epson TF-10 came in both FM-7 and PC-8001 versions; the latter
has "PC専用機" written under the connector on the drive. And I think the
PC-8001 version is actually the TF-20?)

The external disk unit itself has a large 40-pin chip of some sort
(Intel? microcontroller?) and a Fujitsu [MB8877][] (MB8876A in the
case of the Epson TF-10 disk unit) Floppy Disk Formatter/Controller
(FDC). This may be similar to the WD1793 except not needing a +12V
supply; a CoCo user has claimed that he's swapped the two without
problems.

The FM-7 external drive unit [MB27611] appears to have had a pair of
[YD-580] drives in it.

Flexonsbd has created an [FM-7 disk controller board][flexonsbd] with
an MB8877A on-board, so you can connect that directly to external
drives rather than a controller. (It should let you use 3.5" drives!)
The board there still has design issues, though, like the floppy drive
connector being on the wrong side.

### FM77

FM77 and FM-77AV use 320 KB 40-track 3.5" floppies; the drives are
proabably compatible with 5.25" controllers (but I've not tried it).
FM77AV20 and beyond uses 640 KB 80-track floppies. These can format
and write 40-track diskettes, but 40-track drives will have problems
reading these.


Drives, Connectors and Cabling
------------------------------

### FM-7

SS:1-74 gives the 本体 interface, which I believe is between
the card and the expansion bus, and the cable interface, between
the card and the external drive unit.

For the 34-pin interface to the drive unit, all odd pins (1-33) are
GND, excepting 1,3,7 which are N/C. The even pins are:

        2  •DRQ
        4  •INTRQ
        6  •WE
        8  •CS
       10  •RE
       12  RS0
       14  RS1
       16  RS2
    18-32  D0-D7
       34  •MR

These appear to have a close correspondence with the following MB8877
MPU interface pins:

    DRQ         Data Request: data reg filled (read) or empty (write)
    IRQ         Set when command completed or TYPE IV command executed;
                reset when next command written or status read
    W̅E̅          Write Enable
    C̅S̅          Chip Select (DALs high impedence when deasserted)
    R̅E̅          Read Enable
    A₀, A₁      Register select
    DAL₀ - DAL₇ 8-bit bidirectional data bus between FDC and MPU
                (pos. logic for 8877, neg. logic for 8876)
    M̅R̅          Master Reset

(Missing MB8877 MPU interface pins are `T̅E̅S̅T̅` and `D̅D̅E̅N̅`, to enable
FDC test mode and double density when asserted.)

The register select addresses 0=command/status, 1=track, 2=sector, and
3=data registers match up to the first for I/O addresses at $FD18
below.

Pp. 6-7 of the data sheet give commands, status register descriptions,
etc.

### FM77AV

The FM77AV has [Y-E Data YD-625][yd-625] floppy drives. ([Data
sheet][yd-600].) These seem to have standard headers: data/control on
2×17 .1" male header, power on a standard 4-pin amphenol .1" male
power connector (for AMP170204-2 plug) as with most 3.5" drives, and a
2×3 .1" male header presumably for jumpers, both unjumpered in my
system. Control/data cable is a standard 36-conductor ribbon cable
with no twist, to a 2×17 male header on the motherboard. Termination
is 1000Ω, but maybe different from other drives, or maybe 1 drive
only. Compatible with 5.25" YD-580.

From the page above, odd pins 1-33 are all GND; even pins are all
active low unless specified otherwise:

     2  (reserved)
     4  in use (active high?)
     6  drive select 3
     8  index (out); 1 pulse per rotation
    10  drive select 0
    12  drive select 1
    14  drive select 2
    16  motor on
    18  direction select (low=inward to centre, high=outwards to edge)
    20  step
    22  write data
    24  write gate (low=write; high=read/seek)
    26  track 00 (out)
    28  write protect (out) low=protected
    30  read data (out)
    32  side one select (high=side 0, low=side 1)
    34  ready out (low if +5/+12 normal and index detected 4 times)

Jumpers given in page above are 1=short, 2=open. P3 controls whether
the front light follows the drive select signal or not. Max
control/data cable length is 1.5 m.


Memory I/O Addresses
--------------------

(SS:1-73)

    $FD18   read    status register
    $FD18   write   command register
    $FD19   r/w     track register
    $FD1A   r/w     sector register
    $FD1B   r/w     data register
    $FD1C   r/w     head register
    $FD1D   r/w     drive register
    $FD1F   read    bit 7: DRQ 1=on; bit 6: IRQ 1=on


Disk Format
-----------

[富士通 FM-7 F-BASIC 文法書][fm7basic] §2.10.3 pp. 2-23 through 2-30 gives
low-level information on the disk format.

8" 1 MB (2-27) and 5.25" 360K are both 256 bytes per cluster:

    5.25"   8"      Description
    ─────────────────────────────────────────────────────────
    0-1     0-1     side number
    0-39    0-76    cylinder and track number
    1-16    1-26    sector number on track
    1-32    1-52    sector number on cylinder (but often called "track")

5.25" format/layout described here; see book for slightly different 8" layout.

    Trk Sectors Description
    ────────────────────────────────────────────────────────────────
     0   1-2    IPL
     0   3      Disk ID (identifies it as F-BASIC disk)
     0   4-16   reserved
     0  17-32   "disk code" loaded at $7000-$7FFF at IPL, if used
     1   1      FAT
     1   2-3    reserved
     1   4-32   directory
     2   1-8    cluster 0
      ...
    39  25-32   cluster 151

The FAT is an array of one byte per cluster, values:

    00-97   cluster in use and full; value is number of next cluster
    C0-C7   final cluster of file; subtract $BF for count of sectors in use
    FD      no sectors used in cluster
    FE      system cluster
    FF      cluster should never be used (?)

The directory is an array of 32-byte entries:

     0-7    file name
     8-10   reserved
    11      file type: 00=BASIC program, 01=(BASIC) data, 02=machine language
    12      ASCII flag: FF=ASCII, 00=binary
    13      random access flag
    14      file data starting cluster
    15-31   reserved

On 8" floppies only, track 0 sector 28 contains ID information (2-30):

     0-2    `SYS` for a system disk; `S  ` for user disk.
      3     Autostart functionality used by 8" drives
      4     Autostart: file buffers ("How many Disk Files (0-15)")
      5     Autostart functionaly used by 5" disk drives
     6-255  All $00


Sample Code
-----------

The [XM7-for-SDL `linux-sdl/Tool` subdir][xm7tool] contains 6809 code
to dump the ROMs to disk; it offers plenty of examples of direct
access via the registers above, and even formatting I think.



<!-------------------------------------------------------------------->
[MB27611]: http://ja1wby.art.coocan.jp/hamg/7-fm7-fdd/1-fm7-fdd.htm
[MB8877]: https://www.datasheetarchive.com/MB8877A-datasheet.html
[YD-580]: http://ja1wby.art.coocan.jp/hamg/7-fm7-fdd/2-yd-580.html
[flexonsbd]: https://flexonsbd.blogspot.com/2020/01/fm-7fdc.html
[fm7basic]: https://archive.org/details/FM7FBASICBASRF
[fm7sysspec]: https://archive.org/details/FM7SystemSpecifications
[shuwa83]: https://archive.org/stream/fbasicii#page/n4/mode/1up

<!-- Drives, Connectors and Cabling -->
[mb22603]: http://haserin09.la.coocan.jp/mb22603.html
[yd-600-tf]: http://www.textfiles.com/bitsavers/pdf/yeData/FDK-523002_YD-600_Specifications_Jan85.pdf
[yd-600]: http://www.bitsavers.org/pdf/yeData/FDK-523002_YD-600_Specifications_Jan85.pdf
[yd-625]: http://ja1wby.art.coocan.jp/hamg/7-fm7-fdd/2-yd-625.html

<!-- Sample Code -->
[xm7tool]: https://github.com/Artanejp/XM7-for-SDL/tree/master/linux-sdl/Tool
