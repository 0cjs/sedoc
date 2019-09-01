Single-board Computer (SBC) Notes
=================================

Also see [Address Decoding Notes](addr-decoding.md).

Many handy circuits for reset, clock, address decoding, interfacing,
I/O, etc. can be found in the Wilson Mines Co. [Bench-1 workbench
computer quick reference guide][Bench-1 QRG].

Bypass Caps
-----------

[Wikipedia][wp-decoup-cap] mentions ~100 nF ceramic per IC with
up to a few hundred μF electrolytic/tantalum per board section.
Cypress note [Using Decoupling Capacitors][cypress-decoup] goes
into much more detail.


Switch Debounce
---------------

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


1CK (pin 1) is the (debounced) examine button input


Reset Circuits
--------------

The [Searle reset design][searle-6809] uses a 2k2 pullup with an
NO switch to ground, no debounce or power good.

Reset circuit at [Bench-1 QRG]

The [Maxim DS1813] reset generator (~¥120/ea on Aliexpress) is a 5 V
3-pin part that will pull down reset after a button push or voltage
out-of-tolerance condition and after release/restoration will hold
reset for 150 ms.


SBC Designs
-----------

#### Grant Searle

Minimal chip count design for 6502/[6809][searle-6809]/Z-80.



<!-------------------------------------------------------------------->
[Bench-1 QRG]: http://wilsonminesco.com/BenchCPU/B1QRG/
[Maxim DS1813]: https://datasheets.maximintegrated.com/en/ds/DS1813.pdf
[a88theo]: http://chiclassiccomp.org/docs/content/computing/MITS/MITS_Altair8800TheoryOperation_1975.pdf
[cypress-decoup]: http://www.cypress.com/file/135716/download
[searle-6809]: http://searle.hostei.com/grant/6809/Simple6809.html
[wp-decoup-cap]: https://en.wikipedia.org/wiki/Decoupling_capacitor
