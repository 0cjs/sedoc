National/Panasonic JR-200 ROM
=============================

There are two different ROM versions, with a version string [at $BFF2-$BFF6
in the BASIC ROMs][FIND romver] and starting up BASIC with the same text
(see below) but different foreground/background/border colours. The BIOS
ROMs also contain a version string, `500` or `501`, at $FFF5, just before
the vectors.

- `v5.00` (A1, B1 chip markings)
  - Startup: White/Black/Black
  - Serial nos. `2nnnnnnn` ([[FIND romver]]; cjs-owned unit, socketed).

- `v5.01` (A2, B2 chip markings)
  - Startup: Blue/Cyan/Green
  - Serial nos. `3nnnnnnn` ([[FIND romver]]; croys-owned unit, soldered).
    `0nnnnnnn` (cjs-owned unit, soldered).

There are no doubt different versions for the PAL JR-200UP, and possibly
also for the North American JR-200U. ([[FIND romver]] says that a JR-200U
emulator also has `v5.01`.

    JR BASIC 5.0
    (C) 1982 by
    Matsushita System Engineering
    Free Bytes 30716
    Ready

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
without a BASIC ROM installed.

`moncmdsptr` at $0110 points to the commands table; each entry is the
(case-sensitive) command character followed by the address of its routine,
terminated by a command character of $00. At reset this is set to
`moncmds_table` $FFE6 offering the following three commands. [[rebios]]
When an address `aaaa` (upper or lower case) is not given, the default is
just after the last address displayed.

- `Daaaa`: Dump $80 bytes of memory starting at location _aaaa_.
- `Maaaa`: Modify memory a byte at a time; old value displayed first.
  Enter new value, RETURN to leave the same, or `.` to terminate entry.
- `Gaaaa`: Call _aaaa_ (address required); RTS returns to monitor.

There are no CMT load and save commands in the monitor; use `MLOAD
"name"[,start]` and `MSAVE "name",start,end` from BASIC.

`GA000` will display the start-up messages and give the BASIC prompt,
without clearing the screen, though this doesn't seem to leave BASIC
entirely initialized properly (e.g., control-letters no longer enter
BASIC keywords but instead produce symbols; sending a screen code may
fix this).

A simple little program to test the monitor is:

    7000 86 EE      LDAA #$EE
    7002 B7 70 10   STAA $7010
    7005 39         RTS


ROM Routines
------------

Also see [the memory map](./memory.md). The names of these routines were
assigned by me in [the disassembly][disasm].

    ♡       indicates registers preserved by call
    ♣       indicates registers destroyed after call
            (flags assumed destroyed unless otherwise specified)
    ♠       indicates an input parameter
    ♠A      A register contains data to process
    ♠X      X register points to the data or buffer to be used
    ♠$18E   data stored in buffer at $18E

#### Summary

    $E88C   keywait (doesn't update cursor for input status)
    $E892   keycheck (doesn't update cursor for input status)
    $E8CB   XXX joystick read
    $E8DC   rdcharnc    ♠A read a char or mode change keystoke w/o cursor
    $E8E0   rdcharnb    ♠A non-blocking rdchar; $00 = no char avail
    $E8FE   rdchar      ♠A read a char from the keyboard
    $E927   rdline      ♠$18E read and zero-terminate input
    $EAD0   prrdline    pstring + rdline + CMP $03
    $EB21   prcr        ♣A print a CR using prchar; usu. use prnl instead
    $EBE7   prchar      ♠A ♡ABX print char
    $EC7F   clrscrp     clear screen
    $EFF0   prstr8q     ♠X prstr8 unless prb_suppress ≠ $00
    $EFF9   prstr8      ♠X print bit-7-set-terminated string
    $F002   prstr0q     ♠X prstr0 unless prb_suppress ≠ $00
    $F006   prstr0      ♠X print $00-terminated string
    $F00F   prnl           print a newline
    $F05F   errbeep

#### Details

- `$E8CB`: Read joysticks (STICK in BASIC); slow, about 1/4 frame
- `clrscrp $EC7F`: Clear screen, filling with `pcolor $0E` .
- `errbeep $F05F`: Generate error tone.
- `prchar $EBE7`: Print character in A, doing control character processing.
  Preserves A,B,X. If the current character attribute has the user-defined
  charset bit (bit 6) set, codes $20-$3F and $40-$5F are translated to
  block 0 and block 1 user-defined character bitmaps, respectively. (Other
  codes should not be used for user-defined characters; they will display
  random data from the character and attribute screen buffers.)
- `prcr $EB21`: Print a carriage return using the current charset/graphics
  settings. This may produce unepxected behaviour depending on those
  settings; unless you know you want this, use `prnl` instead.
- `prnl $F00F`: Print a newline, even if the current mode is an
  alternate character set or graphics.
- `prrdline $EAD0`: Call `pstring` to print prompt pointed to by X, then
  `rdline` to read a line, and set Z flag (`BEQ`) if Ctrl-C ended input.
- `prstr8 $EFF9`: Print chars pointed to by X. Set MSBit on last char.
  (Cannot print chars \>$7F.)
- `prstr8q $EFF0`: As `prstr8` but prints only if `prb_suppress $45` is $00.
- `prstr0q $F002`: As `prstr8q` but string terminated by $00.
- `rdchar $E8FE`: Wait for a char from the keyboard and return it in A. The
  cursor will be displayed and updated for the input mode, continuing to
  wait for another key, if 英数, GRAPH or カナ is pressed.
- `rdcharnc $E8DC`: Wait for a char from the keyboard and return it
  in A. No cursor is displayed. An 英数, GRAPH or カナ keystroke will be
  returned after processing.
- `rdcharnb $E8E0`: Check if keyboard input is available, returning it
  the char in A or $00 if no char is available. An 英数, GRAPH or カナ
  keystroke will be returned after processing.
- `keywait $E88C`: Return in A the next char from the keyboard buffer,
  waiting if none are available. 英数, GRAPH or カナ will change the
  keyboard's input status but will _not_ update the machine's cursor.
- `keycheck $E892`: `keywait` without the wait.
- `rdline $E927`: Read a line into buffer at $18E-$1DF, terminating it with
  $00. Char that ended entry ($0D or $03) returned in A.



<!-------------------------------------------------------------------->
[FIND romver]: http://www17.plala.or.jp/find_jr200/romver.html
[FIND]: http://www17.plala.or.jp/find_jr200/hard.html
[Reunanen]: http://www.kameli.net/marq/?page_id=1270
[disasm]: https://gitlab.com/retroabandon/panasonic-jr/-/blob/master/Bn-BIOS/B1.dis
[r-dis-bas]: http://www.kameli.net/~marq/jr200/basic.lst
[r-dis-sys]: http://www.kameli.net/~marq/jr200/sysrom.lst
[rebios]: https://gitlab.com/retroabandon/panasonic-jr/-/blob/master/Bn-BIOS/B1.dis
[vjr]: http://www17.plala.or.jp/find_jr200/vjr200_en.html
