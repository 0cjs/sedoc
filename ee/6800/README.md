- [README](README.md), [asm](asm.md), [opcodes](opcodes.md),
  [progcard](progcard)

Motorola 6800-series Microprocessors and Microcontrollers
=========================================================

This covers the Motorola 6800 series processors ([timeline]):
- __6800__ (1974-11): 1 MHz. External clock required.
  __68A00__=1.5 MHz, __68B00__=2.0 MHz (1976).
- [README](README.md), [asm](asm.md), [opcodes](opcodes.md),
  [progcard](progcard)

- __6802__, __6808__ (1977-03): Internal clock. '02 has 128 bytes of RAM.
- __6801__, __6803__ (1978-08): 16-bit D register, multiply and other
  instructions. (Used by GMC.) See [[arch]] for details.

This does not cover:
- __6805__ (1979): 8-bit X register and other incompatible changes.
  M14065: CMOS version. 68HC05: low power version. 6804: reduced cost
  version.
- __6811__ (1984): Greatly extended 6801. Available in modern versions.
- __6809__ (1979-07): Entirely incompatible.

References
----------

- [M6800 Programming Reference Manual][6800ref] M68PRM(D), Motorola, Nov. 1976.
- [SB-Project 6800 Introduction][sb 6800intro]. Brief programming model
  introduction and SB-Assembler support for the 6800/6802.


Bibliography
------------

- \[fin76] Robert Findley, [_6800 Software Gourment Guide and
  Coookbook_][fin76]. Hayden, 1976.
  - Very much a beginners' book. Ch.5 floating point routines might be of
    some interest. Written by Scelbi staff.

There's a [very large bibliography][og bib] at orphanedgames.com.



<!-------------------------------------------------------------------->
[timeline]: https://retrocomputing.stackexchange.com/a/11933/7208

<!-- References -->
[6800ref]: https://archive.org/stream/bitsavers_motorola68rammingReferenceManualM68PRMDNov76_6944968#page/n0/mode/1up
[sb 6800intro]: https://www.sbprojects.com/sbasm/6800.php

<!-- Bibliography -->
[fin76]: https://archive.org/stream/6800-Software-Gourmet-Guide-and-Cookbook-Robert-Findley-1976#page/n0/mode/1up
[og bib]: https://www.orphanedgames.com/APF/6800_cpu_programming/6800_cpu_programming.html
