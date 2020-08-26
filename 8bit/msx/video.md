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
