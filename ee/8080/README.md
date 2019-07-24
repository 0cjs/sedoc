Intel 8080 and Related CPUs
===========================

There's good documentation many different kinds of old systems at
[Daves Old Computers][dunfield]; the undocumented (and unlinked)
[`/dunfield/r`] subdir contains programming information for various
architectures (and ZIPped docs on C64 cassette and video monitor).


8080 Architecture
-----------------

An excellent instruction summary is [8080.txt](8080.txt),
downloaded from [`/dunfield/r`].

Registers:
- `A`, status register (flags); together `PSW`.
- `B`, `C`; together `B`.
- `D`, `E`; together `D`.
- `H`, `L`; `M` in `MOV` instructions is pointed-to memory loc.
- `SP` stack and `PC`; never directly referenced.

Flags: `S`ign, `Z`ero, `-`, `AC`, `-`, `P`, `-`, `C`arry.

Addressing modes: direct and indirect through a register. Nothing
involving addition of offsets. (Such poverty!)



<!-------------------------------------------------------------------->
[`/dunfield/r`]: http://www.classiccmp.org/dunfield/r/
[dunfield]: http://www.classiccmp.org/dunfield/
