NEC PC-nnn Series
=================

- 1979: [PC-8001](8001.md): Business/games.
- 1981: [PC-6001](6001.md): Lower-end gaming; includes cartridge port.
- 1981: [PC-8801](8801.md): Moving more towards business. Separate keyboard
  on all models; integrated FDDs in models after the first.
- 1982: [PC-9801](9801.md): 16-bit, business
- 1983: mkII released for all 8-bit series
- 1985: 8-bit  mkII SRs released: end of PC-80 and focus on games for PC-88.

General references:
- \[rcp] [Retro Computer People NEC refrences][rcp]. Includes PC-2000,
  PC-6000/6600, PC-8000, PC-8200, PC-8800, PC-9800, PC-100 and others.

### Contents

PC-8x01:
- [NEC PC-8001](8001.md)
- [NEC PC-8801](8801.md)
- [N80 and N88 BASIC](basic.md)
- [PC-8001 Programs](programs.md)
- [PC-8001 Floppy Disk Format](floppy.md)
- [PC-6001/8001 Disk Interfaces](floppyif.md)
- [`D88STRUC.txt`](D88STRUC.txt): .D88/.D68/.D77/.D98 disk image file
  structure. Also see [`../floppy`](../floppy.md).

Other systems:
- [NEC PC-6001](6001.md)
- [`sd6031/`](sd6031/): Firmware for SD6031, an emulator for the external
  PC-6031 floppy disk drive unit.
- [NEC PC-9801](9801.md)

The PC-8001 (and later PC-8801) were originally developed by the Electronic
Device Group but manufactured by New Nippon Electric, later renamed NEC
Home Electronics. In 1981 the lines expanded with Home Electronics
developing the PC-6001 and Information Processing the PC-9801. They soon
had they had four lines from three different groups (Electronic Device
released the PC-100 16-bit line). In 1983-12 they consolidated down to
PC-8801, given to Home Electronics, and PC-9801, which stayed with
Information Processing. The PC-6001 and PC-100 were cancelled. (This all
from various Wikipedia articles.)


General Information
-------------------

Holding down the `STOP` key when you reset the computer will do a warm
start rather than a cold start. (Confirmed only for PC-8001.)


TransDisk (xdisk)
-----------------

The TransDisk 2 program (called `xdisk2` in filenames) is used to transfer
PC-8801 floppy images via serial from a Windows PC to a PC-8801, which
writes them.

There's a Unix version, [TransDisk 3][xdisk3]; the repo includes the source
code for the client and a reference to the xdisk2 sources. Build with `cd
pc/; make` (no special libs required) and run `./xdisk3` to see usage
notes. Running `xdisk3 b -p/dev/ttyUSB0` (exactly that spacing) will prompt
with the `LOAD "COM:N81X"` command to start on your PC-88 before downloading
the boot program.

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

Usage:
- Enter `jp $5C66` or `MON` in BASIC (suggest `WIDTH 80` before entry).
- Prompt is `*`.
- `ESC` pauses output, `STOP` aborts output.

Commands:
- Ctrl-B: Return to Basic.
- `Dx,y`: Display bytes at addrs _x_ (def. 0) through _y_ (def. x+$0F).
  Displays 8/16 bytes per line in 40/80 column mode.
- `Sx`: Display byte at _x_ and prompt for new value: must be two digits,
  or `Space` to skip. Continues with subsequent locations until `Enter`.
  Aborts with `?` message on invalid value.
- `Gx`: Goto addr _x_ (default $0000, the reset vector!).
- `Wx, y`: Write tape block from _x_ through _y_.
- `L`: Load tape block.
- `LV`: Load tape block and verify it's correctly loaded.
- `TM`: Test memory and return to Basic. Failure of this test or
  startup leaves bad addr in $FF39/3A, data written in $FF3B, and data
  read in $FF3C.

Extensions:
- If an extension ROM has $7FFF = $55, the BASIC `MON` command will jump to
  $7FFC. (Not tested what the ML entry point does.)


Terminal Mode
-------------

The `TERM` command will enter terminal mode using the RS-232C port (or
print `Illegal function call` if RS-232C is not present). On the original
PC-8001 there is an internal female jumper block CN-8 ([[hb68]] p.91) to
wire; other models have externally-accessible switches.



<!-------------------------------------------------------------------->
[5inch-cache]: https://webcache.googleusercontent.com/search?q=cache:http%3A%2F%2F5inch.floppy.jp%2Fpc88serialconnect.txt
[5inch]: http://5inch.floppy.jp/pc88serialconnect.txt
[rcp]: https://retrocomputerpeople.web.fc2.com/machines/nec/
[xdisk3]: https://github.com/bferguson3/xdisk3

