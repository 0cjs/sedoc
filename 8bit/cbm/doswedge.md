CBM DOS Wedges
==============

A small machine-language program that replaced [CHRGET][64w-chrget]
($73-$8A) in order to intercept characters before they got to BASIC
(or other interpreters also using CHRGET), interpreting its own extra
commands to do things like replace `LOAD "xxx",n`, list the directory
of a disk, etc. Most are usable only in direct mode, not in programs.

There have been many versions of this; the original seems to be the
one by Bob Fairburn on the [test/demo diskette][64w-testdemo] included
with 1541 and other drives and the C64 Macro Assembler. Magazines
published new versions, and many fastloader/freezer/etc. cartridges
also included a DOS wedge with similar commands.

- Wikipedia: [DOS Wedge][wp-wedge]
- C64 Wiki: [DOS wedge][64w-wedge]
- _Compute!_ #41 Oct. 1983 p.266: [Commodore DOS Wedges: An Overview][c!41]


Commands
--------

In most or all cases, `>` can be substituted for `@`. Product codes in
parens after the command refer to section after this.

Common commands:
- `/filename`: Load a BASIC program. (BF, EF)
- `%filename`: Load a machine-language program. (BF, EF)
- `↑filename`: Load/run BASIC program. (BF)
- `←filename`: Save a BASIC program. (BF, EF)
- `@`: Display and clear drive status. (BF, EF)
- `@$`: List disk directory. (BF, EF)
- `@command`: Send [command][cmd] to drive. (BF, EF)
- `@Q`: Deactivate (unhook) wedge. (BF)
- `@#n`: Set device to _n_ (8, 9, etc.). (BF)

Uncommon DOS commands:
- `$`: List disk directory. (EF)
- `@$n`: List disk directory on device _n_. (unknown)
- `DOS"command`: Send _command_ to drive. (FC3)
- `@"command`: Send _command_ to drive. (JD)
- `@"command`: Send _command_ to drive without parsing/changing by
  wedge. (E.g., to avoid fast-format.) (AR)

Non-DOS commands:
- `\`, `£`: Start menus. (EF)
- `!`: Enter machine-language monitor. (EF)


Products including a DOS Wedge
------------------------------

- __BF__: Bob Fairburn version (test/demo, C64 Macro Assembler).
- __EF__: [Epyx Fastload][epyx] cartridge. All wedge commands refer to
  device 8.
- __FC3__: Final Cartridge III
- __JD__: JiffyDOS
- __AR__: Action Replay.
- __C2__: [Commodore CBM-II DOS Wedge][cbm2wedge]. CBM-II machines
  (610, 710, 720, B128, B256) only? Open source; BSD license;
  Sourceforge. Last update 2015-08-21.


Drive Commands
--------------

[Drive commands][dcmd] are sent on channel 15 (see [serial-bus]), and
terminated by UNLISTEN or CLRCHN. From BASIC: `OPEN n,8,15,"command" :
CLOSE n` (replacing _n_ with any unused file handle).

The commands vary by drive and DOS.

Standard 1541/1570/1571/1581/etc. commands:
- `N:label,id` (or `NEW`): Format disk.
- `R:newname=oldname` (or `RENAME:`): Rename file.
- `S:filename` (or `SCRATCH:`): Delete file (wildcards supported).

Non-standard commands:
- `F:label,id`: Fast-format a disk. (JD)

#### Reading Error Status

The error status is read from channel 15 as the error number, error
string, track and sector. Reading the error status will also clear it.
In BASIC:

    10 OPEN 1,8,15
    20 INPUT#1, EN$, ER$, TR$, SC$  :REM INPUT not usable in direct mode
    30 CLOSE 1


Basic 4.0+ Commands
-------------------

- `CATALOG`, `DIRECTORY`: Print disk directory.
- `PRINT DS$`: Query and show the drive status.



<!-------------------------------------------------------------------->
[64w-chrget]: https://www.c64-wiki.com/wiki/115-138
[64w-testdemo]: https://www.c64-wiki.com/wiki/Test/Demo-Diskette
[64w-wedge]: https://www.c64-wiki.com/wiki/DOS_Wedge
[c!41]: https://github.com/0cjs/sedoc/blob/master/8bit/cbm/doswedge.md
[dcmd]: https://www.c64-wiki.com/wiki/Drive_command
[wp-wedge]: https://en.wikipedia.org/wiki/DOS_Wedge

[epyx]: https://rr.pokefinder.org/rrwiki/images/c/c4/Epyx_FastLoad_Manual.pdf
[cbm2wedge]: https://sourceforge.net/projects/cbm2wedge/

[serial-bus]: serial-bus.md
