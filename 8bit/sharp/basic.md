Sharp S-BASIC
=============

- MZ-700 version; probably applies to all of the MZ-80K series.
- MZ-700 also came with Hu-BASIC.
- S-BASIC includes a small program in the tape header comment section to
  save a copy of itself; see [[smzo-bascopy]] for how to load with
  executing and then run this.

[Memory map][som 28]:

    $FEFF   Memory limit
    $A000   Machine-language area
    $????   Basic Text Area
    $1200   BASIC Interpreter
    $1000   Monitor work area
    $0000   Monitor

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
- `USR`
- `LIMIT`, `LIMIT MAX`



<!-------------------------------------------------------------------->
[som 28]: https://archive.org/details/sharpmz700ownersmanual/page/n29/mode/1up?view=theater

[smzo-bascopy]: https://original.sharpmz.org/mz-700/basiccpy.htm
