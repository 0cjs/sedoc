FM-7 and FM77 Information
=========================


Expansion Connectors
--------------------

The connectors used for expansion cards are Fujitsu Component
Connector [FCN-360 series][fcn360]. (The size range is 8, 16, 24, 32,
40, 48, 56, 64, and 80 pin.) These are currently available from Mouser
at around ¥750 qty. 1.

The AU below indicates gold plating; the H is something to do with
cover or mating port. Those parts might be wrong.

- 32-pin (FM-7 I/O board): FCN-365P032-AU/H
- 40-pin (FM-7 Z80 board): FCN-365P040-AU/H


Serial Port
-----------

Ysflight.com has a [blog post][ys serial] with a serial card KiCAD
schematic and board layout and discussion of his work on it. It also
includes some hints on using it from BASIC with, e.g., `OPEN
"O",#1,"COM0:(F8N1)"` (19.2 kbps) etc.

In in particular, hey says that `POKE &hFD0C,5 : POKE &hFD0B,16 : EXEC
-512` will restart BASIC (-512 is the start of the Boot ROM) and after
about 30 seconds, "you can use the serial port from F-BASIC." It's not
clear if this means it runs on the serial port or that this is merely
needed for initialization. Ports $FD0C/D are not documented in the Sysref;
the data and status registers are $FD06 and $FD07.



<!-------------------------------------------------------------------->
[fcn360]: https://www.fujitsu.com/downloads/MICRO/fcl/connectors/fcn-360.pdf
[ys serial]: http://ysflight.in.coocan.jp/FM/fm7_rs232c/e.html
