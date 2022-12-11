MSX Models Summary
==================

See [`../README.md`](../README.md) for standard specifications.

Memory figures are RAM/VRAM. ≥64K VRAM indicates MSX2 or MSX2+. "2C" indicates
two cartridge slots; "1C+E" one cartridge slot plus an expansion bus connector
(usu. for a unit with more slots); "+D" indicates a 3.5" floppy drive. SK
indicates separate keyboard and desktop system unit.

- __Sony HB-F1XD__               64k/128k 2C+D RGB. Ext. PSU.
- __Panasonic FS-A1__            64k/128k 2C RGB. Ext. PSU.
- __Toshiba HX-22__              64k/16k 2C } "Pasopia IQ" (see below)
- __Toshiba HX-21__              64k/16k 2C }
- __Canon V-20__                 64k/16k 2C.
- __Sanyo MPC-2 (Wavy2)__        64k/16k 2C.
- __[National CF-3300]__  85-??  64k/16k 2C+D SK. 360K (1DD 80-track) drive.
- __[National CF-3000]__  84-11  64k/16k 2C   SK. JP21 RGB. No space for drive.
- __[National CF-2700]__  84-10  32k/16k 2C.
- __[National CF-1200]__  85-??  16k/16k 2C. CF-2700 w/½ memory, 30% cheaper
- __Sanyo PHC-SPC__       85-??  64k/16k 2C. Relatively compact.
- __Hitachi MB-H1__       83-12  32k/16k 2C. Extra F/W. Big ext. PSU.
- __National CF-2000__           16k/16k 2C!
- __Sony HB-55__                 16k/16k 1C+E. Cheap keyboard.
- __Sony HB-55P__                16k/16k 2C. European version.
- __[Canon V-8]__         85-08  16k/16k 1C! Compact. Ext PSU 9V.
- __Casio PV-16__                16k/16k 1C+E! Ext. PSU 10 V 800 mA.
                                 Small chiclet keyboard.
- __Casio MX-10/MX-101__         16k/16k 1C+E! PSU 7 V 800 mA.
- __Casio PV-7__                  8k/16k 1C+E! No CMT. PSU 10V 800mA center-neg.
                                         Cursor keys separate from joypad.

Notes:
- `C!` indicates no parallel printer port (despite it being mandatory for
  MSX1). See also [Machines without printer port][mw-noprn], which also
  lists vendor's printer port cartridges. Small Casios have printer port
  in KB-7/10/15 expansion unit.
- __Toshiba HX-21/22__ include RGB (RP13A) output, stereo sound output,
  serial port (optional on -21). Firmware: JP wapro, memorydisk BASIC.
- The __National CF-3000__ and __CF-3300__ have a connector for a
  superimpose unit, the __CF-2601.__ The 3300 has a connector for a second
  external floppy drive.
- The __Casio PV-7__ and __Casio MX-10/MX-101__ have no CMT interface; they
  need the FA-32 expansion unit (which also adds a 100 V PSU)  to add it.

#### Power Supplies

The Sony [AC-HB3][] (for HB-FX1D) and Panasonic [FS-AA51][] (for for FS-A1,
FS-A1mkII) external PSUs use the same 3-pin "mini-IEC" connector and supply
9 VDC 1.2 A and 18 VAC 170 mA. The boards themselves apparently use only
+5 VDC and ±12 VDC, the latter for the audio amplifier.



<!-------------------------------------------------------------------->
<!-- Machines -->
[Canon V-8]: ./models/Canon_V-8.md
[National CF-1200]: https://www.msx.org/wiki/National_CF-1200
[National CF-2700]: https://www.msx.org/wiki/National_CF-2700
[National CF-3000]: https://www.msx.org/wiki/National_CF-3000
[National CF-3300]: https://www.msx.org/wiki/National_CF-3300
[mw-noprn]: https://www.msx.org/wiki/Printer_port#Machines_without_printer_port

<!-- PSUs and accessories -->
[AC-HB3]: https://www.msx.org/wiki/Sony_AC-HB3
[FS-AA51]: https://www.msx.org/wiki/Panasonic_FS-AA51
