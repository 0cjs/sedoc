MSX ROM
=======

Contents:
- Memory Map
- Startup
- Interrupts
- Hooks

### References

(See also the references at the top of [README](README.md).)

- \[td1] [_MSX Technical Data Book_][td1], Sony, 1984.
- \[qest] [_MSX BIOS: The Complete MSX BASIC I/O Listing,_][msxbios],
  Qest Publishing, 1985-01 (Steven M. Ting).
  BIOS only ($0000-$267F); no BASIC.
- \[msxsyssrc] Sourceforge, [msxsyssrc]: MSX system sourcefiles
  (commented disassembly)
- \[rbr.6] [6. ROM BIOS][rbr.6], _The Revised MSX Red Book._
  Very comprehensive, includes some disassembly info.
- \[rbr.8] [8. Memory Usage Map][rbr.8], _The Revised MSX Red Book._


Slot Descriptors
----------------

A slot descriptor (in these documents, _slotdesc_) is as 8-bit value used
to describe a slot configuration.

    bit     76543201
    value   FxxxSSPP
            │   │ └── primary slot number 0-3
            │   └──── secondary slot number 0-3, or `xx` if not specified
            └──────── 1 if secondary slot specified


Memory Map
----------

    F380-FFFF  3200b  BIOS work area
    F1C9-F37F   439b  Disk communication area (fixed)
    HIMEM             Disk work area
                      BASIC work area (see bastech.md)
    BOTTOM            [usu. $8000] $00 byte before start of BASIC text
    01B6-7FFF         Main BIOS and BASIC (always slot 0 or 0-0)
    0000        438b  Jumps to main BIOS routines

#### System Variables and Work Area

Additiona References:
- MSX Wiki, [System variables and work area][mw sysvars].
- \[map sysvars] MSX Assembly Page, [MSX sysvars Calls][map sysvars]

BIOS/BASIC (more also in [`bastech.md`](bastech.md)):

    FD09 128b SLTWRK    Work area words for owners of each slot/page
                        offset = 32*prislot# + 4*expslot# + page ([td2] §7.2.3)
    FCC9 64b  SLTATR    Slot page attribute table
                        offset = 16*prislot# + 4*expslot# + page ([td2] §7.2.3)
                           b7=1 BASIC text present
                           b6=1 expansion device driver present
                           b5=1 expanded statements processor present
                           b4-0 unused
    FCC8  1b        +3  Saved state of the four expansion slot registers
    FCC7  1b        +2  for each expanded slot.
    FCC6  1b        +1      b7-6:page 3   b5-4:page 2
    FCC5  1b  SLTTBL+0      b3-2:page 1   b1-0:page 0
    FCC4  1b        +3  slot 3: Each slot entry
    FCC3  1b        +2  slot 2    bit 7: 1=expanded 0=not
    FCC2  1b        +1  slot 1    bits 6-0: always 0
    FCC1  1b  EXPTBL+0  slot 0: also main BIOS-ROM slot address.
    FCB0  1b  OLDSCR    old screen mode
    FCAF  1b  SCRMOD    current screen mode

MSX-DOS and Disk BASIC (only when DiskROM present):

    F37D                MSX disk BASIC system call addr; func. in C register
                        (See [td1] §3.6 p.267 for data and functions.)
    F348  1b  MASTER    main DiskROM slot address
    F344  1b  RAMAD3    slotdesc of RAM in page 3 (DOS/BASIC)
    F343  1b  RAMAD2    slotdesc of RAM in page 2 (DOS/BASIC)
    F342  1b  RAMAD1    slotdesc of RAM in page 1 (DOS)
    F341  1b  RAMAD0    slotdesc of RAM in page 0 (DOS)
    F30F  4b  KANJTABLE copy of CHAR_16


Startup
-------

On boot the BIOS and BASIC will initialise the system, find RAM to map to
pages 3 and 4, and search for additional ROM ("Sub-ROM") for expansion
devices. Each primary slot and its expanded slots (if present) are scanned
in order, first for RAM and then for ROM. ([[td1]] p.162)
1. Scan at $8000, $C000 and, if the $C000 scan failed, $E000 (to support 8K
   systems) to detect RAM, mapping in the first RAM that it finds for each
   page.
2. Scan at page 1 ($4000) and 2 ($8000) for a cartridge ROM header ($A1A2,
   ASCII `AB`; see below). If present and `INIT` is not $0000, the ROM is
   mapped into its page and `INIT` is called. Note that ROM routines may be
   called multiple times in different locations if the ROM is not fully
   decoded (i.e., mirrored), such as openMSX does with 16K ROMs.

If no program cartridge takes over from `INIT`, Disk BASIC or BASIC will be
started. ([[td1]] p.255)
- The disk ROM checks `H.STKE` after allocating all buffers; if it's not
  $C9 (`ret`) it assumes a ROM cartridge wants control at this point, sets
  up the Disk BASIC environment, and does a `jmp` to the hook.
- If a cartridge BASIC program (`STATEMENT`) is present, it will be
  executed, otherwise the system will go to the BASIC prompt.
- Track 0 sector 0 can be read, it is read to $C000-$C0FF. If this succeeds
  and the first byte of the sector is $EB or $E9, it calls $C01E with carry
  set. (XXX fill in the rest here from [[td1]] at some point.)

To run cartridge code again after initialisation is complete (e.g., to have
disk support), do one of:
- Replace `H.STKE` hook with your code during `INIT`. `H.STKE` is at $FEDA
  and has five bytes available; see "Hooks" below for more info. (I've seen
  `H.CLEA` also used, but that's not documented in [[td1]].)
- Use a cartridge BASIC program (`STATEMENT`) that calls machine language
  following it: `10 DEFUSR=&h8024:?USR(0)`
- See MSX Wiki [Create a ROM with disks support] for examples.

### ROM Header

A primary/expanded slot page containing ROM may contain a header the BIOS
will use on startup to initialise the cartridge's functionality. The
offsets from the start of the page and their values are below. All unused
and reserved values must be set to $0000. Only `INIT` is called at startup.

Note that ROM routines may be called multiple times in different locations
if the ROM is not fully decoded (i.e., mirrored), such as openMSX does with
16K ROMs.

- `$00 ID`: ROM signature; $4142 (ASCII `AB`)
- `$02 INIT`: Hardware/memory initialisation routine ($0000 = not present);
  called by Main-BIOS on system startup after the RAM scan. C register
  contains slot number in standard BIOS form `F000SSPP` (F=1 if secondary
  slot `SS` is specified; `PP`=primary slot). See [[cr init]] for enabling
  the other slot with 32K ROM carts. Application cartridges may take over
  the system when this is called or `ret` to continue standard startup.
- `$04 STATEMENT`: MSX-BASIC `CALL` invokes this to find functionality
  added to BASIC. ($0000 = not present.) Routine must be in page 1. See
  [[td1]] p.163 and [[cr statement]] for details.
- `$06 DEVICE`: Routine to control a device built into the cartridge;
  called by BASIC when it encounters an unknown device name in `OPEN`.
  ($0000 = not present.) Routine must be in page 1. See [[cr device]] for
  details.
- `$08` TEXT: Pointer to start address of tokenized BASIC program ($0000 =
  not present). This must point to a leading $00 byte before the initial
  line pointer, i.e., `TXTTAB`-1. If present, must be in page 1
  ($8000-$BFFF). System sets `BASROM` when running this and disables
  Ctrl-STOP (XXX confirm this). See [[cr text]] for a technique to shift
  RAM BASIC text past the header and create a ROM image file for this.
- `$0A`-`$0F`: 6 bytes reserved for future use.

Additional References:
- [[td1]] p.162-164
- MSX Wiki, [Develop a program in cartridge ROM][cr].


Interrupts
----------

NMI is unused by the ROM, but a RAM hook is provided. It cannot be used
under MSX-DOS because the entry vector $66 is used for DOS FCB data.

INT can be generated by cartridges and the VDP. ROM configures the VDP to
supply 60 Hz interrupts (50 Hz on PAL systems). Keyboard scan is part of
this interrupt processing.


Hooks
-----

$FD9A-$FFC9 ([[td1]] p.147-160) contains a sequence of 5-byte entries for
hooks to modify/override BIOS and BASIC behaviour. These are `call`ed from
ROM at appropriate points. Unused hooks are initialised to 5× $C9 `ret`
instructions at startup.

[[td1]] p.166 gives an example of setup for a cross-slot call:

    HOOKxx: RST 6                   ; $0030 CALLF
            DB <slot-address>       ; FxxxSSPP
            DW <memory-address>
            RET

Summary of hooks:

    Key: [c]: to support other console devices

    addr  name    called at/in
    ────────────────────────────────────────────────────────────────────
    FD9A  H.KEYI  start of int handler (used for RS-232, etc.)
    FD9F  H.TIMI  timer int handler
    FDA4  H.CHPU  [c] start of CHPUT
    FDA9  H.DSPC  [c] start of DSPCSR (display cursor)
    FDAE  H.ERAC  [c] start of ERACSR (erase cursor)
    FDB3  H.DSPF  [c] start of DSPFNK (display function key)
    FDB8  H.ERAF  [c] start of ERAFNK (erase funtion key)
    FDBD  H.TOTE  [c] start of TOTEXT (force screen to text mode)
    FDC2  H.CHGE  [c] start of CHGET (character get)
    FDC7  H.INIP  [c] start of INIPAT (initialize pattern)
    FDCC  H.KEYC  start of KEYCOD (key coder); for alternate key assignments
    FDD1  H.KYEA  start of KYEASY (key easy); for alternate key assignments
    FDD6  H.NMI   beginning of NMI routine
    FDDB  H.PINL  start of PINLIN (program input line)
    FDE0  H.QINL  start of QINLIN (question mark/input line routine)
    FDE5  H.INLI  start of INLIN (input line) routine
    FDEA  H.ONGO  [c] start of ONGOTP (ON GOTO procedure)
    FDEF  H.DSKO  }
     ~~           } ~40 I/O-related hooks that install disk driver
    FEAD  H.BAKU  }
     ~~           XXX more to be documented


BIOS Calls
----------

Additional References:
- \[map bios] MSX Assembly Page, [MSX BIOS Calls][map bios]
- \[td1] [_MSX Technical Data Book_][td1], p.110-134
- \[td2] MSX2-Technical-Handbook [Appendix 1 - BIOS Listing][2the.a1]
  (incomplete)

BIOS calls are at ROM addresses starting at $0000. Below this table are
further details on some of these, including discussion of names. Calls
that disable interrupts and do not re-enable them (which is typical when
changing the page mappings) have `DI` prefixing their description.

    RST0   000  RESET     Z80 reset entry point; init system
           004  CGTABL    Pointer to ROM character table
           006  VDPREAD   I/O port to use for direct read/write
           007  VDPWRITE    to VDP (TMS9918), usu. $98
    RST1   008  SYNCHR
           00C  RDSLT     DI Read byte from slot: A=slotdesc/retval HL=addr
    RST2   010  CHRGTR    Get next char from BASIC text
           014  WRSLT
    RST3   018  OUTDO
           01C  CALSLT    DI and inter-slot call: IX=call addr, IY(hi)=slotdesc
    RST4   020  DCOMPR    compares HL with DE
           024  ENASLT    DI map A=slotdesc to page containing addr HL
    RST5   028  GETYPR
           02B            sysinfo: int freq, date format, charset
           02C            sysinfo: BASIC version, keyboard
           02D            sysinfo: MSX version
           02E            sysinfo: MSX-MIDI (turbo R only)
           02F            reserved
    RST6   030  CALLF     cross-slot call: follow w/db slotdesc, dw addr
           034  CHAR_16   4b default kanji range; DiskBIOS copies to KANJITABLE
                          two pairs of limits for 1st bytes of Shift-JIS chars
    RST7   038  KEYINT    Timer interrupt handler; keyboard scan etc.
           03B  INITIO
           03E  INIFNK    Re-initialise function key strings to default values
           041  DISSCR
           044  ENASCR
           ...            (all? at 3-byte boundaries)
           059  LDIRMV    block xfer to memory from VRAM
           05C  LDIRVM    block xfer to VRAM from memory
           ...
           07E  SETGRP    set VDP to multicolor mode
           ...
           090  GICINI    init PSG and static data for PLAY statement
           093  WRTPSG    write data in E to PSG reg in A
           096  RDPSG     read data from PSG reg in A, returning in A
           099  STRTMS    checks/starts background tasks for BASIC `PLAY`
           09C  CHSNS     test KB buf status: Z=1: empty, Z=0: has keystrokes
           09F  CHGET     ♠A waits for input of 1 char
           0A2  CHPUT     ♠A display character
           0A5  LPTOUT    ♠A send char to printer; cy=1 on fail
           0A8  LPTSTT    test printer status: ready: A=255 !Z, not: A=0,Z
           0AB  CNVCHR    ♠A char code graphic check/graphic header convert
           0AE  PINLIN    store chars in (HL) until ret (cy=0) or STOP (cy=1)
           0B1  INLIN     as PINLIN, but AUTFLG ($F6AA) set
           0B4  QINLIN    print "? " then INLIN
           0B7  BREAKX    test Ctrl-Stop; C flag=set when pressed
           0C0  BEEP      generate a beep
           0C3  CLS       clear the screen
           0C6  POSIT     move cursor to X=H, Y=L
           ...
           0D2  TOTEXT    force screen to text mode
           0D5  GTSTCK    joystick dir read; A=param/ret, see BASIC `STICK()`
           0D8  GTTRIG    joystick btn read; A=param/ret; see BASIC `STRIG()`
           0DB  GTPAD     touchpad read; A=param/ret
           0DE  GTPD      paddle read; A=param/ret
           ...
           135  CHGSND    set 1-bit sound port A=0 off, A=~0 on
           138  RSLREG    A←current output to primary slot register
           13B  WSLREG    A→primary slot register
           13E  RDVDP     A←VDP register
           141  SNSMAT    Reads row=A of keyboard matrix; A=result, 0=keydown
           144  PHYDIO    operation for mass storage (e.g., floppy)
           147  FORMAT    init mass storage (e.g., floppy)
           ...
           159  CALBAS    inter-slot call to BASIC interpreter: IX=call addr

    MSX2   15C  SUBROM
           15F  EXTROM
           ...
           177  NWRVRM

    MSX2+  17A  RDRES
           17D  WRRES

    turboR 180  CHGCPU
           183  GETCPU
           186  PCMPLY
           189  PCMREC

- `RST0` $000 `RESET`: Z80 CPU reset entry vector. Called `CHKRAM` in
  [[td1 p.110]] and [[td2 p.343]] and elsewhere, but actually disables
  interrupts and calls the real `CHKRAM` (MSX1 $02D7, MSX2 $0416). Both
  [[td1]] and [[td2]] say that `INIT` must be called afterwards, but
  `CHKRAM` itself does this. Other names:
  - [[qest p.2 P.6]]: `BEGIN`
  - [[map bios]]: `STARTUP`, `RESET`, `BOOT`

- $02B,$02C,$02D sysinfo, ROM version information. Charset and perhaps
  other information is not reliable in some (many?) BIOSes.
  - $2B   b7: default interrupt frequency: 0=60 Hz 1=50 Hz
  - $2B b6-4: date format: 0=Y-M-D 1=M-D-Y 2=D-M-Y
  - $2B b3-0: character set: 0=ja 1=international 2=kr
  - $2C b7-4: BASIC version: 0=ja 1=international
  - $2C b3-0: keyboard type: 0=JP 1=INT 2=FR (AZERTY) 3=UK 4=DE (DIN)
  - $2D b7-0: MSX version: 0=MSX1 1=MSX2 2=MSX2+ 3=MSX turbo R
  - $2E b7-1: reserved?
  - $2E   b0: MSX-MIDI (turbo R only): 0=absent 1=present
  - $2F b7-0: reserved

- $010 `CHRGTR`: Get next character from BASIC program text pointer.
  HL=program text pointer, A=character at that point. Flag C set if number,
  flag Z set if at end of staement.
- $059 `LDIRMV`, $05C `LDIRVM`: block xfer memory←VRAM, VRAM←memory.
  BC=block length, DE=source start addr, HL=dest start addr.
- $090 `GICINI`. According to the [MSX Wiki][mw sysvars], this initialises
  the BASIC `PLAY` queue tables as well (probably $F3F3 `QUEUES`, $F959
  `QUETAB`, $F971 `QUEBAK`, $F975` VOICAQ`, $F9F5` VOICBQ`, $FA75` VOICAQ`,
  $FB3E `QUEUEN`). Beyond this, documentation exactly on what this does is
  very hard to find.
- $0AB `CNVCHR`. Related to "Graphic Header Byte" ($01 $xx) encoding. It's
  not clear if `CHRGET` is returning this, or if this is converting to GHB.
  This needs to be checked.


<!-------------------------------------------------------------------->

<!-- References -->
[msxsyssrc]: https://sourceforge.net/projects/msxsyssrc/
[rbr.6]: https://www.angelfire.com/art2/unicorndreams/msx/RR-BIOS.html
[rbr.8]: https://www.angelfire.com/art2/unicorndreams/msx/RR-RAM.html
[td1]: https://archive.org/stream/MSXTechnicalHandbookBySony#page/n5/mode/1up

<!-- Memory Map -->
[map sysvars]: https://map.grauw.nl/resources/msxsystemvars.php
[mw sysvars]: https://www.msx.org/wiki/System_variables_and_work_area

<!-- Startup -->
[cr]: https://www.msx.org/wiki/Develop_a_program_in_cartridge_ROM
[cr device]: https://www.msx.org/wiki/Develop_a_program_in_cartridge_ROM#DEVICE
[cr disk]: https://www.msx.org/wiki/Develop_a_program_in_cartridge_ROM#Create_a_ROM_with_disks_support
[cr init]: https://www.msx.org/wiki/Develop_a_program_in_cartridge_ROM#INIT
[cr statement]: https://www.msx.org/wiki/Develop_a_program_in_cartridge_ROM#STATEMENT
[cr text]: https://www.msx.org/wiki/Develop_a_program_in_cartridge_ROM#TEXT

<!-- BIOS Calls -->
[2the.a1]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Appendix1.md
[map bios]: http://map.grauw.nl/resources/msxbios.php
[qest]: https://archive.org/details/MSXBIOSBook/MSX%20BIOS%20Book%20-%2001/mode/1up
