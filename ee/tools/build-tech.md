Build Techniques
================

See also [Crimping](crimping.md) and [Soldering](soldering.md)


Signal and Power Routing, Bypass Caps
--------------------------------------

On an IC, all pins that source current must draw the current from the Vcc
pin; all pins that sink current must sink it to the GND pin. The route
between these two should be as short as possible.

For AC signals, return current through a ground plane will tend to follow
the route of the signal trace parallel to it on the other side of the
board. This effect is not huge at low frequences, such as 400 Hz, but by 1
MHz it's very tight, as shown in [this video][feranec] and the following
image. Thus, the ideal is ground and power planes underneath the signal
traces. Breaks in the ground plan will force the current around the break,
as seen in this [return current image](../sch/return-current.jpg).

Short of a proper ground plane, a quadrille mesh will also work well. Bill
Herd mentions [here][herd10] that he "always ran a ground ring around one
side and a power ring around another, then run feeders across the board to
connect from side to side, every chip can see the power supply or ground in
two directions." He also mentions that one should avoid having any stubs on
power or ground traces (because reflections).

Vcc down one side and ground on the other (inter-digitated) is terrible; it
makes for very long return paths.

The "short return path" principle applied:
- On cables with multiple power and ground, do not cluster either at the
  ends. Distribute them evenly down the length of the connector.
- When using multiple solderless breadboards, jumper between GND (and maybe
  Vcc) buses at multiple points along the length.

Bypass caps:
- On every IC: 0.1 μF between power and ground, as close to the power and
  ground pins as possible.
- Every eight chips: 4.7 μF on array's power rails (PCB trace inductances).
- Also see [Capacitor Notes](../capacitor.md).

References:
- forum.6502.org, [Techniques for reliable high-speed digital circuits][f65
  2029]. In the thread, [this post][f65 80566] has simulation images of
  ground return paths at 1 Mhz.


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


DIP I-leads (Butts) on Multi-layer PCBs
---------------------------------------

As [described on forums.6502.org][gw-ilead] by Garth Wilson, you can
make PCB routing easier by not using through-hole for certain parts
but instead trimming the DIP leads just below the shank and soldering
them directly to longish pads (of normal width) that are on only one
side of the board. (This takes more solder than a normal surface mount
because you need a sizable fillet.) You can also try bending the DIP
leads inward to make them J-leads. This leaves more space on the other
side of the board (and actually all other layers) for routing traces.

[gw-ilead]: http://forum.6502.org/viewtopic.php?f=12&t=5923&start=45#p73277


Mechanical Connections
----------------------

- [Superglue (cyanoacrylate) and baking soda][cabs] creates a very
  sturdy filler compound especially good for filling porous materials.
  Use baking soda to fill the gap and then drop on the superglue. The
  reaction is exothermic and produces noxious vapors.



<!-------------------------------------------------------------------->
[cabs]: https://en.wikipedia.org/wiki/Cyanoacrylate#Filler
[f65 2029]: http://forum.6502.org/viewtopic.php?f=4&t=2029
[f65 80566]: http://forum.6502.org/viewtopic.php?f=4&t=2029&p=80566#p80566
[feranec]: https://youtu.be/4nEd1jTTIUQ?t=631
[herd10]: http://www.6502.org/users/andre/icaphw/design.html
