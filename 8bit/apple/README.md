Apple II
========

References:
- \[a2ref] [_Apple II Reference Manual_][a2ref], 1979 edition.
- \[relay] [Jon Relay's Apple II Info Archives][relay]. Memory areas,
  zero page addresses, etc.
- \[lanc84] Don Lancaster, [_Tearing Into Machine Code_][lanc84],
  referenced from [this 6502.org post][p67532]. A small book on Apple
  II architecture and reverse-engineering 6502 software.


Memory Map
----------

See [a2ref] Ch.4 pp.67-75. "Programmer's Aid #1" could go in $D000
socket. Applesoft uses all 10K of non-monitor ROM space.

    $F800   2k  ROM (Monitor), Language Card RAM
    $F400   1k  ROM Miniassembler, etc.
    $E000   5k  ROM (Integer BASIC), Langauge Card RAM
    $D800   2k  ROM (empty socket), Language Card RAM Banks 1 and 2
    $D000   2k  ROM (empty socket), Language Card RAM Banks 1 and 2

    $C800   2k  I/O card ROM space (switched between cards)
    $C000   2k  I/O ($C100, $C200, etc. are slots 1, 2, etc.)

    $6000  24k  Free RAM
    $4000   8k  Screen: hi-res page 1 (secondary)
    $2000   8k  Screen: hi-res page 1 (primary)
    $0C00   5k  Free RAM
    $0800   1k  Screen: text/lo-res page 2 (secondary)
    $0400   1k  Screen: text/lo-res page 1 (primary)
    $0300   1p  Monitor vector locations ($3F0-$3FF only; see p.62)
    $0200   1p  GETLN input buffer
    $0000   2p  Zero page, stack

There are 64 undisplayed locations in each screen text/lo-res page; in
page 1 these are [reserved for I/O cards][jr-screenholes].

The Language Card had 16K of RAM. 8K could be mapped at $E000, and two
4K banks at $D000. Read the following soft switches (which have
[further aliases][relay-io]) to configure the mapping:

    $C080   read RAM (bank 2); write nothing
    $C081   read ROM; write RAM (bank 2)
    $C082   read ROM; write nothing
    $C083   read/write RAM (bank 2)
    $C088   read RAM (bank 1); write nothing
    $C089   read ROM; write RAM (bank 1)
    $C08B   read/write RAM (bank 1)


Memory Usage
------------

The monitor uses the following zero-page and page-3 locations:

    $20--$2F  $30--$3F  $40-$49 $4E $4F  $50-$55   $3F0-$3FF

See further tables in [a2ref] pp. 74-75 for Applesoft, DOS 3.2 and
Integer BASIC usage. Roughly, the only bytes left free by Applesoft
and DOS 3.2 are the following:

    $06-$09  $CE $CF  $D6 $D7  $E3  $EB-$EE $EF  $F9-$FF
    $06-$09                    $E3  $EB-$EE $EF  $F9-$FF  # +Integer BASIC
    $06-$09  $CE $CF                $EB-$EE      $FD $FE  # +ProDOS

SWEET16 uses `$00`-`$1F`.


Monitor Commands
----------------

`CALL -151` (65385, $FF69) enters monitor, giving a `*` prompt. Exit
with Ctrl-Reset (uses vector at $3F2), Ctrl-C + Enter or `3D0G` (runs
the resident program, usually Applesoft, which has set up a `JMP`
instruction at $3D0). Loading `69 FF 5A` at $3F2 will make Ctrl-Reset
bring up the monitor. Ctrl-B starts the basic interpreter that was
active when the monitor was entered, disabling DOS if resident.

If the monitor was entered via a `BRK` ($00) instruction and `FF 69`
at the break vector $3F0‥$3F1, the registers registers A, X, Y, P
(status), S (stack) at entry are stored at location $45‥$49.

Except for `:`, multiple commands may be entered on a single line,
separated by spaces. "_+:_" indicates a feature available only in
version 00 or higher of the Apple IIc ROM.

Commands:
- `n+m` and `n-m` do 8-bit two's-complement arithmetic.
- All commands may preceeded by a hex value, e.g., `E000` to set the
  "last opened location" (_last_) and the "next changable location"
  (_next_), which is the addresss used for any subsequent command.
  Otherwise the previously set _last_ is used.
- Enter or a single hex value displays the byte at that memory
  location.
- `.` followed by an address displays memory from _last_ to that
  address. _last_ and _next_ are both the last location displayed.
- `l` disassembles ("lists") 20 instructions starting at the address
  given or the current program counter (stored at $3A).
- `:` followed by space-separated hex numbers (`3e 3f`) (_+:_ or
  single-quote followed by a character: `'A 'B`) deposits that byte at
  _next_.
- _+:_ `!` starts the mini-assembler (prompt `!`). Enter `addr:inst
  args` to assemble an instruction; space for _addr_ uses the next
  location. All numbers are in hex; `$` prefixes are optional.
- `dest<start.endM` moves memory from _start_ to _end_ to locations
  starting at _dest_ (the _dest_ range may overlap the source range)
  and sets _last_ to the last location read and _next_ to the last
  location written.
- `dest<start.endV` compares ("verifies") memory. Non-matching
  source/dest bytes will be displayed like `02FB-0B (0A)`.
- `^E` displays the register values from locations $45‥49. (_+:_ This
  includes the `M` memory state from $44; see [a2cref-355].)
- `^Y` jumps to $3F8.
- `G` starts executing at _next_. `RTS` or `BRK` will return to the
  monitor; the latter displays the PC and registers.
- _+:_ `S` steps one instruction; `T` traces execution until
  solid-apple is pressed or `BRK` is executed (`RTS` will not return
  to the monitor). Holding open-apple will slow the trace to one step
  per second.
- `I` and `N` set output to inverse and normal, respectively.
- `port^P` and `port^K` set output and input to _port_.
- Setting location $34 (`34:n`) sets the current read position in the
  input buffer; this can be used to repeat commands by following it
  with a space, e.g., `L 34:0 `. Ctrl-Reset stops the loop.

Detailed documentation is in [Chapter 10][a2cref-c10] of the _Apple
IIc Technical Reference Manual_.



<!-------------------------------------------------------------------->
[a2cref-355]: https://archive.org/details/Apple_IIc_Technical_Reference_Manual/page/n362
[a2cref-c10]: https://archive.org/details/Apple_IIc_Technical_Reference_Manual/page/n230
[a2cref]: https://archive.org/details/Apple_IIc_Technical_Reference_Manual
[a2ref]: https://archive.org/details/Apple_II_Reference_Manual_1979_Apple
[jr-screenholes]: http://www.kreativekorp.com/miscpages/a2info/screenholes.shtml
[lanc84]: http://forum.6502.org/download/file.php?id=7848
[p67532]: http://forum.6502.org/viewtopic.php?f=3&t=5517&sid=f6734cd034b51b20dcd393f67a3c48fe&start=30#p67532
[relay-io]: https://www.kreativekorp.com/miscpages/a2info/iomemory.shtml
[relay]: https://www.kreativekorp.com/miscpages/a2info/index.shtml
