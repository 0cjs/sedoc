ROM and BASIC
=============


Versions
--------

There are essentially six different ROM/BASIC editions, with each machine
having up to three of them. Modes are switched with a switch on the front
of the machine and indicated with a light.

    Series      Mode  Banner
    80 88        N    NEC PC-8001 BASIC Ver 1.0
    80                (? N80-BASIC ?)
    80                (? N80SR-BASIC ?)
       88        V1   NEC N-88 BASIC Version 1.x
       88        V2   NEC N-88 BASIC Version 2.x
       88        V3   NEC N-88 BASIC Version 3.x

PC-8001 BASIC v1.1 is a varaiant of Microsoft Disk BASIC 4.51,
but disk I/O is not in ROM version (I think). The copyright banners are:

    N-88 copyright banner:      Copyright (C) 198n by Microsoft
    PC-8001 copyright banner:   Copyright 1979 (C) by Microsoft

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


Technical Information
---------------------

ROM/Machine-level References:
- \[hb68] [パソコンPCシリーズ 8001 6001 ハンドブック][hb68].
  PC-8001 and PC-6001 BASIC, memory maps, disk formats, peripheral lists,
  and all sorts of further technical info.
- \[techknow80] [_PC-TechKnow8000_][techknow80], システムソフト, 1982.
  Details of interfacing with hardware and ROM for assembly-language
  programmers.
- \[techknow88v1] [_PC-TechKnow8800 Vol.1_][techknow88v1],
  システムソフト, 1982.
- \[techknow88mkII] [_PC-TechKnow8800mkII_][techknow88mkII],
  システムソフト, 1985.



<!-------------------------------------------------------------------->
[8xROM]: https://retrocomputerpeople.web.fc2.com/machines/nec/cmn_vers.html
[hb68]: https://archive.org/stream/PC8001600100160011982#page/n5/mode/1up
[techknow80]: https://archive.org/details/pctechknow8000
[techknow88mkII]: https://archive.org/details/pc-techknow-8801mk-ii
[techknow88v1]: https://archive.org/details/PCTechknow8801Vol.11982/
