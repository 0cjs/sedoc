FM-7 Floppy Disk Information
============================

_SS:n-m_ references refer to section-page numbers in the [富士通 FM-7
ユーザーズマニュアル システム仕様][fm7sysspec].

The external disk unit (MB27601, MB27607, MB27605, Epson TF-10)
contains the controller; the card in the computer doesn't seem to do
much but provide a bit of logic for the parallel interface between the
card and disk unit.

The external disk unit itself has a large 40-pin chip of some sort
(Intel? microcontroller?) and a Fujitsu [MB8877][] (MB8876A in the
case of the Epson TF-10 disk unit) Floppy Disk Formatter/Controller
(FDC). This may be similar to the WD1793 except not needing a +12V
supply; a CoCo user has claimed that he's swapped the two without
problems.

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


Connectors and Cabling
----------------------

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

P. 2-23 through 2-30 of [富士通 FM-7 F-BASIC 文法書][fm7basic] gives
low-level information on the disk format. Disks are 40 cylinder
(tracks 0-39, sides 0-1) with 16 × 256-byte sectors per track,
numbered 1-16 on side
0 and 17-32 on side 1.

    Track Sectors   Descr.
      0     1,2     IPL code
      0      3      Disk ID
      0     4-16    Reserved
      0    17-32    Disk code
      1      1      FAT
      1     2-3     Reserved
      1     4-32    Directory
     2-39           User data

Track 0 sector 28 contains information ID information (§2-30).
Byte offsets:

    0-2     `SYS` for a system disk; `S  ` for user disk.
     3      Autostart functionality used by 8" drives
     4      Autostart: file buffers ("How many Disk Files (0-15)")
     5      Autostart functionaly used by 5" disk drives
    6-255   All $00


F-BASIC uses 8 sector clusters. More info available on FAT, disk
catalogue, etc.

Disk code is loaded from $7000-$7FFF, if used.


Sample Code
-----------

The [XM7-for-SDL `linux-sdl/Tool` subdir][xm7tool] contains 6809 code
to dump the ROMs to disk; it offers plenty of examples of direct
access via the registers above, and even formatting I think.



<!-------------------------------------------------------------------->
[MB8877]: https://www.datasheetarchive.com/MB8877A-datasheet.html
[fm7basic]: https://archive.org/details/FM7FBASICBASRF
[fm7sysspec]: https://archive.org/details/FM7SystemSpecifications
[flexonsbd]: https://flexonsbd.blogspot.com/2020/01/fm-7fdc.html

[xm7tool]: https://github.com/Artanejp/XM7-for-SDL/tree/master/linux-sdl/Tool
