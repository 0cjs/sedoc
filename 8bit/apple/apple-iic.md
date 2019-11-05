Apple IIc Notes
===============

For full details, including hardware design details, ROM listings,
etc., see [The Apple IIc Technical Reference Manual][techref]. This
does not include [schematics] however.

Changes from IIe:
- CMT (cassette) support dropped.
- 65C02 processor.
- The logical slots are now called "ports," but function the same way
  in software.
- Adds built-in support for interrupt handling, including new vertical
  blank interrupt. (IIe could poll vertical blank; not available on
  earlier models.)

Misc Notes
----------

Always run propped up on handle (folded down) for airflow.


Disassembly
-----------

Photos at [ifixit]. EEVblog has a [teardown video][evb-teardown].

The six 19mm wide-thread #2 phillips screws holding the case together
are on the bottom at the outside edge: four on either side of the
keyboard and two right next to the handle. (The two middle ones are
very different on mine; bad replacements?)

There's a catch on the front edge, slightly to the right, above the
speaker. Push in at the seam to push the top edge back from the bottom
hook.


Power
-----

Power input is unregulated 9 to 20 V DC max 25 W. The Apple external
PSU is 15 V 1.2 A. The chassis connector is a male 7-pin DIN. The
PSU plug is wired as follows:

           ∪            Looking into female plug on cable
        7     6         1,4: +15 V DC
      3         1         2: Chassis ground (AC input ground)
        5     4         3,5: Signal ground.
           2            6,7: not connected

Internally the converter generates voltages +5 (1.5A), +12 (0.6 A, 1.5
A surge), -12 (100 mA) and -5 (50 mA). It can run all internal
components plus one 5.25" external drive. It will limit voltages,
dropping to 0 if they can't be maintained, if any supply voltage is
shorted to ground or if any output voltages goes outside normal range
(±5% on 5V, ±10% on 12V).

Max case temperature is 60°.


Models and ROM Versions
-----------------------

There are three versions of the IIc, identified by the ROM byte at
`PEEK(-1089)` (64447, $FBBF).
- Original (255, $FF). The only version that can boot external drive
  with `PR#7`.
- UniDisk 3.5 (0, $00): Expands ROM from 16K to 32K. Adds Protocol
  Converter (earlier version of Smartport) routines to ROM to support
  UniDisk 3.5 external drive. Adds Mini-Assembler and step/trace
  monitor commands. Adds built-in diagnostics. Improved interrupt
  handlers. New external drive startup procedures.
- Memory expansion (3, $03): Uses four 64K×4bit RAM instead of sixteen
  64K×1bit RAM chips and adds motherboard connectors for a RAM
  expansion card. Updates ROM to SmartPort. Moves mouse to port 7;
  memory expansion uses port 4.

See Appendix F (pp.348-365) for more detailed information on
differences between all models.



<!-------------------------------------------------------------------->
[evb-teardown]: https://www.youtube.com/watch?v=JsUM-ZcBFE0
[ifixit]: https://www.ifixit.com/Guide/Disassembling+Apple+IIc+Cover/6772
[schematics]: https://archive.org/details/Schematic_Diagram_of_the_Apple_IIc
[techref]: https://archive.org/details/Apple_IIc_Technical_Reference_Manual
