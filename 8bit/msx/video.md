MSX Video
=========

The video system always has its own VRAM separate from the system RAM and
not directly addressable by the CPU. This is 16 KB in MSX1 machines and 128
KB (or sometimes 64 KB) in MSX2 machines. VRAM holds the current character
set definition (_pattern generation table_), character cells indexing into
the character set to determine which characters are displayed on the screen
(_pattern name table_), sprite and color information, and so on.

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


Characters and Fonts
--------------------

In text modes the frame buffer is a linear sequence of 1-byte character
cells determining the displayed characters from left to right on each line,
with lines from top to bottom. This is called the [_pattern name table_][2t
pntab] (or sometimes the _pattern layout map_). Each byte is an index into
a character definition table called the [_pattern generator table_][2t
pgtab], which is a sequence of 8 bytes for each character definition, each
byte a line from top to bottom and each bit from 7 to 0 a pixel from left
to right.

Some modes also have a [_blink table_][2t btab] with the first byte's bits
0-7 giving blink status (1=on) for character positions 0-7 first row of the
screen, and so on. Other modes also have a [_color table_][2t ctab] that
sets a forground and background color for groups of patterns in the pattern
generator table.

ASCII representation of a font table could be done in an 8×4 character grid:

    ½  ▄▀▀▀▄...  ▄▀▀▀▄...  ........    .▀. TB upper half block
    ¾  .▄▄.█...  ▀▄▄▄....  █...█...    .▄. LB lower half block
    ⅚  █.█.█...  ▄...█...  ▀▄▄▀█...    ...  . period
    ⅞  .▀▀▀....  .▀▀▀....  .▄▄▄▀...    .█. FB full block

### System Fonts

The system font table is in the main ROM; the CGTABL word ($0004) points to
it. CGPNT ($F91F byte slot number, $F920 word address) points to the
current font table; this is loaded into VRAM when a screen text mode is
initialized.

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


Video Modes
-----------

The following were taken from an MSX2 guide; they do not indicate what's
missing in MSX1.

    VDP Mode        BASIC
    ─────────────────────────────────────────────────
    T1  TEXT1       SCREEN 0 (width 1-40)
    G1  GRAPHIC1    SCREEN 1
    G2  GRAPHIC2    SCREEN 2
    ─────────────────────────────────────────────────

    ┌─ VDP Mode
    │   ┌─ Pattern Size
    │   │    ┌─ Screen Size
    │   │    │      ┌─ Patterns
    │   │    │      │     ┌─ Colors
    │   │    │      │     │
    │   │    │      │     │
    ─────────────────────────────────────────────────
    G1  8×8  32×24  256   16/512    0000d
    G2  8×8  32×24  768¹  16/512

    ───────────────────────────────────────────────────
    VDP Mode    T1         G1          G2
    ───────────────────────────────────────────────────
    P.Size      6×8        8×8         8×8
    Scr.Size    40×24      32×24       32×24
    Patterns    256        256         768²
    Colors      2/512      16/512      16/512
    ───────────────────────────────────────────────────
    P.Gen       0800-0fff  0000-07ff   0000-17ff
    P.Layout    0000-03bf  1800-1aff   1800-1aff
                           1800-1f5f
    P.Colors        ─      2000-201f   2000-37ff
    S.Patterns      ─      3800-3fff   3800-3fff
    S.Attr          ─      1b00-1b7f   1b00-1b7f
    S.Colors        ─          ─           ─
    ───────────────────────────────────────────────────
    TDB/PG¹     §3.3 p.25   §3.4 p.38   §3.5 p.42
    ───────────────────────────────────────────────────
      P = Pattern, S = Sprite
    ¹ ASCII / Nippon Gakki V9938 Tech. Data Book/Prog. Guide (1985)
    ² 256 per ⅓ of the screen



<!-------------------------------------------------------------------->
[vpoke]: https://www.msx.org/wiki/VPOKE

[2t btab]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter4a.md#blink-table
[2t ctab]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter4a.md#colour-table
[2t pgtab]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter4a.md#pattern-generator-table
[2t pntab]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter4a.md#pattern-name-table
[mf csbin]: https://www.msx.org/forum/msx-talk/development/dump-character-set-to-bin-for-re-use
