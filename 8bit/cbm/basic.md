Commodore Basic Notes
=====================

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



<!-------------------------------------------------------------------->
[c64w-load]: https://www.c64-wiki.com/wiki/LOAD
