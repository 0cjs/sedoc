DOS 3.3
=======

Alternatives include Diversi-DOS and of course ProDOS.

References:
- Don Worth and Pieter Lechner, [_Beneath Apple DOS_][bad] (1981).
- Apple Computer Inc., [_Apple II: The DOS Manual_][tdm] (1981).


Memory Locations
----------------

`b`=byte, `w`=word, `v`=vector `c`=call (first byte $A5=JMP).

     3D0    976 c  DOS entry vector
     3F5   1013 c  Ampersand (&) vector
    AA60  43616 w  Last BLOAD length
    AA72  43634 w  Last BLOAD start
    AC01  44033 b  Catalog track
    B3C1  46017 b  Disk volume number
    9DBF -25153 c  Reconnect DOS (when $3D0 not available)


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
[bad 7-2]: https://archive.org/details/Beneath_Apple_DOS_OCR/page/n80/mode/1up
[bad]: https://archive.org/details/Beneath_Apple_DOS_OCR/page/n2/mode/1up
[tdm 127]: https://archive.org/details/a2_the_DOS_Manual/page/n69/mode/1up
[tdm]: https://archive.org/details/a2_the_DOS_Manual/page/n2/mode/1up
