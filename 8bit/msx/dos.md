MSX-DOS
=======

The original MSX-DOS distribution diskettes, at least for v1.03, come with
only `MSXDOS.SYS` (2432 bytes) and `COMMAND.COM` (6656) bytes. (From the
small size, these probably make heavy use of the Disk BASIC ROM.) The
manual instructs you to `COPY` just these two files to a freshly formatted
diskette in order to make a system diskette.

The [image on archive.org][ar-MSXDOS] includes a number of additional
programs, some from [MSX-DOS tools][ar-TOOLS] and others that appear to be
user-contributed.

File types used by the DOS itself are `.COM`, `.BAT` and `.SYS`.
`AUTOEXEC.BAT`, if present, is run at boot.

Devices are `AUX:` (CMT), `CON:`, `NUL:`, `PRN:`.
As usual, these are considered device names even without the colon.

File timestamps may record only date, not time.

The 13 built-in commands are below. `[`/`]` indicate optionsal parameters.
`fspec` is a file spec (optional drive, name, wildcards `*?` generally
allowed).
- `BASIC [fspec]`: Start Disk BASIC, optionally running the given file.
  Return to DOS (interactively or programmatically) with `CALL SYSTEM`.
- `COPY  fspec₁ [+ fspecₙ ...] fspec₂`
  - Wildcards copy multiple files.
  - Additional _fspecs_ with `+` concatentates files.
  - You may append `/A` or `/B` to any fspec to force ASCII or binary mode.
    mode. This is related to EOF (`^Z`) usage. (`COPY .../A .../B` will
    remove trailing $1A from the first file during copy.)
- `DATE [yyyy-mm-dd]`: prompts for entry if no param given. Years are
  displayed as two digits even through four are kept internally.
  International systems use `mm-dd-yyyy`; European systems use `dd-mm-yyyy`
- `DEL fspec`/`ERASE fspec`. Arg `*.*` will prompt "Are you Sure (Y/N) ?".
- `DIR [/P][/W] [fspec]`: Display directory. The info displayed for each
  file depends on screen width; use `MODE 40` to see file times.
  - `/P` pause at end of each page of ouptut.
  - `/W` "wide" output; filenames only.
- `FORMAT`: prompts for drive, and type of format if options available.
  (This is the same as `CALL FORMAT` so options depends on your Disk ROM.)
  Manual shows 8 or 9 sector options, not on Toshiba HX-F101.
- `MODE width`: _width_ 0-40, 0-80 on MSX2 machines. 32 or less will use
  screen mode 1, 33-40 screen mode 0. Very short widths will break `DIR`,
  wedging the system when it tries to print.
- `PAUSE [comment]`: prompts to strike a key when read. The comment can be
  seen by the user because there is no `@echo off` in MSX-DOS 1.
- `REM [comment]`
- `REN`/`RENAME fspec₁ fspec₂`: Rename _fspec₁_ to _fspec₂._ Wildcards
  allowed if used in corresponding places in both _fspecs._.
- `TIME [h[:m[:s][A|P]]`: Accepts 24-hour as well. Doesn't work on MSX1
  systems?
- `TYPE fspec`
- `VERIFY [on|off]`

### BASIC

From MSX-DOS, you can enter Disk BASIC with the `BASIC` command and
return with the `CALL SYSTEM` command. (`CALL SYSTEM` seems to do a warm
boot of whatever diskette is in the drive; returning does not prompt for
the date/time, but BASIC will restart if there's no MSX-DOS diskette in
the drive.)


Documentation
-------------

The [_MSX-DOS Tools Users Manual_][mtdum] (ASCII, 1987) is a huge book that
actually contains several different manuals in it, without a proper table
of contents at the beginning or index at the end. (Each manual within the
book has its own ToC and index.) For convenience, I have split the
archive.org OCR scan `MSX-DOS TOOLS USERS MANUAL_text.pdf` into a separate
PDF for each volume that has an independent ToC. The page numbers given
below are the PDF page numbers from the original full scan.

- `COVERS-front-back-matter.pdf` (P.1, P.439)
  - Introduction, list of volumes, publisher info, etc.
- `TOOLS-Users-Manaual.pdf` (P.9)
  - Utility programs (many Unix-like).
- `MSX-DOS-I-Introduction.pdf` (P.67)
- `MSX-DOS-II-Users-Guide.pdf` (P.95)
- `MSX-DOS-III-Programmers-Guide.pdf` (P.173)
- `EDITOR-Screen-Editor-MED-OpMan.pdf` (P.215)
- `UTILITY-Software-Manual.pdf` (P.273)
  - Macro-assembler, linker, cross-referencer, librarian.
- `END-Material.pdf` (P.439)



<!-------------------------------------------------------------------->
[ar-MSXDOS]: https://archive.org/details/MSXDOS
[mdtum]: https://archive.org/details/MSXDOSTOOLS/
[ar-TOOLS]: https://archive.org/details/MSXDOSTOOLS_201606
