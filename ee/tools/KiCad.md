KiCad Schematic/PCB EDA
=======================

[KiCad]'s current stable release (as of 2019-12-06) is 5.1.5.


Installation
------------

Per the [KiCad Debian page][inst-debian], use, e.g.

    apt install -t stretch-backports kicad

Versions available from Debian repos:
- Debian 9 `stretch`: 4.0.5
- Debian 9 `stretch-backports`: 5.0.2
- Debian 10 `buster`: 5.0.2
- Debian 10 `buster-backports`: 5.1.4
- Debian unstable `sid`: 5.1.5


Templates
---------

[`sethhillbrand/kicad_templates`][hill] includes templates to start
projects with correct design rules for various fabs, including JLCPCB etc.


File Formats and Internals
--------------------------

All file types/extensions are listed on the [File Formats] page.


Usage Hints
-----------

Two selection modes:
- Drag left to right: only components entirely inside the selection box.
- Drag right to left: all components intersecting the selection box.

### Schematic Editor


    ESC W       Mode: select, wire
    K           End line/wire/bus
    E V U F     Edit item, value, reference footprint.

### PCB Layout

_Nothing_ is set by eye; the only ways to position are: to snap to a grid
or type in the position in the properties (`E`). (Exception: plain lines
may snap to ends of other lines.) Parts snapped to a different grid than
the one currently in use will resnapped to the new grid only in the
direction it's moved and dropped, so get a part on to the correct grid by
moving it diagonally, dropping it, and then moving it back.

Traces are in segments that stay separate, so try to avoid having more than
one segment for sections of the trace that are straight, except near the
ends as noted below. In particular, it's easy to accidentally get two
segments for a short straight trace between two close pins; these are a
pain to delete if they need to be reworked.

To make traces routing cleanly, make sure that _all_ pins are centred on a
2.54 mm (100 mil) or 1.27 mm (50 mil) grid, and then use the next size down
(1.27 mm or .6350 mm (25 mils)) grid when running traces. (10 mil traces
run nicely between through-hole pins.) `View / Grid Settings` will let you
two quick-switch grid settings for `Alt-1` and `Alt-2`.

__XXX__ There still seems to be an issue with the side of a trace being put
on the grid, rather than the centre; not sure why this is happening or how
to fix it.

Trace routing:
- `X` to start a trace segement; mouse button ends current segment and
  starts a new one. Start a new segment close to your destination but a bit
  before any final bends. This will prevent the previous segment from being
  moved and the final segment(s) can be deleted for fixups with minimal
  rerouting.
- `D` to drag a trace segment, pulling connected segments with it. Good for
  adding/moving angled parts of traces. This may create new segments if it
  adds angles.
- To "extend" extend a trace segment that's nearly at a pin, add a new
  segment connecting the pin and the end of the existing segment, which
  will start out wrongly routed, and then use drag on that new segment to
  fix the routing, which will also move the end of the other segment.

Other:
- There is a measure tool, but it's usually easier to move your mouse to
  the start point, hit space to reset the dx/dy display at the lower right,
  and then move the mouse to the end point.



<!-------------------------------------------------------------------->
[KiCad]: https://www.kicad-pcb.org/
[inst-debian]: https://www.kicad-pcb.org/

[hill]: https://github.com/sethhillbrand/kicad_templates

[File Formats]: https://kicad.org/help/file-formats/
