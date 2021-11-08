Front Panel Operation
=====================

Switch designations:
- ↕ (UD) Single-throw toggle; upper function given first.
- ↑ (-!) Momentary push upward
- ↓ (-v) Momentary push downward

Altair 8800
-----------

![Altair 8800 front panel][8800panel]

References:
- [Daves Old Computers - ALTAIR 8800 - Documentation][8800docs]
- [Altair 8800 Operator's Manual][8800opman]
- [Altair 8800 Theory of Operation Manual][88theory]
  §Display/Control Board Operation (p.5)
- [Altair 8800 Schematics] 880-T06 Computer Front Panel Control (p.9)
- [Altair 8800 Front Panel Schematic][8800psch]

Bus/data display/input:
- A0-15 LEDs always display current address on system address bus (_addr_).
- D0-7 LEDs show data _read_ by CPU (not written) or data read from _addr_
  when using examine.
- ↕S0-15 input switches used for address; S0-7 data; S8-15 sense (read from
  port FFh).

Indicator LEDs:
- INTE: Interrupts enabled
- PROT: "The memory is protected"
- WAIT: CPU in WAIT state. (This is how panel "pauses" CPU.)
- HDLA: Hold acknowledged. CPU has freed bus and is waiting.

Status LEDs:
- MEMR: Memory read. (Not write, not I/O.)
- INP: Reading from I/O port (`IN`); addr dup'd on high/low of _addr_.
- M1: Machine cycle 1, opcode fetch.
- OUT: Writing to I/O port (`OUT`); addr dup'd on high/low of _addr_.
- HLTA: "Halt instruction has been executed and acknowledged."
- STACK: _addr_ is SP
- WO: on = read cycle, off = write cycle
- INT: "An interrupt request has been acknowledged."

Switches:
- ↕Off/On: Power
- ↑STOP: Bring to stop in middle of next machine cycle.
- ↓RUN: Start continuous execution.
- ↑SINGLE STEP: Step to middle of next machine cycle (not instr single-step!)
- ↑EXAMINE: S0-15 placed on _addr_, D0-7 display read data, PC set to _addr_.
- ↓EXAMINE NEXT: _addr_ incremented, D0-7 display read data.
- ↑DEPOSIT: S0-7 written to current _addr_; D0-7 display written data.
- ↓DEPOSIT NEXT: _addr_ incremented, S0-7 written to new _addr_;
  D0-7 display written data.
- ↑RESET: System reset. Needs STOP to be held?
- ↓CLR: "Clear command for external input/output equipment."
- ↑PROTECT: Write-protects the "page" (as defined by RAM subsystem) containing
  _addr_. Some RAM subsystems may not support this.
- ↓UNPROTECT: See PROTECT.
- Two ↑↓AUX switches; not originally connected and not generally used.

Notes:
- Front panel does not work (except for reset) after `HLT`. A0-15 and D0-7
  will all be on because bus is released.
- S0-15 are labled just "0" - "15" on front panel.



<!-------------------------------------------------------------------->
[8800docs]: http://dunfield.classiccmp.org/altair/altair6.htm
[8800opman]: http://www.classiccmp.org/dunfield/altair/d/88opman.pdf
[8800panel]: https://upload.wikimedia.org/wikipedia/commons/4/43/Living_Computers_-_Altair_8800_%2839802981903%29.jpg
[8800psch]: http://dunfield.classiccmp.org/altair/d/88fp_lgl.pdf
[8800sch]: http://dunfield.classiccmp.org/altair/d/88schema.pdf
[8800theory]: http://dunfield.classiccmp.org/altair/d/88theory.pdf
