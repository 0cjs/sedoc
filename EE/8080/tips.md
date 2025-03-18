8080/Z80 Tips and Tricks
========================


8080 and All Compatible
------------------------

#### Argument After Call

    pop  hl         ; load return address
    …               ; iterate through data until end
    jp   (hl)       ; RET to after data

If you need to preserve your HL across subroutine calls, use `ex hl,(sp)`.

#### Conditional RST $38

    jr   c,$-1

Z80 Only
--------

#### Compare HL with DE  [[rz80-top5]]

    or   a,a        ; clear carry flag
    sbc  hl,de      ; sets N, affects all other flags
    add  hl,de      ; (DAD) resets N, affects only C,HC

####  CPI Iteration

`cpi` is compare and increase: compare A with (HL), ++HL, --BC, repeat
until BC==$0000 or A==(HL). `cpd` is same w/--HL, `cpdr` is ???.

But you can ignore the compare result, and check parity/overflow flag
for BC==0:

    -   ld   a,(hl)
        ; process A
        cpi             ; inc HL, dec BC
        jp   pe,-       ; repeat until BC==0


Sources
-------

- YouTube, Ready? Z80, [Top 5 Z80 Coding Hacks][rz80-top5]
- Sinclair ZX World Forums, [Top Five Z80 Coding Hacks In Five
  Minutes][zxwtop5].



<!-------------------------------------------------------------------->
[zxwtop5]: https://www.sinclairzxworld.com/viewtopic.php?t=5675
[rz80-top5]: https://www.youtube.com/watch?v=jvDO9N6_t24
