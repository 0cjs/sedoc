6502 Routines
=============

### Contents

- Misc
- Arithmetic, Boolean Algebra, Bit/Word Handling

Misc
----

### Stack-relative Indexing

            STA $100,X      ; PHA equivalant using X as stack pointer
            DEX

            INX             ; PLA equivalant using X as stack pointer
            LDA $100,X

Stack-relative indexing with another register assumes a non-wrapping
stack, i.e., that it's been initialized with `LDX, #$FF; TXS`.

After a `TSX`, offset `$101,X` is current stop of stack; add values into
that to do stack-relative indexing. Less efficiently, you can load the
base into ZP and index off it with Y:

            LDX #$01        ; init hibyte of addr; never changes
            STX spbase+1
            ...
            TSX
            INX             ; use 0-based indexing
            STX spbase      ; lobyte must be updated for particular stack state
            LDY 3           ; fourth byte  on stack
            LDA (spbase),Y

### Saving registers and flags for printing

To preserve registers and get the value of the flags to print them
(from 6502.org wiki [Software - Output flags][6w-flags]):

            PHP
            PHA
            TXA
            TSX             ; save location flags - 2
            PHA
            INX
            INX
            LDA $100,x      ; get P from stack
            JSR printflags
            PLA
            TAX
            PLA
            PLP
            RTS

(This is simpler on the 65C02 where you have PHX/PLX and PHY/PLY
instructions.)

### Easy Delay

This delays 9×(256×A+Y)+8 cycles, i.e., 9 to 589,832 cycles, with
resolution of 9 cycles. From [Bruce Clark][6f-bclark] via [wmtips].

    loop:   CPY #1      ; set carry if Y >= 1, i.e., if Y is not 0
            DEY         ; does not affect carry
            SBC #0      ; subtract ¬C from A; i.e., subtract 1 only if
                        ; carry was 0 because Y is 0 after decrement
            BCS loop


Arithmetic, Boolean Algebra, Bit/Word Handling
----------------------------------------------

### Increment/Decrement

From [6w-incdec]. Constant-time increment/decrement (both 6 cycles):

        CPX #$FF                CPX #$01
        INX                     DEX
        ADC #$00                SBC #$00

You can use the same "compare to set carry then add/subtract it"
to increment and stop at $00, or decrement and stop at $FF:

        CMP #1                  CMP #$FF
        ADC #0                  SBC #0


### Arithmetic shift right

From Nesdev Wiki [Synthetic Instructions][nw-syn]:

            CMP #$80        ; copy sign bit of A into carry
            ROR A

            LDA addr        ; copy memory into A
            ASL A           ; copy sign bit of A into carry (shorter than CMP)
            ROR addr

### Sign Extension

From Nesdev Wiki [Synthetic Instructions][nw-syn].

            ASL A           ; sign bit into carry; use CPX etc. if using X reg
            LDA #$00
            ADC #$FF        ; C set:   A = $FF + C = $00
                            ; C clear: A = $FF + C = $FF
            EOR #$FF        ; Flip all bits and they all now match C

To get the sign extension of the of the X or Y register, instead of
`ASL A` use `CPX #$80` or `CPY #$80`.

### Negation and Reversed Subtraction

From Nesdev Wiki [Synthetic Instructions][nw-syn].

                                        ; two's complement negation:
            EOR #$FF    EOR #$FF        ; flip bits...
            CLC         SEC             ; (assuming we don't know carry state)
            ADC #1      ADC #0          ; ...and add 1

            ; A = value - A is just add of negated A
            EOR #$FF
            SEC
            ADC value

### Fast nybble swap

By David Galloway. See [wm-SWM].

            ASL A
            ADC #$80
            ROL A
            ASL A
            ADC #$80
            ROL A

### Binary digit to ASCII HEX digit

From [6t-decimal]:

            CMP #$0A
            BCC digit
            ADC #$66    ; Add $67 (carry is set), $0A-$0F -> $71-$76
    skip    EOR #$30    ; $00-$09, $71-$76 -> $30-$39, $41-$46

Slightly shorter (but not faster) using decmial mode, but needs
undocmented carry behaviour?

            SED
            CMP #$0A
            ADC #$30
            CLD

### Decimal Output of Fixed-width Values

See [6w-outdec], which also includes versions with leading spaces
instead of zeros or no leading chars at all. The leading zeros one is,
though longer, the simplest because it more clearly shows the `EOR
#$30` (in this case, split into `EOR #$10` and `EOR #$20`) that
translates the BCD digit to the ASCII code for that digit.

XXX The comments added to explain this need to be completed.

    outdec8:
            LDX #1          ; start with leading zeros
            STX pzero
            INX             ; X=2; start with most significant position
            LDY #$40        ; ??? clearing bit 4 and setting 4 will give digit?
    1$:     STY digit       ; start working on this digit
            LSR             ; clears MSb; LSb in carry; skips BCS below
    2$:     ROL             ; MSB in carry; A restored; N affected
            BCS 3$          ; carry clear if we came from 1$, otherwise
                            ; ensure we subtract if left shift produced >$FF
            CMP digtab,X    ; is current digit > table value for that digit?
            BCC 4$          ; no, skip next bit
    3$:     SBC digtab,X    ; yes, subtract table value
            SEC             ; ensure carry is still set; it would have been
                            ; cleared if BCS 3$ above was taken
    4$:     ROL digit
            BCC 2$          ; top bit not set

            TAY             ; preserve working value
            CPX pzero
            LDA digit
            BCC 5$          ; X > pzero; ???
            BEQ 6$          ; X = pzero; ???
            STX pzero
    5$      EOR #$10        ; flip (set?) bit 4
    6$      EOR #$20        ; flip (set?) bit 5
            JSR print_digit
            TYA             ; restore working value
            LDY #$10        ; ??? setting 5 will give digit?
            DEX             ; decrement position counter
            BPL 1$          ; >=0; do next digit
            RTS

    digtab: .DB 128
            .DB 160
            .DB 200         ; most significant digit is portion >= 200
    digit:  .DS 1           ; current digit we're working on
    pzero   .DS 1           ; If this is 1, and X (current digit) > 1, we
                            ; are outputting leading zeros


<!-------------------------------------------------------------------->
[6f-bclark]: http://forum.6502.org/viewtopic.php?p=62581#p62581
[6t-decimal]: http://www.6502.org/tutorials/decimal_mode.html
[6w-flags]: http://6502org.wikidot.com/software-output-flags
[6w-incdec]: http://6502org.wikidot.com/software-incdec
[6w-outdec]: http://6502org.wikidot.com/software-output-decimal
[nw-syn]: http://wiki.nesdev.com/w/index.php/Synthetic_instructions
[wm-SWM]: http://6502.org/source/general/SWN.html
[wmtips]: http://wilsonminesco.com/6502primer/PgmTips.html
