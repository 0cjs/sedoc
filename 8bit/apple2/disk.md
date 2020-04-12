Apple II Disk Hardware and I/O
==============================

References:
- [bad] Don Worth and Pieter Lechner, [_Beneath Apple DOS_][bad] (1981).
- [tdm] Apple Computer Inc., [_Apple II: The DOS Manual_][tdm] (1981).


Disk II Controller
------------------

See "Hardware Addresses" [bad 6-2].
Add slot number × 16 to all addresses below ($C0Ex for slot 6).

    C080  49280  s  PHASEOFF: Stepper motor phase 0 off
    C081  49281  s  PHASEON: Stepper motor phase 0 on
    C082  49282  s  PHASE1OFF
    C083  49283  s  PHASE1ON
    C084  49284  s  PHASE2OFF
    C085  49285  s  PHASE2ON
    C086  49286  s  PHASE3OFF
    C087  49287  s  PHASE3ON
    C088  49288  s  MOTOROFF: Drive motor off
    C089  49289  s  MOTORON: Drive motor on
    C08A  49290  s  DRIVE0EN: Select drive 1
    C08B  49291  s  DRIVE1EN: Select drive 2
    C08C  49292     Q6L: Strobe data latch for I/O
    C08D  49293     Q6H: Load data latch
    C08E  49294     Q7L: Prepare latch for input
    C08F  49295     Q7H: Parepare latch for output



<!-------------------------------------------------------------------->
[bad]: https://archive.org/details/Beneath_Apple_DOS_OCR/page/n2/mode/1up
[tdm]: https://archive.org/details/a2_the_DOS_Manual/page/n2/mode/1up
