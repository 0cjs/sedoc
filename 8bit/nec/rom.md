ROM and BASIC
=============

Versions
--------

There are essentially six different ROM/BASIC editions, with each machine
having up to three of them. Modes are switched with a switch on the front
of the machine and indicated with a light.

    Series      Mode  Banner
    80 88        N    NEC PC-8001 BASIC Ver 1.0
    80mkII            NEC PC-8001 BASIC Ver 1.3     (©1979)
    80mkII            NEC N-80 BASIC Ver 1.0        (©1979, Enh.1982)
    80                (? N80SR-BASIC ?)
       88        V1   NEC N-88 BASIC Version 1.x
       88        V2   NEC N-88 BASIC Version 2.x
       88        V3   NEC N-88 BASIC Version 3.x

PC-8001 BASIC v1.1 is a varaiant of Microsoft Disk BASIC 4.51,
but disk I/O is not in ROM version (I think). The copyright banners are:

    PC-8001 copyright banner:   Copyright 1979 (C) by Microsoft
    PC-8001mkII N-80 banner     Enhanced 1982 by NEC
    N-80/88 copyright banner:   Copyright (C) 198n by Microsoft


After booting a DOS/Disk BASIC, a prefix banner will be printed before the
ROM banner:

    S-DOS80 Version 2.0  for N/N80-BASIC
    Copyright 1985 (C) by S.Kobayashi

Selected version information (from [8xROM] and experimentation).
The year given next to the version is the Microsoft copyright year and
indicates that it's been verified on one of my machines.

                  Release
    Machine         Year    N-BASIC N80     N88 V1  N88 V2
    ─────────────────────────────────────────────────────────────────
    PC-8001         1979    1.0
    PC-8001  (early '80s)   1.1 ⁷⁹
    PC-8001mkII     1983    1.3     1.0
    PC-8801mkII     1985    1.4             1.3
    PC-8801mkII SR  1985    1.5 ⁷⁹          1.4 ⁸¹  2.0 ⁸¹
    PC-8801mkII FR  1985                    1.5     2.1
    PC-8801mkII MR  1985                    1.5     2.1
    PC-8801mkII MA  1987                    1.9     2.3


Keyboard, Control Characters and Editing
----------------------------------------

BIOS control codes/editing keys:

    ESC Pause listing/program operation/etc.
    ^B  Move cursor to head of preceding item (roughly, word)
    ^B  (in TERM/MON/etc.) Return to BASIC
    ^C  Terminate input and return control to direct mode
    ^E  Delete to EOL
    ^G  Sound buzzer
    ^H  Destructive backspace
    ^I  Tab
    ^J  Split line
    ^K  Cursor to home (upper left corner of screen)
    ^L  Clear screen
    ^N  Move cursor to head of next item (roughly, word)
    ^R  Insert space char
    $1C →
    $1D ←
    $1E ↑
    $1F ↓

[[br01b] p.1-2 P.12]


Technical Information
---------------------

ROM/Machine-level References:
* \[hb68] [パソコンPCシリーズ 8001 6001 ハンドブック][hb68].
  PC-8001 and PC-6001 BASIC, memory maps, disk formats, peripheral lists,
  and all sorts of further technical info.
* \[techknow80] [_PC-TechKnow8000_][techknow80], システムソフト, 1982.
  Details of interfacing with hardware and ROM for assembly-language
  programmers.
* \[techknow88v1] [_PC-TechKnow8800 Vol.1_][techknow88v1],
  システムソフト, 1982.
* \[techknow88mkII] [_PC-TechKnow8800mkII_][techknow88mkII],
  システムソフト, 1985.
* \[mlhb] [_PC-8001マシン語活用ハンドブック_][mlhb], Kawamura Kiyoshi,
  秀和システムトレーデインク.株式会社, 1982-06.
  - 1: Addresses and descriptions of ROM routines (but no names). Work area.
  - 2: Detailed hardware interface descirptions.
  - 3: ROM subroutine use and cautions.
  - 4: Utility routines (type-in)
  - 5: Appendicies.

Other references:
- \[br01b] [PC-8001B N-Basic Reference Manual][br01b] (PC-8102B/PTS-069), 1981.


Extension ROMs
--------------

The PC-8001 and PC-8001mkII have a socket on the motherboard for an 2364
8K×8 ROM chip that is mapped to $6000-$7FFF. The BIOS and BASIC check for
various magic numbers:

    7FFF   1b   $55 for altnerate monitor
    7FFC   3b   alternate monitor entry point
    6002    -   extension rom init entry point
    6000   2b   extension ROM signature area: sig = "AB" ($41 $42)


- $7FFF = 55: The BASIC `mon` command jumps to $7FFC instead $7FFC instead
  of the normal monitor. (Not tested what the ML monitor entry point does.)
- $6000 = "AB": After some initialisation (and check for DOS boot?), system
  startup does `call $6002` if this signature is present. This can replace
  some BASIC commands, as described in ["Basic Extensions"](
  basic.md#basic-extensions).



<!-------------------------------------------------------------------->
[8xROM]: https://retrocomputerpeople.web.fc2.com/machines/nec/cmn_vers.html
[hb68]: https://archive.org/stream/PC8001600100160011982#page/n5/mode/1up
[mlhb]: https://archive.org/details/pc-8001
[techknow80]: https://archive.org/details/pctechknow8000
[techknow88mkII]: https://archive.org/details/pc-techknow-8801mk-ii
[techknow88v1]: https://archive.org/details/PCTechknow8801Vol.11982/

[br01b]: https://archive.org/details/pc-8001b-n-basic-reference-manual-nec-en-1981
