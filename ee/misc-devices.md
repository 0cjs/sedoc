Misc. Devices
=============


Switches
--------

* Mitel/Zarlink [__MT8812__][] (40): 8×12 Analog Switch Array.
  - Inputs on `AX0`-`AX3` (4,22,23,5) and `AY0`-`AY2` (24,25,2) select
    address of latch holding status of corresponding switch in 8×12
    matrix. Address must be stable on rising edge of `STROBE` (18).
  - Set `DATA` (38) to high to connect selected switch, low to turn
    off. Data latched on falling edge of `STROBE`.
  - `RESET` (3) turns off all switches when brought high. Async.
  - Outputs `X0`-`X11` (33-28,9-14) and `Y0`-`Y7` (35,37,39,1,21,19,17,15).
  - `Vdd` (40) 4.5-14.5V; also limit on input voltage to switches.
    `Vss` (20) is GND.
  - Tends to run around $12.



<!-------------------------------------------------------------------->
[__MT8812__]: http://pdf.datasheetcatalog.com/datasheet/zarlinksemiconductor/zarlink_MT8812_MAR_97.pdf
