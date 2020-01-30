6502 CPU Families
=================

There are four basic families of the 6502 CPU:
- __N__ 6502: Original NMOS (with and without the ROR bug)
- __C__ [65C02] or 65CE02: Bugfixes, more instructions, etc.
- __S__ 65SC02: 65C02 but without the bit manipulation instructions.
- __8__ 65C802 or 65C816: 16-bit processor in 8-bit mode


Model Detection
----------------

### Hardware

A CMOS version draws between 4-16 mA; an NMOS one between 70-160 mA.
([BillIO][73307])


### Software

This [program from Chromatix][73317] leaves an ASCII code in the
accumulator indicating the family of the CPU it's run on.

    ;   N - NMOS 6502
    ;   S - 65SC02
    ;   C - 65C02 or 65CE02
    ;   8 - 68C816 or 65C802

    TestCPU:    lda #0
                sta $84
                sta $85
                lda #$1D    ; 'N' EOR 'S'
                sta $83
                lda #$25    ; 'N' EOR 'S' EOR '8'
                sta $1D
                lda #$4E    ; 'N'
                rmb4 $83    ; magic $47 opcode
                eor $83

                ; output routine for BBC Micro
                jsr $FFEE   ; OSWRCH
                jsr $FFE7   ; OSNEWL
                rts


<!-------------------------------------------------------------------->
[65C02]: https://en.wikipedia.org/wiki/WDC_65C02
[73307]: http://forum.6502.org/viewtopic.php?f=4&t=5929&view=unread#p73307
[73317]: http://forum.6502.org/viewtopic.php?f=4&t=5929&view=unread#p73317
