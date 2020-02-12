Build Techniques
================


Wire Wrap without Wire-wrap Sockets
-----------------------------------

JuanGg [demonstrated a technique on 6502.org][jg-ww] for doing a
partially wire-wrapped board without using (expensive) wire-wrap
sockets. He soldered regular DIP sockets into perfboard with header
pins on either side of them, and then soldered the header pins and
adjacent socket pins together.

The board is half-and-half: power and bypass caps are also soldered on
the bottom, but the logic is wired using wire-wrap between the header
pins on the top. This also makes wiring easier since you're looking at
the chips top-down instead of bottom-up.

<img src="http://forum.6502.org/download/file.php?id=9202&mode=view" width="400" alt="top side" title="top side"/>
<img src="http://forum.6502.org/download/file.php?id=9203&mode=view" width="400" alt="bottom side" title="bottom side"/>

[jg-ww]: http://forum.6502.org/viewtopic.php?f=12&t=5811&start=45#p72988


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


Crimping "Dupont" and Similar Connectors
----------------------------------------

Use a proper crimping tool. For dupont it should crimp the wire tabs
with "curl-in" but the insulation tabs with "wrap-around." I use a
Preciva PR-3254 with three blocks:
1. (outside) XH and C3-R 2.54 mm, JST
2. (middle) Molex IDE power, ATX power, VH3.96
3. (handle) dupont 2.54 male/female

The insulated part _must_ be fully inserted to at least the inside end
of the insulation grip tabs on the connector. It's seems ok if it
extends very slightly into wire crimp tabs. Give the crimped
connection a good strong tug before inserting it into the housing.
- The amount of bare wire you need to strip is less than you might
  think; only about 3 mm or so. 5 mm is too long and will interfere
  with pin insertion for female connectors.
- Ensure the connector lines up the insulation ("wrap") and wire
  ("curl in") with the proper spots on the crimper.
- Close the crimper only one notch after first inserting the
  connector; using two may close it too much for the insulation to get
  completely through to the end of the insulation tabs.
- When inserting the wire, angle it down from the top (open side) of
  the connector in the block; this will help get the bare wire through
  the smaller wire tabs and the insulation completely to the end of
  the insulation tabs. Push hard enough to make sure it goes fully in;
  it's better to have a little insulation in the wire tabs than not to
  have it fully to the end of the insulation tabs. (Again, give it a
  good tug.)

Colors follow, as much as possible, the electronics color code, with
substitutions where there aren't enough wire colors.

    0   black               (arrow/triangle on connector)
    1   brown, blue
    2   red
    3   orange
    4   yellow
    5   green
    6   blue
    7   violet, orange
