CBM Peripherals
===============


Commodore 64/128
----------------

### REU (RAM Expension Unit)

DMA engine w/128 K to 512 K (or 2 MB in user modifications) of memory
that is not directly accessible by the C64. Uses I/O2 page.

    $DF00   Status register (read-only). Bits 3-0 contain version.
    $DF01   Command register (unmarked bits reserved)
              7   write 1 to execute command
              5   0: addr/length registers unchanged after execute
                  1: set address reg to end of last xfer+1, length to 1
              4   0: execute above waits for write to $FF00 before executing
                  1: execute starts immediately on writing bit 7 above
              1,0 Transfer type:
                  00: C64 → REU
                  01: REU → C64
                  10: Swap REU/C64
                  11: Compare REU/C64
    $DF02,3 C64 base address
    $DF04-6 REU base address (LSB, MSB, bank number)
    $DF07,8 Xfer length; 0 = 64 KB. Length > end of C64 memory will wrap.
            Crossing 512 KB boundary in REU will wrap.
    $DF09   Interrupt mask
    $DF0A   Address control (0 = don't increment DMA addr counter during xfer)
              7: 1 = fix C64 address
              6: 1 = fix REU address

There's some stuff about interrupts, too; this may not be necessary to use.

Documentation:
- [Codebase 64 REU links][cb64]
- [Programming the Commodore RAM Expansion Units (REUs)][C=hack#8]

[cb64]: https://codebase64.org/doku.php?id=base:thirdparty#reu
[C=hack#8]: https://ar.c64.org/wiki/Programming_the_Commodore_REUs_C%3DHacking_Issue_8.txt
