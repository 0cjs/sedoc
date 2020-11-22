Panasonic JR-200 Video
======================

- 32×24 text in 8×8 cells.
- 253 built-in glyphs (96 letters/numbers/symbols, 5 greek letters, 63
  graphical symbols, 79 katakana, 10 music/other.)
- Colors: 0=black 1=blue 2=red 3=magenta 4=green 5=cyan 6=yellow 7=white.

References: [[Reunanen]].


Character Codes and Attributes
------------------------------

The video system displays 32 chars × 24 rows with character codes read from
$C100 and corresponding character attributes read from $C500.

#### Standard Charset Screen Codes

    $00-$1F   kanji, symbols, Greek
    $20-$7E   standard printable ASCII characters
    $7F       high horizontal bar instead of ~
    $80-$9F   graphics
    $A0-$DF   katakana
    $E0-$FF   graphics

#### Character Attributes

     Bit   Description
      7    0=character cell  1=semi-graphics cell
      6    base addr for character bitmaps: 0=$D000  1=$C000
     5-3   background color: 0-7
     2-0   foreground color: 0-7


VRAM Organization
-----------------

There is 4K of VRAM in 2 × 2K blocks at at $C000 and $D000.

    $D000-$D7FF  system-defined characters (256 chars × 8 bytes)

    $C500-$C7FF  screen character attribute cells
    $C400-$C4FF  user-defined characters block 1 (32 chars × 8 bytes)
    $C100-$C3FF  screen character codes cells
    $C000-$C0FF  user-defined characters block 0 (32 chars × 8 bytes)

The VRAM with the system-defined characters, $D000-$D7FF, is loaded at
system initialization from ROM in the MN1544CJR microcontroller, which
after that is used to scan the keyboard.

If the attribute byte for a character position has bit 6 clear, the
character bitmap will be read from the $D000-$D7FF block of 256 characters.
If attribute bit 6 is set, the character bitmap will be read from
$C000-$C7FF. Since this area has the character code and attribute buffers
read by the video system, in practice there are only 64 usable user-defined
character bitmaps at $C000-$C0FF and $C400-$C4FF. The `prchar` ($EBE7)
routine in the BIOS will translate character codes for positions with
attribute bit 6 set to make them easier to use:

    ASCII sticks      codes     translation   char def memory range
    ───────────────────────────────────────────────────────────────
    punctuation       $20-$3F → $00-$1F       $C000-$C0FF
    upcase letters    $40-$5F → $80-$9F       $C400-$C4FF

When using `prchar` with the alternate char set attribute set do not print
ranges $00-$1F (control chars) or $60-$FF (lower case sticks and extended
codes); these will show as random character patterns taken from the screen
character and attribute buffers.


Semi-Graphics
-------------

Bit 7 set in the character attribute indicates the character code and
attribute should be interpreted as a block of 2×2 pixels at that character
position, each with its own color 0-7, giving 64×48 eight-color graphics.

The BASIC `PLOT` command can handle plotting these for you.

In semi-graphics each 8×8 pixel character cell becomes four independent 4×4
pixel blocks, 'a' and 'b' across the top, 'c' and 'd' across the bottom.
Each has a three-bit color value.

         bits   7  6  5  4  3  2  1  0
    character  xx xx bG bR bB aG aR aB
    attribute   1  0 dG dR dB cG cR cB


Border
-----

Writing $CA00 will set the frame color; all but the lowest three bits are
ignored. Reads are invalid.



<!-------------------------------------------------------------------->
[Reunanen]: http://www.kameli.net/marq/?page_id=1270
