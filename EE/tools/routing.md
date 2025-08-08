Signal and Power Routing
========================

See also:
- [Build Techniques](build-tech.md) (especially "Bypass Caps")
- [KiCad](KiCad.md)
- forum.6502.org, [Techniques for reliable high-speed digital circuits][f65
  2029]. In the thread, [this post][f65 80566] has simulation images of
  ground return paths at 1 Mhz.


Speed and Bandwidth
-------------------

The overshoot and ringing at the end of an edge is usually due to
transmission line reflections (because source/line and line/target
impedence is not matched) and will generally increase with edge speed. It
can help do do impedence matching on the board for important traces.

For signal integrity, the clock frequency is not as of much interest as the
frequency implied by the rise time of the signals. A clock signal with a 1
ns rise time has the same routing/coupling/RF issues whether it's running
at 10 MHz or 100 kHz.

Useful equations:
- _BW = 0.35/RT_ gives the bandwidth of a signal from its rise time. [[rot1]]
  (For _RT_ in ns, _BT_ is in GHz.) E.g., 0.35 / 5.4 ns RT = 65 MHz BW.
- _F = 0.5 / Tr_ gives the -40 dbV frequency for signals with a rise time
  of _Tr_. Tr=20 ns → F=25 MHz; Tr=1 ns → F=500 Mhz (i.e., even a 10 Hz
  clock with 1 ns rise time needs 500 MHz board design). [[ganssle]]

Rise and fall times (in ns) for families (from [Temps de Montée / Descente
des familles logiques][rft]):


         Family   Rise  Fall    Source

      4000 CMOS   50    50      Motorola CMOS databook
            TTL    5.5   3.3    TI TTL databook
             LS    5.4   6.7    TI TTL databook
         HC/HCT    3.8   3.8    TI HC/HCT databook
            ALS    3     2      TI ALS/AS databook
              S    2.1   8      TI TTL databook
           FAST    1.6   1      TI F Logic databook
            BCT    1.6   2.7    TI BICMOS Bus I/F databook
             AS    1.7   1      NS ALS/AS databook
         AC/ACT    1     1      Motorola FACT databook
            ABT    1     1      TI ABT databook

The speed of a signal in FR4 is about 15 cm/ns. From this the length of an
edge can be calculated: a DDR3 edge of 300 ps will be spread across ~4.5
cm. Discontinuitites less than one-third this length will be transparent to
the signal. [[rot29]]


Signal Return Paths
-------------------

> Forget the word _ground_. More problems are created than solved by using
> this term. Every signal has a return path. Think _return path_ and you
> will train your intuition to look for and treat the return path as
> carefully as you treat the signal path.
>
>   --Eric Bogatin, _Signal and Power Integrity—Simplified_
>     (Top Ten Signal Integrity Principles, number 3.)


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
[The Value of the White Space][vws].)

This effect starts at around 1 kHz and by 1 MHz it's very tight, as shown
in the video above around 00:48 and [this video][feranec] and the following
image. Thus, the ideal is ground and power planes underneath the signal
traces. Breaks in the ground plane will force the current around the break,
as seen in this [return current image](../sch/return-current.jpg).

Note that shared return paths (two return paths using the same narrow
conductor at some point) will also cause interference with each other. This
is usually seen as "ground bounce," where the ground side of the path shows
a voltage change (as compared to the source ground on the board) during a
signal transition. This is often seen in a shared ground lead in a package
with multiple signal outputs.

The return path may also be (at least partially) via another (usually
adjacent) signal path, which causes signals to interfere with each other.

### Designing Return Paths

- Continuous return planes under the signal lines are idea; a ground plane
  is one implementation of this.
- When a gap across the return path is necessary:
  - Route signal around the gap; a longer signal line with uniform return
    path will work better than a split return path.
  - Cross the gap but add adjacent return "straps" on either side. (I.e.,
    bring the ground up to the signal layer on either side of the signal
    path during the crossing; example on [p.24 here][vws-slides].)
  - Even add a full return ground trace (obviously attached at both ends)
    parallel to the entire signal trace (like a ribbon cable).
- For surface-mount packages, via to ground plane should be as close as
  possible to ground pin, and trace to it short and wide.
- In connectors: a return adjacent to every signal pin (yes, this means
  more pins on connectors), and minimize sharing of returns.

### Short Return Paths When Not Continuous

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
[ganssle]: https://youtu.be/MJpDFnRQw8s?t=259
[gw-ilead]: http://forum.6502.org/viewtopic.php?f=12&t=5923&start=45#p73277
[herd10]: http://www.6502.org/users/andre/icaphw/design.html
[rft]: http://ve2zaz.net/referenc/LogicT.htm
[rot1]: https://www.edn.com/rule-of-thumb-1-bandwidth-of-a-signal-from-its-rise-time/
[rot29]: https://www.edn.com/what-is-the-spatial-extent-of-an-edge-rule-of-thumb-29/
[vws-slides]: https://www.altium.com/live-conference/sites/default/files/pdf/The%20Value%20of%20the%20White%20Space%20-%20Eric%20Bogatin.pdf#page=24
[vws]: https://www.altium.com/live-conference/altiumlive-2018-annual-pcb-design-summit/sessions/value-white-space
