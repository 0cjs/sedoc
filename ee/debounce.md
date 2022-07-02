Switch Input Debouncing
=======================

74x123 Pulse Generator
----------------------

The Altair 8800 debounces front panel momentary switches with 1/2
74x123 (dual retrigggerable monostable multivibrator); schematic on
p.24 of [Theory of Operation][a88theo]. Below, pin numbers in
subscript prefix pin function.

- Examine line ₁1A (active-low), held high w/1KΩ pull up; switch
  shorts to ground via the S̅T̅O̅P̅ signal from the RUN/STOP flip-flop
  when in stop mode.
- ₂1B (active-high), ₃C̅L̅R̅ connected to ₁₆Vcc.
- 0.1 μF between ₁₄Rext and ₁₅Rext/Cext, 47 KΩ between ₁₅Rext/Cext and ₁₆Vcc.
- Ouput is ₁₃1Q, inverted ₄1Q̅ unused.


7406 Debouncer
--------------

![7406 two-gate debouncer](sch/7406-debouncer.jpg)

Note that you can get inverted output from the other gate.

From James W. Coffron, _Getting Started with 8080, 8085, Z80, and 6800
Microprocessor Systems,_ 1981, Prentice Hall. [pp.285-287][coff-286].


S/R Flip-flop
-------------

Can be used for "break before make" dual-pole switches, as [described
here][le5.2].



<!-------------------------------------------------------------------->
[a88theo]: http://chiclassiccomp.org/docs/content/computing/MITS/MITS_Altair8800TheoryOperation_1975.pdf
[coff-286]: https://archive.org/details/gettingstartedwi0000coff/page/286/mode/1up?view=theater
[le5.2]: http://www.learnabout-electronics.org/Digital/dig52.php
