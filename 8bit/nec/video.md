NEC PC-8001/PC-8801 Video Programming
=====================================

PC-8001
-------

The RAM above the video memory, $FEB8-$FFFF, is free for scratchpad use.
(Or used by ROM?)

$0257 is CRT output routine.

[[hb68]] pp.88-

Video RAM starts at $F300 and is organized in rows of 80 character bytes
followed by 40 attribute bytes. (The first character byte cannot be used in
colour mode.) In 40-column mode only even character bytes are used.

    row char attr   row char attr   row char attr
     0  F300 F350    8  F6C0 F710   10  FA80 FAD0
     1  F378 F3C8    9  F738 F788   11  FAF8 FB48
     2  F3F0 F440    A  F7B0 F800   12  FB70 FBC0
     3  F468 F4B8    B  F828 F878   13  FBE8 FC38
     4  F4E0 F530    C  F8A0 F8F0   14  FC60 FCB0
     5  F558 F5A8    D  F918 F968   15  FCD8 FD28
     6  F5D0 F620    E  F990 F9E0   16  FD50 FDA0
     7  F648 F698    F  FA08 FA58   17  FDC8 FE18
                                    18  FE40 FE90 (-FEB7)

When a character cell is being interpreted as 2×4 graphics pixels, the bits
are encoded as:

    01 10
    02 20
    04 40
    08 80
