Address Decoding Notes
======================

General Notes
-------------

* See [ram-rom](ram-rom.md) for memory device pinouts.
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


References and Reading
----------------------

* forum.6502.org, [I think I finally have my decoding down.][
  decoddown]  Lots of good discussion about decoding for a 6502 system
  and many examples of different ideas.
* Retrocomputing SE [Mapping more than 64kb of address space](
  https://retrocomputing.stackexchange.com/q/4925/7208). Some good
  bank switching ideas.



<!-------------------------------------------------------------------->
[6509]: http://archive.6502.org/datasheets/mos_6509_mpu.pdf
[decoddown]: http://forum.6502.org/viewtopic.php?f=12&t=3620&sid=4c12bb500e4de4611e2dd902aed40ec7&start=15
[rcse-4932/7208]: https://retrocomputing.stackexchange.com/a/4932/7208
