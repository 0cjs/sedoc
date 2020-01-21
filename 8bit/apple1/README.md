Apple 1 Notes
=============

- [_Apple-1 Operation Manual_][a1man].

The original Apple I used an [MC6820] PIA, but the RC6502 replica uses
an [MC6821].


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


I/O, MC6820
-----------

The configuration is the same for both ports (control registers `CRA`
and `CRB`) of the 6820: $A7 = `10100111`. However, though interrupts
are inabled, normally /IRQB and /IRQB outputs are not jumpered to go
through to CPU /IRQ and /NMI, respectively.

- b0-1 (CA1 control) = `11`: enable interrupt when CA1 input goes low to high.
- b2 (DDR access): `1`: other register address is port, not direction register.
- b3-5 (CA2 control) = `100`: CA2 is output, read strobe with CA1 restore.
  CA2 goes low on read from MPU and back to high when CA1 goes low again.
- b6: Read-only: unused because CA2 is not an input.
- b7: Read-only: goes high when CA1 goes high; cleared on MPU read of data.

### Keyboard

The keyboard connector is a DIP-16 socket. It has inputs for 7 data
lines `B1-B7`, a strobe line `STR`, and two NO pushbutton switches for
reset and clearing the screen. `B1-B7` connect to `PA0-PA6` on the
MC6820 PIA; pin 15 also connects to `PA7` but that's expected to be
tied to +5V (note 10 on schematic) because WozMon etc. assumes that
bit 7 of characters is always high.

`STR` (strobe) connects to `CA1`, which is configured to mark data as
available on a low to high transition. (The manual claims that, "The
strobe can be either positive or negative, of long or short duration."
Clearly "strobe" here means it always transitions twice within a short
time of the keypress.)

### Video

See [`charrom`](charrom.md) for character ROM details.

On PIA port PB. `PB0-PB6` are outputs, `PB7` is input. `CB1` and `CB2`
both used.

Character output translation:

    $00-$1F  Print nothing (excepting $0D)
        $0D  (CR) Moves to the beginning of the next line.
    $20-$5F  (space through underbar) prints given char
    $60-$7F  (lower-case etc.) prints same as $40-$5F

The high bit is ignored on output, producing the same results as above.

This was confirmed by observing the behaviour of a real Apple 1 in
[this Breker auction video][breker]. The [Apple 1js emulator][a1js]
and [Pom1 1.0.0][pom1] are also consistent with this.

The [nappel1] emulator is quite inaccurate (though convenient to use).
It backspaces and erases the previous character when either `_` or
backspace is typed, prints a space for nonprinting chars, and prints
lower-case.


Video Circuit
-------------

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
[MC6820]: http://archive.pcjs.org/pubs/c1p/datasheets/pdfs/MC6820.pdf
[MC6821]: http://archive.pcjs.org/pubs/c1p/datasheets/pdfs/MC6821.pdf
[a1man]: https://www.applefritter.com/files/a1man.pdf
[jt-wozmon]: https://github.com/jefftranter/6502/tree/master/asm/wozmon
[sbp-basic]: https://www.sbprojects.net/projects/apple1/a1basic.php
[sbp-wozmon]: https://www.sbprojects.net/projects/apple1/wozmon.php

[a1js]: https://www.scullinsteel.com/apple1/
[breker]: https://youtu.be/wTgyll6IqJY?t=33
[ca-emul]: https://www.callapple.org/soft/ap1/emul.html
[nappel1]: https://github.com/nobuh/napple1
[pom1]: http://pom1.sourceforge.net/

[2513]: https://www.applefritter.com/files/signetics2513.pdf
[2513b]: https://www.datasheetarchive.com/pdf/download.php?id=5065adad5e4757ac90073038091de3931e7380&type=M&term=2513
[2519]: https://www.applefritter.com/files/signetics2519.pdf
[555]: http://www.ti.com/lit/gpn/sn74s175
[74157]: http://www.ti.com/lit/gpn/sn74ls157
[74160]: http://www.ti.com/lit/gpn/sn74ls161a
[74161]: http://www.ti.com/lit/gpn/sn74ls161a
[74166]: http://www.ti.com/lit/gpn/sn54ls166a
[74174]: http://www.ti.com/lit/gpn/sn74s175
