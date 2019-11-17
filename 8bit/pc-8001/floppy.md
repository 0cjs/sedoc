PC-8001 Floppy Disk Format
==========================

References:
- [PC-8001⇒Windows floppy conversion][marugoto] (ja). Some information
  on and a program to analyze/convert both BASIC and CP/M disk
  formats.

The double-sided double-density format is 40 tracks per side, 16
sectors per track and 256 bytes per sector for a total of 320 KB of
raw storage.

DISK-BASIC
----------

System disks contain an IPL and the "disk code" (DOS); on user data disks
those sectors are all available for user data.

    Side    Track   Sector      Description
    ---------------------------------------
    0       0       1           IPL
                    2-16        disk code
            1-2                 disk code
            3-39                user data
    1       0-17                user data
            18      1-12        directory
            18      13          ID sector
            18      14-16       FAT
            19-39               user data

Directory:

    Bytes   Description
    -------------------
    0-5     filename
    6-8     extension (拡張子)
    9       attributes (see hex table below) (属性)
    10      first cluster number
    11-15   unused (未使用)

    Attribute Byte
    --------------
     0  ASCII
    10  ASCII, read-only
    40  ASCII, read-after-write
    80  non-ASCII format
    90  non-ASCII format, read-only
    C0  non-ASCII format, read-after-write

Clusters are 8 sectors (2 KB) in size. The FAT is an array with an
entry for each cluster, and appears to be interleaved between sides
1 and 2 (on double-sided disks). Each entry contains one of the
following values:

    00-9F   Cluster in use. Value is the next cluster number.
    C1-C8   Last cluster in file. Bits 0-3 are number of sectors used
            in the cluster.
       FE   Reserved cluster that cannot be used for user files.
            (IPL, disk code, directory, FAT)
       FF   Unused (free cluster).


CP/M
----

Due to restrictions imposed by CP/M, only 256 KB of the capacity is used.

128 byte sectors ("records" in [Marugoto]/Japanese ), 8 sectors per block.

Each directory entry is an "extent"; a file using more than 16 blocks
will use multiple sequential extents. See also [CP/M disk and file
system format][cpm].

    32-byte Directory/Extent Entry
    -----------------------
    0       user area number, or $E5 for ???
    1-8     filename
    9-11    extension
    12      "ex" - something to do with more extents for larger files
    13      0 (reserved?)
    14      0 (reserved?)
    15      "rc" (number of records used in last extent?)
    16-31   "d0-dn" (block numbers)



<!-------------------------------------------------------------------->
[marugoto]: http://www8.plala.or.jp/ita-sys/K02B_PC8001-Marugoto.html
[cpm]: https://www.cpm8680.com/cpmtools/cpm.htm
