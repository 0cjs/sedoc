Machine Language
================


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
($FFD2) and so works for ML programs that use this routine. It pauses for
about 1/2 second after every newline.

- [Dreams AAY C64 helpfiles (HTML)][aay]
- pagetable.com [Ultimate Commodore 64 BASIC & KERNAL ROM Disassembly][ultdis]
- [C64 KERNAL ROM Listing][krnromma]
- [C64 BASIC ROM Listing][basromma]



<!-------------------------------------------------------------------->
[MultiMax]: http://www.multimax.co/download/

[alphacart]: http://swut.net/files/Alphaworks_8k_Cartridge.pdf
[lemon-64kcart]: https://www.lemon64.com/forum/viewtopic.php?t=67075

[aay]: http://unusedino.de/ec64/technical/aay/c64/
[basromma]: http://unusedino.de/ec64/technical/aay/c64/basromma.htm
[krnromma]: http://unusedino.de/ec64/technical/aay/c64/krnromma.htm
[ultdis]: https://www.pagetable.com/c64disasm/
