Ghidra
======

[Ghidra][wp] ([GitHub][gh]) provides disassembly, program analysis, and
decompilation (to C) of binary programs. Almost 20 architectures are
supported, including x86 (16/32/64-bit), ARM, AVR, 68xxx, Z80 and 6502. A
[definition language][lang] permits adding more architectures and plugins
may be written in Java or Python (via Jython). Some capabilities are
[available via the command line][cmdline].

Contents:
- Installation and Startup
- Documentation
- Projects
- Usage
  - Comments
  - Labels
  - Control Flow Analysis
- Extending

Menus in the GUI are indicated with a `»` prefix, e.g., "»Edit"; "»RMB" is
the context menu. Additional ` » ` markers separate submenus and options
within dialogs.

### Review

Ghidra suffers from the typical problem of GUI tools: it's good at what it
does, but when you hit that limit you're stuck because it doesn't integrate
with anything else; all work must be done within the tool and the work is
saved in proprietary database files. (These are megabytes in size for
kilobytes of binary, though they compress around ×100. See )

Ghidra is a good tool for browsing code and annotating code, to a point,
but falls short of a full RE system in that it won't take you all the way
to creating the clearest code that explains the program. To do that you'd
need to export the disassembly in ASCII format and then do a _lot_ of work
to get that into its best source form, possibly more than with "dumber"
disassemblers.

Some examples of the issues:
- There's no way to document changes in Git (except in the comments);
  commits are always just large binary blobs. Ghidra does keeps its own
  internal history of some changes, such as label renames, though these
  can't be annotated. And the authors did seem eventually to see the need
  for revision control, so they sensibly decided to build their own new and
  inferior revision control system, incompatible with anything else, into
  Ghidra itself.
- Effectively unused labels may appear because Ghidra sees, e.g., `LD
  HL,addr` ... `INC HL`; it creates the unnecessary and undeleteable able
  label for _addr+1_ and ignores the rest of the table. (Creating an array
  doesn't fix this if you need to annotate the individual element values.)
- You can define assembler equates so that, e.g., `0xf0` becomes
  `modkey_mask` in an instruction argument, but the only way to view them
  is in a special window. They don't get exported in the ASCII assembler
  output: the only way to know what the value of that equate is there is to
  look at the accompanying hex values in the data column to the left, if
  you've included that in the output.
- Annotations are generally to assembly addresses that are assigned to a
  function. This can't be changed for uses of that address by another
  function, e.g., if the address is also the end address of a table
  belonging to the previous function where you want to load a counter using
  `LD C,tabend-tabbase`.
- The assembly output tends to be littered with C-related notes (such as
  function prototypes); Ghidra seems more focused on reverse-engineering to
  C code than working with native assembly programs.

In the [retroabandon/pc8001-re][80re] repo on branch `dev/cjs/21m18/ghidra`
you can see some sample work an 8-bit ROM. See the README there for more
details.


Installation and Startup
------------------------

Ghidra requires Java 11 and is supported on Windows, MacOS and Linux. It
uses the same "portable" installation for all OSes, with many files under a
single directory that may be placed anywhere. (It can be built as a single,
less-configurable JAR file if necessary.) The [Installation Guide][install]
gives more details.

Debian suggestion, after downloading from the [GitHub releases page][rel]:

    sudo -s
    apt-get install -y openjdk-11-jdk
    cd /opt
    umask 022
    unzip ~/Downloads/ghidra\*.zip
    exit

    #   As a regular user (PNAME.gpr file optional; must be full path):
    /opt/ghidra*/ghidraRun /???/PNAME.gpr

The distribution contains [Processor Language manual index][idx] files,
`Ghidra/Processors/*/data/manuals/*.idx`. The initial `@filename.pdf
[User-readable Manual Title]` give the filename in which to put the manual
in that same directory.

    curl http://z80.info/zip/z80cpu_um.pdf | sudo >/dev/null tee \
      /opt/ghidra*/Ghidra/Processors/Z80/data/manuals/UM0080.pdf


Documentation
-------------

- __Help ?? Contents__ brings up a new window with the manual. (This happens
  automatically the first time you run Ghidra.)
- `F1` on any menu item will bring up the documentation for that item in
  the above window.
- There is also a [Cheat Sheet][cheat].


Projects
--------

All work must be performed in the context of a _project._ When creating a new
project choose "Non-Shared Project"; shared projects are for storage on the
Ghidra server. The project name `PNAME` is used for the `PNAME.gpr` project
file and `PNAME.rep/` "repository" directory under the project directory,
which must exist but itself may have any name.

Any data to be worked on must be _imported_ (File ?? Import) into the
project, creating _programs_ that will be manipulated by _tools,_ which are
configurations of plugins. A _workspace_ is a configuration of running
tools that are visible on the desktop. (Other non-visible tools may also
still be running.)

### Project Repository

- Provides versioning of project files, but only those explicitly added to
  version control. (File not added are considered "private.")
- Server not needed; works with plain file version as well. (But only
  server can merge.)
- Files to be changed must be checked out out and in. Exclusive check-out
  (preventing other users from checking out) is required for changing a
  file's language or memory map (e.g. move/delete memory blocks).

### Archived Projects

Archived projects are a single `.gar` file which is actually a Java JAR/ZIP
that appears to contain most of the files from the unpacked format.
(Excluded are the lock files and `PNAME.rep/{projectState,project.prp}`.)

This is supposed to be compatible with different releases of Ghidra.

### Project Directory Contents

XXX Consider storing projects only in archived form, for compatibility
across all Ghidra versions.

The `.gitignore` for a project should be as follows. This assumes that PDIR
contains only a ghidra project(s); if it contains other things as well the
first `*` should probably be replaced with _PNAME._

    #   Ghidra project files
    /PDIR/*.lock
    /PDIR/*.lock~
    /PDIR/*.rep/*/~*.bak
    /PDIR/*.rep/**/tmp*.ps
    /PDIR/*.rep/projectState

The `projectState` file contains information about what windows are open
and their layout.

Project files to commit include:

    PNAME.gpr                "Project file"; give full path as command line arg
    PNAME.rep/
      project.prp
      idata/~index.dat
      user/~index.dat
      versioned/~index.dat


Usage
-----

- Key bindings for top-level- (except "Window") or context-menu items may
  be changed by hovering over the item and pressing `F4` or »Edit » Tool
  Options… » Key Bindings.)

Tables:
- Add/remove columns with right-click context menu.
- After clicking on a column to sort, sub-sort with Ctrl-click on
  additional columns.

History:
- Generally kept for all changes (comments, labels, etc.)
- Search label history with »Search » Label History….
- Search comment history from »RMB » Comments » ….

### Comments

Comments can be added to any instruction or data item with `;` (»RMB »
Comments » …).

The comment type determines how it's displayed:
- End-of-line (EOL): at right of instruction
- Pre: above instruction
- Post: below instruction
- Plate: Block header above instruction, surrounded by `*`
- Repeatable: at right of instruction if no EOL comment, and also displayed
  at the "from" address of a reference (if no EOL or repeatable comment
  there).

Addresses and labels in comments are automatically made clickable to
navigate to that target. If there are multiple matches a dialog is
displayed.

### Labels

Updated or added (depending on context) with `l` (»RMB » Edit Label… or
»RMB » Add Label…). A location may have multiple labels; the _primary_
label is displayed by default for branch targets etc. unless overridden for
that target with »RMB » Set Associated Label….

Default generated name patterns (listed below) are reserved and may not be
manually assigned. Also avoid namespace separator `::`. Labels may contain
almost any printable character besides space and are limited to 2000 chars.
Function names may be duplicated within the same namespace to support
overloading; there's no check for distinct prototypes. Namespaces may be
specified with the label name using double-colons, e.g.
`Global::foo::bar::myLabel`, or the namespace dropdown below the label name
may be used. (See below for more on namespaces.)

The automatically generated default label prefixes are as follows. These
are typically followed by underscore separated address space and numeric
address, e.g., `LAB_ram_006a`.

    EXT_    external entry point
    FUN_    there is a function at this address
    SUB_    code here has at least one "call" to it
    LAB_    there is code at this address
    DAT_    there is a data item at this address
    OFF_    "offcut" address inside an instruction or data item
    UNK_    none of the above are recognised

Default labels may not be removed unless a user-assigned label is
available; removing a user-assigned label that is a branch target will
re-generate a default label.

Label properties:
- Entry point. (Actually associated with the address, so applies to all
  labels at that address.) An "external" entry point that can be used to
  initiate execution from outside the program. Most programs have a single
  "main" entry point having the label `Entry`. Shared libraries usually
  have an entry point for each function.
- Primary: default displayed for targets (see above). If set, replaces any
  previous primary.
- Pinned: Label does not move if the memory block is moved or image base is
  changed.

Namespace types are _Global, External, Function, Class, Generic._ A Z80
import offers `Global` and `RST0` in the namespace dropdowns; the latter is
an auto-generated function label so presumably that's a function namespace.

### Control Flow Analysis

Analysis is based around _function objects_ keyed by a _function symbol_
created by designating a label to be _entry point_ (see above). The function
object is the core of the decompilation, which is generated from a control
flow analysis (of the P-code) from the entry point that follows all
branches (both sides for conditionals), as well as storing function
parameters, local variables, etc. Addresses within the middle of the
function are linked back to this function object.

Individual branches may be marked with a _flow override_ that changes how
the branch is interpreted (this relates to the P-Code :
- BRANCH override: a branch within the function, rather than a call out to
  another function.
- CALL override: target is considered not part of the function.
- CALL_RETURN override: treated as a CALL followed by a RETURN, i.e. a tail
  call optimization.
- RETURN override: indirect BRANCH or CALL is treated as a RETURN
  instruction.


Extending
---------

[SLEIGH].



<!-------------------------------------------------------------------->
[80re]: https://gitlab.com/retroabandon/pc8001-re

[cmdline]: https://htmlpreview.github.io/?https://github.com/NationalSecurityAgency/ghidra/blob/master/Ghidra/RuntimeScripts/Common/support/analyzeHeadlessREADME.html
[gh]: https://github.com/NationalSecurityAgency/ghidra
[idx]: https://github.com/NationalSecurityAgency/ghidra/blob/master/GhidraDocs/languages/manual_index.txt
[install]: https://htmlpreview.github.io/?https://github.com/NationalSecurityAgency/ghidra/blob/stable/GhidraDocs/InstallationGuide.html
[rel]: https://github.com/NationalSecurityAgency/ghidra/releases
[wp]: https://en.wikipedia.org/wiki/Ghidra

[cheat]: https://htmlpreview.github.io/?https://github.com/NationalSecurityAgency/ghidra/blob/stable/GhidraDocs/CheatSheet.html
[lang]: https://htmlpreview.github.io/?https://github.com/NationalSecurityAgency/ghidra/blob/stable/GhidraDocs/languages/index.html
[sleigh]: https://htmlpreview.github.io/?https://raw.githubusercontent.com/NationalSecurityAgency/ghidra/stable/GhidraDocs/languages/html/sleigh.html
