UART, ACIA etc. chips
=====================


MOS 6551
--------

Similar to the 6550, but 24-pin instead of 20-pin and somewhat different
registers. Rockwell (and others?) made an R65C51 version, too. Used in the
Commodore Plus/4 with pins coming out to to the user port.

The WDC [W65C51N] has several bugs (documented since 2014):
- The Transmitter Data Register Empty (status register bit 4 TDRE) of the
  status register is never set. They suggest using the interrupt or a a
  timer appropriate for the bps rate. But if you also receive interrupts on
  incoming data and Receiver Data Register Full (status register bit 3
  RDRF) is set, how do you know if TDRE was also true?
- If Parity Mode Enabled (command register bit 5 PME) is set, Parity Mode
  Control (command register bits 6-7 PMC) is is ignored and mark parity is
  always sent. Presumably the workaround is always to calculate/check
  parity in software.

[VHDL-6551-ACIA] is a clone though with a few missing bits (only 8N1, no
DSR/DCD). Might fit into a XC9572XL which has 5V tolerant inputs.



<!-------------------------------------------------------------------->
[W65C51N]: https://eu.mouser.com/datasheet/2/436/WDC_Datasheet%20Update_20141024-1211725.pdf
[VHDL-6551-ACIA]: https://github.com/LIV2/VHDL-6551-ACIA
