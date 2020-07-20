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

Character data output via `PB0`-`PB6` on the 6820 are passed to the
video circuit as `RD1`-`RD7` (read data, from the terminal's point of
view). `PB7` is input for the `DA` (data available?) signal.

The video circuitry asserts `R̅D̅A̅ ` (ready for data available) when ready
for input (?); this generates (via 74123 B3) a ???

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
