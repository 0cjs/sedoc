Soldering
=========

- On protoboard especially, but also with edge connectors, use tape to mask
  off traces/holes that should remain solder-free. (Clean with IPA after.)
- [JRE] suggests 0.5 mm solder. I've been using 0.8 ok, but I'd
  definitely not want to go larger.
- Thoroughly tin tip, leaving lots of solder on it, before first use
  and before putting iron back in stand. Wipe when removing from
  stand. [jre-sol05]
- For conical tip, use edge in preference to point (where room) for
  better heat transfer.
- Primary heat transfer is _through solder_. Use blob of fresh solder
  on tip to help heat transfer, but not to solder the work. Solder
  bonding the work should be melted on the work itself, not on the iron.
- Generally no need to remove solder from holes when re-soldering;
  just cut off device and remove pins. [jre-sol09]
- Good info on tip construction and life in HakkoUSA Knowledge Base article
  [How to Maximize Soldering Iron Tip Life][hkb-10322].

Desoldering ([jre-sol10]):
- Iron:
  - Raise rather than slide iron when done to help avoid lifiting pads.
  - Lots and lots of flux!
  - For removing solder alone (no part), clean tip, add flux to solder,
    touch tip to  touch to solder; after it melts some will come away with
    the iron when you lift it off.
  - On pins, add flux and solder first to help with heat transfer and
    remove oxidization.
  - For multi-pin parts, place a thick copper wire along the pins, flux and
    solder all the pins to it, then heat the wire by running wide tip along
    it to loosen all pins simultaneously. Wire can be taped (w/kapton tape)
    to board to keep it in place if necessary. [MrSolderFix][msf]
  - For xformers etc. w/sidely separated pins, two separate wires and two
    irons, one to heat each.
  - For SMD discrete parts add solder to get big blobs on both ends so you
    can then touch/melt both at once with the iron. Put solder on iron tip
    for heat xfer before removing part.
- Desoldering braid:
  - Put a little flux on the braid to help with desoldering (bigclive.com).
  - Sliding braid across pads may remove pads, or may be better if you're
    doing it because you're maintaining heat with the iron until the braid
    is away, avoiding braid gettin stuck to traces.
- Solder sucker (not as good as braid):
  - Clean solder sucker tip after every suck.
  - Notch the tip (just one side) of a solder sucker to let it get closer
    to a PCB hole while still leaving space for the soldering iron to get in.

Heat shrink can also be shrunk by rubbing the shank of the soldering
iron against it (not too slowly).

Aluminum cannot be soldered without [very special techniques][Al]: Al
immediately reacts with atmospheric oxygen to form a very tough, strongly
bound oxide layer a few atoms thick. (Anodising forms a similar, thicker
layer.) Even within a joint, oxide can also form over time via oxygen
diffusing through the metal around the joint, so what looks like a good
joint initially may entirely detach after a few weeks.

Stainless steel also tends to reject solder (using standard flux), and so
stainless steel dentist's picks can be helpful for cleaning out
through-holes in boards when desoldering.


Soldering Iron
--------------

[Goot PX-201], 70 W temperature controlled. Tip base is ∅7mm × 37.

                     R      Style
    ●PX-2RT-SB      0.3     conical
    ●PX-2RT-B       0.5     conical             standard tip/w PX-201
    ●PX-2RT-BC      1.0     45° conic section
     PX-2RT-2C
     PX-2RT-3C
     PX-2RT-4C
     PX-2RT-5C
     PX-2RT-1.6D
    ●PX-2RT-2.4D    2.4     chisel
     PX-2RT-3.2D
     PX-2RT-4D
     PX-2RT-5D
     PX-2RT-5K

The above came off a shop inventory listing; there are more on the
[Goot site][goot px-201].

Other suggestions I've seen:
- Hakko FX-888D is very standard.
- [KSGER T12]: Hakko-compatible tips.
- Anesty ZD-915 vacuum desoldering unit; cheap and works well.



<!-------------------------------------------------------------------->
[Al]: https://users.monash.edu.au/~ralphk/solder-aluminium.html
[hkb-10322]: https://kb.hakkousa.com/Knowledgebase/10322/How-to-Maximize-Soldering-Iron-Tip-Life
[jre-sol05]: https://josepheoff.github.io/posts/howtosolder-5getstarted
[jre-sol09]: https://josepheoff.github.io/posts/howtosolder-9throughhole-remove
[jre-sol10]: https://josepheoff.github.io/posts/howtosolder-10soldersucker
[jre]: https://josepheoff.github.io/posts/howtosolder-toc
[msf]: https://youtu.be/Vou2xlJkuoU

[goot px-201]: http://en.goot.jp/products/detail/px_201
[KSGER T12]: https://www.amazon.com/dp/B07PMZGPQQ

