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


Segments
--------

(§3.2.13)
`DATA`, `IDATA`, `XDATA`, `YDATA`, `BITDATA`, `IO`, or `REG`.
`MOMSEGMENT` is current segment.


Source Format and Syntax (§2.5)
-------------------------------

    [label[:]] op[.attr] [param[,param …]   [;comment]


Assembler Directives
--------------------

### Code Generation (§3.2)

- `cpu`
- `org`, `rorg`, `phase`
- `segment` (§3.2.13)
- `save`, `restore` (§3.2.15): XXX Mainly for include files.
- `assume`
- `z80syntax`

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


<!-------------------------------------------------------------------->
[0cjs/8bitdev]: https://github.com/0cjs/8bitdev
[Kuba0/asl]: https://github.com/KubaO/asl.git
[as-dl]: http://john.ccac.rwth-aachen.de:8000/as/download.html
[as-doc]: http://john.ccac.rwth-aachen.de:8000/as/as_EN.html
[as]: http://john.ccac.rwth-aachen.de:8000/as/
