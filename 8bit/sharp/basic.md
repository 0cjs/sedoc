Sharp S-BASIC
=============

- MZ-700 version; probably applies to all of the MZ-80K series.
- MZ-700 also came with Hu-BASIC (MS-BASIC).
- S-BASIC includes a small program in the tape header comment section to
  save a copy of itself; see [[smzo-bascopy]] for how to load with
  executing and then run this.

[Memory map][som 28]:

    $FEFF   Memory limit
    $A000   ??? Machine-language area (seems wrong; use LIMIT)
    $????   Basic Text Area
    $1200   BASIC Interpreter
    $1000   Monitor work area
    $0000   Monitor (S-BASIC version on MZ-700)

### Function Keys

Defaults:

                 F1          F2          F3          F4          F5
    Shift       CHR$(       DEF KEY(    CONT        SAVE        LOAD
    Plain       RUN(cr)     LIST        AUTO        RENUM       COLOR

### Variables

Variable names are significant only in the first two letters.
"Numeric" `NM`, string `NM$` and array `A(n)`/`A$(n)` variables are
available. Hex representation can be used only with the machine-language
interfacing statements below.

The two system variables are:
- `SIZE` (`SI`): Amount of free space in BASIC text area.
- `TI$`: Current time in `HH:MM:SS` (24-hour) format.

### I/O Statements

- `LOAD "name"` Loads file _name_ from tape, skipping over any other files.
- `PRINT/P`: Prints to printer/plotter.

### Program Editing

- `LIST n-m`

### Screen-related Statements

### Machine-language Interfacing

Hex numbers are of the form `$nnnn` and can be used only with these
statements.

- `PEEK`, `POKE`
- `USR(addr, [arg$])`: Call _addr_, with the address of the string argument
  text in DE.
- `LIMIT`, `LIMIT MAX` (S-BASIC): Set top of memory available for BASIC use.
- `CLEAR n` (HU-BASIC): Set top of memory available for BASIC use. Note
  that unlike MS-BASIC it takes only a single parameter.
- `BYE`, `B.`: (S-BASIC) Enter S-BASIC monitor.


Disk Basic
----------

See Sharp [_Disk Basic Manual_][sdbm] for details. Requires MZ-IU06
Extension Unit, MZ-1E05 Floppy Disk Interface card for MZ-IU06 (with
appropriate ROM in its socket), and MZ-1F02 floppy drives (appear to be
5.25").

Autoboots disk at startup; `AUTO LOAD` program loaded and run if present.

Four file types:
- `BSD`: data, sequential access
- `BRD`: data, random access
- `BTX`: BASIC text
- `OBJ`: machine-language program



<!-------------------------------------------------------------------->
[som 28]: https://archive.org/details/sharpmz700ownersmanual/page/n29/mode/1up?view=theater

[smzo-bascopy]: https://original.sharpmz.org/mz-700/basiccpy.htm
[sdbm]: https://archive.org/details/manualzilla-id-7339763/page/17/mode/1up?view=theater
