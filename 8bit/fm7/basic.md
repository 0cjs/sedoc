FM-7 BASIC
----------

Section-page references below are to [富士通 FM-7 F-BASIC
文法書][fm7basic].

The FM-7 started with V3.0; 1.0 and 2.0 were FM-8 only. ROM BASIC does
not include disk I/O; `LOADM "0:FOO"` will give `Device Unavailable`
and `FILES "0:"`, `Illegal Function Call`. `DSKINI 1` returns `Syntax
Error`.

User program code starts at $0600; all memory below that is reserved
for BASIC.

- Use `&Hnn` for hex numbers; `&Onn` `&nn` for octal.
- Variables are single precision float (`!`) by default `x` and `x!`
  are the same variable. Other other suffixes (`%` integer, `#`
  double-precision FP, `$` string, `#` ??) are separate variables.

Selected system commands:
- `MON` (3-35): Enter a simple monitor; see [ml](ml.md).
- `HARDC` (3-36): Print a hardcopy of the screen.
- `TERM` (3-38): Initiate a connection via serial option board.
- `KEY LIST` (3-145): List function key definitions

Selected display-related commands:
- `WIDTH n,m` (3-104): Set screen width to _n_ (40 or 80) and number
  of lines to _m_ (20 or 25).
- `COLOR n,m`: Set forground colour to _n_, inverting fg/bg for 8-15.
  Background colour will become _m_ after next `CLS`.
- `SYMBOL (x,y),"c",hscale,vscale[,palette[,rot[,func]]]`. Write
  symbol _"c"_ (1-char string) at _(x,y)_ (0-640, 0-200), with
  horizontal and vertical scale (based on 80-col size).
- `CONSOLE` (3-105): Set scroll areas and other screen attributes.
- `SCREEN` (3-111): Select VRAM usage.
- `PSET`: Set/clear a point on the screen.

Selected BASIC commands:
- `EDIT n`: Clear screen and edit line _n_ for with `←↓↑→`, `EL` etc.
- `EXEC &Hnnnn`: Execute (JSR?) machine language code at address _nnnn_.
- `DEF FN`



<!-------------------------------------------------------------------->
[fm7basic]: https://archive.org/details/FM7FBASICBASRF
