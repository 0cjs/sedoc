Address Decoding Notes
======================

General Notes
-------------

* 0.1 μF between power and ground!
  - Every eight chips, 4.7 μF on array's power rails (PCB trace inductances).
  - When using multiple solderless breadboards, jumper between GND (and
    maybe Vcc) buses at multiple points along the length.
* Generally, assert /CS ("wake", activate address decoder) before /OE
  for better performance.
* Non-65xx chips may require /RE, /WE to be asserted only after /CS.


Specific Techniques
-------------------

* On 32K split RAM/ROM+IO, use A15 as RAM /CE.
* Use quad SR latch to store bits for bank switching.

#### 6502

* Use φ2 to qualify /RD and /WR.
* Assert /CE as soon as addr bus is valid, even if Φ2 still low.

Extended memory:
* Use /SYNC to identify when `LDA/STA (zp),Y` ($91/$B1) is being read
  and, during cycle 5 of execution expose bits from extended memory
  address latch on extended address bus. [6509] \(Commodore PET II)
  had something like this built in. this. But external implementation
  is complex and on 65C02 must deal with possible additional cycle for
  address that crosses to next page. See comments on [rcse-4932/7208].
  (Or just use 65c816. :-))


Implementations
---------------

* Single 7400 quad-NAND.
* Single 74139 dual 2-4 demux. ('156 won't work due to shared A,B inputs.)


Memory Chips
------------

Abbreviations:
- DIPnn: 0.3" wide dual-inline package, _nn_ pins
- WDIPnn: 0.6" wide DIP

A [search for "memory dip" on the JDEC site][JDEC-memory-dip] gives
standards and pinouts for various kinds of memory chips.

#### SRAM

[JDEC Standard No. 21-C §3.7.5][JDEC-3.7.5] has standard pinouts for
byte-wide and TTL MOS SRAM.

Hitachi [HM62256A] series 32K×8 high-speed CMOS
- TTL compatible.
- Speed: -8 (85 ns), -10, -12, -15
- L/L-SL indicates low-power (5 μW standby, 40 mW @ 1 MHz)
- Packaging: P→WDIP28, SP→DIP28, FP=.45" SOP, T=TSOP
- 28 Pins: 14=Vss, 28=Vcc, 20=/CS, 27=/WE, 22=/OE
  -   D0-7: 11 12 13 .. 15 16 17 18 19  ("I/O" pins in datasheet)
  -  A0-A7: 10 9 8 7 .. 6 5 4 3
  - A8-A14: 25 24 21 23 .. 2 26 1
- Function table (/CS=L where not specified):
  - /CS=H: standby, low power (all other inputs ignored)
  - /WE=H /OE=H: output disabled
  - /WE=H /OE=L: D out, read cycle (diag. 1-3, dep. on signal order)
  - /WE=L /OE=H: D in, write cycle (diag. 1, /OE clock, /CS before /WE)
  - /WE=L /OE=L: D in, write cycle (diag. 2, /OE low fixed)

#### EEPROM

Amtel [AT28C64] Parallel EEPROM
- TTL and CMOS compatible
- Other sizes avail., 2K×8 [AT28C16A] \(24pin), 32K×8 [AT28C256]
- Speed: -12, -15, -20, -25
- 28 Pins: 14=GND, 28=Vcc, 20=/CE, 22=/OE, 27=/WE, 1=RDY,/BUSY 26=NC
  -   D0-7: 11 12 13 .. 15 16 17 18 19  ("I/O" pins in datasheet)
  -  A0-A7: 10 9 8 7 .. 6 5 4 3
  - A8-A12: 25 24 21 23 .. 2
- Erase/program:
  - Erase: /CE=low, /OE=12V, assert /WE for 10 msec
  - Write: no special voltages; completion poll /DATA (takes 1 ms)
    - /DATA poll: D7 returns complement of data during write
    - Open-drain READY,/BUSY pulled low during write cycle
  - AT28C64E has 200 μsec write

Winbond [W27C512-45Z] 64K×8 (45 ns., Z=lead free)
- TTL and CMOS compatible
- Packaging: WDIP28, .33" 32-pin PLCC
- 28 Pins: 14=Vss, 28=Vcc, 20=/CE, 22=/OE,Vpp
  -   D0-7: 11 12 13 .. 15 16 17 18 19  ("Q" pins in datasheet)
  -  A0-A7: 10 9 8 7 .. 6 5 4 3
  - A8-A15: 25 24 21 23 .. 2 26 27 1
- Erase/program:
  - For Vcc=5V, /CE pulse 100 ms. (95 min 105 max)
  - Erase (to all-ones): Vpp=14V, A9=14V, A=low, D=high; /CE to erase.
  - Program: Vpp=12V, A=address, D=data; /CE write.
  - Erase verify, program verify: ??? Vpp=14V,12V, VCC=3.75V, /OE=lowV
  - See data sheet waveforms, flowcharts for details.
- Pricing: ¥80~¥120 on aliexpress.com


References and Reading
----------------------

* forum.6502.org, [I think I finally have my decoding down.][
  decoddown]  Lots of good discussion about decoding for a 6502 system
  and many examples of different ideas.
* Retrocomputing SE [Mapping more than 64kb of address space](
  https://retrocomputing.stackexchange.com/q/4925/7208). Some good
  bank switching ideas.



[6509]: http://archive.6502.org/datasheets/mos_6509_mpu.pdf
[AT28C16A]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0001h.pdf
[AT28C256]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf
[AT28C64]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0001h.pdf
[HM62256A]: https://datasheet.octopart.com/HM62256ALP-10-Hitachi-datasheet-115281844.pdf
[JDEC-3.7.5]: https://www.jedec.org/system/files/docs/3_07_05R12.pdf
[JDEC-memory-dip]: https://www.jedec.org/document_search/field_committees/25?search_api_views_fulltext=memory+dip
[W27C512-45Z]: http://www.kosmodrom.com.ua/pdf/W27C512-45Z.pdf
[decoddown]: http://forum.6502.org/viewtopic.php?f=12&t=3620&sid=4c12bb500e4de4611e2dd902aed40ec7&start=15
[rcse-4932/7208]: https://retrocomputing.stackexchange.com/a/4932/7208
