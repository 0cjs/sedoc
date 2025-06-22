KiCad Schematic/PCB EDA
=======================

The [KiCad website][kicad] changed to `kicad.org` from `kicad-pcb.org`;
the latter now goes to a gambling site.

See [KiCad-install](./KiCad-install) for installation details.

#### Templates

[`sethhillbrand/kicad_templates`][hill] includes templates to start
projects with correct design rules for various fabs, including JLCPCB etc.


KiCad Model
-----------

[KiCad files and folders][kc-ff-9] lists all file types; [File Formats]
gives details of file contents (usually S-expressions). Common types are as
follows; `¤` indicates a global version in `~/.config/kicad/9.0/` as well
as a local version in the project.

    *.kicad_pro       Project file
    *.kicad_prl       Current preferences (visible layers, etc.)

    *.kicad_sch       Schematic file
    *.kicad_sym       Symbol library
    sym-lib-table   ¤ List of symbol libraries for symbol browser.

    *.kicad_pcb       Board file
    *.pretty/         Footprint library containing *.kicad_mod files.
    *.kicad_mod       Footprint library file (contains only a single footprint).
    fp-lib-table    ¤ List of footprint libraries for footprint browser.
    fp-info-cache     Cache to speed loading of footprint libraries.

Many files need to be ignored by Git. [KiCad.gitignore] gives suggestions,
but does not appear to be up to date. We tweak for our standard "project
subdirs in a repo" layout and use the following:

    /kicad-lib/*.bak
    /*/kicad/*-backups/
    /*/kicad/*.lck
    /*/kicad/fp-info-cache
    /*/kicad/*.kicad_prl

[kc-ff-9]: https://docs.kicad.org/9.0/en/kicad/kicad.html#kicad_files_and_folders
[KiCad.gitignore]: https://github.com/github/gitignore/blob/main/KiCad.gitignore

#### Projects

All design documents are in a _project._ My standard format is to have a
Git repo $REPO, a $PROJNAME subdir for each design, each with a `kicad/`
subdir for the KiCad files. When creating a new project, use $PROJNAME as
the project name select the `kicad/` subdir and ensure "Create a new folder
for the project" is not checked; this will create three files:

    $REPO/$PROJNAME/kicad/$PROJNAME.kicad_{pro,sch,pcb}

#### Schematics and Symbols

Designs start in the _schematic editor_ (`eeschema`), editing the
`*.kicad_sch` file. This contains one or more _sheets_ in a hierarchical
format.

On sheets we place _symbols,_ which have:
- _Pin numbers_ to be connected to _wires_ and _buses._ Pins have optional
  names as well.
- _Fields_ including Reference (e.g., 'U1'), Value (e.g. '100 μF'), Library
  Link, Library Descriptor.
- A board editor _footprint_  matches its Reference field and pin numbers
  to those of a schematic symbol.
- Symbols may have a set of standard footprint templates that can be used
  to generate a footprint to the board editor. Or any footprint can be
  linked.

Symbols are defined the schematic, but may be copies from libraries that
can be updated from those libraries. __View » Symbol Library Browser__ and
__Place » Place Symbols__ show a list of known libraries from
`sym-lib-table`  (e.g., "74xx", "Memory_EPROM") these may be expanded by
clicking ▶ to see the symbols in each library. Symbols may be in several
parts placed separately, e.g., 7400's "Unit A" through "Unit D" (NAND
gates) and "Unit E" (power).

#### Boards and Footprints

XXX


Usage Hints
-----------

### General

Movement and Selection:
- Right-click-drag to scroll; mouse wheel to zoom.
- Click element to select. (For components, line or blank space inside it.)
- Shift-select to add to selection.
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

_References_ throughout refer to a specific part on the schematic and PCB.
These must end in a number for the schematic checker to work. References
should _never_ differ between the two; to change them change the reference
in the schematic and then "Update PCB from schematic" to change it in the
PCB file. (See below regarding references on silkscreen.)

_Labels_ in Eeschema (the schematic editor) attach to lines to add them to
a net. _Symbols_ have pin numbers, which connect to footprint pin numbers,
pin names, used only for schematic design. _Footprints_ from the footprint
library are assigned to symbols just before starting the board layout.

In Pcbnew (the PCB layout editor) each footprint is created by making a
copy in the PCB file of the library footprint. Each individual part
footprint may then be edited further (particularly to add text for the
silkscreen or narrow/remove courtyards). Updates to library footprints may
be wholly or partially applied to footprints in the PCB file, optionally
overriding/dropping changes to the PCB file footprint.

Do not change PCB refs to change the silkscreen! Instead, make the
reference silk non-visible and add your preferred label as an additional
text object on the silk layer in that part's footprint in the PCB file.

### Schematic Editor

    ESC W       Mode: select, wire
    K           End line/wire/bus
    E V U F     Edit item, value, reference, footprint
    M           Move item
    Ctrl-D      Duplicate item (w/Shift to increment)

For DRC, each symbol must have a _reference_, such as `R1` or `U1` ending
in a number. For sub-components associated with main component, I use a
"sub-number" after a period, e.g., `WW_U1.1` for a wire-wrap header
associated with `U1`.

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

__Trace Routing__

For clean trace routing, pins should be on a consistent grid. Set up as
follows:
1. Place the grid origin at a round number point, such as 200,150 mm. Put
   your edge connector with pin 1 on this point. Then draw your board
   outline with appropriate (usually non-grid) offsets from this to get the
   edge connector in the right physical position on the board. Then add
   mounting holes relative to the board edge.
2. Set grid origin to pin 1 again, grid size to 2.54 mm, and place ICs and
   other major parts Drop down to a 1.27 mm grid only where necessary for
   compact placement. Place as many discrete parts (caps, resistors, etc.)
   as possible on this grid, too.
3. On 1.27 mm (50 mil) or 0.635 mm (25 mil) grids, route any 0.508 mm (20
   mil) power traces first, then 0.254 mm (10 mil) traces. The "Auto track
   width" button can also be useful during initial trace working. Small
   discrete components may be moved as necessary at this point.

0.254 mm (10 mil) traces run nicely between through-hole pins. Note that
pcbnew will refuse to route traces in guard zones or off the board or in
clearance zones (set with "Setup / Design Rules."

Trace routing commands:
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
- DRC (in ≥5.1) will confirm that traces have clearance (using the net's
  clearance value) from the _center_ of the `Edge.Cuts` line . Drawing
  traces however will disallow crossing the _edge_ of the line, so this
  line should be kept at the default narrow .0381 value, adding only 1/2
  that to the extra padding when you draw along the edge of the board.

__Other Notes__

There is a measure tool (Shift-Ctrl-M), but it's usually easier to move
your mouse to the start point, hit space to reset the dx/dy display at the
lower right, and then move the mouse to the end point. Remember that this
measures only aligned (grid or object) points.

Layout of non-schematic items.
- Hints at EE SE [How approach breadboard layout using KiCad?][se 198934]
  and [Design a veroboard/stripboard layout from an Eagle schematic][se
  5524].
- Use "Place / Footprint" to place .1" pin headers for prototype areas?

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
[File Formats]: https://dev-docs.kicad.org/en/file-formats/
[KiCad]: https://www.kicad.org/
[hill]: https://github.com/sethhillbrand/kicad_templates
[pcbnewref]: https://docs.kicad.org/5.1/en/pcbnew/pcbnew.html
[se 198934]: https://electronics.stackexchange.com/q/198934/15390
[se 5524]: https://electronics.stackexchange.com/a/256368/15390
