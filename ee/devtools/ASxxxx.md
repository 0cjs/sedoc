ASxxxx Cross Assemblers
=======================

- [ASxxxx](http://shop-pdp.net/ashtml/asxxxx.htm)
- [Documentation](http://shop-pdp.net/ashtml/asmlnk.htm)
- [Supported CPUs](http://shop-pdp.net/ashtml/asxdoc.htm)
- [Downloads](http://shop-pdp.net/ashtml/asxget.php)


Assembler And Linker Invocation
-------------------------------

Invoke with no args or `-h` for help text. Give either a single file or
_OUTFILE_ (with output dir if you like) followed by a list of input files.

Both the assembler and linker take the following options for debug symbols:
- `-j`: [NoICE] debug symbols as `.noi` file.
- `-y`: [SDCDB] debug symbols as `.cdb` file.

`.noi` is a [NoICE command file][noi-cmd] containing [symbol definition
commands][noi-sym]. NoICE 6809 version is free.

### Assembler

    -l      Create .lst listing file
    -o      Create .rel object file (and .hlr?)
    -s      Create .sym symbol file
    -p      Disable listing pagination
    -i      Insert assembly line at start, e.g.: -i .list -i BUILD=2

`.rel` files (§3.5.1) are linkable object files. `.hlr` files (§1.10) are
hint files used by the linker to convert the listing into a relocated
listing. Symbol table file format is described in §1.8.

Error codes are described in §1.6.

### Linker

Common `aslink` options:

    -c              ASlink >> prompt input
    -f file.lnk     Command file input
    -k              Path to a library dir
    -l              `.lib` filename to read
    -m              Generate .map file (-m1 to include linker-generated syms)
    -u              Update listing file(s) .rst

The `.lib` library file contains a list of object modules (without `.rel`
extension?) with absolute paths or paths relative to the dir containing
the `.lib` file; these files (both given paths and in dirs specified
with `-k`) are searched to resolve undefined symbols.

Error messages are explained in §3.5.12.

#### Output Formats

Uses only the last one of these specified:
- `-i`: [Intel HEX] §3.8 `.ihx` file. Use `-i1` for legacy type 1 start record.
- `-s`: [Motorola S-record][srec] §3.10 `.s19` file.
- `-t`: Tandy CoCo Disk BASIC binary §3.13 `.bin` file.

[Intel HEX]: https://en.wikipedia.org/wiki/Intel_HEX
[srec]: https://en.wikipedia.org/wiki/SREC_(file_format)

The Tandy record format is binary; all word values are MSB→LSB. The final
record has type `FF`, length `0000` and load address is the execution
address.

    00      00 for start of data record, FF for last record in file.
    01-02   Length of data area below (longer for 24- and 32-bit formats)
    03-04   Load address for record: MSB-LSB (longer for 24-/32-bit)
    05-...  Data


General Assembler Syntax
------------------------

Comment char is `;`, to end of line.

Default radix is decimal. `.radix` followed by one char `[boqd hx]` sets.
Temporary radix prefixes:

    $%  0b  0B              Binary
    $&  0o  0O  0q  0Q      Octal
    $#  0d  0D              Decimal
    $$  0h  0H  0x  0X      Hexadecimal

Unary Operators (highest precedence):

    #n              Immediate value
    <n  >n          Lower/upper byte value
    +   -           No-op, 2s-complement negation
    'c              Byte value of char c
    "cc             Word value of chars cc

Binary operators, high to low precedence:

    *  /  %         Multiply, divide, modulus
    +  -            Add, subtract
    << >>           Left shift, right shift
    ^               Xor
    &               And
    |               Or

Expressions evaluate to one of:
- Relocatable: fixed relative to base address of program area.
- Absolute: fixed.
- External: expression contains a single global ref not defined within
  the current program (+/- an absolute expression value).

### Symbols and Labels

- Symbols max 79 chars, from `[A-Za-z0-9.$_]+`, no initial digit or `$$`.
- Symbol assignement is `=`, `X .equ Y`, `.equ X, Y`.
  These do not start/end a reusable symbol block.
- Labels in the first field end with `:`. A line may have multiple labels.
- Force symbols to global (export) with `::`, `==`, `.gblequ`.
- Force symbols to local (no export) with `=:`, `.lclequ`.
- Local overrides `-a` "all globals" option.
- Last local/global directive is used.

Resuable symbols are decimal numbers with `$` appended. The scope is from
the previous to the next non-reusable label.

`.` is location counter. In instruction, referrs to start of instr, e.g.,
`LDA <#.`. In `.byte`/`.word`/etc., refers to current pos in data list.
`.org` is always absolute; use `. = . + EXPR` for relative/relocatable.


Assembler Directives
--------------------

### Data

One or more comma-separated expressions:

    .byte   .db      .fcb       Byte(s)
    .word   .dw      .fdb       Word(s)
    .3byte  .triple             24-bit value(s)
    .4byte  .quad               32-bit value(s)

String delimited with char not in string, optional `^` prefix.
E.g., `^/foo bar/`, `"baz quux"`.

    .ascii  .str   .fcc         Printable ASCII string
    .ascis  .strs               High bit set in last char
    .asciz  .strz               Zero-byte terminator

Expression _N_ for number of items or size:

    .blkb  .ds   .rmb  .rs      Reserve N bytes of space
    .blkw  .blk3 .blk4          Reserve N words/triples/quads
    .even  .odd                 (No arg) incr loc ctr by 1 if necesary
    .bndry                      Loc ctr to integer multiple of N

### Sections

- `.area NAME (OPT,OPT,...)` §1.4.22 and §3.4 for linker processing
  - _NAME_: separate namespace from symbols.
  - _OPT_: `ABS`, `REL`, `OVR`, `CON`, `NOPAG`, `PAG`;
    `CSEG`, `DESG`; `BANK=NAME`. Blank to re-use previous opts for _NAME_.
- `.bank NAME (OPT,OPT,...)` §1.4.23:
  - _NAME_: Separate namespace from symbols, areas.
  - _OPT_: `BASE=...`, `SIZE=...`, `FSFX=...` (file suffix),
    `MAP` (NoICE mapping parameter for this bank).

### Misc

- `.end EXPR`: Set entry address. Ignored if no _EXPR_ given.
- `.org`: Absolute location; also see `. = . + EXPR` above.
- `.globl sym₁,sym₂,...`: Exports symbols not otherwise defined as global.
- `.local sym₁,sym₂,...`: Override previous `.globl`/`::`/`==`/`-a` option.
- `.setdp [BASE[,AREA]]` §1.4.41: Set direct page. No args for current `.area`.

### Listing

- `.module`: Identifier for this object module (used in linker err messages).
- `.title`, `.sbttl`: Title (2nd line of listing), subtitle (3rd line).
- `.list`, `.nlist` §1.4.4:
  - `.list EXPR`: Enables/disables listing.
  - `.list (opt₁,opt₂,...)`: Sets opts such as `!` (invert `.list`/`.nlist`),
    `cyc` (cycle count).

Enable/disable various parts of listing; see docs.
  Use k
- `.page` §1.4.5: Page eject.
  Listing-only text block (`.if 0`, `.page 1`, ...text..., `.endif`)

### Output During Assembly

- `.msg /text/`: Print _text_ on console during assembly; use string delim.
- `.error expr` §1.4.7, `.assume expr` §1.4.17: Assertions.


Assembler Conditonal/Macro Directives
-------------------------------------

### Conditional Assembly 

Maximum nesting of 10 levels.

- `.if EXPR`, `.else`, `.endif` §1.4.28: _EXPR_ false if evaluates to 0.
  Use empty section between `.if`/`.else` for negated condition.
- `.ifne`, `.ifeq`, `.ifgt`, `.iflt`, `.ifge`, `.ifle`: Compare _EXPR_ with 0.
- `.ifdef SYM`, `.ifndef SYM`.

Usually used on macro args:
- `.ifb SYM`, `.ifnb`: If symbol is/isn't blank. (Used for macro args.)
- `.ifidn SYM₁,SYM₂`, `.ifdif`: If symbols are/are not identical.

Weird thing:
- `.ift`, `.iff`, `.iftf`: True/false/both blocks used only within `.if`.

Alternate form is `.if CND[,] ARG[,ARG]`, with _CND_ of `eq`, `ne`, `gt`,
`lt`, `ge`, `le`, `b`, `nb`, `idn`, `dif`, `f`, `t`, `tf`.

Single-line "immediate" form is `.iif EXPR LINE_TO_ASSEMBLE`, etc. Can use
alternate form with this.

### "Preprocessor"

- `.include /FILENAME/`: Max nesting 5. Issues `.page` before/after.
  May need Windows file seps on Windows?
- `.define KEYWORD /STR/`, `.undefine KEYWORD`. Recursive.

### Macros

See chapter 2 (§2.1 etc.).


Specific Assemblers
-------------------

### AS6500 (§AG)

Addressing modes:

    #nn         immediate
    *aa         direct page
    aaaa        absolute (extended)
    aaaa,x      absolute indexed
    aaaa,y      absolute indexed
    [aaaa]      indirect
    [aaaa,x]    indexed indirect
    [aaaa],y    indirect indexed

Targets:

    .r6500      Core 650x and 651x (default)
    .r65f11     Core plus 65F11 and 65F12
    .r65c00     Core plus 65C00/21 and 65C29
    .r65c02     Core plus 65C02, 65C102, 65C112



<!-------------------------------------------------------------------->
[NoICE]: https://www.noicedebugger.com
[SDCDB]: https://en.wikipedia.org/wiki/Small_Device_C_Compiler
[noi-cmd]: https://www.noicedebugger.com/help/cmdfile.htm
[noi-sym]: https://www.noicedebugger.com/help/symbols.htm
