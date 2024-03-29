Machine Language
================

See also [TEDMON](./tedmon.md).


Disk/Cassette Program Setup
---------------------------

A `.PRG` file contains a (little-endian) load address in the first two
bytes followed by data, usually a BASIC program or assembler code. `LOAD
"…",8,n` will load the file into memory; `,8` is the device number for the
first floppy drive and _,n_ is an optional load style:
- _n_=1 will load the data into memory at the load address given in the
  file.
- _n_=0 (the default) will ignore the load address in the file and instead
  load at the start of the BASIC program text area. ($801 on C64; varies on
  other models.)

BASIC Program Text start addresses (`Ver`=version of BASIC):

    Addr   Ver  Machine
    ───────────────────────────────────────────────────────────────────────────
    $0401  1.0  PET 2001
    $0801  2.0  Commodore 64
    $1001  3.5  TED (C16, C116, PLUS/4), graphics pages off

The Macroassembler AS `p2bin` program can generate these files by using the
entrypoint options to prepend the little-endian 2-byte start address:

    p2bin -e 0x801 -S L2 foo.p foo.prg

A machine-langauge program can work with the `Shift-RUN/STOP` autoload
(which uses `,8,0`) or [VICE autoload][vice] by prefixing it with a BASIC
program that executes `SYS 2064` (or whatever the start address is).
[[ophis]] [[rcse 17475]]


Cartridge Program Setup
-----------------------

The cartridge LOROM base address is $8000, but if neither RAM if
neither G̅A̅M̅E̅ nor E̅X̅R̅O̅M̅ is asserted RAM will be read on the C64
instead. Either way, the C64 Kernal reset vector checks $8004-$8008
for `C3 C2 CD 38 30` ("CBM" with high bits set, then "80"). If set, no
further Kernal startup is done and instead it jumps to the cartridge
cold-start vector at $8000.

The Kernal NMI routine (activated by the RESTORE key) also checks the
signature and, if present, uses the cartridge warm-start vector at
$8002. $FE5E can be used here for the standard system NMI (BASIC warm
start if STOP key pressed).

The above details come from the [Alphaworks Cartridge PCB
documentation][alphacart], which also provides basic init code
(calling into the Kernel) for cartridges. Also see the init code
in the lemon64.com/forum topic ["C64 64k carts?"][lemon-64kcart].

### MAX Startup

The MAX has no ROM, so G̅A̅M̅E̅ must be asserted and not E̅X̅R̅O̅M̅; the
standard 6502 reset/NMI vectors at $FFFC/$FFFA will be used.

Standard 6502 initialization must be done at startup. A good example
of a simple stand-alone cart program is the [MultiMax]; see
[`multimax.asm`](multimax.asm) from the `multimax_src.zip` archive.
Critical for any 6502 system is:

            sei         ; Mask interrupts until all peripherals are configured
            ldx #$ff
            txs         ; Clear stack
            cld         ; Clear decimal flag

In the code you can see following this the configuration for the CIAs
(one on MAX, two on C64) and the VIC-II, followed by a memory test.


Zero Page Usage
---------------

The zero page usage seems to differ significantly between PET/C64 and TED,
though there are definite shifts between PET and C64 as well.

Free zero page area for applications:
- $FB-$FE: C64, C128
- $D8-$E8: Plus/4

Possible locations for temporary storage:
- $03-$06 is "Storage for RENUMBER" on the Plus/4. It stomps on the
  (generally unused) pointers to ROM FP routines on the C64. These are temp
  locations for BASIC SYS/monitor call ($03-04) and register temps on C128.
- $61-$70 is the floating point accumulators and related locations in BASIC
  2.0 (C64) and 3.5 (TED); it's shifted two bytes up ($63-$72) in BASIC 7.0
  (C128). The ML monitor on the 128 uses T0 ($60), T1 ($63) and T2 ($66);
  BASIC 3.5 may use the same or 2 locations down for its monitor.
  - Using these on the Plus/4 seems to corrupt the BASIC program currently
    in memory.

References:
- Wikipedia, Commdore BASIC [Versions and Features][wpver] (for ROM vers)
- comp.sys.cbm (1994-12-14) [PET RAM memory map][c.s.c-pet-zp] (2.0 and 4.0?)
- Jim Butterfield, [VIC 20 / Commodore 64 Memory Map][butt]
- c64-wiki.com: [Zeropage][c64w-zp]
- unusedino.de: [Mapping the Commodore 64][mapping]
- [Plus/4 PRG][p4prg]: Detailed Memory Map p.425 P.439
- [Commodore 128 Programmer's Reference Guide][128prg], Bantam Books, 1986.
  p.502 P.512 Ch.15 The Commdore 128 and Commodore 64 memory Maps


ROM Routines
------------

The check for `CTRL` being held down to slow output is done in `CHROUT`
($FFD2, actually the $E716 subroutine that it calls for screen output) and
so works for ML programs that use this routine. It pauses for about 1/2
second after every newline.

- [Dreams AAY C64 helpfiles (HTML)][aay]
- pagetable.com [Ultimate Commodore 64 BASIC & KERNAL ROM Disassembly][ultdis]
- [C64 KERNAL ROM Listing][krnromma]
- [C64 BASIC ROM Listing][basromma]



<!-------------------------------------------------------------------->
[VICE autoload]: ./emulators.md#files-interfaces
[ophis]: https://michaelcmartin.github.io/Ophis/book/x72.html
[rcse 17475]: https://retrocomputing.stackexchange.com/q/17475/7208

[MultiMax]: http://www.multimax.co/download/
[alphacart]: http://swut.net/files/Alphaworks_8k_Cartridge.pdf
[lemon-64kcart]: https://www.lemon64.com/forum/viewtopic.php?t=67075

[128prg]: https://archive.org/details/C128_Programmers_Reference_Guide_1986_Bamtam_Books/page/502/mode/1up?view=theater
[butt]: https://www.commodore.ca/wp-content/uploads/2018/11/commodore_vic-20_c64_memory_map.pdf
[c.s.c-pet-zp]: http://dunfield.classiccmp.org/pet/petmem.txt
[c64w-zp]: https://www.c64-wiki.com/wiki/Zeropage
[mapping]: http://unusedino.de/ec64/technical/project64/mapping_c64.html
[p4prg]: https://archive.org/details/Programmers_Reference_Guide_for_the_Commodore_Plus_4_1986_Scott_Foresman_Co/page/n436/mode/1up?view=theater
[wpver]: https://en.wikipedia.org/wiki/Commodore_BASIC#Versions_and_features

[aay]: http://unusedino.de/ec64/technical/aay/c64/
[basromma]: http://unusedino.de/ec64/technical/aay/c64/basromma.htm
[krnromma]: http://unusedino.de/ec64/technical/aay/c64/krnromma.htm
[ultdis]: https://www.pagetable.com/c64disasm/
