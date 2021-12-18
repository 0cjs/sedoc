Ghidra
======

[Ghidra][wp] ([GitHub][gh]) provides disassembly, program analysis, and
decompilation (to C) of binary programs. Almost 20 architectures are
supported, including x86 (16/32/64-bit), ARM, AVR, 68xxx, Z80 and 6502. A
[definition language][lang] permits adding more architectures and plugins
may be written in Java or Python (via Jython). Some capabilities are
[available via the command line][cmdline].



Installation and Startup
------------------------

Ghidra requires Java 11 and is supported on Windows, MacOS and Linux. It
uses the same "portable" installation for all OSes, with many files under a
single directory that may be placed anywhere. (It can be built as a single,
less-configurable JAR file if necessary.) The [Installation Guide][install]
gives more details.

Debian suggestion, after downloading from the [GitHub releases page][rel]:

    sudo -s
    apt-get install openjdk-11-jdk
    cd /opt
    unzip ~/Downloads/ghidra\*.zip
    exit

    #   As a regular user:
    /opt/ghidra_10.0.4_PUBLIC/ghidraRun

The distribution contains [Processor Language manual index][idx] files,
`Ghidra/Processors/*/data/manuals/*.idx`. The initial `@filename.pdf
[User-readable Manual Title]` give the filename in which to put the manual
in that same directory.

    curl http://z80.info/zip/z80cpu_um.pdf | sudo >/dev/null tee \
      /opt/ghidra_10.0.4_PUBLIC/Ghidra/Processors/Z80/data/manuals/UM0080.pdf


Usage
-----

The first time you start the application a second window with the manual
will open. There is also a [Cheat Sheet][cheat].
I²C

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
