Crimping Tools and Techniques
=============================

References:
- Matt Millman, [Common Wire-to-board, Wire-to-wire Connectors, and Crimp
  Tools][millman]. Fantastic guide with many, many details.
- Gogo:Tronics, [Crimping Electronics Connectors (Dupont, PH, XH, VH,
  KF2510)][gogo].

Terminology:
- A _wire_ consists of a _conductor_ wrapped in _insulation_.
- _Connectors_ may be male or female, and have two sets of metal tabs, the
  _insulation tabs_ at the end and the _conductor tabs_ in the middle.
  (Tabs may also be called _barrels_.)
- The connectors are inserted into a _shroud_, which for dupont-style
  accepts both male and female connectors.


"Dupont" and Similar Connectors
-------------------------------

Use a proper crimping tool. For dupont it should crimp the wire tabs
with "curl-in" but the insulation tabs with "wrap-around." I use a
Preciva PR-3254 with three blocks:
1. (outside) XH and C3-R 2.54 mm, JST
2. (middle) Molex IDE power, ATX power, VH3.96
3. (handle) dupont 2.54 male/female

When crimping, press the jaws together _very_ hard; it's easy to use too
little force and get a loose connection, even if all else is done
correctly.

The insulated part _must_ be fully inserted to at least the inside end of
the insulation grip tabs on the connector. It's can work if it extends very
slightly into conductor crimp tabs, but this should be avoided if possible.
Give the crimped connection a good strong tug before inserting it into the
housing.
- The amount of conductor you need to strip is less than you might
  think; only about 3 mm or so. 5 mm is too long and will interfere
  with pin insertion for female connectors.
- However, you can strip twice the length and fold the bare conductor back
  at the half-way point, if you need more thickness. This will only work
  with very thin conductor; normal 24 gauge will be too thick if you do
  this.
- Ensure the connector lines up the insulation ("wrap") tabs and conductor
  ("curl in") tabs with the proper spots on the crimper. It may be
  easier to insert the tabs into the slot, even if this means turning
  the tool around until you can use that direction, but that makes it
  harder to align the gap between the two sets of tabs to the centre
  of the die.
- Sometimes closing the crimper more than one notch will not allow the
  insulation to get into the insulation tabs. Other times it's ok. I
  sometimes use two.
- To get correct alignment: insert the connector until the conductor tabs are
  almost at the centre ledge between the two sets of tabs. There should be
  more space between the centre ledge and the insulation tabs than between
  the centre ledge and the conductor tabs. Then when inserting the wire from
  the other side, use the ledge at the top of the jaws (opposite the side on
  which the connector rests as the "feel stop" for the insulation. This
  should bring the insulation almost but not quite to the conductor tabs,
  ensuring that it's fully held by the insulation tabs.
- When doing the crimp there's no need for the conductor or insulation to be
  resting on the connector; even resting against the top edge of the jaws,
  as far away from the connector as it can get, it will still be crimped
  properly.

#### Double Crimps

It can be useful to crimp two wires into a single connector to duplicate a
ground.
1. Crimp a short wire in the normal way and cut it down to 3 cm from the
   back of the crimp pin.
2. Strip the other end of the short wire to 2-3× normal bare length; none
   of the insulation, only the conductor should enter the crimp connector.
   (This wire should need little strain relief; don't pull it!)
3. Strip the longer wire, the signal you're duplicating, as normal.
4. Place longer wire on top of shorter wire, with the ends lining up, and
   crimp so that only the long wire's insulation goes in the insulation
   tabs; the short wire will have conductor in both conductor and
   insulation tabs..
5. Get the longer wire's pin in the shroud first; it may require a bit of
   squeezing due to the double-insulation at the entry to the shroud.
   (Consider stripping bare conductor to outside of shroud?)
6. Loop the shorter wire's pin into its shroud slot.


Colors
------

Colors follow, as much as possible, the electronics color code, with
substitutions where there aren't enough wire colors.

    0   black               (arrow/triangle on connector)
    1   brown, white        (draw black stripe on white with marker)
    2   red
    3   orange, white
    4   yellow
    5   green
    6   blue
    7   violet, white       (tried orange, but found it confusing)


<!-------------------------------------------------------------------->
[gogo]: https://sparks.gogo.co.nz/crimping/
[millman]: http://tech.mattmillman.com/info/crimpconnectors/
