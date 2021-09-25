6502 Routines
=============

### Contents

- Misc
- Looping and Delays
- Arithmetic, Boolean Algebra, Bit/Word Handling
- External Sources

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

### Store Carry Flag for Later Use

You can store it in bit 0 of X, with the other bits being rubbish. Or
even just leave it in A if you don't need A for other things during
`...`. From Jean-Charles Meyrignac on [cowlark].

            LDX #0          ; clear carry
    loop:   TXA             ; get saved carry from X
            LSR             ;   and shift it into carry flag
            ...
            ROL             ; carry flag → A bit 0
            TAX             ;   and save in X

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

### Autoamtic Long JMP vs. Short BRA

Create macros `JEQ`, `JNE`, `JCC` etc. that assemble to the equivalent
`BEQ` etc. instruction if the branch is in range for it, otherwise assemble
to the opposite branch jumping over a `JMP`:

    │ JNE target │    │ BNE target │       │       BEQ .skip  │
    │            │ →  │            │  or   │       JMP target │
    │            │    │            │       │ .skip            │

### Detecting 6502 vs. 65C02

Without undefined opcodes ([BDD on 6502.org][6f p73063]):

           SED                   ; select decimal mode
           CLC
           LDA #$99
           ADC #$01              ; produces $00 with carry
           CLD                   ; back to binary mode
           BEQ is_cmos           ; is a 65C02/65C802/65C816
           BNE is_nmos           ; is a 6502/6510/8502, etc.

Using `BRA` ($80), which is undefined but a two-byte NOP on the NMOS
CPUs, is faster, and should be reliable according to Chromatix in a
follow-up post to the above.

[Chromatic provides a more precise routine.][6f p73317] This is
modified by me for Apple II output, but it's necessary for it to stomp
on zero-page addresses used by Applesoft and Integer BASIC.

    ; One of the following codes is left in the accumulator:
    ;    N - NMOS 6502         S - 65SC02
    ;    C - 65C02 or 65CE02   8 - 68C816 or 65C802

    02E8 A9 00      LDA #0
    02EA 85 84      STA $84
    02EC 85 85      STA $85
    02EE A9 1D      LDA #$1D    ; 'N' EOR 'S'
    02F0 85 83      STA $83
    02F2 A9 25      LDA #$25    ; 'N' EOR 'S' EOR '8'
    02F4 85 1D      STA $1D
    02F6 A9 4E      LDA #$4E    ; 'N'
    02F8 47 83      RMB4 $83    ; magic $47 opcode
    02FA 45 83      EOR $83

    ; Output routine for Apple II (we leave it as a flashing char).
    02FC 20 ED FD   JSR COUT    ; Or use $FFEF for Apple 1 Wozmon.
    02FF 60         RTS

    ; output routine for BBC Micro
                    JSR $FFEE   ; OSWRCH
                    JSR $FFE7   ; OSNEWL


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

### Short Delays

`NOP` (2 cycles) helps created even-cycle-count delays. `JMP *+3` takes 3
cycles. `BVC *+2`, `BVS *+2` takes exactly 5 cycles.

For "run-time programmable" (but destroys flags), jump to any byte from
`delayJumpVectorInit` to the code following it to get a delay of the given
number of cycles. (Extend it with further `CMP #C9` as necessary.) [[White
Flame][6f p77097]]

    delayJumpVectorInit:                ; (2nd inst)
            CMP #$C9    ; 7, 6 cycles     (CMP #$C9)
            CMP #$C9    ; 5, 4 cycles     (CMP $24)
            BIT $EA     ; 3, 2 cycles     (NOP)


Arithmetic, Boolean Algebra, Bit/Word Handling
----------------------------------------------

### Increment/Decrement

[[6w-incdec]] contains a wide variety of increments/decrements (byte, word,
word with test for zero, +/-255 (DEC LSB and INC MSB or vice versa),
constant time, stop at $00/$FF). Peter Ferrie commenting on [[cowlark]] has
further discussion of designing around convenient increment/decrement
routines. [[8b decw]] compares size/time for double-decrement using SUB and
DEC+DEC (former is much better), and that's also discussed at [[6f t????]].

Constant-time increment/decrement, both 6 cycles ([[6w-incdec]]):

        CPX #$FF                CPX #$01
        INX                     DEX
        ADC #$00                SBC #$00

You can use the same "compare to set carry then add/subtract it"
to increment and stop at $00, or decrement and stop at $FF:

        CMP #1                  CMP #$FF
        ADC #0                  SBC #0

### 16-bit Decrement

From Peter Ferrie commenting on [cowlark]:

            LDA addr
            BNE .skip
            DEC addr+1
    .skip   DEC addr

### Arithmetic Shift Right (ASR)

From Nesdev Wiki [Synthetic Instructions][nw-syn]:

            CMP #$80        ; copy sign bit of A into carry
            ROR A           ; shift register

            LDA addr        ; copy memory into A
            ASL A           ; copy sign bit of A into carry (shorter than CMP)
            ROR addr        ; shift memory location

### Sign Extension

From Nesdev Wiki [Synthetic Instructions][nw-syn].

            ASL A           ; sign bit into carry; use CPX etc. if using X reg
            LDA #$00
            ADC #$FF        ; C set:   A = $FF + C = $00
                            ; C clear: A = $FF + C = $FF
            EOR #$FF        ; Flip all bits and they all now match C

To get the sign extension of the of the X or Y register, instead of
`ASL A` use `CPX #$80` or `CPY #$80`.

For extension in the zero page, [Mike B.][6f t6069] offers:

      ; Sign-extend A to 16 bits in ZP
            STA zp
            LDA #$7F
            CMP zp          ; C=0 for <0, C=1 for >= 0
            SBC #$7F
            STA ZP+1

      ; Promote int16 in ZP to int32
            LDA #$7F
            CMP zp+1        ; C=0 for <0, C=1 for >=0
            SBC #$7F
            STA ZP+2        ; $FF for <0, $00 for >0
            STA ZP+3

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

### Fast Accumulate in Registers

From [BigEd][6f-t5945] (also [here][rcf-929]): accumate in X and Y (15
cycles for zero-page operand, otherwise 17).

            TXA
            CLC
            ADC lowbyte
            TAX
            TYA
            ADC highbyte
            TAY

### Fast nybble swap

By David Galloway. See [wm-SWM]. The [explanation by gfoot][6f p85436]:

> The idea is to rotate four times but without including the carry flag in
> the operation, unlike the 6502's normal rotate instruction. The first
> line shifts one place with the high bit going into the carry flag. To
> complete the first shift we just want to get that value out of the carry
> flag into the low bit. ADC #0 would do that, and you could repeat those
> two instructions four times to get the desired result. It only works with
> left shifts because ADC can only move the carry flag into the bottom bit.

> The clever shortcut in that code though is that instead of adding zero to
> extract the carry flag into the bottom bit, it adds $80 which also
> inverts the top bit, causing a new carry if it was set originally. This
> effectively moves that top bit into the carry flag, which allows a
> follow-up ROL to rotate that value out of the carry flag into the bottom
> bit more efficiently.

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

### Bit-banging I/O

Absolute-addresed `INC/DEC` can do input and output simultaneously for
things like synchronous serial interfaces because it does both a read
and write of the memory location. Make bit 0 the clock output and bit
7 the input:
- With the clock bit clear, `INC portaddr` will set the clock bit and
  copy the input bit to the N flag.
- With the clock bit set, `DEC portaddr` will clear the clock bit and
  copy the input bit to the N flag.

([Dr. Jefyll][6f p73765]. Also see [his SPI post][6f p45555].)


External Sources
----------------

- [pfusik/zlib6502] is an INFLATE routine for [DEFLATE] protocol as used in
  ZIP, gzip, PNG, etc. Uses 508 bytes of code and constants, 765 bytes of
  data memory and 10 bytes of zero page memory.


<!-------------------------------------------------------------------->
[6f p45555]: http://forum.6502.org/viewtopic.php?p=45555#p45555
[6f p73063]: http://forum.6502.org/viewtopic.php?f=2&t=5922#p73063
[6f p73317]: http://forum.6502.org/viewtopic.php?f=4&t=5929&start=15#p73317
[6f p73765]: http://forum.6502.org/viewtopic.php?f=4&t=6021#p73765
[6f p77097]: http://forum.6502.org/viewtopic.php?f=2&t=6177#p77097
[6f p85436]: http://forum.6502.org/viewtopic.php?f=2&t=6697&view=unread#p85436
[6f t6069]: http://forum.6502.org/viewtopic.php?f=2&t=6069
[6f-bclark]: http://forum.6502.org/viewtopic.php?p=62581#p62581
[6f-p67837]: http://forum.6502.org/viewtopic.php?f=3&t=5517&hilit=robotron&start=60#p67837
[6f-t5945]: http://forum.6502.org/viewtopic.php?f=2&t=5945
[6t-decimal]: http://www.6502.org/tutorials/decimal_mode.html
[6w-flags]: http://6502org.wikidot.com/software-output-flags
[6w-incdec]: http://6502org.wikidot.com/software-incdec
[6w-outdec]: http://6502org.wikidot.com/software-output-decimal
[8b decw]: https://github.com/0cjs/8bitdev/blob/ce7d4eadf6738f7d3b806d2b2486309c493742be/src/m65/misc.a65#L7-L36
[cowlark]: http://cowlark.com/2018-02-27-6502-arithmetic/
[harper]: https://retrocomputing.stackexchange.com/a/12974/7208
[kf19alli]: https://www.youtube.com/watch?v=xS58zd3wsuA
[nw-opt]: http://wiki.nesdev.com/w/index.php/6502_assembly_optimisations
[nw-syn]: http://wiki.nesdev.com/w/index.php/Synthetic_instructions
[rcf-929]: https://retrocomputingforum.com/t/life-4-gosper-glider-guns-on-pdp-7-type-340-display/929/9
[simple-asl]: https://github.com/0cjs/8bitdev/blob/master/src/simple-asl.a65
[wm-SWM]: http://6502.org/source/general/SWN.html
[wmtips]: http://wilsonminesco.com/6502primer/PgmTips.html
[yt-hj]: https://www.youtube.com/watch?v=bDbpntumA6A&lc=Ugw4AnVKe4y6_INt1FV4AaABAg
[yt-ytvu]: https://www.youtube.com/watch?v=bDbpntumA6A&lc=UgzUx3ScG6-3lXWMNq54AaABAg.9-yXOn4CLwJ90M2ZlcJW8d

<!-- External Sources -->
[pfusik/zlib6502]: https://github.com/pfusik/zlib6502
[DEFLATE]: https://en.wikipedia.org/wiki/DEFLATE
