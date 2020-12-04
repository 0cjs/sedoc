Digital Logic Levels and Families
=================================

Families can refer to both general TTL vs. CMOS and specific (usually
[7400-series](7400.md) families: S-TTL, LS-TTL, ALS-TTL, HC-CMOS, etc.

Logic levels apply to all digital parts.

XXX try to sort Vcc levels (5 V, 3.3 V) from logic low/high levels
within a Vcc level.


Families
--------

- "Sub-types" on the [Wikipedia TTL page][wp-ttl] has some families.
- Interfacebus.com's [Digital Logic Information][ib-digital] page has
  lots of information on glue logic families and how to choose them.
- TI document on CMOS/HC/HCT/TTL and noise level ranges in TTL:
  [SN54/74HCT CMOS Logic Family Applications and Restrictions][ti-hct].
- LS reduced power consumption by reducing output drive and increasing
  input impedence; replacing original with LS can thus cause problems in
  heavily loaded signals such as clocks. Replacing original with HCT,
  which has more output drive (especially upward) may work.
- LS loads signal lines a lot more than HC; outputs can't pull high
  enough into some CMOS loads for them to consistently recognize HIGH
- HC is fast enough for 4 MHz; AC required for faster.
- 74LVC1G and 74AHCT1G families (TI "litle logic," mostly single gates in
  4-8 pin "flyspeck" packages) simplify routing and have a maximum
  propagation time of ≤ 3 ns, combining these can be faster than more
  integrated ICs. (Esp. useful for building gates with wide inputs, e.g.,
  13-input NAND.) Discussion: [[any 1767]]. Docs: [[TI SCYA0409A]].

### HC over LS in Modern Systems

#### Levels

Various users on 6502.org suggest [not using LS in modern
systems][f6-t3620-2], suggesting `HC` or `HCT` instead. Obviously the
latter is TTL compatible, but [Garth Wilson has used MOS +
HC][f6-p1288] extensively, and even occsionally mixed LS with HC. Also
see later bogax post in same thread, where he also mentions that TTL
sources less current so is slower to bring up a CMOS input.

Here's a comparison of non-HC outputs to HC inputs. All HC parts use
the Vcc = 4.5 V spec. It appears that LS driving HC is not within min
specs, but would work if the LS chip has "typical" output specs.
Pull-ups might help make things compatible.

                │ Fam  │ VOLmax  VILmax │ VOHmin  VOHtyp  VIHmin │
    ────────────┼──────┼────────────────┼────────────────────────┤
    MOS 6502    │ NMOS │  0.4           │  2.4      -            │
    RC65C02     │ CMOS │  0.4           │  2.4      -            │
    SN74LS138   │  LS  │  0.5           │  2.7     3.4           │
    SN74HC138   │  HC  │          1.35  │                  3.15  │

Data sheets: [[MOS 6502]], [[RC65C02]], [[SN74LS138]], [[SN74HC138]],
[[SN74HCT138]].

Fairchild [AN-319][fc-an-319] has some notes on this in the "A word
about plug-in replacement of TTL" section:

> In systems where all TTL is not being replaced and TTL outputs feed
> CMOS inputs, the input high voltages, as specified, are not totally
> compatible. Although TTL outputs will typically drive HC inputs
> correctly, an external pull-up resistor should be added to the TTL
> outputs, or an MM54HCT/MM74HCT TTL compatible circuit should be
> used. This incompatibility tends to limit the designer’s ability to
> intermingle TTL and HC-CMOS.
>
> Note, though, that HC outputs are completely compatible with the
> various TTL family’s input specifications; therefore, there is no
> problem when HC is driving TTL. Another source of possible problems
> can occur when the LS design floats device inputs. This practice is
> not recommended when using LS-TTL, but it is sometimes done.
> Usually, TTL inputs float high; however, CMOS inputs may float
> either high or low depending on the static charge on the input. It
> is therefore important to always tie unused CMOS inputs to either
> VCC or ground to avoid incorrect logic functioning.
>
> A third factor to consider when replacing any TTL logic is AC
> performance. The logic functions provided by 54HC/74HC are
> equivalent to LS-TTL, and the propagation delay, set-up and hold
> times are similar to LS. However, there are some differences in the
> way CMOS circuits are implemented which will cause differences in
> speed. For the most part, these differences are minor, but it is
> important to verify that they do not affect the design.

#### Speed

HC parts are generally about as fast or slightly faster than LS parts
(per [Garth Wilson][f6-p1288] and data sheets).

HC is fast enough for a 4 MHz system; faster than that use AC.

The high slew rates of faster parts (AS, AC, ABT) can cause problems
in circuits not constructed for high speed. [Garth Wilson's expanation
and links][f6-195-19810].


Logic Levels
------------

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

### Current

TTL parts pull up weakly so even if they can get up to the right
level, they may be slow doing so. A pull-up resistor to supply
additional current when the part outputs high can help with this. When
outputting low, TTL parts generally pull down strongly enough to
quickly overcome the pull-up.

[Garth Wilson][f6-p904] discusses this further, and mentions that a
Rockwell VIA I/O port gives 15-20 mA/pin shorted to ground, and pulls
100 mA/pin shorted to +5 V; WDC part more balanced.

XXX What's a good size for the pull-up?

When sending one TTL output to mixed inputs (one TTL, one CMOS), the
TTL input may load the output so much that the CMOS no longer sees a
high input.


References
----------

Family-related (5 V level):
* Fairchild, [AN-319][fc-an-319] comparing LS-TTL, ALS-TTL, HC-CMOS, S-TTL.
* Radical Brad's [VIC-20 JetPack][rbv20] gives levels and the chips he
  uses for interfacing.
* [BJ Furman ME 106 Intro to Mechatronics][ME106]. CMOS vs. TTL.
* [[TI SCYA0409A]] Texas Instruments, "How To Select Little Logic"
  (SCYA0409A) 2010.

Level-related:
* 3.3V CMOS levels from `74LVT04` Hex Inverter.
* Sparkfun's [Logic Levels][spark-levels] is a basic discussion. Its
  many references are mostly in this list.
* Interfacebus.com's [Logic Threshold Voltage Levels][ib-levels] has a
  bar graph representation of interface voltage levels for various
  families. ([Digital Logic Information][ib-digital] links to a
  low-level logic voltage chart and other information.)

Level- and current-related:
* "Interfacing Considerations" on the [Wikipedia TTL page][wp-ttl] has
  a brief discussion of levels and current.
* JeeLabs post [Voltage: 3.3 vs 5][jee-33vs5] discusses running an
  Arduino at 3.3V (apparently ok even at 16 MHz), mixing 3.3V and 5V
  devices, and using a 1K Ohm resistor to limit current to allow
  (slow) 5V inputs on 3.3V digital pins via limiting by the ESD
  diodes.
* All About Circuits' [Logic Signal Voltage Levels][aac-lsvl] is a
  detailed tutorial also discussing Schmitt triggers, pullup
  resistors, open collector interfacing, etc.
* Microchip's [3V Tips 'n Tricks] is a catalog of techniques for
  interfacing between 3.3V and 5V parts including power, digital and
  analog interfaces. Some calculations required.
* TI Application Report [Migration From 3.3 V to 2.5 V Power Supplies
  for Logic Devices][scea005] has a nice voltage level diagram  for 5V
  CMOS/TTL, 3.3V and 2.5V on page 2 (PDF page 14), some logic family
  information (including AHC and LVCH), notes on tolerance of
  higher-level families, and some fairly technical information on
  capacitive load and propagation delays.




<!-------------------------------------------------------------------->
[3vTnT]: https://www.newark.com/pdfs/techarticles/microchip/3_3vto5vAnalogTipsnTricksBrchr.pdf
[ME106]: https://web.archive.org/web/20150412022002/engr.sjsu.edu/~bjfurman/courses/ME106/ME106pdf/TTL-CMOS_logic-levels.pdf
[TI SCYA0409A]: http://anycpu.org/forum/download/file.php?id=225&sid=4af8a5ae7968b237983d98bb8ce21cb8
[aac-lsvl]: https://www.allaboutcircuits.com/textbook/digital/chpt-3/logic-signal-voltage-levels/
[any 1767]: http://anycpu.org/forum/viewtopic.php?p=1767#p1767
[f6-195-19810]: http://forum.6502.org/viewtopic.php?f=4&t=195&start=15#p19810
[f6-p1288]: http://forum.6502.org/viewtopic.php?p=1288#p1288
[f6-p904]: http://forum.6502.org/viewtopic.php?p=904#p904
[f6-t3620-2]: http://forum.6502.org/viewtopic.php?f=12&t=3620&start=15
[fc-an-319]: https://web.archive.org/web/20161223140623/https://www.fairchildsemi.com/application-notes/AN/AN-319.pdf
[ib-levels]: http://www.interfacebus.com/voltage_threshold.html
[jee-33vs5]: https://jeelabs.org/2010/12/16/voltage-3-3-vs-5/
[rbv20]: http://forum.6502.org/viewtopic.php?f=4&t=5315#p63368
[scea005]: http://www.ti.com/lit/an/scea005/scea005.pdf
[spark-levels]: https://learn.sparkfun.com/tutorials/logic-levels/all
[ti-hct]: http://www.ti.com/lit/an/scla011/scla011.pdf
[wp-ttl]: https://en.wikipedia.org/wiki/Transistor%E2%80%93transistor_logic


[MOS 6502]: http://archive.6502.org/datasheets/mos_6500_mpu_mar_1980.pdf
[RC65C02]: http://archive.6502.org/datasheets/rockwell_r65c00_microprocessors.pdf
[SN74HC138]: http://www.ti.com/lit/gpn/sn74hc138
[SN74HCT138]: http://www.ti.com/lit/gpn/sn74hct138
[SN74LS138]: http://www.ti.com/lit/gpn/sn74ls138
