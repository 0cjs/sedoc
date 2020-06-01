Digital Logic Levels and Families
=================================


Levels and Families
-------------------

### Levels

These vary with individual parts; always verify with data sheet.
CMOS may generally be run up to 15 V with approx.
0.3\*Vcc = LOW max and min HIGH = 0.7\*Vcc.

|    OUTPUT | min low | LOW max | min HIGH | high max |
|----------:|--------:|:--------|---------:|:---------|
|   5V CMOS |     0.0 | 0.05    |     4.95 | 5.0      |
| ATMega328 |     0.0 | 0.9     |     4.2  | 5.0      |
|   5V  TTL |     0.0 | 0.5     |     2.7  | 5.0      |
| 3.3V CMOS |     0.0 | 0.5     |     2.4  | 3.3      |

|     INPUT | min low | LOW max | min HIGH | high max |
|----------:|--------:|:--------|---------:|:---------|
|   5V CMOS |     0.0 | 1.5     |     3.5  | 5.0      |
| ATMega328 |     0.0 | 1.5     |     3.0  | 5.0      |
|   5V  TTL |     0.0 | 0.8     |     2.0  | 5.0      |
| 3.3V CMOS |     0.0 | 0.8     |     2.0  | 3.3      |

For interfacing, `74x245` octal bus transceivers with 3-state outputs:
* `74HC245`: CMOS → CMOS
* `74VC245`: 3.3V CMOS → 5V TTL
* `74HCT245`: 5V TTL → 5V CMOS

#### Sources

* 3.3V CMOS levels from `74LVT04` Hex Inverter.
* "Interfacing Considerations" on the [Wikipedia TTL page][wp-ttl] has
  a brief discussion of levels and current.
* Sparkfun's [Logic Levels][spark-levels] is a basic discussion. Its
  many references are mostly in this list.
* Interfacebus.com's [Logic Threshold Voltage Levels][ib-levels] has a
  bar graph representation of interface voltage levels for various
  families. ([Digital Logic Information][ib-digital] links to a
  low-level logic voltage chart and other information.)
* JeeLabs post [Voltage: 3.3 vs 5][jee-33vs5] discusses running an
  Arduino at 3.3V (apparently ok even at 16 MHz), mixing 3.3V and 5V
  devices, and using a 1K Ohm resistor to limit current to allow
  (slow) 5V inputs on 3.3V digital pins via limiting by the ESD
  diodes.
* Radical Brad's [VIC-20 JetPack][rbv20] gives levels and the chips he
  uses for interfacing.
* All About Circuits' [Logic Signal Voltage Levels][aac-lsvl] is a
  detailed tutorial also discussing Schmitt triggers, pullup resistors,
  open collector interfacing, etc.
* Microchip's [3V Tips 'n Tricks] is a catalog of techniques for
  interfacing between 3.3V and 5V parts including power, digital and
  analog interfaces. Some calculations required.
* TI Application Report [Migration From 3.3 V to 2.5 V Power Supplies
  for Logic Devices][scea005] has a nice voltage level diagram  for 5V
  CMOS/TTL, 3.3V and 2.5V on page 2 (PDF page 14), some logic family
  information (including AHC and LVCH), notes on tolerance of
  higher-level families, and some fairly technical information on
  capacitive load and propagation delays.
* [BJ Furman ME 106 Intro to Mechatronics][ME106].

### Families

- "Sub-types" on the [Wikipedia TTL page][wp-ttl] has some families.
- Interfacebus.com's [Digital Logic Information][ib-digital] page has
  lots of information on glue logic families and how to choose them.
- TI document on CMOS/HC/HCT/TTL and noise level ranges in TTL:
  [SN54/74HCT CMOS Logic Family Applications and Restrictions][ti-hct].
- LS loads signal lines a lot more than HC; outputs can't pull high
  enough into some CMOS loads for them to consistently recognize HIGH
- HC is fast enough for 4 MHz; AC required for faster.

http://forum.6502.org/viewtopic.php?f=12&t=3620&sid=4c12bb500e4de4611e2dd902aed40ec7&start=15


<!-------------------------------------------------------------------->
[3vTnT]: https://www.newark.com/pdfs/techarticles/microchip/3_3vto5vAnalogTipsnTricksBrchr.pdf
[ME106]: https://web.archive.org/web/20150412022002/engr.sjsu.edu/~bjfurman/courses/ME106/ME106pdf/TTL-CMOS_logic-levels.pdf
[aac-lsvl]: https://www.allaboutcircuits.com/textbook/digital/chpt-3/logic-signal-voltage-levels/
[ib-levels]: http://www.interfacebus.com/voltage_threshold.html
[jee-33vs5]: https://jeelabs.org/2010/12/16/voltage-3-3-vs-5/
[rbv20]: http://forum.6502.org/viewtopic.php?f=4&t=5315#p63368
[scea005]: http://www.ti.com/lit/an/scea005/scea005.pdf
[spark-levels]: https://learn.sparkfun.com/tutorials/logic-levels/all
[ti-hct]: http://www.ti.com/lit/an/scla011/scla011.pdf
[wp-ttl]: https://en.wikipedia.org/wiki/Transistor%E2%80%93transistor_logic
