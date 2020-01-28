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
