PC-8001 Memory
==============

Memory Map
----------

Overview ([[hb68]] p.85):

    C000 FFFF 16K   Standard RAM
    F300 F3B7       VRAM
    8000 BFFF 16K   Expansion RAM
    6000 7FFF  8K   Expansion ROM (unpopulated socket)
    0000 5FFF 24K   BASIC

    C000 EA00       Disk BASIC (unconfirmed)
    EA00 FFFF       BIOS/BASIC work area
    F300 FEB8       Screen memory (see Byte article)

Special addresses (prob. much more at [[EnrPc]]):

    F1E3            RST $38 target
    F1E0            RST $30 target
    F1DD            RST $28 target
    F1DA            RST $20 target
    E9FF            start of BASIC string area (grows down)
    C021            start of BASIC text (16K system)
    8021            start of BASIC text (32K system)

    PC-8011 ROM BASIC Interrupt table
    801E                INT 0
    801C                INT 1
    801A                INT 2
    8018                INT 3
    8016                INT 4
    8017                INT 5
    8012                INT 6
    8010                INT 7
    800E                INT 8 GPIO parallel
    800C                INT 9 GPIO parallel
    800A                RS-232 Ch2
    8008                RS-232 Ch1
    8006                (unused)
    8004                "real time clock"
    8002                IEEE-448
    8000                IEEE-448

    8000H-8001H: IEEE-448
    8002H-8003H: IEEE-448
    8004H-8005H: Real
    - time clock 8006H-8007H: Unused
    8008H-8809H: RS-232C Ch1　
    800AH-800BH: RS-232C Ch2　
    800CH-800DH: / INT9 General
    - purpose parallel 800EH-800FH: / INT8 General
    - purpose parallel 8010H-8011H: / INT7
    8012H-8013H: / INT6
    8014H-8015H: / INT5
    8016H-8017H: / INT4
    8018H-8019H: / INT3
    801AH-8019H: / INT2
    801CH-8011DH: / INT1
    801EH-801FH: / INT0


[ROM images for PC-8001 and PC-8001mkII][rom] (including font ROM).


Banked Memory (64K)
-------------------

The ROM area can be replaced by 32K RAM from the PC-8011 or one of up to
four banks of 32K RAM from the PC-8012. It appears that for the 8011 all
writes to $0000-$7FFF write to RAM, and writing any value to I/O port $E2
changes reads from ROM to RAM. For the 8012, port $E2 takes the following
output values. ($E7 also used in sample code below; not clear what it
does.)

    $10     write bank 0
    $01     read bank 0
    $11     write/read bank 0
    $00     no read/write bank 0

The following are `DEFUSR0=&hFF80: A=USR(0)` routines that will copy the
BASIC ROM to low RAM and switch it in, restarting BASIC with a 40K text
area. ([[hb68]] pp.76-77):

    ;   PC-8011
    FF80: 01 00 60  ld bc,$6000     ; N.B.: In Z80 assembly, "n" is immediate
    FF83: 11 00 00  ld de,$0000     ;   value, "(n)" is contents of address.
    FF86: 21 00 00  ld hl,$0000
    FF89: ED B0     ldir            ; [HL]→[DE] decrementing BC until 0
    FF8B: D3 E2     out ($E2),a
    FF8D: C3 E9 17  jp $17E9        ; BASIC cold entry (no h/w init or CLS)

    ;   PC-8012
    FF80: 3E 01     ld a,1
    FF82: D3 E7     out ($E7),a
    FF84: 3E 10     ld a,$10
    FF86: D3 E2     out ($E2),a
    FF88: 01 00 60  ld bc,$6000
    FF8B: 11 00 00  ld de,$0000
    FF8E: 21 00 00  ld hl,$0000
    FF91: ED B0     ldir
    FF93: E3        ex (sp),hl      ; swap HL and top word on stack
    FF94: 11        ld (de),a
    FF95: D3 E2     out ($E2),a
    FF97: C3 E9 17  jp $E917

See also [[km82]] pp.250-251 for a simpler PC-8012 routine:

    ;   N-BASIC ON RAM
                    org  $EE00
    EEOO: 3E 10     ld   a,$10
    EE02: D3 E2     out  ($E2),a
    EE04: 01 00 80  ld   bc,$8000
    EE07: 11 00 00  ld   de,0
    EEOA: 21 00 00  ld   hl,0
    EEOD: ED BO     ldir
    EEOF: 3E 11     ld   a,$11
    EE11: D3 E2     out  ($E2),a
    EE13: C3 81 00  jp   $0081


I/O Ports
---------

Bit 7 0=internal 1=external. Bits 6-4 are device code, 3-0 are registers
within a device ("order code"). [[hb68]] pp.92-93, [[rcp88io]].

    F0-FF   Floppy disk control
    E0-EF   PC-8011 system control
            - E4: RS-232C channel usage initial setting
            - E0-E3: modes 0-3
    D0-DF   IEEE-488
            - D8 control signal input
            - D3 8255 control
            - D2 control signal output
            - D1 data in
            - D0 data out
    C0-CF   RS-232C interface (C1=channel 1; C2=channel 2)
    B0-BF   GPIO (outputs to high level on system reset)
            - B3: 4-bit output
            - B2: 4-bit input
            - B1: 8-bit output
            - B0: 8-bit input
    80-AF   expansion I/O (free)
    70-7F   unused
    60-6F   DMA control
    50-5F   CRT control
    40-4F   IN: printer busy, ack; OUT: printer, beep
    30-3F   CPU system control
    20-2F   8251 USART
    11-1F   (↓mirror)
    10      OUT: printer, calendar/clock chip command
    00-0A   Keyboard input row registers (0 bits indicate key down in row).
            See keyboard map [hb68] p.94-95 or ./8801.md map rows 0-9.
            Rows 0-1 are numeric keypad.



<!-------------------------------------------------------------------->

<!-- duplicated from README.md -->
[hb68]: https://archive.org/stream/PC8001600100160011982#page/n5/mode/1up
[km82]: https://archive.org/details/pc-8001

[rcp88io]: https://retrocomputerpeople.web.fc2.com/machines/nec/8801/io_map88.html
[rom]: https://ia902908.us.archive.org/view_archive.php?archive=/33/items/NEC_PC_8001_TOSEC_2012_04_23/NEC_PC_8001_TOSEC_2012_04_23.zip
