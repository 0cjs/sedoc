Commodore Basic Notes
=====================

References:
- [Commodore 64 Programmer's Reference Guide][prg]

Input:
- `RUN/STOP` breaks; if that fails reset with BIOS `RUN/STOP`+`RESTORE`.
  - Deactivate w/`POKE 788,52`; reactivate w/`POKE 788,49`.
- Shift+`RUN/STOP` executes `LOAD` command (cassette only).

Special variables:
- `TI$`: Six-digit timer as string; increments once per second. Reset
  with `TI$="000000"`.

Commands:
- `LOAD ["filename" [,dev [, secondary]]]` ([wiki][c64w-load]).
  - `*?` glob match like Unix. `$` loads directory.
  - _dev_ `1` (default) is tape, `8` is first disk.
  - _secondary_ `0` (default) loads at start address of BASIC 2049/`$0801`,
    `1` loads at loc defined in first two bytes of PRG file image.
  - In interactive mode, closes all open files and does `CLR`.
  - In a BASIC program, keeps existing variables/arrays and re-runs program
    from start (for chain loading), even if a binary module is loaded.
- `SAVE "filename",8` will silently not save (except for green
  blinking light) if the file already exists. Use `SAVE
  "@0:filename",8` to overwrite.


Copying ROM to RAM
------------------

As mentioned in [CBM Address Decoding][ad-c64-mmap], when you write to
mapped ROM it will actually write to the RAM underneath. You can thus
copy the KERNAL ROM to RAM, map in that RAM, and the system will
continue to work. This can be used to patch the KERNAL. Try:

    10 REM This will take some time to run.
    20 FOR I = 57344 to 65535 : REM $E000-$FFFF
    30 X = PEEK(I)
    40 POKE I,X
    50 NEXT

    PRINT PEEK(1)       # Returns 55, $37
    POKE 1,53           # $35, i.e., assert H̅I̅R̅A̅M̅, unmapping KERNAL and BASIC

Without running the program, the system will lock up due to having no
KERNAL. If you run it, it will clear the screen and return to the
`READY.` prompt with your program intact, having used KERNAL code in
RAM. (The BASIC ROM, though mapped out by this, is apparently mapped
back in automatically by code outside of that ROM.)


Machine Language
----------------

[`SYS loc`][c64w-sys] ([$E12A]) does a `JSR` to the given _loc_
(0-65535); `RTS` returns to BASIC. Before call, loads registers from,
and after call, stores registers to, the following locations:

    A   $030C   780
    X   $030D   781
    Y   $030E   782
    P   $030F   783

[`USR(exp)`][c64w-usr] calls an ML routine via vector `$0311`. The
function's parameter will be in the FAC (`$61–$66`) as a floating
point number if numeric, or the string descriptor pointer at `$64-65`
if a string.

For using BASIC routines to continue parsing the line after the `SYS`
call, see [Borrowing ML from BASIC][pickett85].

### Saving Memory/Machine-Language Programs

A secondary address of `1` on a `SAVE` command will mark the file as
a binary file to be loaded at the location given in the first two bytes,
when later loaded with `,8,1`. (This will not clear the current BASIC
program, but may make it unrunnable.)

    REM Save $C000-$CFFF
    POKE 43,0:POKE 44,192
    POKE 45,0:POKE 46,208
    POKE 55,255:POKE 56,255
    SAVE "ML",8,1
    REM Reset above to previous values when done.


Internals
---------

For VIC-20 information, most general to the C64 and v2 ROM PETs, see
also [_VIC-20 Programmer's Reference Guide_][v20-prg] pp. 119-122.

#### Program and Data Storage

The "text" area contains lines of BASIC code, starting from an
address set in a zero-page location. The format is:

    llhh    Start address of next BASIC line; $0000 for last line.
    llhh    Line number (int16), max 63999.
    ....    Tokenized program code (up to 250 bytes).
    00      Terminator.

Keywords are 1-byte tokens with the high bit set, except inside a
double-quoted string.

Variables are stored above the program text, arrays above variables,
and strings are stored from the top of the BASIC memory area working
downwards.

#### Handy Addresses

[`petmem.txt`][petmem] gives 0-page addresses for useful stuff.

Start of BASIC text is at $28-29 (40-41); this is 400 on PET but
800 on C64, so POKE it to load a C64 program. (But doesn't run;
something else is broken.)


<!-------------------------------------------------------------------->
[$E12A]: http://unusedino.de/ec64/technical/aay/c64/rome12a.htm
[ad-c64-mmap]: address-decoding.md#c64-memory-map
[c64w-load]: https://www.c64-wiki.com/wiki/LOAD
[c64w-sys]: https://www.c64-wiki.com/wiki/SYS
[c64w-usr]: https://www.c64-wiki.com/wiki/USR
[petmem]: http://www.classiccmp.org/dunfield/pet/petmem.txt
[pickett85]: https://www.atarimagazines.com/compute/issue67/292_1_Readers_Feedback_Borrowing_ML_From_BASIC.php/
[prg]: https://archive.org/details/Commodore_64_Programmers_Reference_Guide_1983_Commodore
[v20-prg]: https://archive.org/details/VIC-20_Programmers_Reference_Guide_1983_Commodore_fourth_printing
