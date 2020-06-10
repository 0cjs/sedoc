National/Panasonic JR-200 ROM
=============================

The boot screen is as follows, and may come up in two different colours.

    JR BASIC 5.0
    (C) 1982 by
    Matsushita System Engineering
    Free Bytes 30716
    Ready

- Dark blue text, cyan background, green border.
- White text, black background, black border.

For use with [the emulator][vjr], the ROMs can be dumped to tape as
follows:

    MSAVE  "BASROM",$A000,$BFFF         # 8K
    MSAVE "BIOSROM",$E000,$FFFF         # 8K
    MSAVE "CHARROM",$D000,$D7FF         # 2K

[[Reunanen]] has disassemblies of his [BASIC ($A000)][r-dis-bas] and
[system ($E000)][r-dis-sys] ROMs, but they are completely raw, no
comments, data/code separation, or labels for vectors.

### Machine-language Monitor

The system ROM has simple machine-language monitor built-in (at least
on my white/black/black version); it comes up with a `> ` prompt by
using the `MON` command from BASIC or when the machine is started
without a BASIC ROM installed. Some experimentation discovered the
following (case-sensitive) commands. When an address `aaaa` (upper or
lower case) is not given, the default is just after the last address
displayed.

- `Daaaa`: Dump $80 bytes of memory starting at location _aaaa_.
- `Maaaa`: Modify memory a byte at a time; old value displayed first.
  Enter new value, RETURN to leave the same, or `.` to terminate entry.
- `Gaaaa`: Call _aaaa_ (address required); RTS returns to monitor.

A simple little program to test the monitor is:

    7000 86 EE      LDAA #$EE
    7002 B7 70 10   STAA $7010
    7005 39         RTS

`GA000` will display the start-up messages and give the BASIC prompt,
without clearing the screen, though this doesn't seem to leave BASIC
entirely initialized properly (e.g., control-letters no longer enter
BASIC keywords but instead produce symbols; sending a screen code may
fix this).



<!-------------------------------------------------------------------->
[Reunanen]: http://www.kameli.net/marq/?page_id=1270
[r-dis-bas]: http://www.kameli.net/~marq/jr200/basic.lst
[r-dis-sys]: http://www.kameli.net/~marq/jr200/sysrom.lst
[vjr]: http://www17.plala.or.jp/find_jr200/vjr200_en.html
