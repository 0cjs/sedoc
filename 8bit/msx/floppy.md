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
- Using drive `B:` on single-drive systems will prompt for diskette swap.
- Filenames are 8.3, upper-case and kana only.
- Extensions have no special meaning and need not be used for BASIC
  programs. Pattern `*` matches only files without an extension; use `*.*`
  for all files.
- 1D/2D diskettes have 719/1439 512-byte sectors. A freshly formatted 2D
  diskette has 719 free 1024-byte clusters.


Disk BASIC version 1
--------------------

Disk BASIC requires an extra 5385 (3827 if `Ctrl` held down during boot)
bytes of memory (Canon V1 12431 → 7046/8604 bytes free).

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


Disk BASIC version 2
--------------------

Adds optional _path_ to `"device:\path\filename"` parameters.



References
----------

- MSX Wiki, [Disk BASIC]



<!-------------------------------------------------------------------->
[Disk BASIC]: https://www.msx.org/wiki/Disk_BASIC
[bas]: ./basic.md
