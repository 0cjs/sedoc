FM-7 Machine Language
=====================

_SS:n-m_ references refer to section-page numbers in the [富士通 FM-7
ユーザーズマニュアル システム仕様][fm7sysspec].

Typing `MON` in BASIC will drop to a monitor, prompt `*`. Break key,
Ctrl-C or Ctrl-X will exit back to BASIC.

Commands below determined through experimentation and from p. 3-35 of
the BASIC manual. All take a following hex address _nnnn_ (unless
otherwise specified), which defaults to last-used/printed location
plus 1 if not supplied.

- `D`: Hex dump of 64 bytes (8 per row) from address _nnnn_.
- `G`: Branch to address `nnnn`. Uses current PC if no argument given.
  An `RTS` will return to BASIC (maybe with error). Maybe same as `EXEC`?
- `M`: Modify memory. Prints address and old value; type in new value
  or _Enter_ to leave it the same. Exit deposit mode with any invalid
  character (such as `x` or `.`) to trigger an error.
- `R`: Modify registers (`CC`, `A`, `B` `DP` `X`, `Y`, `U`, `PC`).
  Takes no argument. Old/new/exit as with `M`.

The monitor entry point is $ABF9 (this is the default `PC` when first
entering the monitor as well). `JMP $ABF9` to return to the monitor
after a `G` command to avoid problems with `RTS` causing errors in
BASIC.


Memory Map
----------

SS:1-6 gives both main processor and sub-processor memory maps.

    $0000 - $7FFF   RAM
    $8000 - $FBFF   RAM or BASIC ROM
    $FC00 - $FC7F   RAM
    $FC80 - $FCFF   Shared RAM (with sub-CPU)
    $FD00 - $FDFF   I/O area
    $FE00 - $FFDF   Boot ROM (1 of 2, depending on switch settings)
    $FFE0 - $FFEF   RAM?
    $FFF0 - $FFFF   Vector area

It's not clear what's going on with the 16-byte "pre-vector" area
($FFE0) and the 16-byte vector area ($FFEF). These may not be mapped
in by ROM. The meory block diagram (SS:1-15) indicates that ROM
extends to $FFE0 (a misprint, I think; it must be one less) and that
$FFE0-$FFFD go through an address multiplexer to RAM. The reset vector
$FFFE/F is detected by an address decoder that detects it and triggers
a "reset vector 発生回路" (generation circuit) that I guess dumps the
reset vector on the data bus.


I/O Map
-------

See SS:1-8 _et seq._ After the basic map tables, extensive details are
given.

    $FD00           Read Bit 0: 0=1.2 MHz, 1=2 MHz clock
                         Bit 7: "D8"
                    Write: printer strobe, etc.
    $FD01           Read: keyboard D0-7. Write: Printer D0-7 output.
    $FD02           CMT/printer (read); Device IRQ mask bits (write)
    $FD03           Device IRQ status bits (read); Buzzer (write)
    $FD04           Subproc FIRQ status (see "Interrupts" below)
    $FD05           Read: Subproc/expansion status
                    Write: Z80-related halt/cancel/wait
    $FD06 - $FD07   RS-232C option
    ...
    $FD0D - $FD0E   PSG (programmable sound generator)
    $FD0F           Bank mode: read for ROM, write for RAM. (SS:1-25)
    $FD10           Boot ROM Switch
    $FD18 - $FD1F   Mini-floppy; see [floppy.md]
    $FD20 - $FD23   Kanji ROM
    $FD24 - $FD36   Unused
    $FD37 - $FD3F   Graphics-related stuff

`$FD03`: bits 5-1 unused
  - 7: Continuous buzzer; 0=off 1=on
  - 6: Momentary buzzer; 0=off 1=on
  - 0: Speaker; 0=on, 1=off

`$FD05`: bits 6-1 unused
  - 7: appears to to be 0=busy=/1=ready status for the sub-processor.
  - 0: "EXTDET" 0=present, 1=absent

`$FD10`: (Unverified) Writing $00 to the Boot ROM Switch maps the two
boot ROM banks to $7800-$79FF and $7A00-$7BFF; writing $02 to it
unmaps them.


Interrupts
----------

### FIRQ

The BREAK key directly generates an FIRQ. The display subsystem
interrupts for interval timers, clocks, PF keys, etc. (SS:1-28) The
$FD04 sub-interface FIRQ register indicates the source of such
interrupts (SS:1-8):

       bit 0  ATENT: 0=present 1=absent
       bit 1  BREAK key: 0=on, 1=off
    bits 7…2  unused


BIOS Usage
----------

(SS:2-1) BIOS calls use an 8-byte RCB (Request Control Block) for
parameters and return values. After setting up the RCB, load its
address into `X` index register and `JSR [$FBFA]`. Call returns with
carry clear on success (possibly with updates to RCB); on error carry
is set and the RCB status byte has the error code.

The RCB is always eight bytes long, though not all eight are always
used. Byte 0 is always the request number, `RQNO` and byte 1 the error
status return, `RCBSTA`. Additional bytes are parameters that vary by
call.

#### BIOS Requests

Request numbers are $00-$1B; some are unused but reserved. Useful ones
include:

- $05 `SCREEN`

- $08 `RESTOR`: Make selected drive seek to track 0. Parameters:
  - 7 `RCBUNT`: Drive (0-3)

- $09 `DWRITE`: Write the given block of data (256 bytes) to a sector
  on disk. Parameters:
  - 2,3 `RCBDBA`: Data buffer address
  - 4 `RCBTRK`: Track number (0-39)
  - 5 `RCBSCT`: Sector number (1-16)
  - 6 `RCBSID`: Side (0, 1)
  - 7 `RCBUNT`: Drive (0-3)

- $0A `DREAD`: Read a sector (256 bytes) from the disk, and write it
  at the given address. Parameters same as `DWRITE`.

- $0C `BEEPON`: Start sounding buzzer. No additional parameters.
- $0D `BEEPOFF`: Stop sounding buzzer. No additional parameters.

- $10 `SUBOUT`: Send command or data to display subsystem.
- $11 `SUBIN`: Receive data from display/keyboard(?) subsystem.

- $12 `INPUT`
- $13 `INPUTC`
- $14 `OUTPUT`: Display bytes on the screen. Parameters:
  - 2,3 `RCBDBA`: Data buffer
  - 4,5 `RCBLNH`: Length

- $15 `KEYIN`
- $16 `KANJIR`
- $18 `BIINIT`

#### Error Codes

(SS:2-19)

    BIOS System:
       1  RCB error
       2  Device Unavailable
    Floppy Disk:
      10  Drive not ready
      11  Disk write protected
      12  Hardware error (seek, lost data, record not found)
      13  CRC error
      14  DD (deleted data) mark found
      15  Timeout
    Printer/CMT:
      50  Paper empty
      51  Printer not ready
      52  Audio cassette error
    Subsystem:
      60  INIT command parameter error
      61  Console co-ordinate (座標) error
      62  ??? (bad data of some sort; bad character?)
      63  Graphic co-ordinate (座標) error
      64  Unusable function code or ???
      65  ???
      66  ??? (bad character number?)
      67  ??? (bad color?)
      68  Function key number error
      69  Parameter error
      70  Command error



<!-------------------------------------------------------------------->
[fm7sysspec]: https://archive.org/details/FM7SystemSpecifications
