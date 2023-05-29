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


Solderless Breadboards
----------------------

Common sizes:
- 170 point (tiny); 400 (half-length w/power rails);
  830 (full-length w/power rails).

Protosupplies.com [Guide To Solderless Breadboards][probb] is a long and
good article. Some points:
- Contacts are steel/nickle-plated steel or phosphor bronze/copper/similar.
  - Steel is cheapier, higher resistance esp. on long power lines, loses
    spring tension quicker.
- Contact physical design:
  - Flat: Cheapest. Opening looks like two parallel lines when viewed from
    top. Minimal surface are when used w/round lead. Least strength against
    losing tension. Avoid when possible.
  - Embossed Throat: slight embossment/oval dint at opening to help guide
    lead, reduce loss of spring.
  - Fully Embossed: embossment extends down entire length of contact.
    Better strength against permanent bending etc.

### vs. Dual Row Pin Headers

[Topic on EEVblog forum.][msg2860602]

- Plug male jumper pins into female connector on the end of an IDC cable.
- Solder a breakout board with perfboard.
- Just bend the pins (90° out then down again) of a PCB-mount IDC
  socket to make it reach across the centre gap..
- Use DIP IDC connectors, e.g. CW Industries CWR-130 series. (These
  have fragile pins, so best to use in a sacrificial socket.)
- If using 26- or 40-pin IDC cable, use a Raspberry PI GPIO extension
  board for breadboards. These usually have a shrouded header 0.6" DIP
  connection to the breadboard.



Wire Wrap Materials
-------------------

- Mouser has sockets, e.g. Mouser part number 575-12343316.
- See also "Wire Wrap Sockets" discussion at [THS Google Group][THSgg].
- Standard post size is 0.025" square and 0.625" (just under 16 mm) long


Wire Wrap without Wire-wrap Sockets
-----------------------------------

Summary:
- Solder sockets to adjacent header pins
- Solder ground, Vcc, bypass caps and other never-changed connections
- Wire-wrap header pins for infrequently changed lines
- Use female-female dupont jumper cables for frequently changed lines

JuanGg [demonstrated a technique on 6502.org][jg-ww] for doing a
partially wire-wrapped board without using (expensive) wire-wrap
sockets. He soldered regular DIP sockets into perfboard with header
pins on either side of them, and then soldered the header pins and
adjacent socket pins together. (A similar technique of top wire wrap
has also been seen in production systems, such as the two "wired
wrapped cards" images of a Burroughs B7800 card seen on [this
page][b7800].)

The board is half-and-half: power and bypass caps are also soldered on
the bottom, but the logic is wired using wire-wrap between the header
pins on the top. This also makes wiring easier since you're looking at
the chips top-down instead of bottom-up.

<img src="http://forum.6502.org/download/file.php?id=9202&mode=view" width="400" alt="top side" title="top side"/>
<img src="http://forum.6502.org/download/file.php?id=9203&mode=view" width="400" alt="bottom side" title="bottom side"/>

You can also use female dupont jumper wires for connections that change
often, as pointed out in Dr Jefyll's [Throw-Together-Computer][ttc] (TTC)
6502. That's a similar idea to the above though the pins come out the
bottom (like traditional wire wrap) and he uses more permanent soldered
connections for things like data buses. He also adds headers for
daughterboards.

[b7800]: https://users.monash.edu.au/~ralphk/burroughs.html
[jg-ww]: http://forum.6502.org/viewtopic.php?f=12&t=5811&start=45#p72988
[ttc]: http://forum.6502.org/viewtopic.php?p=62120#p62120

### Notes

- For posts next to IC sockets, take care to get the tool down past
  the socket. (This may require very slightly bending the pin out.)
  Otherwise you get only one wrap on the top half of a standard post.
- Standard header pins are  11mm overall height, with 5.5 mm of
  exposed pin on the long side. This is long enough to wrap two 7-turn
  connections. (Remember there's a third soldered connection on the
  short side.) I have 15, 17 and 19 mm (overall) header pins on order
  to see how those will work out.

#### Related Techniques

- Use coloured headers for wrap pins to encode signal types coming off
  of buses, etc.
- For 74xx decoding logic sockets, use a 16-pin with 16=Vcc and 8=GND;
  you can jumper 8→7 for use with a 14-pin chip.


Wire Wrapping Technique
-----------------------

- Avoid touching wires or pins to avoid skin oils. [[wmco]]
  (Clean pins w/IPA?)
- Measure length first:
  - Insulation strip length by removal end of WW tool, bend wire there.
  - Wrap bend point around post, route to to other post, 2nd bend there.
  - Strip just a bit short of the bend to account for insulation wrap.
- Ensure both sides of the wire are at 90° from the cutter edge in the
  wire wrap tool and pull straight to avoid nicking the wire.
  direction that pulls the blade against the tool, not outward, to
  avoid breakage, if not inconvenient.)
- Stripping 20 mm (the length of the removal end of the wire wrap
  tool) seems to produce about 7 turns. This is slightly less than the
  [inch suggested by Bil Herd][yt IXvEDM-m9CE] as standard, may be
  slightly less than but gives ample room for two connections to the
  long side of an 11 mm (overall) header pin. (Standard wirewrap
  two-level protrudes .4" [[wmco]] or 10 mm, equivalant to 15 mm
  (overall) header pin.)
- First turn (or first 1/2, some sources) should be all insulation to
  avoid strain breakages. My WSU-30M (not WSU-30) should do this
  [[wmco]], but doesn't, and I can't get insulation to show in
  external wire channel. So I don't hold the wire when wrapping,
  allowing the tool to draw up a bit of tension and insulated section
  at start.
- Use very gentle pressure on the tool when wrapping, and you _must_
  let it rise naturally as you wrap. Avoid overlap!
- Removal can be done with just a few turns to loosen the wrap and
  then pulling up.

Other notes:
- For quick hacks, you can wrap the lead of a part (resistor, etc.)
  directly. This will not be reliable, however, unless the component
  has square posts (e.g., some LEDs) or you later solder those
  connections.


Protoboard Info and Techniques
------------------------------

- With plated-through boards, keep soldering iron very vertical to
  avoid accidentally filling adjacent vias.
- In general solder in and wire up (or at least tack) shorter
  components before taller ones to avoid having difficulting holding
  in shorter components when taller ones keep them well off the bench.
- For non-socket/header components, remember you can solder/wire on
  the top side as well. Wires can also go through holes to change
  sides, esp. useful for boards plugging into IC sockets. ([Picture,
  scroll down.][p74792].)
- To test during the build, use IC test clips to subtitute for
  yet-unwired connections on the board.
- To bridge pins use 30 AWG (wire wrap) wire. This is easier to bend
  in place after tacking and reduces heat transfer to adjacent pins.
  1. Solder the first pin to the board; it's important that all other
  pins to be bridged are unsoldered.
  2. Take a long piece of 30 AWG wire with a stripped end, remelt and
  insert the end. The connection doesn't have to be good, just held in
  place.
  3. Route the wire to the far end pin and only then cut the wire to
  length. Tweeze it against the pin and down against the board. This
  step may be repeated for several pins before repeating the next
  step.
  4. Solder the far end, all intermediate pins and resolder the the
  first pin.

Adjacent connected components:
- For adjacent headers:
  - Loop through each going from lowest to highest profile, tacking
    each in with an end pin, re-tacking to make sure it's fully
    inserted at both ends, and then adjusting the angle to make it
    perpendicular to the board. Once done, it may be useful to tack
    the opposite end pin.
  - After all are tacked in, bridge per above.
  - Repeat until done, then go back to the pins used to tack the
    headers of and add the bridge wire.
- Doesn't work (due to holes being too small): connect adjacent pin
  components (headers, ICs), drop a "U" of bare wire-wrap wire (or a
  bent lead) into the two holes before putting in the
  headers/sockets/whatever. May also be useful for GND/Vcc buses and
  whatever.

Component placement:
- Leave plenty of room at each end of an IC socket to be able to get
  the chip out.

### Prototype Board (Protoboard) Sizes

         PB-37       protoboard 10×24  3×7cm
         PB-46       protoboard 14×20  4×6cm
         PB-57       protoboard 18×24  5×7cm
         PB-68       protoboard 22×27  6×8cm
         PB-79       protoboard 26×31  7×9cm
         PB-812      protoboard 30×41  8×12cm
         PB-915      protoboard 34×53  9×15cm
         PB-1218     protoboard 48×65 12×18cm
         PB-1520     protoboard 57×73 15×20cm

Fujitsu FM-7 I/O card protoboard is approx 25×43 ?×? cm.:
.15" border, 10 holes, 20×2-pin connector, 13 holes;



<!-------------------------------------------------------------------->
<!-- Solderless Breadboards -->
[probb]: https://protosupplies.com/guide-to-solderless-breadboards/
[msg2860602]: https://www.eevblog.com/forum/projects/breadboards-vs-dual-row-pin-headers-(dupont-berg)/msg2860602/

<!-- Wire Wrap -->
[THSgg]: https://groups.google.com/group/tokyohackerspace>
[wmco]: http://wilsonminesco.com/6502primer/WireWrap.html
[yt IXvEDM-m9CE]: https://www.youtube.com/watch?v=IXvEDM-m9CE

<!-- Protoboards -->
[p74792]: http://forum.6502.org/viewtopic.php?f=4&t=1457#p74792

