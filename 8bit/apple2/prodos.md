Apple ProDOS
============

This covers ProDOS 8 for the II series. ProDOS 16 for the GS is a
separate OS, later replaced by GS/OS.

References and sites:
- Wikipedia, [Apple ProDOS][wp-prodos].
- [_ProDOS 8 Technical Reference Manual_][techref]. (HTML)
- Don D. Worth and Pieter M. Lechner, [_Beneath Apple
  ProDOS_][beneath], 2nd printing (corrected). Quality Software,
  1985-03. Has information missing in _Tech. Ref._ Supplement contains
  further errata.
- [prodos8.com]. Post-Apple ProDOS development. [Manual][pd8-man].
  GitHub project [ProDOS-8] but source code not available. Latest
  versions: 2.4.2, 2.5 alpha 8.

#### Versions

    1983-10  1.0        Initial release
    ????-??  1.01       Checks for "Apple" string in ROM or won't boot
    ????-??  1.1        48K support removed
    ????-??  2.0        65C02 required; utility progs need 128K
    1993-05  2.0.3      Last official release
    2016-08  2.4        Unofficial; 6502 supported again
    20

XXX p. 74, 92, 100, 110, 166

#### Incompatibilities

Applesoft requires 64K RAM and Applesoft ROM, and makes less RAM
available for BASIC programs. Later versions remove 48K support even
for ProDOS kernel. Integer BASIC unspported. ASCII text files have
MSbit clear, not set. `BRUN` uses `JSR`, not `JMP`.


Memory Locations
----------------

    BEC8  48840 w  Last BLOAD length
    BEB9  48825 w  Last BLOAD start


File System
-----------

ProDOS uses the SOS file system and cannot read DOS 3.3 disks except
with a utility program. It supports Disk-II and block devices using
the Pascal firrmware protocol (3.5" drives, HDDs). Custom block device
drivers can be used.

Blocks are 512 bytes, even on 256-byte/sector devices. Block 0 boots
`PRODOS`; block 1 boots `SOS.KERNEL` (on Apple IIIs). A floppy or hard
drive partition is a _volume_ up to 32 MB; the volume name is the base
directory name and must be unique on a running system. All available
drives will be searched for a named volume.

Volume, directory and file names are <= 15 chars, starting with a
letter followed by letters/digits/periods. Files also have a pointer
to the start block (2b), block count (2b), file size (3b), type (1b),
auxiliary type dependent on type (2b), creation/modification
timestamps. Files may be sparse or have allocated all-zero blocks.

Names in paths are separated by a slash; an initial slash preceedes
the volume name. The maximum path length is 64 characters. ProDOS has
a _prefix_ similar to the current working directory; there are not
multiple per-volume prefixes.



<!-------------------------------------------------------------------->
[techref]: http://www.easy68k.com/paulrsm/6502/PDOS8TRM.HTM
[wp-prodos]: https://en.wikipedia.org/wiki/Apple_ProDOS#Requirements
[beneath]: https://archive.org/details/Beneath_Apple_ProDOS_Alt
[prodos8.com]: https://prodos8.com/
[ProDOS-8]: https://github.com/ProDOS-8
[pd8-man]: https://prodos8.com/docs/techref/
