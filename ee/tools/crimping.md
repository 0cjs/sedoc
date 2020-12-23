Crimping Tools and Techniques
=============================

References:
- Matt Millman,
  [Common Wire-to-board, Wire-to-wire Connectors, and Crimp Tools][millman].
  Fantastic guide with many, many details.
- Gogo:Tronics,
  [Crimping Electronics Connectors (Dupont, PH, XH, VH, KF2510)][gogo].
- EEVblog, [Affordable crimp tools for small connectors (Dupont, etc.)][eev]
  Includes links to other threads at end of first post.

Terminology:
- A _wire_ consists of a _conductor_ wrapped in _insulation_.
- _Connectors_ may be male or female, and have two sets of metal tabs, the
  _insulation tabs_ at the end and the _conductor tabs_ in the middle.
  (Tabs may also be called _barrels_.)
- Crimping is done using one of the _crimp nests_ in the _crimp die_ of the
  tool. The base of the connector rests on an _anvil_ protruding up into
  the _punch_ that closes and curls the tabs. Expensive tools will have a
  _locator_ and _wire stop_ that ensure that the connector and wire are
  positioned properly. (See [this doc][63828-2000] p.4 fig. 7 for an
  example and p.2 for more terms.)
- The crimped connectors are inserted into a _shroud_, which for
  dupont-style accepts both male and female connectors.



Tools
-----

For "dupont" pins you need a longer jaw with "wrap" rather than "curl"
(F-type? M-shaped) for the insulation tabs (see "Dupont" section below).
Only such blocks are described here as appropriate for dupont, though
manufacters may state otherwise.

I use a Preciva [PR-3254][] ($40 kit.) with three blocks.  Appears no
longer to be available on amazon.co.jp.
1. (outside) XH and C3-R 2.54 mm, JST
2. (middle) Molex IDE power, ATX power, VH3.96
3. (handle) dupont 2.54 male/female

The [TZ-4228B][] (sometimes known as the SN-4228B, $20 単品, $30 kit)
appears to have a proper dupont jaw like the PR-3254, and has a fourth,
smaller jaw as well.

The IWISS [SN-025][] ($30) has round "wrap" insulation punches on all
three crimp nests in the die, and they make it clear that it's designed
for dupont-style connectors.


"Dupont" and Similar Connectors
-------------------------------

Use a proper crimping tool. For dupont it should crimp the wire tabs
with "curl-in" but the insulation tabs with "wrap-around." See above.

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
[eev]: https://www.eevblog.com/forum/reviews/affordable-crimp-tools-for-small-connectors-(dupont-etc-)/?all
[gogo]: https://sparks.gogo.co.nz/crimping/
[millman]: http://tech.mattmillman.com/info/crimpconnectors/

[63828-2000]: https://www.molex.com/pdm_docs/ats/ATS-638282000.pdf
[PR-3254]: https://www.amazon.com/dp/B07R1H3Z8X/
[SN-025]: https://www.aliexpress.com/item/1005001580094815.html
[TZ-4228B]: https://www.aliexpress.com/item/4000497324950.html
