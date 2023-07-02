Commodore Serial Bus
====================

Contents:
- Commodore Serial Bus
  - Protocol Overview
  - Device Numbers
  - Fast Mode
- Drive Commands
  - References

Reduced-cost version of IEEE-488 interface used on PETs. A.K.A:
IEC-625, "IEC serial bus," and GPIB (General Purpose Interface Bus).

Used on VIC-20, C64, TED machines, C128.
(But Plus/4 used 1551 drive on parallel interface in cartridge port.)

Docs:
- [_Commodore 64 Programmer's Reference Guide_][c64progref], p. 362 et seq.
- [_Service Manual: C64/C64C_][c64service], p. 13. Schematic and brief
  circuit theory description.
- [_Inside Commodore DOS_][c64dos]
- [Commodore bus] on Wikipedia
- [Commodore Peripheral Bus][cbmbus0] on pagetable.com and [cbmbus.git]. In
  particular, [Part 4][cbmbus4] discusses the physical layer of the serial
  bus and differences from the the IEEE-488 bus.
- [IEC disected] by the 1541-III developer. Contains chart of min/typ/max
  timings for all states.
- [How the VIC/64 Serial Bus Works][cb64] on Codebase64.org is a
  better-formatted version of part of IEC disected.
- [MKJ Serial Bus][mjk] page, w/schematic of 6526/CIA2 interface to
  connector.
- [PET and the IEEE 488 Bus (GPIB)][petieee], Osborne/McGraw-Hill, 1980.
  249 pp. Extremely detailed book on the PET and bus, from hardware to
  programs to talk to multimeters.

Theoretical maximum rate (using minimum 20 μs data hold) is 50 kpbs.
Practical max on C64 was 20 kbps because video interrupt could block
processing for up to 42 μs.

         ∪                 u
     5       1      5:D̅A̅T̅A̅  1:S̅R̅Q̅I̅N̅
         6              6:R̅E̅S̅E̅T̅
      4     2        4:C̅L̅K̅   2:GND
         3               3:A̅T̅N̅

[DIN-6 connector][din]. Pins numbered clockwise from 1 o'clock (looking
into the female jack on the computer), then pin 6 in middle. Devices must
provide their own power. All signals are true-low, open-collector w/pullups
in the C64 as below. (Schematic on p.13/PDF 17 of the [service
manual][c64service]. Also see [UWaterloo serialbus page][uwser] with
diagrams and schematic.

1. `S̅R̅Q̅I̅N̅`: "Service request"; unused on C64, C128 uses for fast xfer clock.  
   3.3 KΩ  pullup. Also on cassette port. To F̅L̅A̅G̅ (CASS RD) on CIA1.
2. `GND`
3. `A̅T̅N̅`: Held low by master when doing transfer setup.  
   1KΩ pullup. Also on user port. Output via CIA2 PA3 and inverting buffer.
4. `C̅L̅K̅`: Serial clock in/out.  
   1KΩ pullup. Output from CIA2 PA4 (CLK OUT) via inverting buffer,
   and input to CIA2 PA6 (CLK).
5. `D̅A̅T̅A̅`:  Serial data in/out.  
   1KΩ pullup. Output from CIA2 PA5 (DATA OUT) via inverting buffer
   and input to CIA2 PA7 (DATA).
6. `R̅E̅S̅E̅T̅`: Resets peripherals on bus; also computer on older C64s.

### Protocol Overview

Below: "assert" means holding low, "release" means not driving, "set"
means assert or release as per data value.

__Data Link Layer__

A _message_ is an an arbitrary number of 8-bit frames (LSB first) sent
from a _talker_ to a _listener_.

1. Init: talker asserting `C̅L̅K̅`, listener(s) asserting `D̅A̅T̅A̅`. (If no
   listeners assert `D̅A̅T̅A̅` within 256 μs, a C64 will abort with a `DEVICE
   NOT PRESENT` error.)
2. Ready to send: talker releases `C̅L̅K̅`.
3. Ready for data: listener(s) release `D̅A̅T̅A̅`; no time limit.
4. Talker asserts `C̅L̅K̅` within 200 μs or 256 μs (sources vary). If talker
   waits more than this, EOI as below.
5. Send bit: Talker sets `D̅A̅T̅A̅`, releases `C̅L̅K̅`, holds for min. 20 μs
   (theoretical) or 60 μs (C64 listener).
6. Talker asserts `C̅L̅K̅`. Repeat above step while more bits to send.
7. Frame ack: talker continues to assert `C̅L̅K̅`, listener asserts `D̅A̅T̅A̅`
   within 1000 μs or talker assumes error.
8. Repeat from initial step if not in EOI state.

EOI (End of Indicator) signals to listener last byte is coming.

1. Talker does not assert `C̅L̅K̅` within 200/256 μs of listener releasing `D̅A̅T̅A̅`.
2. Listener acks by asserting `D̅A̅T̅A̅` for >= 60 μs, then releasing.
3. Within 60 μs talker sets `D̅A̅T̅A̅` and asserts `C̅L̅K̅`, starting send of last
   byte as per last steps above.
4. After frame ack, talker and listener release `C̅L̅K̅` and `D̅A̅T̅A̅`;
   transmission over.

Becuase EOI is given before the last byte, the above mechanism can't
be used to send an empty stream. Instead, in that case at this point
the sender waits more than 512 μs (equivalent to an IEEE-488 sender
timeout) indicating "no data" and the message is over.

A potential bug in the above scheme is that with multiple receivers,
it's possible that at frame ack (step 7) a listener asserts `D̅A̅T̅A̅`,
talker asserts `C̅L̅K̅`, that listener releases `D̅A̅T̅A̅`, transmission of
the next byte starts, but then another (slow) listener asserts `D̅A̅T̅A̅`
after this but still within the 1000 μs period.

__Network Layer__

With CBM buses, there is only one _controller_, the computer itself, which
does not have an address. All other entities on the bus are _devices_ with
addresses set from 4-30 (1-3 are internal to the C64; see below) usually
using DIP switches. Each device may also have one or more secondary
addresses (which CBM calls _channels_) ranging from 0-31.

To start a message:
1. Controller (C64) asserts `A̅T̅N̅` and `C̅L̅K̅`, releases `D̅A̅T̅A̅`, becomes
   talker. (Aborts any message in progress, even though no EOI.)
2. All other devices within 1000 μs assert `D̅A̅T̅A̅`, release `C̅L̅K̅` and become
   listeners. (Now at step 1 of _message_ above.)
3. Controller/talker sends one of unlisten-all/listen/talk below, followed
   by further (device-specific?) information and other commands below.
4. All devices handshake/ack the command; only addressed device acts on it.
5. Controller releases `A̅T̅N̅`.

If controller sent talk command to device, role switch:
1. Controller releases `C̅L̅K̅`, asserts `D̅A̅T̅A̅`, becomes listener.
2. Device sees `C̅L̅K̅` released, asserts `C̅L̅K̅`, releases `D̅A̅T̅A̅`, becomes talker.
3. Controller sees `C̅L̅K̅` asserted, ready to receive.

Serial bus control codes:

    0x20|dev        Listen dev 0-30
    0x3f            Unlisten all devices
    0x40|dev        Talk dev 0-30
    0x5f            Untalk all devices
    0x60|chan       Reopen channel 0-15
    0x30|chan       Open channel 0-15
    0xf0|chan       Close channel 0-15

Typical messaging:

    LOAD "filename",8,1

            # host asserts A̅T̅N̅
    28      listen dev 8
            # host releases A̅T̅N̅
    f0      open channel 0
    ...     filename bytes
    3f      unlisten all (A̅T̅N̅ handling here as per above)
    48      talk dev 8
    60      reopen channel 0
            # listener asserts D̅A̅T̅A̅ to indicate byte accepted
            # host releases A̅T̅N̅, CLK, asserts D̅A̅T̅A̅ (bus turnaround)
            # dev 8 becomes bus master
    ...     byte data of file sent by dev 8
            # EOI, host asserts A̅T̅N̅ to become master
    5f      untalk all devices
    28      listen dev 8
    e0      close channel 0
    3f      unlisten all devs
            # host releases A̅T̅N̅

There are minimum timings for the above, e.g. between `A̅T̅N̅` and `CLK`
release. See pp. 10-11 of [IEC disected] for details.

### Device Numbers

Kernal handles 0-3 internally; never sends to bus.

    0       Keyboard
    1       Cassette
    2       RS-232 on user port (2nd cassette on PETs)
    3       Screen
    4,5     Printers
    6,7     Plotter, ?second plotter?
    8       Primary disk
    9-15    Disks
    16-30   Unknown
    31      Command to all devices

### Fast Mode

C128 queries by sending a byte in fast mode, using `S̅R̅Q̅I̅N̅` as the clock
(toggling eight times) `A̅T̅N̅` low. If device responds with a fast ack fast
mode is used until the device is requested to untalk or unlisten or reset.
The fast serial bus uses different hardware, the serial port lines of 6526
CIA 1, pin 39. (See also F̅S̅D̅I̅̅R̅ signal on MMU U7, pin 44.)


Drive Commands
--------------

Channel 15 is the command (when written) and error (when read) channel.
This can be accessed through BASIC v2.0 (on the C64, at least) via code
such as the following. Note that `INPUT#` doesn't work in BASIC's direct
mode, and so must be done in a program.

    10 OPEN 1, 8, 15            :REM Open Error/Command Channel
    20 INPUT#1, EN, ER$, TR, SC
    30 CLOSE 1
    40 PRINT "ErrNr: "; EN
    50 PRINT "Error: "; ER$
    60 PRINT "Track: "; TR
    70 PRINT "Sector:"; SC

    REM rename OLDNAME → NEWNAME
    OPEN 1,8,15,"R:NEWNAME=OLDNAME":CLOSE 1

### Error messages/codes

From [cbm2040um] p.82:

     0  OK (no error)
     1  File scratched (no error)
     2  unused range (start)
    19  unused range (end)
    20  Block header not found on disk
    ...
    74  Drive not read (8050 only)

### Useful CBM BASIC

- `GET#f,A$`: Read one character from file descriptor _f_ to `A$`.

### Commodore DOS General Operation

The DOS impelementation is split between two logical devices [[cbm2040um]]:
- The _file interface controller_ (usually implemented on a 6502)
  interfaces with the IEEE-488 or serial bus and queues jobs for the disk
  controller. It will retry several times jobs that return an error.
- The _disk controller_ takes jobs that give sector header and operation
  type, executes the operations in optimal order, and returns results to
  the file interface controller.
- These share a set of 256 byte buffers. Three are used for BAMs, variable
  space, command channel I/O and disk controller job queue.

The secondary address given to OPEN can be 0 automatically interpreted as
`LOAD`, 1 automatically interpreted as `SAVE`, 2-14 for up to five
simultaneous channels of data, and 15 for writing commands and reading
status.

Commands are ASCII, but numeric parameters are usually binary, and so
need to be sent as, e.g.,

    PRINT #1 "B-R:"2;1;4;0
    PRINT #1 "B-R:"chr$(2);chr$(1);chr$(4);chr$(0);
    PRINT #1 "B-R:"c;d;t;s

Disk Utility Command Set [[cbm2040um]] pp.47-.

    Long Command    Abbr/params         Description
    BLOCK-READ      "B-R:"ch,dr,t,s     block read
    ...
    memory-read     "M-R"adl/adh        memory read  adl=LSB adh=MSB of addr


    ch: channel (secondary address to OPEN)
    dr: drive number: 0, 1
     t: track number: 0-77
     s: 
    adl:


### References

- c64-wiki.com, [Drive command][c64w-dc]
- c64-wiki.com, [Commodore 1541 § Disk Drive Commands][c64w-1541dc]
- c64.org, [Commodore 1541 drive memory map][c64o-1541mmap]
- [[cbm2040um]] _User's Manual for CBM 5¼-inch Dual Floppy Disk Drives,_
  Commodore, 1980.
  - "Dual Drive Floppys: Model 2040—Model 4040, Model 3040—Model-8050."
  - "Appropriate for use with: Commodore Computers • Series 2001 (CBM-PET)
    • Series 3000 (CBM) • Series 4000 (PET) • Series 8000 (CBM)."



<!-------------------------------------------------------------------->
[Commodore bus]: https://en.wikipedia.org/wiki/Commodore_bus
[IEC disected]: http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
[c64dos]: https://www.pagetable.com/docs/Inside%20Commodore%20DOS.pdf
[c64progref]: https://archive.org/details/c64-programmer-ref
[c64service]: https://www.retro-kit.co.uk/user/custom/Commodore/C64/manuals/C64C_Service_Manual.pdf
[cb64]: https://codebase64.org/doku.php?id=base:how_the_vic_64_serial_bus_works
[cbmbus.git]: https://github.com/mist64/cbmbus_doc
[cbmbus0]: https://www.pagetable.com/?p=1018
[cbmbus4]: https://www.pagetable.com/?p=1135
[din]: ../../hw/din-connector.md
[mjk]: https://ist.uwaterloo.ca/~schepers/MJK/serialbus.html
[petieee]: https://archive.org/details/PET_and_the_IEEE488_Bus_1980_McGraw-Hill
[uwser]: https://ist.uwaterloo.ca/~schepers/MJK/serialbus.html

[c64o-1541mmap]: https://sta.c64.org/cbm1541mem.html
[c64w-1541dc]: https://www.c64-wiki.com/wiki/Commodore_1541#Disk_Drive_Commands
[c64w-dc]: https://www.c64-wiki.com/wiki/Drive_command
