Apple II ROM Information
========================


Useful ROM Routines
-------------------

See also [pp. 61-64][a2ref-61] of [a2ref].

- $FDED COUT: Print ASCII char (MSB set) in A.
- $FC58 HOME: Clear screen and move cursor to upper left.
- $FCA8 WAIT: Short delays related to the square of the value in A.
  The comment in the non-autostart monitor source code ((512a² + 2712a
  + 13) × 1.0204 μsec) seems bogus; it's actually approximately 5a²/2
  + 12a + 8. Some analysis at [blondihacks-151011].


Zero Page
---------

`b`=byte; `w`=word.

    20  32 b  text window left edge (0-38)
    21  33 b  text window width (1-40, 1-80)
    22  34 b  text window top row (0-23)
    23  35 b  text window bottom row (1-24)
    24  36 b  cursor pos., horizontal (0-39)
    25  37 b  cursor pos., vertical (0-23)
    2B  43 b  boot slot * 16
    32  50 b  text output (normal:$FF/255, inverse:$3F/63, flash:$7F/127)
    33  51 b  prompt character
    4E  71 w  random number field
    67 103 w  start of Applesoft program (ptr-1 byte must be 0 for NEW)
    69 105 w  LOMEM (start of Applesoft variable space, approx end of prog.)
    6B 107 w  start of array space
    6D 109 w  end of array space
    6F 111 w  start of string storage
    73 115 w  HIMEM (one past highest usable addr)
    AF 175 w  end of Applesoft program


References
----------

References:
- \[a2ref] [_Apple II Reference Manual_][a2ref], 1979 edition.


<!-------------------------------------------------------------------->
[a2ref-61]: https://archive.org/details/Apple_II_Reference_Manual_1979_Apple/page/n71/mode/1up
[a2ref]: https://archive.org/details/Apple_II_Reference_Manual_1979_Apple

[blondihacks-151011]: https://blondihacks.com/apple-iic-plus-fixing-the-beep/
