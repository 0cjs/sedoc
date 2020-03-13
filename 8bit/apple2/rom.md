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


References
----------

References:
- \[a2ref] [_Apple II Reference Manual_][a2ref], 1979 edition.


<!-------------------------------------------------------------------->
[a2ref-61]: https://archive.org/details/Apple_II_Reference_Manual_1979_Apple/page/n71/mode/1up
[a2ref]: https://archive.org/details/Apple_II_Reference_Manual_1979_Apple

[blondihacks-151011]: https://blondihacks.com/apple-iic-plus-fixing-the-beep/
