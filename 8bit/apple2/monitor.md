Apple II Monitor
================

`CALL -151` (65385, $FF69) enters monitor, giving a `*` prompt. Also,
default `BRKV $3F0` vector followed on `BRK` instruction is `OLDBRK
$FA59`, which saves registers A, X, Y, P (status), S (stack) at at
locations $45‥$49, displays PC/regs and enters monitor.

Set `SOFTEV` vector to `MON`: (`3F2: 65 FF 5A`, note `PWREDUP` set
too) to enter Monitor on reset. Unfortunately the reset routine does
not preserve the registers; you'd need to use the `NMI` JMP ($3FB) to
do this.


Monitor Commands
----------------

"©" indicates a feature available only in version 00 or higher
of the Apple IIc ROM.

Input to the monitor is a sequence of hexadecimal addresses and
commands, with multiple addresses and commands allowed on a line.
(Note that there are no "separators"; space is a valid command and
other whitespace will be read as invalid commands.)
- Addresses are any sequence of `0-9` and `A-F`. Only the lowest
  sixteen bits of an address will be used; the higher bits are
  ignored.
- Commands are any other character. Unrecognized commands terminate
  processing of the input line. Note that this means commands that
  take an argument must be followed immediately by the argument.

### Remembered Locations and Number Entry

There are three addresses that the monitor remembers and uses as
default addresses for its commands:
- _next_: the default address for dumping data, and some other
  commands. (Stored at `A1L $3C`,`A1H $3D`.)
- _end_: The address given as the argument to the `.` command. (Stored
  at `A2L $3E`, `A2H $3F`; cleared immediately after a command.)
- _load_: the default address at which data entry will start with the
  `:` command. (Stored at `A3L $40`,`A3H $41`.)
- _dest_: An third argument, for those commands that need it, set by
  the `<` command copying the _next_ value. Stored at `A4L $42`, `A4H
  $43`. (Some details of this may still need to be worked out.)
- _PC_: the saved program counter providing the default address for
  the `G` and `L` commands. (Stored at `PCL $3A`, `PCH $3B`.)

Entering an address will set both _next_ and _load_ to that address.
Commands will update these as described below.

### Commands

Exiting the Monitor:
- Ctrl-Reset exits w/$3F2 vector.
- Ctrl-B cold starts Applesoft/Integer BASIC ($E000)
- Ctrl-C warm starts Applesoft/Integer BASIC ($E003)
- `3D0G` relinks DOS and starts current interpreter.

Argument-setting commands:
- `.` followed by an address will load the address into _end_. `.` is
  often preceeded by a an address that will set _next_, but need not
  be. Unlike _next_, _end_ is cleared to $0000 after a command has
  been executed. This is used for commands that take start and end
  addresses: memory dumps, `M`, `V`. It can also be useful for Ctrl-Y
  user commands.
- `<`: Copies _next_ to _dest_. Typically used as `dest<next.end` to
  set _dest_, _next_ and _end_ for the following command (`M`, `V` or
  user command Ctrl-Y.)

Disassembly and running code:
- `L` disassembles 20 lines of code and sets _PC_ to the next address
  after the disassembly. When immediately preceded by an address it
  first sets _PC_ to that address. (A preceding address also still
  sets _next_ and _load_.)
- `G` loads the registers from the saved values (`ACC`, `XREG`,
  `YREG`, `STATUS` and `SPNT` at $45-$49) and does a `JSR` to _PC_.
  When immediately preceded by an address, it first sets _PC_ to that
  address. (A preceding address also still sets _next_ and _load_.)
- ©`S` steps one instruction. ©`T` traces execution until solid-apple
  is pressed or `BRK` is executed (`RTS` will not return to the
  monitor). Holding open-apple will slow the trace to one step per
  second.

Depositing data into memory:
- `:` takes a sequence of data bytes and deposits them into memory
  starting at _load_. The data bytes are space-separated hexadecimal
  numbers; only the lowest 8 bits of each number are used. Any command
  will terminate the list of bytes. (`N` is a convenient command to
  terminate the list if you want to continue the line with an
  address.) © data bytes may also be a single quote followed by a
  character, e.g. `'A 'B`.
- `dest<start.endM` moves memory from _start_ through _end_ to
  locations starting at _dest_ (the _dest_ range may overlap the
  source range), sets _load_ to _dest_ and _next_ to _end+1_.
- `dest<start.endV` compares ("verifies") memory. Non-matching
  source/dest bytes will be displayed like `02FB-0B (0A)`.
- ©`!` starts the mini-assembler (prompt `!`). Enter `addr:inst args`
  to assemble an instruction; space for _addr_ uses the next location.
  All numbers are in hex; `$` prefixes are optional.

Misc. commands:
- `+` and `-` do 8-bit two's-complement arithmetic on the low 8 bits
  of _next_ and the address following the command. They do nothing if
  not immediately followed by an address.
- `N`, `I`: Change character output to normal and inverse,
  respectively.
- `Ctrl-P` and `Ctrl-K` set output resp. input to the lowest three
  bits of _next_. These are the equivalent of `PR#n` and `IN#n` in
  BASIC.
- `Ctrl-Y` calls $3F8; `RTS` returns to monitor.

Tricks:
- Setting `YSAV $34` (with `34:n`) sets the current read position in
  the input buffer; this can be used to repeat commands within a line
  by following it with a space, e.g., `L 34:0 `. Ctrl-Reset stops the
  loop.

Detailed documentation is in [Chapter 10][a2cref-c10] of the _Apple
IIc Technical Reference Manual_. Also see [Apple-II
Mini-Assembler][a2mini-asm] instructions and listing.



<!-------------------------------------------------------------------->
[a2cref-355]: https://archive.org/details/Apple_IIc_Technical_Reference_Manual/page/n362
[a2cref-c10]: https://archive.org/details/Apple_IIc_Technical_Reference_Manual/page/n230
[a2mini-asm]: https://archive.org/details/Apple2_Woz_MiniAssembler/page/n1/mode/1up
