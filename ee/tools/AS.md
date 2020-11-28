The Macroassembler AS
=====================

- [AS home page][as]
- [AS documentation (HTML, English)][as-doc] (§ references below)
- Quickref in man pages in the `man/` subdir of the distributions.


Installation
------------

The [download page][as-dl] includes tarballs of some recent versions
of the source and binaries for Win32 and DOS/DPMI. (Platforms with
easily available compilers get distributions only in source form.)
There's no official public source repo, but [Kuba0/asl] on GitHub
seems to import the latest betas regularly.

There's no `Makefile.def` for modern (64-bit) Linux; see dev branches
in [0cjs/8bitdev] for a version and a build script. Consider doing a
`make test` after building the default `binaries` target.

§I gives notes on the source and hints on porting; this may also
contain information needed for a Unix install.


Invocation
----------

### asl

The assembler itself. (§2.4) It must be able to find its `.msg` files,
searching the current dir, the executable's directory, `$AS_MSGPATH`
and compiled-in `LIBDIR`.

Command line option args may start with `-` or `/` to enable and `+`
to disable; some take the next arg as a parameter; when optional these
must not be followed by a source filename. Single-char options may be
combined. All other args are files to be assembled; filenames without
an extension will have `.asm` appended. Each filename generates a
separate output file. All options apply to all output files,
regardless of arg order. Initial command-line args will be taken from
the `ASCMD` env var. Use `@FILE` to read params from a file.

Output goes to `.p` files; see commands below for further manipulating
those.

Misc options:
- `-i PATH[:PATH:…]`: Prepend include search path entries.
- `-q`: Quiet output: error/warning messages only.
- `-Werror`: Treat warnings as errors.
- `-maxerrors N`: Terminate after _N_ errors.
- `-u`: Detect overlapping memory usage. (Also lists used address
  ranges.) Expensive.
- `-U`: Enable case-sensitive symbols, sections, macros, etc. Use
  before any `-D` options.

Generation options:
- `-cpu NAME`: Change default CPU from `68008`.
- `-alias NEWNAME=OLDNAME`: CPU alias for `CPU` op.. Changes `MOMCPU`
  and `MOMCPUNAME`. (§2.14) Used for MCUs with different peripherals
  on a known core.
- `-D NAME[=VALUE[,…]]`: Pre-define symbols. Default value `1`; some
  expressions allowed, but not symbol references.

Output options:
- `-o FILE`: Assembled output ("code" file). Default extension `.p`.
- `-E [FILE]`: Errors/warnings to _FILE_ instead of stderr. Default
  _FILE_ is source filename plus `.log`.
- `-a`, `-c`, `-p`: Write out shared symbol definitions (§2.13) in
  assembler (`.inc`), C (`.h`) or Pascal/Modula 2 (`.inc`). Change
  name with `-shareout NAME`.
- `-g [MAP|Atmel|NoICE]`: Write debug information in given format to
  `.map`/`.obj`/`.noi` file. Default format is `MAP`. Also use
  `-noicemask` to add segments other than code segment.
- `-M`: Output macro definitions to a `.mac` file.
- `-P`: Generate "macro" output file (`.i`) with source after macro
  expansion and conditional assembly.

Listing options:
- `-L`,`-l`: Generate assembly listing to `.lst` file in same dir as
  source, or console.
- `-olist NAME`: Specify name of assembly listing file.
- `-s`: Add section list to assembly. (§3.8)
- `-C`: Add cross-ref table to listing.
- `-I`: Add include file list.
- `-u`: Add used address ranges. (Also detects overlapping memory
  usage.)
- `-h`: Print hex constants with lower-case `a-f`.
- `-t MASK`: Enable (`-`)/disable (`+`) listing components. Bits:
  0=code/source lines, 1=symbol table, 2=macro table, 3=function
  table, 4=line numbering.

Message options:
- `-x`: Extended error reporting. Can be used twice.
- `-n`: Add error number to errors.
- `-r [NUM]`: Warn when forced to run assembly pass _NUM_ or larger.
- `-w`: Suppress warnings.
- `-gnuerrors`: GCC-like error messages.

#### Exit Codes

- 0: No errors. (But there may have been warnings.)
- 1: No command line params given; help printed.
- 2: Errors occured in at least one source file, no code file
  generated for it..
- 3: Fatal error; code files probably unusable.
- 4: Terminated during initialization (bad command line arg).
- 255: Internal error.

### Other Programs

These take `@FILE` and env var params (`$P2BIN` etc.) just like `asl`.

- `plist`: List contents of a code file.
- `pbind`: Combine/extract records from a code file.
- `p2hex`: Convert a code file to a hex file.
- `p2bin`: Convert a code file to a binary image.


Segments (§3.2.13)
------------------

      0 -  NOTHING      Pseudo-segment (predefined symbols, etc.)
      1 C  CODE
      2    DATA
      3    IDATA
      4    XDATA
      5    YDATA
      6    BITDATA
      7    IO
      8    REG
      9    ROMDATA
    128                 Register symbol (§2.12)

The `MOMSEGMENT` symbol contains the current segment. The `symtype()`
function returns the current segment of a symbol; `symtype(aLabel)`
returns `1` if `aLabel` is in the code segment.

Symbols
-------

Symbols (§2.7) are up to 255 chars from [`A-Za-z0-9_.`]; the first char
must not be a digit. They are case-insensitive unless `-U` is supplied on
the command line; pre-defined symbols are upper-case. Each symbol is part
of a segment, default `CODE`. (See above.) Each symbol also has a type
of `String`, `Int` or `Float`.

Constants/vars (§3.1.1) are defined with: `set` or `:=`, which allows
later redefinition, and `equ` or `=`, which is constant. When not
prefixed by a label the first argument is the label. An additional
argument may be given to restrict the definition to a given address
space.

Symbol values may be subtituted using braces. This can be used to produce
new symbol names; be careful not to produce invalid ones.

    cnt         set     cnt+1
    tmp         equ     "\{cnt}"
                jnz     skip{temp}
    skip{temp}: nop

Pre-defined symbols are listed in §E and in the listing and `.map` file,
with the exception of the following:

    *, $, PC            Current program counter
    MOMSEGMENT          Current segment
    MOMSECTION          Name of current section or empty string
    MOMPASS             Current assembly pass
    MOMFILE, MOMLINE    Current source file, line

### Temporary Symbols

"Temporary" symbols are rewritten to global symbols that vary based on
their position between two exiting non-temporary symbols. These can collide
with directly-defined global symbols (producing an error) if the programmer
defines conflicting ones. The three forms of temporary symbols are:

- Named: `$$name`. Rewritten to `name#` where `#` is from a counter
  incremented with every non-temp symbol.
- Nameless: `-` is rewritten to `__back#`, `+` and `/` to `__forw#`, where
  `#` is a sequence number incrementing separately for each `__back` and
  `__forw` generation. `-`/`+` may be used only for their corresponding
  targets; `/` may be used for targets in either direction. Multiple char
  targets skip that many temporary labels, e.g., `jmp --` will jump to the
  second-previous `-`/`/`.
- Composed: `.name`. Rewritten to `prev.name` where `prev` is the most
  recent non-temporary symbol. This includes symbols generated by other
  temporary forms above. Not clear how this interactions with `section`
  directives.

### Sections / Local Symbols (§3.8)

Sections are declared with `section NAME` and `endsection NAME`
(_NAME_ optional) directives, which may be nested. Unqualified
references are searched from inner to outer sections. Section names
conflict only at the same level; a section name does not conflict with
any parent or child with the same name, nor with section names in
other branches of the hierarchy.

References may be qualified with `name[secname]` to reference (only)
enclosing sections; _secname_ may be `parent0`…`parent9` for current
and parent sections. `parent` is the same as `parent1`.

Symbols defined in sections are not visible outside those sections
except when one of the following is used:
- `public NAME`: Make _NAME_ a global symbol rather than a
  section-qualified symbol. Must appear before symbol definition.
- `public NAME:SECNAME`: Lifts _NAME_ to enclosing section _SECNAME_.

If a symbol is referenced before definition and a parent section
contains a symbol of the same name, a forward reference must be
declared before use: `forward NAME`.

#### Sections in Listings and Map Files

Sectioned symbols appear in the `.map` file as `name[#]` where `#` is
a number referencing a later `Info for Section # name` line whence the
section name can be read. This distinguishes separate sections with
the same name.

Section symbols in the listing symbol table appear as `name
[secname]`; these entries appear to be duplicated for different
sections with the same name; they can be distinguished only in the
`.map` file. The `-s` option makes no difference to the listing symbol
table; it merely adds an additonal page to the listing output with a
hierarchical listing of section names.


Source Format and Syntax (§2.5)
-------------------------------

One instruction/pseudo-op/macro call per line.

    [label[:]] op[.attr] [param[,param …]   [;comment]

### Literals (§2.10.1-4)

Integer constants use `radix` (§3.7.7, always taking a decimal argument)
when unadorned, or the following modifiers, depending on architecture.
`relaxed on` (§3.9.6) will enable all modifers below.
- Motorola: prefix `$` hex, `@` octal, `%` binary.
- Intel: suffix `H` hex, `Q` or `O` octal, `B` binary.
- C: prefix `0x` hex, `0` octal, `0b` binary.
- Relaxed: `x'…'` or `h'…'` hex, `o'…'` octal, `b'…'` binary.

Floating point constants use the following format. At last one digit (even
just `0`) after the decimal point or an exponent are required; `2.` is an
integer constant but `2.0` is floating point.

    [-]<integer digits>[.post decimal positions][E[-]exponent]

String constants may not contain null (`\0`) characters. They are enclosed
in `"` or `'` and use (case-insensitive) C escapes.

    \a  BEL     \n  LF      \' \h  single quote     \###    decimal value
    \b  BS      \r  CR      \" \i  double quote     \x##    hex value
    \e  ESC     \t  TAB     \\     backslash        \0###   octal value

    \{…}    expression interpolation into the string (using `outradix`)

`move.l #'\'abc',d0` will not work; the comma will be interpreted as part
of the character constant. Use `\i` instead of `\'`.

### Expressions/Formulas (§2.10.5-7)

Numeric expressions are evaluated using the highest available precision
(32/64-bit int, 64/80-bit floating point, 255 char strings) with overflow
tests only on the final result.

Operators ([§2.10.6]), from higest to lowest precedence. Parens for grouping.
Shifts are logical (filling with `0`), not arithmetic. Lines starting with
`>` list different precedence in descending order; lines starting with `=`
have same precedence for all operators.

    >    ~ NOT      << lshift   >> rshift   >< bit mirror
    >    & bit-AND   | bit-OR    ! bit-XOR

         ^ exponen
    =    * mult      / quotient  # remainder(mod)
    =    + addition  - subtrac
    >   ~~ NOT      && AND      || OR       !! XOR

    =   <>    >=    <=     >     <        = == (same)

Functions ([§2.10.7]).


Assembler Directives
--------------------

### Code Generation (§3.2)

- `cpu`
- `org`, `rorg`, `phase`
- `segment` (§3.2.13)
- `save`, `restore` (§3.2.15): XXX Mainly for include files.
- `assume`
- `z80syntax`
- `radix N`: Default radix for integer constants, _N_ = `2`…`36` (always
  read as decimal).
- `outradix N`: Output radix for `"…\{…}…"` interpolation of integers.

### Definitions (§3.1)

- `equ`, `set`: Typeless constant; not allocated to a segment. `equ`
  is single-assigment; `set`s are reassignable variables. (May be
  allocated to a segment by providing segment name as additional
  argument.)
- `enum`: Sequential `equ` assigment of `0…` to arguments; use `=` to
  override value. Continue immeidately previous enum with `nextenum`
- `label`: XXX
- `charset`, `codepage`: XXX
- `pushv`, `popv`: XXX

### Data Definitions (§3.3)

These differ for different CPUs. General rules:
- Numeric constants (bytes, words, …) can use a reptition factor in
  brackets before a parameter, e.g. `[(*+255)&$FFFF00-*]0`. This may
  overflow the limit of 1 KB code generated per line.
- Strings can be delimited by double/single quotes and slashes.

Common to all processors:
- `align`: Aligns to the next byte boundary divisible by the given
  arg. An optional second arg defines the fill used for the skipped area.

6502:
- `byt`, `fcb`: Byte constants or ASCII strings. ("Form Constant Byte")
- `adr`, `fdb`: Word constants. ("Form Double Byte")
- `fcc`: String constants; double-quoted only.
- `dfs`, `rmb`: Reserve number of bytes given as parameter. ("Reserve
  Memory Bytes")

### Conditional Assembly (§3.6)

_EXPR_ below evaluates to false for any 0 result or true for any non-0
result. See §2.10 for expression formulas.

`if EXPR` / `elseif [EXPR]` / `else` / `endif` assembles the block if
_EXPR_ is true. Zero or more `elseif`s may be used between `if` and
`endif`. An `elseif` with no _EXPR_ is the same as `else`. In nested
constructions `elseif` always refers to the innermost unclosed `if`.

Additional special `if` constructs are:
- `ifdef SYM` / `ifndef SYM`: Symbol _SYM_ is/is not defined.
- `ifused SYM` / `ifnused SYM`: Symbol _SYM_ has been referenced before
  this point in the assembly.
- `ifexist FILE` / `ifnexist FILE`: File _FILE_ does/doesn't exist. Same
  syntax and search paths as `include` (§3.9.2).
- `ifb ARGLIST` / `ifnb ARGLIST`: True/false if all arguments in the list
  are empty strings.

`switch EXPR` / `case VAL` / `elsecase` / `endcase` compares the value
of _EXPR_ against each _VAL_, assembling only the first matching case.

### Listing Control (§3.7)

- `title TITLE`
- `page LINES,WIDTH`: Number of lines at which to emit a form feed,
  not including header lines. `1`-`255` or `0` for none between
  initial header and symbol table. Optional _WIDTH_ (`5`-`255`) wraps
  lines at that column; default 0 does not wrap.
- `newpage N`: Force a new page. Optional section depth N (`0`-`4`)
  controls generation of `3.2`, `4.1.1` etc chapter depths.
- `macexp_dft`, `macexp_ovr`: Control of macro expansion.
- `listing ARG`: _ARG_ is `off`, `on`, `noskipped` (don't print
  conditional assembly not assembled) and `purecode` (as `noskipped`
  but suppress `if` etc. as well). Sets values `0` to `3` resp. of
  `LISTING` symbol.
- `prtinit SI`, `prtexit SO`: Emit _SI_ and _SO_ before and after
  listing. Used for, e.g., setting compressed mode on printers.



<!-------------------------------------------------------------------->
[0cjs/8bitdev]: https://github.com/0cjs/8bitdev
[Kuba0/asl]: https://github.com/KubaO/asl.git
[as-dl]: http://john.ccac.rwth-aachen.de:8000/as/download.html
[as-doc]: http://john.ccac.rwth-aachen.de:8000/as/as_EN.html
[as]: http://john.ccac.rwth-aachen.de:8000/as/
[§2.10.6]: http://john.ccac.rwth-aachen.de:8000/as/as_EN.html#sect_2_10_6_
[§2.10.7]: http://john.ccac.rwth-aachen.de:8000/as/as_EN.html#sect_2_10_7_
