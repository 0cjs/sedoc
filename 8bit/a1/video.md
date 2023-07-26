Apple 1 Video Circuit
=====================

Schematic on second-last page of the [manual][a1man].

Parts included:
- [555] timer
- 2504 possibly RAM? (?×)
- Signetics [2513]: 2560 bit 64×8×5 character generator ROM (1×)
- [2519] hex 40-bit shift register (1×)
- [74157] quad 2-line to 1-line data selector/multiplexer (2×)
- [74161] 4-bit binary counters (5×, plus one decade 74160)
- [74166] parallel load 8-bit shift register (1×)
- [74174] hex D flip-flop, common asynchronous clear (1×)
- DS0025 ??? (1×)
- Lots of AND/OR/etc. gates
- 14.31818 Mhz crystal


Theory of Operation
-------------------

(This is very incomplete.)

Character data output via `PB0`-`PB6` on the 6820 are passed to the video
circuit as `RD1`-`RD7` (read data, from the terminal's point of view).
`PB7` is input for the `DA` (data available?) signal, which is high when
you may write a new character to the video system. A write at that time
also clears the cursor bit, which causes flip-flops 2 and 3 at C13 to
re-set the cursor bit on the next character clock; this advances the cursor
one position.

The video circuitry asserts `R̅D̅A̅ ` (ready for data available) when ready
for input (?); this generates (via 74123 B3) a ???

The shift register at C11b stores `1` bit as a cursor marker amongst all
the `0` bits it's shifting. It's clocked through the flip-flop at C13, and
gated with the output of the 555 at D13 into the 2519 shift register as
bits 5 (inverted) and 6.

The 2519 shifts through the 40 characters on the line for 7 scan lines (+1
blanking line) into the 2513 generator, whose output bits O1-O5 are shifted
out into the video signal. When the 555 oscillates, it changes the
character in the cursor cell from $20 (space) to $40 (@-sign), which is the
blinking cursor.

My guess is that output of OR gate C8 50 at the far right triggers a
new line. The inputs are Q5∧Q3 would indicate reaching the end of the
line; the other OR gate input (per below) is triggered when
`RD7`-`RD1` are 0001101 = $0D = CR.

    D2, RD6, RD7      all low     → NOR-0  high
    RD1, RD3, RD4     all high    → NAND-0 low
    NAND-0, RD2, RD5  all low     → NOR-1  high
    NOR-0, NOR-1      all high    → AND-0  high
    Q5, Q3            all high    → AND-1  high
    AND-0, AND-1   either high    → NOR-2  low

    RD 765 4321
       000 1101 = $0D

[The comments on Ken Shirriff's shift register blog post][shirriff] include
a little bit of further information.

----------------------------------------------------------------------

The 6821 handles both keyboard input (Port A) and output to the display
(Port B). Port B is configured to use PB7 as an input and PB0 through PB6
as outputs. PB7 will read high when the shift sequence is at the cursor
location; you can then write the character to Port B which will send it
over PB0 through PB6 to be inserted at that point in the shift sequence.
This is very simply done in code: just execute BIT $D012 followed by BMI
back to that BIT instruction to loop until the video system is ready and
then STA $D012 to send the character. (That code starts at $FFEF in the
ROM, labeled ECHO in the listing.)

The 6502 can update once per frame, as the cursor location comes around, so
60 times per second. The only control character available is CR to move to
the start of the next line (scrolling if the cursor was on the bottom
line); there's no way to move the cursor (beyond printing a character) or
even to clear the screen via software (there is a switch provided that you
can close to clear the screen manually).

The scroll feature is a bit complex; it's done all in hardware in the terminal section of the board. On the far right of the terminal section sheet you can see how some gates are used to detect when RD7 through RD1 are 0001101 = $0D = ASCII CR; you can try to follow along from there to see how the scroll is done.


IC Notes
--------

__[74123]__ Dual retriggerable monostable multivibrator.
In processor section, 1/2 used for 6820 `CB1` input. Pin 9 is `A` input.

     A     => ¬Q
    ¬B     => ¬Q
    ¬A∧B↑  =>  Q positive pulse
     B∧A↓  =>  Q positive pulse
    clear  =>  Q positive pulse



<!-------------------------------------------------------------------->
[a1man]: https://www.applefritter.com/files/a1man.pdf

[2513]: https://www.applefritter.com/files/signetics2513.pdf
[2513b]: https://www.datasheetarchive.com/pdf/download.php?id=5065adad5e4757ac90073038091de3931e7380&type=M&term=2513
[2519]: https://www.applefritter.com/files/signetics2519.pdf
[555]: http://www.ti.com/lit/gpn/sn74s175
[74123]: http://www.ti.com/lit/ds/symlink/sn74ls122.pdf
[74157]: http://www.ti.com/lit/gpn/sn74ls157
[74160]: http://www.ti.com/lit/gpn/sn74ls161a
[74161]: http://www.ti.com/lit/gpn/sn74ls161a
[74166]: http://www.ti.com/lit/gpn/sn54ls166a
[74174]: http://www.ti.com/lit/gpn/sn74s175

[shirriff]: https://www.blogger.com/comment.g?blogID=6264947694886887540&postID=6988848721781537170
