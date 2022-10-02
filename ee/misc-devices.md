Misc. Devices
=============


Switches
--------

### Electronic

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

### Mechanical Slide Switches

- "Micro" are PCB mount on 0.1" pin centers; a bit too small for comfort.
- [SK12D07] seems equally small.
- [SS12F44] is slightly larger and more comfortable. PCB mount with strain
  relief tabs on end. Pins are not 0.1" centers but less than 20% off; bend
  back the strain relief tabs and slightly angle the pins to fit 3 pins.
  Dims in mm: 12.1×5.5 OD. Pins 0.8 wide on 3.0 centers. 3.2 travel.
- [SS12D10][] (SS12D11? SS12D06?) PCB mount, no strain relief flanges but
  wider pins. 2A 125V AC non-shorting. Dims in mm: 12.7×6.7 OD. Pins 1.3
  wide on 4.7 centers. 2.2 travel. (Ordered to try, but not arrived yet.)


<!-------------------------------------------------------------------->
[SK12D07]: https://www.aliexpress.com/item/1005004391945669.html
[SS12D10]: https://www.aliexpress.com/item/4000680248707.html
[SS12F44]: https://www.aliexpress.com/item/32950503406.html
[__MT8812__]: http://pdf.datasheetcatalog.com/datasheet/zarlinksemiconductor/zarlink_MT8812_MAR_97.pdf
