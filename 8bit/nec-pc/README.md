NEC PC-nnn Series
=================

- 1979: [PC-8001](8001.md): Business/games.
- 1981: [PC-6001](6001.md): Lower-end gaming; includes cartridge port.
- 1981: [PC-8801](8801.md): Moving more towards business. Separate keyboard
  on all models; integrated FDDs in models after the first.
- 1982: [PC-9801](9801.md): 16-bit, business
- 1983: mkII released for all 8-bit series
- 1985: 8-bit  mkII SRs released: end of PC-80 and focus on games for PC-88.

### Contents

PC-8x01:
- [NEC PC-8001](8001.md)
- [NEC PC-8801](8801.md)
- [N80 and N88 BASIC](basic.md)
- [PC-8001 Programs](programs.md)
- [PC-8001 Floppy Disk Format](floppy.md)
- [PC-6001/8001 Disk Interfaces](floppyif.md)

Other systems:
- [NEC PC-6001](6001.md)
- [`sd6031/`](sd6031/): Firmware for SD6031, an emulator for the external
  PC-6031 floppy disk drive unit.
- [NEC PC-9801](9801.md)


TransDisk (xdisk)
-----------------

The TransDisk 2 program (called `xdisk2` in filenames) is used to transfer
PC-8801 floppy images via serial from a Windows PC to a PC-8801, which
writes them.

There's a Unix version, [TransDisk 3][xdisk3]; the repo includes the source
code for the client and a reference to the xdisk2 sources.

### SR Patch

A client program patch is required for some of the early 4 MHz models (SR,
TR and earlier, but perhaps not MR), as described at [[5inch]], which also
includes good general instructions for doing the transfers. If it fails to
sync, press `STOP` and patch as follows. You may still need to retry sync
several times after this.

    POKE & HC068,0
    POKE & HC069,0
    POKE & HC06A,0
    POKE & HC06F, 7
    A = USR(0)          :REM start program again


Machine-language Monitor
------------------------

Enter from Basic with `MON` command. Prompt is `*`. `ESC` pauses output.

- `Dx,y`: Display bytes at addrs _x_ (def. 0) to _y_ (def. x+$10).
- `Sx`: Display byte at _x_ and prompt for new value;
  continue with next addr until no value entered.
- `G x`: Goto addr _x_.
- `W x, y`: Write tape block from _x_ to _y_.
- `L`: Load tape block.
- `LV`: Load tape block and verify it's correctly loaded.
- `TM`: Test memory and return to Basic.
- Ctrl-B: Return to Basic.



<!-------------------------------------------------------------------->
[5inch]: http://5inch.floppy.jp/pc88serialconnect.txt
[5inch-cache]: https://webcache.googleusercontent.com/search?q=cache:http%3A%2F%2F5inch.floppy.jp%2Fpc88serialconnect.txt
[xdisk3]: https://github.com/bferguson3/xdisk3
