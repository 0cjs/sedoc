Build Techniques
================

See also
- [Routing and bypass caps](routing.md).
- [Crimping](crimping.md) and [Soldering](soldering.md)


Bypass Caps
-----------

- On every IC: 0.1 μF between power and ground, as close to the power and
  ground pins as possible.
- Every eight chips: 4.7 μF on array's power rails (PCB trace inductances).
- Also see [Capacitor Notes](../capacitor.md).


SMD
---

Smaller parts (<`0805`) are not marked. Keep only one value at a time
open on the workbench, and put all parts away before opening up
another value part.


Sockets
-------

DIP sockets come in two types: machine-tooled with gold flashed
contacts (more reliable long term) and cheaper tin wiper contacts
which are more suited to frequent removal and reinstallation. For
wiper, always use double-wipe, where there are contacts on both sides
of the IC pin.


Mechanical Connections
----------------------

- [Superglue (cyanoacrylate) and baking soda][cabs] creates a very
  sturdy filler compound especially good for filling porous materials.
  Use baking soda to fill the gap and then drop on the superglue. The
  reaction is exothermic and produces noxious vapors.



<!-------------------------------------------------------------------->
[cabs]: https://en.wikipedia.org/wiki/Cyanoacrylate#Filler
