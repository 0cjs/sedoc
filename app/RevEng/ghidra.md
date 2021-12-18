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
- Extending


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

    #   As a regular user (optionally add full path to PNAME.gpr file):
    /opt/ghidra*/ghidraRun

The distribution contains [Processor Language manual index][idx] files,
`Ghidra/Processors/*/data/manuals/*.idx`. The initial `@filename.pdf
[User-readable Manual Title]` give the filename in which to put the manual
in that same directory.

    curl http://z80.info/zip/z80cpu_um.pdf | sudo >/dev/null tee \
      /opt/ghidra*/Ghidra/Processors/Z80/data/manuals/UM0080.pdf


Documentation
-------------

- __Help » Contents__ brings up a new window with the manual. (This happens
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

Any data to be worked on must be _imported_ into the project, creating
_programs_ that will be manipulated by _tools,_ which are configurations of
plugins. A _workspace_ is a configuration of running tools that are visible
on the desktop. (Other non-visible tools may also still be running.)

### Project Repsitory

- Provides versioning of project files, but only those explicitly added to
  version control. (File not added are considered "private.")
- Server not needed; works with plain file verison as well. (But only
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

The `.gitignore` for a project should be:

    PDIR/PNAME.lock
    PDIR/PNAME.lock~
    PDIR/PNAME.rep/*/~index.bak

Project files include:

    PNAME.gpr                "Project file"; give full path as command line arg
    PNAME.rep/
      projectState
      project.prp
      idata/~index.dat
      user/~index.dat
      versioned/~index.dat


Usage
-----


- Key bindings for top-level- (except "Window") or context-menu items may
  be changed by hovering over the item and pressing `F4` or Edit » Tool
  Options... » Key Bindings.)

Tables:
- Add/remove columns with right-click context menu.
- After clicking on a column to sort, sub-sort with Ctrl-click on
  additional columns.


Extending
---------

[SLEIGH].



<!-------------------------------------------------------------------->
[cmdline]: https://htmlpreview.github.io/?https://github.com/NationalSecurityAgency/ghidra/blob/master/Ghidra/RuntimeScripts/Common/support/analyzeHeadlessREADME.html
[gh]: https://github.com/NationalSecurityAgency/ghidra
[idx]: https://github.com/NationalSecurityAgency/ghidra/blob/master/GhidraDocs/languages/manual_index.txt
[install]: https://htmlpreview.github.io/?https://github.com/NationalSecurityAgency/ghidra/blob/stable/GhidraDocs/InstallationGuide.html
[rel]: https://github.com/NationalSecurityAgency/ghidra/releases
[wp]: https://en.wikipedia.org/wiki/Ghidra


[cheat]: https://htmlpreview.github.io/?https://github.com/NationalSecurityAgency/ghidra/blob/stable/GhidraDocs/CheatSheet.html
[lang]: https://htmlpreview.github.io/?https://github.com/NationalSecurityAgency/ghidra/blob/stable/GhidraDocs/languages/index.html
[sleigh]: https://htmlpreview.github.io/?https://raw.githubusercontent.com/NationalSecurityAgency/ghidra/stable/GhidraDocs/languages/html/sleigh.html
