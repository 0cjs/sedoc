Machine Language
================


Cartridge Program Setup
-----------------------

Carts may need to do some basic system initialization at startup,
particularly on the MAX which has no ROM. (XXX Figure out what setup a
C64 does before jumping to cart entry point.) A good example of a
simple stand-alone cart program is the [MultiMax]; see
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

- [Dreams AAY C64 helpfiles (HTML)][aay]
- [C64 KERNAL ROM Listing][krnromma]
- [C64 BASIC ROM Listing][basromma]



<!-------------------------------------------------------------------->
[MultiMax]: http://www.multimax.co/download/
[krnromma]: http://unusedino.de/ec64/technical/aay/c64/krnromma.htm
[basromma]: http://unusedino.de/ec64/technical/aay/c64/basromma.htm
[aay]: http://unusedino.de/ec64/technical/aay/c64/
