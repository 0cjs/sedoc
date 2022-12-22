MSX Models Summary
==================

See [`../README.md`](../README.md) for standard specifications.

Memory figures are RAM/VRAM. ≥64K VRAM indicates MSX2 or MSX2+. "2C" indicates
two cartridge slots; "1C+E" one cartridge slot plus an expansion bus connector
(usu. for a unit with more slots); "+D" indicates a 3.5" floppy drive. SK
indicates separate keyboard and desktop system unit.

MSX2:
- __Sony HB-F1XD__               64k/128k 2C+D RGB. Ext. PSU.
- __Panasonic FS-A1__            64k/128k 2C RGB. Ext. PSU.

MSX1 64K:
- __Toshiba HX-22__¹             64k/16k 2C } "Pasopia IQ" (see below)
- __Toshiba HX-21__¹             64k/16k 2C }
- __Canon V-20__                 64k/16k 2C.
- __Sanyo MPC-2 (Wavy2)__        64k/16k 2C.
- __[National CF-3300]__² 85-??  64k/16k 2C+D SK. 360K (1DD 80-track) drive.
- __[National CF-3000]__² 84-11  64k/16k 2C   SK. JP21 RGB. No space for drive.
- __Sanyo PHC-SPC__       85-??  64k/16k 2C. Relatively compact.

MSX1 32K:
- __[National CF-2700]__  84-10  32k/16k 2C.
- __Hitachi MB-H1__       83-12  32k/16k 2C. Extra F/W. Big ext. PSU.

MSX1 16K:
- __[National CF-1200]__  85-??  16k/16k 2C. CF-2700 w/½ memory, 30% cheaper
- __National CF-2000__           16k/16k 2C!
- __Sony HB-55__                 16k/16k 1C+E. Cheap keyboard.
- __Sony HB-55P__                16k/16k 2C. European version.
- __[Canon V-8]__         85-08  16k/16k 1C! Compact. Ext PSU 9V.
- __Casio PV-16__³        85     16k/16k 1C+E! Std CMT.     PSU 10V 800mA •-
- __Casio MX-101__³       87     16k/16k 1C+E! Non-std CMT. PSU  7V 800mA •-
- __Casio MX-10__³        85     16k/16k 1C+E! Non-std CMT. PSU  7V 800mA •-
- __[Sony HB-101]__       84-??  16k/16k 2C. "Personal Data Bank" w/disk support

MSX1 8K:
- __Casio PV-7__³         84-10   8k/16k 1C+E! Non-std CMT. PSU 10V 800mA •-

Notes:
- '•-' indicates center-negative 5.5/2.5 mm barrel jack for power.
- `!` indicates no parallel printer port (despite it being mandatory for
  MSX1). See also [Machines without printer port][mw-noprn], which also
  lists vendor's printer port cartridges. Small Casios have printer port in
  KB-7/10/15 expansion unit.
- ¹ __Toshiba HX-21/22__ include RGB (RP13A) output, stereo sound output,
  serial port (optional on -21). Firmware: JP wapro, memorydisk BASIC.
- ² The __National CF-3000__ and __CF-3300__ have a connector for a
  superimpose unit, the __CF-2601.__ The 3300 has a connector for a second
  external floppy drive.
- ³ __Casio PV-16__, __Casio PV-7__, __Casio MX-10__, __Casio MX-101__
  - MX-101 is just an MX-10 w/UHF antenna.
  - Cursor keys/space separate from joypad. Two separate joystick buttons
    on unit itself. Terrible chicklet keyboards (touch-typing impossible).
  - PV-7 cart slot: no 12V, SW1/2 are grounded, sound in on KB-7 slots only.
  - PV-7, MX-10, MX-101 DIN-5 CMT port is not standard; needs an FA-32/33
    adapter. See [[fa32clone]], [[fa32load]], [[fa32git]].
  - KB-7 (PV-7, PV-16) and KB-10 (MX-10, MX-101) expansion units add 2 more
    slots and AC power.

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
[Sony HB-101]: https://www.msx.org/wiki/Category:Sony_HB-101
[fa32clone]: http://basshp.blogspot.com/2015/03/casio-fa-32-clone-interface-de-cassete.html
[fa32git]: https://github.com/Danjovic/MSX/tree/master/FA-32
[fa32load]: https://basshp.blogspot.com/2015/05/fa-32-mini-cassete-loader-p-casio-msx.html
[mw-noprn]: https://www.msx.org/wiki/Printer_port#Machines_without_printer_port

<!-- PSUs and accessories -->
[AC-HB3]: https://www.msx.org/wiki/Sony_AC-HB3
[FS-AA51]: https://www.msx.org/wiki/Panasonic_FS-AA51
