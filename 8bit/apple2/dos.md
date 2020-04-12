Apple II DOS 3.3
================

See [disk](disk.md) for hardware information.

Alternatives include Diversi-DOS and of course ProDOS.

References:
- [bad] Don Worth and Pieter Lechner, [_Beneath Apple DOS_][bad] (1981).
- [tdm] Apple Computer Inc., [_Apple II: The DOS Manual_][tdm] (1981).

The [Apple IIjs README][a2js] has links to further references.


Memory Locations
----------------

All addresses marked "(48K)" are for DOS relocated for a ≥48K system;
they will be different if DOS is relocated for a smaller-memory
system. See "Vector Table," [bad 5-5]; "Memory Use," [bad 5-1]. Also
see [the ROM document](rom.md) for details of the $3F0-$3FF locations.

Key: `b`=byte, `w`=word, `v`=vector (pointer); `c`=call (first byte
$A5=JMP, or complete routine), `s`=soft switch (read to trigger),
`r`=I/O input, `w`=I/O output.

     3D0    976  c  DOS entry
     3D3    979  c  DOS coldstart
     3D6    982  c  File manager subroutine
     3D9    985  c  RTWS
     3DC    988  c  Returns file manager call param table address
     3E3    991  c  Returns RTWS call param table address
     3EA   1002  c  Reconnects DOS keyboard/screen routine hooks
     3EF   1007  c  JMP to BRK handler (autostart ROM only); default monitor
     3F0-3FF        ROM locations: see ROM document
     3F2   1010  w  RESET vector; updated by DOS
    AA60  43616  w  Last BLOAD length
    AA72  43634  w  Last BLOAD start
    AC01  44033  b  Catalog track
    B3C1  46017  b  Disk volume number
    9DBF -25153  c  Reconnect DOS (when $3D0 not available)
    9600  38400  -  DOS work areas/buffers (48K)
    9D00  40192  w  Start of DOS (48K), pointer to work-area/buffer chain
                    Contains BASIC interface, command interpretation, etc.
    AAC9  43721  -  File manager (OPEN/CLOSE/etc. API)
    B600  46592  -  RWTS (Read/Write Track/Sector)
    BFFF  49151  -  Top of RAM
    C000  49152  -  Start of I/O address space

#### Buffers

DOS requires 595 bytes of work area and buffer space for each open
file and/or disk operation (e.g., `CATALOG`). Three work/buffer areas
are allocated by DOS below DOS itself, from $9600 to $9CFF on a 48K
system; the application may allocate further work/buffer areas if necessary.

The format is described at [bad 6-13]. DOS allocates these adjacent
(with the offsets given below), but they need not be. The file name
and following pointers are the root of the data structure. The start
of DOS's work-area/buffer chain is at the first two bytes of DOS
($9D00 on a 48K system).

    000 0FF  Data sector buffer
    100 1FF  Track/sector list sector buffer
    200 22C  Work area

    22D 24A  File name (30 bytes); first byte $00 if work/buffer area is free
    24B      Address of work area
    24D      Address of track/sector list sector buffer
    24F      Address of data sector buffer
    251      Address of file name of next buffer in chain ($0000 = last entry)

See [bad 6-16] for code to:
- locate a free DOS buffer
- check version of DOS
- check presence of DOS
- check which version of BASIC is selected
- see if a BASIC program is currently executing


Avoiding Language Card Reload
-----------------------------

The `STA` at $BFD3 (49107) stores a zero in the language card that
makes it test as unloaded later during the boot. After writing 3×NOP
($EA=234) starting there, diskettes you `INIT` will no longer do that
on boot, preserving what's already loaded in the language card. [bad 7-2]


File Types and Formats
----------------------

[tdm 127]

    I  Integer BASIC
    A  Applesoft BASIC
    B  Binary
    T  Text (sequential or random access)

- Both BASICs: first word is program length, followed by the tokenized program.
- Binary: starting address word, length word, binary data.
- Text: ASCII bytes (MSB set); $00 marks EOF. All-zero sectors are not
  written to disk and have track/sector 00/00 in the track/sector list
  sector.



<!-------------------------------------------------------------------->
[a2js]: https://github.com/whscullin/apple2js#readme
[bad]: https://archive.org/details/Beneath_Apple_DOS_OCR/page/n2/mode/1up
[tdm]: https://archive.org/stream/The_DOS_Manual_HQ#page/n3/mode/1up

[bad 5-1]: https://archive.org/details/Beneath_Apple_DOS_OCR/page/n53/mode/1up
[bad 6-13]: https://archive.org/details/Beneath_Apple_DOS_OCR/page/n73/mode/1up
[bad 6-2]: https://archive.org/details/Beneath_Apple_DOS_OCR/page/n62/mode/1up
[bad 7-2]: https://archive.org/details/Beneath_Apple_DOS_OCR/page/n80/mode/1up

[tdm 127]: https://archive.org/stream/The_DOS_Manual_HQ#page/n138/mode/1up
