Apple II Tips and Tricks
========================

$FF54 for Help with Relocatable Code
------------------------------------

The Apple II ROM contains this routine at $FF54:

            TSX
            STX SPNT    ; $49
            CLD
            RTS

You can call this to get the return address of your call pushed on to
the stack and then popped off; since it still remains in memory below
the stack pointer, retrieve it with:

            JSR $FF54
    me:     TXS         ; move SP back down where it was in subroutine
            PLA         ; retrieve <me-1 (calling address +2 low byte)
            STA $zp
            PLA         ; retrieve >me-1 (calling address +2 high byte)
            STA $zp+1

This can be used for "relative subroutine" calls as well:

            JSR $FF54   ; clears Z flag
            BNE sub
            ...
    sub:    TSX         ; sets stack pointer instead of JSR having done it
            ...
            LDA #00     ; or any other way of setting Z
            RTS
