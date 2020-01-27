FM-7 Floppy Disk Information
============================

_SS:n-m_ references refer to section-page numbers in the [富士通 FM-7
ユーザーズマニュアル システム仕様][fm7sysspec].

The external disk unit (MB27601, MB27607, MB27605, Epson TF-10)
contains the controller; the card in the computer doesn't seem to do
much but provide a bit of logic for the parallel interface between the
card and disk unit.


Connectors and Cabling
----------------------

SS:1-74 gives the 本体 interface, which I believe is between
the card and the expansion bus, and the cable interface, between
the card and the external drive unit.

The drive unit interface has all ground on odd pins (excepting 1,3,7,
n/c). Even pins include `D0-7`, `RS0-2` and negative logic control
signals `DRQ`, `INTRQ`, `WE`, `CS`, `RE` and `MR`.


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




<!-------------------------------------------------------------------->
[fm7sysspec]: https://archive.org/details/FM7SystemSpecifications
[fm7basic]: https://archive.org/details/FM7FBASICBASRF
