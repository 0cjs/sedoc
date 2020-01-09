6502 Routines
=============

### Contents

- Misc
- Looping and Delays
- Arithmetic, Boolean Algebra, Bit/Word Handling

Also see Nesdev Wiki [6502 assembly optimisations][nw-opt].

Misc
----

### "Negative" Indexes

Mentioned in [6502 arithemtic and why it is terrible][cowlark],
possibly it comes from commenter Anonymous Cow. See `negoff` in
[8bitdev:src/simple-asl.a65][simple-asl] for a unit-tested example.

            LDY #-5             ; length of array
    loop:   LDA arr_end,$100,y  ; arr_end is location after last byte of array
            ...
            INY
            BNE loop

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

### Store two conditional results for later use

            JSR pred1       ; returns predicate value in carry
            ROR $00         ; any zero page addr
            JSR pred2
            ROR $00
            ...
            BIT $00
            BPL pred2true
            BVC pred1false

### BIT Interior-branch No-op

The BIT instruction sets NVZ flags but is otherwise a no-op; the
argument can be used to hold one or two bytes of instruction to which
you can jump. From [KansasFest 2019 Assembly Language Lightning
Talks][kf19alli].

    ;   Obfuscate a CLC instruction; this is from a copy-protected game
    09B9 C9 DE      CMP #$DE
    09BB F0 02      BEQ $09BF   ; branch to argument of BIT instruction
    09BD 38         SEC         ; next BIT does not affect C flag
    09BE 24 18      BIT $18     ; 18 = CLC

- Replace `JSR $8635` with `BIT $8635` (instead of `NOP; NOP; NOP`) to
  avoid executing a subroutine, preserving the address, though one
  must be careful if the subroutine returned flags.


Looping and Delays
------------------

### Run a Subroutine Two or More Times

Similar to the tail call optimization where one subroutine drops
straight into another, rather than calling it and returning, start
with a `JSR` to the immediately following routine, which becomes a TCO
call to itself. This can be stacked. From [this comment][6f-p67837] in
forum.6502.org.

    fourx:  JSR twice   ; executes `once` four times before returning
    twice:  JSR once    ; executes the following routine twice before returning
    once:   ...
            RTS

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

### ASCII decimal digit to binary

From [Henning Jensen][yt-hj]. (Also see [yt-ytvu].)

            EOR #$30    ; clears bits 4,5 if in range '0'-'?'
            CMP #$0A
            BCS notdigit

- Input $40/'@' or above will have two top bits set and be caught by
  the CMP/BCS.
- EOR will set one or both of bits 4,5 for input below the $30/'0'
  stick and also be caught by the CMP/BCS.
- Otherwise the EOR brought the $30/'0' to $3F/'?' range down to
  $00-$0F.
- Thus, input in the '0' stick but $3A/':' or above will be caught
  after that EOR by the CMP/BCS.
- If none of those conditions hold the EOR turned $30/'0'-$39/'9' into
  $00-$09.

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

### Compact ROM Multi-table

[Harper's answer on RCSE][harper] describes a very efficient technique
for storing three boolean flags plus a 5-bit value in a single array
of bytes in ROM. Bits 0, 6 and 7 are three tables of flag values, and
bits 1-5 are another value. Below, Y register is the offset into the
table (e.g., for a video game level).

* Bit 0 value: `ROR (table),y` loads bit 0 into the carry flag. This
  would modify RAM, but does not affect ROM. (This can serve as a form
  of copy-protection.)
* Bit 7 or 6 value: `ASL` loads bit 7 into the carry flag and bit 6
  into the negative flag. Again, table must be in ROM to avoid modification.
* Bits 1-5 are loaded via the obvious `LDA (table),y; LSR; AND #$1F`,
  which also leaves bit 0 in the carry.



<!-------------------------------------------------------------------->
[6f-bclark]: http://forum.6502.org/viewtopic.php?p=62581#p62581
[6f-p67837]: http://forum.6502.org/viewtopic.php?f=3&t=5517&hilit=robotron&start=60#p67837
[6t-decimal]: http://www.6502.org/tutorials/decimal_mode.html
[6w-flags]: http://6502org.wikidot.com/software-output-flags
[6w-incdec]: http://6502org.wikidot.com/software-incdec
[6w-outdec]: http://6502org.wikidot.com/software-output-decimal
[cowlark]: http://cowlark.com/2018-02-27-6502-arithmetic/
[harper]: https://retrocomputing.stackexchange.com/a/12974/7208
[kf19alli]: https://www.youtube.com/watch?v=xS58zd3wsuA
[nw-opt]: http://wiki.nesdev.com/w/index.php/6502_assembly_optimisations
[nw-syn]: http://wiki.nesdev.com/w/index.php/Synthetic_instructions
[simple-asl]: https://github.com/0cjs/8bitdev/blob/master/src/simple-asl.a65
[wm-SWM]: http://6502.org/source/general/SWN.html
[wmtips]: http://wilsonminesco.com/6502primer/PgmTips.html
[yt-hj]: https://www.youtube.com/watch?v=bDbpntumA6A&lc=Ugw4AnVKe4y6_INt1FV4AaABAg
[yt-ytvu]: https://www.youtube.com/watch?v=bDbpntumA6A&lc=UgzUx3ScG6-3lXWMNq54AaABAg.9-yXOn4CLwJ90M2ZlcJW8d
