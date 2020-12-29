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


Symbol and Footprint Libraries
------------------------------

Remember to check [File Formats] for some information on any of the files
mentioned below. The key files and formats are:
- `.lib`: file of schematic symbols
- `.dcm`: file of descriptions, aliases and keywords for schematic symbols
- `.pretty/`: footprint library (always a directory)
- `.kicad_mod`: one footprint entry in a footprint library directory

### Global and Project Library Lists

`sym-lib-table` and `fp-lib-table` are s-expr files containing a lists of
libraries. The global list is in `~/.config/kicad/`; project lists are in
the project directory. Variable `${KIPRJMOD}` in paths expands to the
project directory.

The global library lists, if they don't already exist, are created and
populated by by `eeschema` and `pcbnew` at startup. If these do not contain
common libraries a "rescue" will occur, copying symbols out of the project
cache into the project library(s). (See below.) __Warning:__ in 5.0
`eecschema` has been observed to incorrectly initialize a missing global
library list, setting it only to the current project's library even when
the standard global libraries are requested. I ended up fixing this by
wiping all my global config files, creating a new project, and then
starting `kicad` followed by `eecschema`.

### Symbol Cache and Rescue

`φ-cache.lib` in the project directory contains copies of all symbols used
in schematic `φ.sch`. This should be committed as it allows systems with
missing global libraries to recover. When opened in this situation, KiCAD's
rescue procedure will:
1. Create `φ-rescue.lib` in the project dir and add it to the project
   `sym-lib-table`.
2. Move missing symbols from `φ-cache.lib` to `φ-rescue.lib`.
3. Update symbol references in `φ.sch` to point to `φ-rescue.lib`.

`φ-cache.lib` should be committed along with the other project files
to enable recovery. (This is especially important once a project is
archived.) The `φ-rescue.lib` should not normally be committed but
instead the problem (with the user's system or the project) resolved as
below.

When a rescue occurs, the correct solution is to:
1. Quit, revert any changes, and ensure that the global libraries are set
   up correctly per above. (Manually check the global `sym-lib-table` after
   recreating it to ensure it was recreated correctly.)
2. Restart `kicad` on the project and open each schematic and drawing.
   Where a rescue still occurs, move the rescued symbols to a project-local
   library, remove the now-empty `*-rescue.lib` files and remove their
   entries from the project `sym-lib-table`.

### Library File Formats

`.lib` schematic library files are in a line-based `COMMAND args` format,
with some commands starting and ending subsections. The `DRAW` section
contains lists of `S` (line segment), `X` (labeled point) etc. sections;
the order of these lists within `DRAW` is not significant.



<!-------------------------------------------------------------------->
[KiCad]: https://www.kicad-pcb.org/
[inst-debian]: https://www.kicad-pcb.org/

[hill]: https://github.com/sethhillbrand/kicad_templates

[File Formats]: https://kicad.org/help/file-formats/
