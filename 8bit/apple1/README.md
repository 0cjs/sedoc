Apple I Notes
=============

- [_Apple I Manual_][a1man].

Memory Map
----------

    $0000 - $7FFF  32K RAM
    $D000 - $DFFF   4K I/O area
    $E000 - $EFFF   4K RAM in original; ROM on most replicas
    $F000 - $FEFF   4K ???
    $FF00 - $FFFF  256 WozMon

### I/O ports

    $D010   KBD: keyboard input register. Valid when KBDCR bit 7 is 1.
            Reads clear KBDCR bit 7.
    $D011   KBDCR: Bit 7 cleared when KBD is read; set when keyboard
            key pressed.
    $D012   DSP: when bit 7 is 0, write bits 0-6 to output char and
            set bit 7.
    $D013   DSPCR: control register for output; init'd by WozMon

ROM Software
------------

### ROM Routines

    $E000   Woz BASIC entry point (`E000R` to run)
    $E2B3   Woz BASIC warm entry point (preserves existing program)
    $FF1F   GETLINE: Monitor entry point (CALL -225 from BASIC)
    $FFEF   ECHO: Print char in A to terminal
    $FFDC   PRBYTE: Print value in A as two hex digits
    $FFE5   PRHEX: Print lower nybble of A as a single hex digit

### Woz Monitor

- SB-Projects, [The Woz Monitor][sbp-wozmon].
- Jeff Tranter, [Woz Monitor Source Code][jt-wozmon]

Multiple commands may be given in sequence (numbers must be separated
with spaces); the current location _curloc_ will be used when not
being set.

- _nnnn_: Examine byte value at _nnnn_ and set _curloc_ = _nnnn_+1.
- _.nnnn_: Examine byte values in range _curloc_ through _nnnn_ (eight
  bytes per line); set _curloc_ = _nnnn_+1. Often preceeded by address
  to set/examine _curloc_ above, e.g., _mmmm.nnnn_.
- _nnnn: aa bb ..._: Deposit starting at _nnnn_ bytes _aa_, _bb_,
  etc., set _curloc_ = last loc. deposited + 1, and print previous
  value at _nnnn_.
- _R_: "Run," `JMP` (not `JSR`) to _curloc_. Return to monitor with
  `JMP $FF1F`.

### Woz BASIC

- SB-Projects, ["The Apple 1 Basic"][sbp-basic]


Video Circuit
-------------

Schematic on second-last page of the [Apple I Manual][a1man].

Parts included:
- [555] timer
- 2504 possibly RAM? (?×)
- 2513 character ROM (1×)
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
[jt-wozmon]: https://github.com/jefftranter/6502/tree/master/asm/wozmon
[sbp-basic]: https://www.sbprojects.net/projects/apple1/a1basic.php
[sbp-wozmon]: https://www.sbprojects.net/projects/apple1/wozmon.php

[2519]: https://www.applefritter.com/files/signetics2519.pdf
[555]: http://www.ti.com/lit/gpn/sn74s175
[74157]: http://www.ti.com/lit/gpn/sn74ls157
[74160]: http://www.ti.com/lit/gpn/sn74ls161a
[74161]: http://www.ti.com/lit/gpn/sn74ls161a
[74166]: http://www.ti.com/lit/gpn/sn54ls166a
[74174]: http://www.ti.com/lit/gpn/sn74s175
