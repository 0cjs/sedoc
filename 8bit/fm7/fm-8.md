Fujitsu FM-8
============

Books and References
--------------------

- [FM-8活用研究][fm8kk82] by 工学社, 1982, IO Publishing.
  - Schematics, detailed memory map (BASIC work area, ROM routines).
  - Hexdump/checksum program on p.25.
  - Lots of other good technical data.

Modifications and projects:
- [FM-8改造 備忘録 (by はせりん)][haserin]. Long list of mods, mostly for
  faster 68B09 CPU.
- [FM-8 メインCPUの高速化 HERO-09 の製作][io8210], I/O 1982-10. Switches
  main CPU between 2.457 and 4 MHz.


Switches
--------

From photographs of the manual, 1-8 are RS-232C and 9-10 are boot mode.

Corresponding to switches 1 and 2 [on the FM-7](fm-7.md),
switches 9 and 10 (external labelling) are SW2-9 and SW2-10 on [the
schematic][sch]. These both set address lines A9 and A10 (open=1, closed=0)
on the boot ROM (M16, MB8516) to select one of four 512 byte blocks and and
determine whether the upper half of memory is RAM or the F-BASIC ROM. It
appears that ROM is selected only when both switches are up, otherwise RAM
is selected.

     9 10
    UP UP   F-BASIC ROM/disk mode
    UP dn   Bubble mode
    dn UP   DOS mode
    dn dn   reserved/unused (or 8" DOS?)

裏RAM切替 (うらRAMきりかえ, "shadow RAM switch"):
- The FM-7 can software-switch the upper half of the address space between
  ROM and upper RAM by reading (→ROM) and writing (→RAM) $FD0F. The FM-8
  does not do this; instead hardware switch SW9 (ROM BASIC/DOS mode) must
  be used.
- FM-8 mods are available to do this. Some use the FM-7 method above,
  others use a different method depending on what other mods they're
  combined with. [[fm8_ura1]]


Address Map
-----------

`w`=word (2 bytes). `j`=JMP (3 bytes)

    00EF-00FE   PAINT work variables
    00DE j      JMP to BIOS entry
    01D1 j      JMP to SWI 3
    01D4 j      JMP to SWI 2
    01D7 j      JMP to SWI
    01DA j      JMP to NMI (8C83 or BC83)
    01DD j      JMP to IRQ (D5AB)
    01E0 j      JMP to FIRQ (CC57)
    0314 w      MON memory read-out address
    0316 w      MON stack save
    0730-0748   COM 0-4 subroutine jump table
    079C-AD     COM I/O routine jump table
    0800        BASIC text area start?

    9F97        output CR/LF
    9FDF        output from X until $00
    A01A        output from X length B
    AFE3        output D in hex
    AFE9        output A in hex
    D336        input char in A with wait
    D352        output A
    AFA2        MON entry point
    F2DB        BIOS entry

<!-------------------------------------------------------------------->
[fm8_ura1]: http://haserin09.la.coocan.jp/fm8_kaizo.html#FM8_URA1
[fm8kk82]: https://archive.org/details/fm-8_20220609/mode/1up
[sch]: https://gitlab.com/retroabandon/fm7re/-/tree/master/schematic

<!-- Modifications and projects -->
[haserin]: http://haserin09.la.coocan.jp/fm8_kaizo.html
[io8210]: https://archive.org/details/Io198210/page/n255/mode/2up
