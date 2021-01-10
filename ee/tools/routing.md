Signal and Power Routing
========================

See also:
- [Build Techniques](build-tech.md) (especially "Bypass Caps")
- [KiCad](KiCad.md)
- forum.6502.org, [Techniques for reliable high-speed digital circuits][f65
  2029]. In the thread, [this post][f65 80566] has simulation images of
  ground return paths at 1 Mhz.


Signal Return Paths
-------------------

For routing issues, the clock frequencies themselves are not of interest:
the frequency implied by the rise time is. A clock signal with a 1 ns rise
time has the same routing/coupling/RF issues whether it's running at 10 MHz
or 100 kHz.

On an IC, all pins that source current must draw the current from the Vcc
pin; all pins that sink current must sink it to the GND pin. The route
between these two should be as short as possible.

Return current for a signal always takes the path of lowest impedence. For
DC, this is the path of lowest resistance (usually the most direct path
back) and the return current is _conduction current_. But for AC signals
return current is _displacement current_ transferred through the field
between the signal and the return path (like a capacitor) and the
lowest-impedence path will tend to follow the signal line, because the
smaller the loop area, the lower the inductance (Z = R + iωL). (A good
explanation of this is around 40 minutes into Eric Bogatin's presentation
[The Value of the White Space] [vws].)

This effect starts at around 1 kHz and by 1 MHz it's very tight, as shown
in the video above around 00:48 and [this video][feranec] and the following
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


Routing Tricks
--------------

### DIP I-leads (Butts) on Multi-layer PCBs

As [described on forums.6502.org][gw-ilead] by Garth Wilson, you can
make PCB routing easier by not using through-hole for certain parts
but instead trimming the DIP leads just below the shank and soldering
them directly to longish pads (of normal width) that are on only one
side of the board. (This takes more solder than a normal surface mount
because you need a sizable fillet.) You can also try bending the DIP
leads inward to make them J-leads. This leaves more space on the other
side of the board (and actually all other layers) for routing traces.



<!-------------------------------------------------------------------->
[f65 2029]: http://forum.6502.org/viewtopic.php?f=4&t=2029
[f65 80566]: http://forum.6502.org/viewtopic.php?f=4&t=2029&p=80566#p80566
[feranec]: https://youtu.be/4nEd1jTTIUQ?t=631
[herd10]: http://www.6502.org/users/andre/icaphw/design.html
[vws]: https://www.altium.com/live-conference/altiumlive-2018-annual-pcb-design-summit/sessions/value-white-space
[gw-ilead]: http://forum.6502.org/viewtopic.php?f=12&t=5923&start=45#p73277
