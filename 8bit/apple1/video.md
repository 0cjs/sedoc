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



<!-------------------------------------------------------------------->
[a1man]: https://www.applefritter.com/files/a1man.pdf

[2513]: https://www.applefritter.com/files/signetics2513.pdf
[2513b]: https://www.datasheetarchive.com/pdf/download.php?id=5065adad5e4757ac90073038091de3931e7380&type=M&term=2513
[2519]: https://www.applefritter.com/files/signetics2519.pdf
[555]: http://www.ti.com/lit/gpn/sn74s175
[74157]: http://www.ti.com/lit/gpn/sn74ls157
[74160]: http://www.ti.com/lit/gpn/sn74ls161a
[74161]: http://www.ti.com/lit/gpn/sn74ls161a
[74166]: http://www.ti.com/lit/gpn/sn54ls166a
[74174]: http://www.ti.com/lit/gpn/sn74s175
