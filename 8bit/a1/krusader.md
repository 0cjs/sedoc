KRUSADER - Symbolic Assembly Development Environment
====================================================

Important addresses:

    $F000   Entry point for cold start
    $F01C   Entry point for resume after dropping to Wozmon.
    $FE17   Entry point for BRK/IRQ debugger (6502 v1.2)
    $FE19   (or $FE14?) Entry point for BRK/IRQ debugger (6502 v1.3)


Introduction
------------

[KRUSADER] is a shell/editor/assembler/debugger for the Apple 1 with
optional support for 65C02 instructions. It is less than 3.75K and is
typically at one of two locations:
- $F000-$FEFF for ROM (between Integer BASIC and Wozmon); start w/`F000R`.
- $7100-$7FFF for high RAM.

Krusader uses Wozmon subroutines, and also relies on it for dumping
and changing memory.

There is also companion software, The KRUSADER Toolkit (Java,
multi-platform), which lets you load/edit/save source code on a PC and
send the built code to an Apple 1 (via serial interface) or run it on
an emulator. The tokenizer used to tokenize assembly source is also
available as a separate C++ program.


Usage
-----

No character rubout; Backspace will kill line. The "shell" command
prompt is `? `. Listings pause every 22 lines; press Esc to abort,
Enter to print one more line, any other key to print one more page.

The line entry mode prompt is a hexadecimal line number. Finish any
field with Tab or Space. Fields are 6-char label, 3-char mnemonic, 14
char arguments, 10 char comment. `Esc` to leave entry mode (discards
current line).

- `N`: New program; clears source code buffer and  starts entry.
- `I nnn`: Insert lies before line _nnn_; after last line if no arg.
- `E nnn`: Retype line _nnn_; continues inserting after that line.
- `X nnn mmm`: Delete line _mmm_, optionally through line _mmm_.
- `L`: List program. Press any key to stop listing.
- `M`: Show memory locations used by the source code.
- `P`: Panic recovery of lost source; see docs.

Commands may take an _addr_ argument which is a symbol or hex number
starting with `$`.

- `A`: Assemble. If no errors, prints start/end locations of assembly
  (meaningless if modules present) followed by module names, line
  numbers and addresses.
- `V addr`: Print address of _addr_.
- `R addr`: JSR to _addr_
- `D addr`: Disassemble at _addr_, or continue from last address if no arg.
- `!`: Send next line typed to Wozmon. (≥1.3 only)
- `$`: Drop into monitor. Return with `F01CR`.


Assembly Syntax
---------------

- All numbers must be hex and preceeded with a `$`.
- ASCII chars between single quotes may be used for byte values.
- Anything not the above is a symbol.
- Comments starting a line must start with `;` followed by a space.
- Blank lines are allowed.

Labels/symbols are up to 6 alpha-numberic chars. Symbols starting with
`.` are local to a module. Forward references are always words, not
bytes, and `<`/`>` operators cannot be used with them. Symbols may not
be redefined. Max 256 global symbols, 32 local symbols per module, and
85 forward references.

### Instructions and Directives

- `BRK` is assembled as two `$00` bytes.
- `.=`: Set label value to argument.
- `.M`: Module. No arg starts after previous module (the usual usage),
  otherwise uses start address given without checking for overlap.
- `.B`: Store bytes; separate multiple values with commmas.
- `.W`: Store words; separate multiple values with commmas.
- `.S`: Store string literal. Args must be in single quotes, max 13
  chars, no spaces.

### Operator Arguments

Relative address args may be given as `*+nn` and `*-nn`.

Expressions are `addr+m`, `addr-m`, `<addr`/`>addr` for low/high byte
of word. `<`/`>` cannot be used on forward references.


Error Messages
--------------

Error messages start with `ERR: `.

- `SYN`: Syntax error in command or source code.
- `MNE`: Illegal mnemonic.
- `ADD`: Illegal addressing mode.
- `SYM`: A needed symbol was not found.
- `OVF`: Symbol table overflow.


Interactive Debugger/Mini-monitor
---------------------------------

(Possibly in ROM version only.)

Setting the BRK/IRQ vector ($FFFE) to get to $FE19 ($FE0A on 65C02
version), the DEBUG routine, will enter the mini-monitor on BRK. (Hope
your system isn't using the IRQ line!)

See the User Manual for more.


Internals
---------

See the User Manual.


<!-------------------------------------------------------------------->
[KRUSADER]: http://school.anhb.uwa.edu.au/personalpages/kwessen/apple1/Krusader.htm
