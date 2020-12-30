KiCad Schematic/PCB EDA
=======================

[KiCad]'s current stable release (as of 2019-12-06) is 5.1.5.


Installation
------------

The [KiCad Debian page][inst-debian] claims that `stretch-backports` has
5.1, but actually that has 5.0; 5.1 is in `stretch-backports-sloppy`:

    apt install -t stretch-backports-sloppy kicad

Versions available from Debian repos:
- Debian 9 `stretch`: 4.0.5
- Debian 9 `stretch-backports`: 5.0.2
- Debian 9 `stretch-backports-sloppy`: 5.1.6
- Debian 10 `buster`: 5.0.2
- Debian 10 `buster-backports`: 5.1.8
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

### General

Selection:
- Shift-select to add to selection.
- Click element to select. (For components a line or blank space inside the
  component.)
- Drag left to right: only components entirely inside the selection box.
- Drag right to left: all components intersecting the selection box.

Measurement and Grids:
- Measurements for the current location of the cursor are shown at the
  lower right. Even when the mouse is not snapped to the grid, these are
  shown for the nearest grid point.
- Absolute measurements (shown as 'X' and 'Y' at lower right) are always
  from the upper-left-hand corner of the page, which is the outermost grey
  rectangular box.
- A "local" origin for the 'dx'/'dy' display can be set with `Space`; this
  is snapped to the nearest grid point at time of setting.
- The grid is not used for measurement, just for aligning objects with
  other objects.
  - Change the grid spacing with `Alt-1` and `Alt-2` (values set in "View /
    Grid Settings" dialogue) or with the dropdown menu below the toolbar.
  - Set the grid origin set mode by pressing `S`. Move the cursor to snap
    to a point on an object (indicated by a cross+circle cursor) then `MB1`
    or `Enter` to set. `Esc` to exit set mode. (This will also snap to
    existing grid points, useful for grid-origin relative moves.)

### Schematic Editor

    ESC W       Mode: select, wire
    K           End line/wire/bus
    E V U F     Edit item, value, reference footprint.

### PCB Layout

- [Pcbnew Reference Manual][pcbnewref]

My keybinding changes:

        Binding
     New    Default  Function               New Binding Overrides
    ─────────────────────────────────────────────────────────────
    Ctrl-A  Ctrl-M   Move Item Exactly      (previously unused)

_Nothing_ is set by eye; the only ways to position are: to snap to a point
on the current grid, snap to a point on an object, or type in the position
in the properties (`E`). Parts snapped to a different grid than the one
currently in use will resnapped to the new grid only in the direction it's
moved and dropped, so get a part on to the correct grid by moving it
diagonally, dropping it, and then moving it back.

Traces are in segments that stay separate, so try to avoid having more than
one segment for sections of the trace that are straight, except near the
ends as noted below. In particular, it's easy to accidentally get two
segments for a short straight trace between two close pins; these are a
pain to delete if they need to be reworked. (__XXX__ "Edit / Cleanup tracks
and vias..." has a "Merge overlapping segments" option that may help with
this.)

The start point of a trace will align to either a grid point or an object
point. If the latter, the trace will extend vertically or horizontally out
from the object point until it needs to change direction, at which point a
new segment will be created extending from the (off-grid) end of the first
segment to a grid point. The "Auto track width" button, when enabled,
extends tracks using the existing width instead of the currently selected
track width.

To make traces route cleanly, it's best to have all pins centred on the
same 2.54 mm (100 mil) or 1.27 mm (50 mil) grid, and then use the next size
down (1.27 mm or 0.635 mm/25 mil) grid when running traces. (10 mil
traces run nicely between through-hole pins.) The "Auto track width" button
can also be useful. Note that pcbnew will refuse to route traces in guard
zones or off the board or in clearance zones (set with "Setup / Design
Rules."

Trace routing:
- `X` starts a trace segement; `MB1` ends current segment and starts a new
  one; `Esc` ends trace laying.. Start a new segment close to your
  destination but a bit before any final bends. This will prevent the
  previous segment from being moved and the final segment(s) can be deleted
  for fixups with minimal rerouting.
- `D` to drag a trace segment, pulling connected segments with it. Good for
  adding/moving angled parts of traces. This may create new segments if it
  adds angles.
- To "extend" extend a trace segment that's nearly at a pin, add a new
  segment connecting the pin and the end of the existing segment, which
  will start out wrongly routed, and then use drag on that new segment to
  fix the routing, which will also move the end of the other segment.

Other:
- There is a measure tool (Shift-Ctrl-M), but it's usually easier to move
  your mouse to the start point, hit space to reset the dx/dy display at
  the lower right, and then move the mouse to the end point. Remember that
  this measures only aligned (grid or object) points.

#### PCB Layers

Layers are enabled/disabled in "Setup / Layers".

- Paired layers (12), named `F.*` and `B.*`. In order towards copper:
  - `?.CrtYd`  Courtyard (off-board): physical space used by a component.
    Checked for overlap by DRC
  - `?.Fab`    Fabrication (off-board): Usu. documentation to the fab or
    assembler.
  - `?.Adhes`  Adhesive: for sticking SMT to board before soldering.
  - `?.Paste`  Solder paste mask: surface mount pads usu. appear here.
  - `?.SilkS`  Silk screen
  - `?.Mask`   Solder mask: Pads must appear here to avoid being masked.
- Copper layers (1-32).  Arbitrary names (on 2-layer, usu. `Front` and
  `Back`). Each may be of type signal, power, mixed or jumper.
- Standalone layers (2):
  - `Edge.Cuts`: Edge of board. Traces cannot cross this when routing; also
    checked by DRC in ≥5.1. The lines on this layer are also generated to
    output separately or on every layer depending on the fab.
  - `Margin`: "Edge_Cuts setback." Not used in 5.0, and maybe not 5.1
- Auxiliary layers `*.User` (4), all unused by KiCAD:
  - `Eco1.user`, `Eco2.User`: ECOs (engineering change orders)
  - `Cmts.User`, `Dwgs.User`


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
[pcbnewref]: https://docs.kicad.org/5.1/en/pcbnew/pcbnew.html

[hill]: https://github.com/sethhillbrand/kicad_templates

[File Formats]: https://kicad.org/help/file-formats/
