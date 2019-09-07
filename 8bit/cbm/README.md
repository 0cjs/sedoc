Commodore (CBM) Computer Information
====================================

Documentation here:
- [PETSCII](petscii.md)
- [CBM Address Decoding (Memory Maps)](address-decoding.md)
- [Machine Language](machlang.md)
- [Commodore Serial (IEC) Bus](serial-bus.md)
- [Commodore BASIC](basic.md)


Summary of Machines
-------------------

- [VIC-20]: 5K; no bitmap graphics, programmable charset
  - 22×23×2 (8×8 cells = 176×184)
  - 20×20×2 (8×8 cells = 160×160) "bitmap" w/1 programmed char/cell
  - 11×23×4 (4×8 cells = 88×184)
- [MAX Machine]: 2K, no ROM; additional RAM/ROM supplied on carts.
  No IEC serial, user ports. Otherwise C64 hardware (but different
  memory map).
- [C64]: 64K
  - Text: text 40x25×16 (8x8 cells = 320×200), programmable charset
  - Bitmap: 160×200×4, 320×200×2, sprites

Emulate all CBM models on [VICE] \([manual][viceman]).
- Key mappings (not PET):
  - `CTRL`=Tab, `C=`=Left-Ctrl, `STOP/RUN`=Esc, `CLR/HOME`=Home, `RESTORE`=PgUp.
  - May need Shift-F2/F4/F6/F8 to enter F2/F4/F6/F8.
  - See [`gtk3_sym.vkm`] for full details (docs are incomplete).


Commodore 64
-------------

General documentation:
- [Commodore 64 Programmer's Reference Guide][c64progref], 1982, CBM.
- [Commodore C64/C64C Service Manual][c64service], March 1992 PN-314001-03



<!-------------------------------------------------------------------->
[`gtk3_sym.vkm`]: https://sourceforge.net/p/vice-emu/code/HEAD/tree/trunk/vice/data/C64/gtk3_sym.vkm
[c64]: https://www.c64-wiki.com/wiki/C64
[max machine]: https://www.c64-wiki.com/wiki/Commodore_MAX_Machine
[vic-20]: https://www.c64-wiki.com/wiki/VIC-20
[vice]: http://vice-emu.sourceforge.net/index.html
[viceman]: http://vice-emu.sourceforge.net/vice_toc.html

[c64progref]: https://archive.org/details/c64-programmer-ref
[c64service]: https://www.retro-kit.co.uk/user/custom/Commodore/C64/manuals/C64C_Service_Manual.pdf
