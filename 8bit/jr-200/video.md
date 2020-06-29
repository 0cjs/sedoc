Panasonic JR-200 Video
======================

- 32×24 text in 8×8 cells.
- 253 built-in glyphs (96 letters/numbers/symbols, 5 greek letters, 63
  graphical symbols, 79 katakana, 10 music/other.)
- Colors: 0=black 1=blue 2=red 3=magenta 4=green 5=cyan 6=yellow 7=white.

The character data are normally from VRAM at $D000-$D7FF; changing an
attribute bit will read the data from $C000-$C7FF instead, though this
partially overlaps the screen character RAM ($C100-$C3FF) and attribute RAM
($C500-$C7FFF).

The $D000-$D7FF VRAM is is loaded at boot with data downloaded from the
MN1544CJR microcontroller (which then goes on to run the keyboard).

Standard screen codes:

    $00-$1F   kanji, symbols, Greek
    $20-$7E   standard printable ASCII characters
    $7F       high horizontal bar instead of ~
    $80-$9F   graphics
    $A0-$DF   katakana
    $E0-$FF   graphics

#### Semi-Graphics

64×32. Use `PLOT` in BASIC. On screen, set bit 7 in color/attribute byte
and other bits there and in char determine colours of each of the four
pixels.


Details
-------

Most of the following information is from [[Reunanen]].

The attribute buffer at $C500-$C7FF has a byte corresponding to each
character cell at $C100-$C3FF:

    Bits  Purpose
      7   0=text cell  1=semi-graphics cell
      6   Charset base address: 0=$D000  1=$C000
     5-3  Background color
     2-0  Foreground color

The semi-graphics mode breaks each 8×8 pixel character cell into four 4×4
pixel blocks, 'a' and 'b' across the top, 'c' and 'd' across the bottom.

         bits   7  6  5  4  3  2  1  0
    character  xx xx bG bR bB aG aR aB
    attribute   1  0 dG dR dB cG cR cB

Writing $CA00 will set the frame colour; all but the lowest three bits are
ignored. Reads are invalid.



<!-------------------------------------------------------------------->
[Reunanen]: http://www.kameli.net/marq/?page_id=1270
