MSX Video
=========

### Screens

Japanese MSX systems boot in screen 1 by default (when `SET SCREEN` has not
been used to save a different configuration); others boot in screen 0.

Screen 0 gives 40-colums, but at the cost of only 6 pixel width for
characters rather than the 8 that screen 1 (32 columns) gives you. In
screen 0 the right-hand two columns of pixels are simply not displayed;
this makes code point 0xC9 in the International charset (a vertical line at
the right hand side of the cell) display as a space.

### BASIC Commands

- [`VPOKE a,v`][vpoke]. _a_ is a VRAM address (0 through `&h3FFF` on MSX1,
  `&hFFFF` on MSX2; use `PAGE` to access the upper 64K of VRAM).

### Loading Fonts

From msx.org forum [Dump character set to BIN for re-use][mf csbin]:

    SC = ...                        ' screen number (mode)
    CT = BASE(SC*5 + 2)             ' get "pattern" table start address
    BSAVE "c.bin",CT,CT+(256*8),S   ' Save from VRAM; BLOAD ...,S to reload

    #   Load font and set up for copy to VRAM at next SCREEN command
    BLOAD "c.bin",&hC000-CT
    POKE &hF91F, PEEK(&hF343)       ' slot ID of font
    POKE &hF920,&h00                ' LSB of font addr
    POKE &hF921,&hC0                ' MSB of font addr



<!-------------------------------------------------------------------->
[vpoke]: https://www.msx.org/wiki/VPOKE

[mf csbin]: https://www.msx.org/forum/msx-talk/development/dump-character-set-to-bin-for-re-use
