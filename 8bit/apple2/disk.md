Apple II Disk Hardware and I/O
==============================

References:
- [bad] Don Worth and Pieter Lechner, [_Beneath Apple DOS_][bad] (1981).
- [tdm] Apple Computer Inc., [_Apple II: The DOS Manual_][tdm] (1981).


Disk II Controller
------------------

### I/O Addresses

"Hardware Addresses" [bad 6-2]. I/O addresses are $C080 - $C08F for
slot 0; add slot number × 16 for other slots. Typically done by
loading X with slot number << 4 and using `$C080,X` addressing mode.
Addresses below are hardcoded for slot 6.

    C0E0  49280  s  PHASEOFF: Stepper motor phase 0 off
    C0E1  49281  s  PHASEON: Stepper motor phase 0 on
    C0E2  49282  s  PHASE1OFF
    C0E3  49283  s  PHASE1ON
    C0E4  49284  s  PHASE2OFF
    C0E5  49285  s  PHASE2ON
    C0E6  49286  s  PHASE3OFF
    C0E7  49287  s  PHASE3ON
    C0E8  49288  s  MOTOROFF: Drive motor off
    C0E9  49289  s  MOTORON: Drive motor on
    C0EA  49290  s  DRIVE0EN: Select drive 1
    C0EB  49291  s  DRIVE1EN: Select drive 2
    C0EC  49292     Q6L: Strobe data latch for I/O  (P6A A2 low)
    C0ED  49293     Q6H: Load data latch            (P6A A2 high)
    C0EE  49294     Q7L: Prepare latch for input    (P6A A3 low)
    C0EF  49295     Q7H: Parepare latch for output  (P6A A3 high)



<!-------------------------------------------------------------------->
[bad]: https://archive.org/details/Beneath_Apple_DOS_OCR/page/n2/mode/1up
[tdm]: https://archive.org/stream/The_DOS_Manual_HQ#page/n3/mode/1up
[bad 6-2]: https://archive.org/stream/Beneath_Apple_DOS_OCR#page/n62/mode/1up
