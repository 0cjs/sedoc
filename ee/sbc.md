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


[Bench-1 QRG]: http://wilsonminesco.com/BenchCPU/B1QRG/
[Maxim DS1813]: https://datasheets.maximintegrated.com/en/ds/DS1813.pdf
[cypress-decoup]: http://www.cypress.com/file/135716/download
[searle-6809]: http://searle.hostei.com/grant/6809/Simple6809.html
[wp-decoup-cap]: https://en.wikipedia.org/wiki/Decoupling_capacitor
