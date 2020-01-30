6502 CPU Families
=================

There are four basic families of the 6502 CPU:
- __N__ 6502: Original NMOS (with and without the ROR bug)
- __C__ [65C02] or 65CE02: Bugfixes, more instructions, etc.
- __S__ 65SC02: 65C02 but without the bit manipulation instructions.
- __8__ 65C802 or 65C816: 16-bit processor in 8-bit mode

The CMOS versions should draw between 4 mA and 16 mA; the NMOS between
70 mA and 160 mA.

References:
- Wilson Mines Co., [Differences between NMOS 6502 and CMOS 65c02][wm-diff]



Model Detection
----------------

### Hardware

A CMOS version draws between 4-16 mA; an NMOS one between 70-160 mA.
([BillIO][73307])


### Software

This [program from Chromatix][73317] leaves an ASCII code in the
accumulator indicating the family of the CPU it's run on.

    ; Left in A register at end:
    ;      'N' - NMOS 6502
    ;      'S' - 65SC02
    ;      'C' - 65C02 or 65CE02
    ;      '8' - 68C816 or 65C802
    2B0 : A9 00     lda   #0
    2B2 : 85 84     sta  $84
    2B4 : 85 85     sta  $85
    2B6 : A9 1D     lda  #$1D       ; 'N' EOR 'S'
    2B8 : 85 83     sta  $83
    2BA : A9 25     lda  #$25       ; 'N' EOR 'S' EOR '8'
    2BC : 85 1D     sta  $1D
    2BE : A9 4E     lda  #$4E       ; 'N'
    2C0 : 47 83     rmb4 $83        ; magic $47 opcode
    2C2 : 45 83     eor  $83
    2C4 : 60        rts



<!-------------------------------------------------------------------->
[65C02]: https://en.wikipedia.org/wiki/WDC_65C02
[wm-diff]: http://wilsonminesco.com/NMOS-CMOSdif/

[73307]: http://forum.6502.org/viewtopic.php?f=4&t=5929&view=unread#p73307
[73317]: http://forum.6502.org/viewtopic.php?f=4&t=5929&view=unread#p73317
