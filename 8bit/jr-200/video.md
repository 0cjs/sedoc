Panasonic JR-200 Video
======================

- 32×24 text in 8×8 cells.
- 253 built-in glyphs (96 letters/numbers/symbols, 5 greek letters, 63
  graphical symbols, 79 katakana, 10 music/other.)
- Colors: 0=black 1=blue 2=red 3=magenta 4=green 5=cyan 6=yellow 7=white.

"Low-res" video (`PLOT` in BASIC) is 64×32. It is not just using the block
chars; a single character block can display four different colours with no
problem.


Details
-------

Most of the following information is from [[Reunanen]].

The colour table has a byte for each character cell:

    Bits  Purpose
      7   0=text cell  1=low-res graphics cell
      6   Charset base address: 0=$D000  1=$C000
     5-3  Background color
     2-0  Foreground color

The low-res graphics mode breaks each 8×8 pixel character cell into four
4×4 pixel blocks; each block can have its color set independently.



<!-------------------------------------------------------------------->
[Reunanen]: http://www.kameli.net/marq/?page_id=1270
