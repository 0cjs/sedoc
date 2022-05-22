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

The Macroassembler AS `p2bin` program can generate these files by using the
entrypoint options to prepend the little-endian 2-byte start address:

    p2bin -e 0x801 -S L2 foo.p foo.prg

A machine-langauge program can work with the `Shift-RUN/STOP` autoload
(which uses `,8,0`) by prefixing it with a BASIC program that executes `SYS
2064` (or whatever the start address is). [[rcse 17475]]


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
[rcse 17475]: https://retrocomputing.stackexchange.com/q/17475/7208

[MultiMax]: http://www.multimax.co/download/
[alphacart]: http://swut.net/files/Alphaworks_8k_Cartridge.pdf
[lemon-64kcart]: https://www.lemon64.com/forum/viewtopic.php?t=67075

[aay]: http://unusedino.de/ec64/technical/aay/c64/
[basromma]: http://unusedino.de/ec64/technical/aay/c64/basromma.htm
[krnromma]: http://unusedino.de/ec64/technical/aay/c64/krnromma.htm
[ultdis]: https://www.pagetable.com/c64disasm/
