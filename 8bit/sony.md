Sony SMC-777/SMC-777C
=====================

Models
------

- __SMC-777__ (1983-12, ¥148,000) Black.
  - Color palette board available for 16 or 4 of 4096 colours.
- __SMC-777C__ (¥168,000) White.
  - Identical to the SMC-777 in most ways. Comes with more software and
    colour palette board standard. Only available in black.

Tech specs:
- Z80 4.028 MHz. M5L8041 sub-CPU.
- VRAM: 32K graphics, 2K text, 2K attribute, 2K PCG.
  - VRAM in I/O space above $00FF.
  - Graphics: 320×200/16, 640×200/4. 16 fixed colours w/o palette board.
- Floppy: 3.5" 1DD, 80 track, 280 KB, standard MIC/ANSI X3.137.
- Audio: TI SN76489AN PSG (3 channels + noise). Built-in speaker.
- Analog RGB (25-pin proprietary), printer (25-pin centronics), Joystick 2×
  DE-9.

Peripherals:
- SMI-733 Color Palette Board (¥12,800)
- SMI-740 Expansion Card (¥19,800)
- SMI-752 Kanji ROM card (¥34,800)
- SMI-711 2nd Microfloppy Disk Unit (¥35,800)
- KX-13CD1 Analogue/Digital RGB Trinitron color monitor (¥89,800)

Software info:
- Came with a ton of software (777C more than 777?), including DR LOGO,
  777-BASIC, 777-ASSEMBLER, 777-DEBUGGER, 777-MEMO spreadsheet. Assembler
  uses Sony's "ANN" notation, not Z80 mnemonics. (Software written by
  Digital Research.)
- FORTRAN , COBOL , C , Pascal , APL , Forth , Prolog , and LISP available
  for CP/M.
- SONY FILER system calls compatible with CP/M 1.4 BDOS. CP/M 2.2
  available; included a screen editor.

Option Boards
-------------

- __SMI-752:__ Kanji ROM card
- __SMI-733:__ Colour palette board
  - Upgrades the SMC-777 to the SMC-777C specification. Changes from 16
    fixed colour palette, allowing software to choose 16 colours of 4096
    available colours.


References
----------

- [ディ スク 内 蔵 で 148.000 円 ソニーSMC-777][ASCII-8311], ASCII, 1983年
  11月号. p.100. Brief overview of system.
- ratscats.client.jp, [ソニー-SMC-777][ratscats]. Scanned copy of sales
  catalogue, including peripherals, available monitors, and prices.



<!-------------------------------------------------------------------->
[ratscats]: https://ratscats.client.jp/so-smc777.html
[ASCII-8311]: https://archive.org/details/ascii-1983-11/page/101/mode/1up
