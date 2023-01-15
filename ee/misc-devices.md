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


Non-MOS Memory
--------------

### Core Rope Memory (ROM)

Nowadays this refers to two different forms of woven-wire ROM consisting of
wires threaded through and around ferrite cores. According to Hilpert,
pulse-transformer ROM may not have been called "core rope" historically.

With the __pulse-transformer__ technique, the memory is effectively a
series of transformers. Round ferrite cores are wrapped with several turns
(for voltage amplification) for the sense (output, secondary) side; each
has multiple inputs (primaries) consisting of a single wire per address
that goes through or around each core in sequence.

Sending a pulse down one of the address wires will produce a pulse on sense
output of the cores through which it passes, and no pulse from the cores
where the wire goes around instead of through it.

The __switching-core__ technique also uses "word-select" wires that thread
through and around cores, but these carry only half the current;
"row-select" wires that thread through subsets of the cores carry the other
half. With both energised the magnetic state of a core will be flipped and
one sense amplifier can be used for each column (since only the activated
row can ever be flipped). A reset wire going through all rows can be pulsed
with a full unit current in the opposite direction of the row selects to
clear the state.

References:
- Brief [description at Wikipedia][w-core-rope].
- SV3ORA, [Core rope memory: A practical guide of how to build your
  own.][sv3ora]. Demonstrates how to build a very simple memory of ten
  words × 7 bits, with very clear explanation, diagrams and photos.
- Brian Hilpert, [Core Rope & Woven-Wire Memory Systems][hilpert]. Much
  more detailed explanation, with various efficiency tricks, and discussion
  of the switching-core technique. (Some links from that page work only on
  the [archive of his UBC pages][hilpert-ubc].)
- High-res photo of a West German [Wagner Computer 256-word × 64 bit ROM
  board][wagner] (16 kbit, probably used as 2 kbytes).



<!-------------------------------------------------------------------->

<!-- Switches -->
[SK12D07]: https://www.aliexpress.com/item/1005004391945669.html
[SS12D10]: https://www.aliexpress.com/item/4000680248707.html
[SS12F44]: https://www.aliexpress.com/item/32950503406.html
[__MT8812__]: http://pdf.datasheetcatalog.com/datasheet/zarlinksemiconductor/zarlink_MT8812_MAR_97.pdf

<!-- Non-MOS Memory -->
[hilpert-ubc]: https://web.archive.org/web/20160822041959/http://www.cs.ubc.ca/~hilpert/e/corerope/index.html
[hilpert]: http://madrona.ca/e/corerope/index.html
[sv3ora]: http://qrp.gr/coreROM/
[w-core-rope]: https://en.wikipedia.org/wiki/Core_rope_memory
[wagner]: https://i.redd.it/h9sb550uhnm61.jpg
