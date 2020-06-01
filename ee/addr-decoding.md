Address Decoding Notes
======================

General Notes
-------------

* See [memory](memory.md) for memory device pinouts.
* 0.1 μF between power and ground!
  - Every eight chips, 4.7 μF on array's power rails (PCB trace inductances).
  - When using multiple solderless breadboards, jumper between GND (and
    maybe Vcc) buses at multiple points along the length.
* Generally, assert `C̅S̅` ("wake", activate address decoder) before
  `O̅E̅`/`W̅E̅` for better performance.
* Non-65xx chips may require `R̅E̅`, `W̅E̅` to be asserted only after `C̅S̅`.
* RAM must be fast enough to return data within duration of `O̅E̅`/`W̅E̅`
  (`C̅E̅` is usually longer), usually a half clock cycle minus the
  decoding latency.

#### Latency Example

Delays are typ/max. The HTC138 part around the same as the LS138, but
the LS138A (not used here) is significantly faster. We assume that the
address setup doesn't finish until the start of Φ2, though it's probably
a bit earlier.
- XXX check address setup times; may be longer?
- XXX check when data needs to be stable for CPU.
- Decoding the address first via '138 (18/41 ns), and then through two
  additional '32 OR gates (14/22 ns ea.) to enable on any of four
  lines from the '138 totals 46/85 ns.
- Given a 100 ns memory device, we add that to the decoding delay
  giving 185 ns and double it because we must complete the access during
  Φ2 high. 1000/370 = 2.7 MHz maximum system speed.

Here's a table for various memory device speeds (ns), total latency
(ns), bus maximum speed (Mhz, typical and max) and an example device
with those parameters:

    Device Typ Max  T  Mhz M  Example Device
      250  296 335  1.7  1.5  HN27256G-25 EPROM (UV erase)
      150  196 235  2.5  2.1  Amtel AM28C256 EEPROM (5v program)
      100  146 185  3.4  2.7  Hitachi HM62256ALP-10 32k×8 static RAM
       80  126 165  3.9  3.0  Hitachi HM62256ALP-8  32k×8 static RAM
       70  116 155  4.3  3.2  HM6264LP-70 8k×8 static RAM
       45   91 130  5.5  3.8  Winbond W27C512-45Z EEPROM (12 V program)


Specific Techniques
-------------------

* On 32K split RAM/ROM+IO, use A15 as RAM `C̅E̅`.
* Use quad SR latch to store bits for bank switching.

### 6502

#### Φ2 Qualification

The criticial thing is to qualify RAM writes becuase there if the
address bus is not stable it will change random areas of memory.
Unqualified reads are no big deal; the CPU is will not latch the data
bus before its address bus has settled.

However, there are some peripheral chips, such as some 65C22s, that
may need [chip selects, register selects and `R/W̅` all valid before
`Φ2` rises][f6-p8953].

[[Searle 6502]] qualifying `C̅E̅`/`O̅E̅`/`W̅E̅` :
- Read:  `Φ2` NAND  `R/W̅` → `O̅E̅` (RAM and ROM).
- Write: `Φ2` NAND ¬`R/W̅` → `W̅E̅` (`O̅E̅` disabled by read qual.).
- Do not qualify `C̅E̅` with `Φ2`, let it go out as soon as addr bus valid.

[[wm addr]] simple 3-NAND qualification/decoding:
- Qualifies only RAM `C̅S̅`.
- Links `O̅E̅` and `C̅S̅`/`C̅E̅`; fine at slow speeds.
- Further variations later on page.

Michael's [fast single-'139 qualification/decoding][f6-p43668]:
- 32K RAM, 16K I/O, 16K ROM
- 1: Φ2 Qualified /RD & /WR
- 2: Φ2 Qualified RAM Select
- Later post 3rd method: drive active high chip select on RAM from Φ2.
- Thread has more designs and discusses chip select vs. read/write
  signal timing.

#### Other

Extended memory:
* Use `S̅Y̅N̅C̅` to identify when `LDA/STA (zp),Y` ($91/$B1) is being read
  and, during cycle 5 of execution expose bits from extended memory
  address latch on extended address bus. The [6509] \(Commodore PET II)
  had something like this built in. this. But external implementation
  is complex and on 65C02 must deal with possible additional cycle for
  address that crosses to next page. See comments on [rcse-4932/7208].
  (Or just use 65c816. :-))

### 6809

Similar to 6502, but qualify with `E`? [[Searle 6809]]

### Z80

Refer to [[Searle Z80]].


References and Reading
----------------------

* Wilson Mines Co., [6502 Primer: Address Decoding][wm addr].
* forum.6502.org, [I think I finally have my decoding down.][
  decoddown]  Lots of good discussion about decoding for a 6502 system
  and many examples of different ideas.
* Retrocomputing SE [Mapping more than 64kb of address space](
  https://retrocomputing.stackexchange.com/q/4925/7208). Some good
  bank switching ideas.


Designs
-------

Ensure you have enough extra gates (typically 2 NAND) to qualify
signals appropriately for the CPU, e.g., `O̅E̅` and `W̅E̅` with Φ2 on
6502. See above for more details.

Most chip selects are negative logic (`G̅`). Translation from positive
logic (`G`) is:
- `G1`  OR `G2` → `G̅1` AND `G̅2`
- `G1` AND `G2` → `G̅1`  OR `G̅2`

NAND/NOR gates are frequently substituted; output can go to a `G` on
chip or to both inputs of another NAND for an inverter. See the circuits
below for more examples.

An __'85__ comparator can generate select based on 2-4 input bits
being equal to, less than or greater than a reference. Make sure you
properly wire the `=`/`<`/`>` inputs.

The __'138__ breaks down 3 bits of an address range into 8 select
signals via `A B C` inputs, or no select when not enabled with all `G`
inputs. `G1 G̅2A G̅2B` can limit the range for the decode within a
larger address space by selecting high/low blocks nested three times
in one arrangement from `H L L`, `L H L`, `L L H`. E.g., A15-13 as
`L H L` for $0000-$FFFF → $0000-$7FFF → $4000-$7FFF → $4000-$5FFF
resp.

### Commonly used parts:

-  ['00][SN74LS00]  (14)  4× NAND, inputs `1̅A̅∙̅1̅B̅` etc.
-  ['02][SN74LS02]  (14)⁻ 4× NOR gate,  inputs  `1̅A̅+̅1̅B̅` etc.
-  ['04][SN74LS04]  (14)  6× inverter, inputs `1A`…`6A`. ('06 O/C, '14 schmitt)
-  ['08][SN74LS08]  (14)⁻ 4× AND, inputs `1A∙1B` etc.
-  ['32][SN74LS32]  (14)  4× OR gate,  inputs  `1A+1B` etc.
-  ['85][SN74LS85]  (16)  4-bit comparator, inputs `A0…A3=B0…B3`, `A>B,A=B,A<B`.
- ['138][SN74LS138] (16)  3→8 demux, inputs `A B C G̅2A G̅2B G1` (A=LSB).
- ['688][SN74SL682] (20)  8-bit comparator

Other possibilities not used here: '139 2× 2→4 demux ('156 won't work
due to shared A,B inputs).

### Circuits

'138 decodes 4K blocks $8000, $9000, ..., $E000, $F000 to `Y̅0`…`Y̅7`,
as used on RC6502 SBC. XXX extended this to decode a 16K block
$8000-$BFFF to a single select.

                ┌──∪──┐ '138 3→8 demux
      A12 → A   │1  16│ Vcc
      A13 → B   │2  15│ Y̅0 → $8000
      A14 → C   │3  14│ Y̅1 → $9000
        ⏚ → G̅2A │4  13│ Y̅2 → $A000
        ⏚ → G̅2B │5  12│ Y̅3 → $B000
      A15 → G1  │6  11│ Y̅4 → $C000
    $F000 ← Y̅7  │7  10│ Y̅5 → $D000
            ⏚   │8   9│ Y̅6 → $E000
                └─────┘

'138 decodes 1K blocks $A000-$BFFF. Requires inverter for A14.

                ┌──∪──┐
      A10 → A   │1  16│ Vcc
      A11 → B   │2  15│ Y̅0 → $A000
      A12 → C   │3  14│ Y̅1 → $A400
     /A13 → G̅2A │4  13│ Y̅2 → $A800
      A14 → G̅2B │5  12│ Y̅3 → $AA00
      A15 → G1  │6  11│ Y̅4 → $B000
    $BC00 ← Y̅7  │7  10│ Y̅5 → $B400
            ⏚   │8   9│ Y̅6 → $BC00
                └─────┘

More chip pinouts to use in further examples.

                        '08 AND
                ┌──∪──┐ '00 NAND
           → 1A │1  14│ Vcc
           → 1B │2  13│ 4A →
           → 1Y │3  12│ 4B →
           → 1A │4  11│ 4Y →
           → 1B │5  10│ 3A →
           → 1Y │6   9│ 3B →
           ← ⏚  │7   8│ 3Y →
                └─────┘

                ┌──∪──┐ '04 NOT
           → 1A │1  14│ Vcc
           → 1Y │2  13│ 6A →
           → 2A │3  12│ 6Y →
           → 2Y │4  11│ 5A →
           → 3A │5  10│ 5Y →
           → 3Y │6   9│ 4A →
           ← ⏚  │7   8│ 4Y →
                └─────┘

                ┌──∪──┐ '85 =,<,>
          → B3  │1  16│ Vcc
          → A<B │2  15│ A3 →
          → A=B │3  14│ B2 →
          → A>B │4  13│ A2 →
          ← A>B │5  12│ A1 →
          ← A=B │6  11│ B1 →
          ← A<B │7  10│ A0 →
            ⏚   │8   9│ B0 →
                └─────┘



<!-------------------------------------------------------------------->
[6509]: http://archive.6502.org/datasheets/mos_6509_mpu.pdf
[Searle 6502]: http://searle.wales/6502/Simple6502.html
[Searle 6809]: http://searle.wales/6809/Simple6809.html
[Searle Z80]: http://searle.wales/z80/SimpleZ80.html
[decoddown]: http://forum.6502.org/viewtopic.php?f=12&t=3620&sid=4c12bb500e4de4611e2dd902aed40ec7&start=15
[f6-p43668]: http://forum.6502.org/viewtopic.php?f=12&t=3620&start=15#p43668
[f6-p8953]: http://forum.6502.org/viewtopic.php?p=8953#p8953
[rcse-4932/7208]: https://retrocomputing.stackexchange.com/a/4932/7208
[wm addr]: http://wilsonminesco.com/6502primer/addr_decoding.html

[SN74LS00]: http://www.ti.com/lit/gpn/sn74ls00
[SN74LS02]: http://www.ti.com/lit/gpn/sn74ls02
[SN74LS04]: http://www.ti.com/lit/gpn/sn74ls04
[SN74LS08]: http://www.ti.com/lit/gpn/sn74ls08
[SN74LS32]: http://www.ti.com/lit/gpn/sn74ls32
[SN74LS85]: http://www.ti.com/lit/gpn/sn74ls85
[SN74LS138]: http://www.ti.com/lit/gpn/sn74ls138
[SN74SL682]: https://www.ti.com/lit/ds/symlink/sn74ls682.pdf
