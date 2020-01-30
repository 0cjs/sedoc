Prototyping Techniques
======================

This is mainly about breadboarding; see also [Build
Techiques](build-tech.md) for anything involving soldering.


Wire Lengths
------------

Fujiya auto-stripper removes 5 mm insulation at shortest setting.
Extend slightly to 7 mm for breadboard hookup wires. For short
hookups, strip 10 mm, cut to length at far end, and slide insulation
down slightly.


Breadboards vs. Dual-Row Pin Headers
------------------------------------

[Topic on EEVblog forum.][msg2860602]

- Plug male jumper pins into female connector on the end of an IDC cable.
- Solder a breakout board with perfboard.
- Use DIP IDC connectors, e.g. CW Industries CWR-130 series. (These
  have fragile pins, so best to use in a sacrificial socket.)
- If using 26- or 40-pin IDC cable, use a Raspberry PI GPIO extension
  board for breadboards. These usually have a shrouded header 0.6" DIP
  connection to the breadboard.

[msg2860602]: https://www.eevblog.com/forum/projects/breadboards-vs-dual-row-pin-headers-(dupont-berg)/msg2860602/
