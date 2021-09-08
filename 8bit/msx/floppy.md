MSX Disk BASIC / MSX-DOS
========================

Version 1 carts carts boot on any MSX system. Version 2 carts requires
MSX2. Version 2 is built in to some MSX2 systems. Starting with a
DOS-1-formatted diskette in the drive or or pressing the `1` key during
boot will boot Version 1 instead.

An MSX1 machine booted with an FDC cartridge but no diskette or a diskette
without a boot block will prompt for the date and then enter BASIC with
less memory free and an additional banner line `Disk BASIC version 1.0`.

Notes:
- Hold down `Ctrl` during startup to reserve memory for only one drive
  instead of two. (Trying to use drive `B:` will then give `Bad drive
  name`.)
- `AUTOEXEC.BAS` will be run as a BASIC program on start, if present.
- Using drive `B:` on single-drive systems will prompt for diskette swap.
- Filenames are 8.3, upper-case and kana only.
- Extensions have no special meaning and need not be used for BASIC
  programs. Pattern `*` matches only files without an extension; use `*.*`
  for all files.
- 1D/2D diskettes have 719/1439 512-byte sectors. A freshly formatted 2D
  diskette has 719 free 1024-byte clusters.
- Special files are `CON` (console), `NUL`, `PRN`/`LST`, and `AUX` (same as
  `NUL` unless extension added).


Disk BASIC version 1
--------------------

Disk BASIC requires an extra 5385 (3827 if `Ctrl` held down during boot)
bytes of memory. (16K: 12431 → 7046/8604 bytes free. 64K: 28815 →
23430/24988 bytes free.)

As with standard BASIC, _fspec_ is `"[device:]filename"`, where _device_ is
`CAS:`, etc.; Disk BASIC addes drives `A:` through `H:`. _filename_ is
sometimes optional. Filename `CON` is the console. The default device in
Disk BASIC is `A:`.

The following [existing BASIC commands][bas] work with disk files:
- `RUN`, `LOAD`, `BLOAD`, `SAVE`, `BSAVE`, `MERGE`
- `OPEN`, `CLOSE`, `ERR`, `ERROR`

Additional commands and functions:
- `CALL FORMAT`, `_FORMAT`: Prompts for drive name and 1/2 sided.
- `FILES`: show filenames; opt. param is drive and/or restriction pattern.
- `KILL "fspec"`: delete a file
- `NAME "fspec" AS "fspec"`: rename a file
- `COPY "fspec" TO "fspec"`. Target filename `CON` will print a file to the
  screen.
- `DSKF(d)`: return number of free clusters on specified drive. _d=0_ for
  default drive, _d_ = 1 through 8 for drives `A` through `H`.
- `DSKI$(d,s)`, DSKO$ d,s: Read/write a 512 byte sector to/from buffer
  pointed to by word $F351 (default $EB95). `DSK$()` returns an empty
  string; `DSKO$` is a statement.

Additional disk-unrelated commands and functions:
- `CVD(str)`: Convert string expression _str_ to a double.
- etc.

For more, see the MSX Wiki [Disk BASIC] page.


MSX-DOS
-------

Feels MS-DOSy but runs most CP/M programs too.

### Boot

[TH2 1.3.invoking] At startup logical sector 0 is loaded into $C000-$C0FF.
If the "top" of the sector is not $EB or $E9, Disk BASIC is invoked,
otherwise $C01E is called with carry clear. The default boot sector has
`RET NC` here, causing the boot block to return and ROM load of MSX-DOS to
continue.

If the machine has at least 64K of RAM, $C01E is called with carry set. At
this point it's not clear if the boot block or something else loads
`MSXDOS.SYS` at $100, but however it happens, that code then moves itself
to a higher address, loads `COMMAND.COM` at $100 and executes it. That in
turn also copies itself up and starts. (If `MSXDOS.SYS` is missing, Disk
BASIC is invoked. If `COMMAND.COM` is missing, `INSERT A DISKETTE` is
printed and it waits for a diskette.)

MSX-DOS runs `AUTOEXEC.BAT` is run if present.

### Disk Structure

[TH2 3.1] Boot sector, FAT, directory then data area. Boot sector contains
offsets/counts for remaining parts of the diskette:

    0B 0C   sector size (bytes)
       0D   cluster size (sectors)
    0E 0F   count of unused sectors
       10   number of FATs
    11 12   number of directory entries
    13 14   number of sectors per disk
       15   media ID
    16 17   size of FAT (sectors)
    18 19   tracks per sector (??? maybe track count)
    1A 1B   sides used (1 or 2)
    1C 1D   count of hidden sectors

This information is also copied into the DPB (Disk Parameter Block) in
memory, though in different form.

Allocation is done in clusters, linked by the 24-bit entry for each cluster
in the FAT. Not clear the exact relation between logical and physical
sectors.


Disk BASIC version 2
--------------------

Adds optional _path_ to `"device:\path\filename"` parameters.


References
----------

- MSX Wiki, [Disk BASIC]
- [alwinh MSX Tech Doc Documentation][alwinh] contains a link to a `.arj`
  file containing a partial disassembly of the DOS1 diskROM, though with
  comments in Dutch.



<!-------------------------------------------------------------------->
[Disk BASIC]: https://www.msx.org/wiki/Disk_BASIC
[TH2 1.3.invoking]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter3.md#procedure-for-invoking-msx-dos
[alwinh]: https://web.archive.org/web/20050414002839/http://www.alwinh.dds.nl/msx/docs/vg8245.arj
[bas]: ./basic.md
