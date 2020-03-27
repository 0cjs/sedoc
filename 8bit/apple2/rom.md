Apple II ROM Information
========================

There are two ROM versions:
- Apple II: Monitor ROM with Integer BASIC and the Mini Assembler.
- Apple II Plus: Autostart ROM with Applesoft BASIC.

The original "langauge card" for the II contained the Autostart and
Applesoft ROMs; the later language card for the II Plus contained RAM
that could be loaded with Monitor ROM and Integer BASIC.


Useful ROM Routines
-------------------

#### All ROMs

$F800-$FFFF Monitor; see also [[a2ref] pp. 61-64]:
- $FDED COUT: Print ASCII char (MSB set) in A.
- $FC58 HOME: Clear screen and move cursor to upper left.
- $FCA8 WAIT: Short delays related to the square of the value in A.
  The comment in the non-autostart monitor source code ((512a² + 2712a
  + 13) × 1.0204 μsec) seems bogus; it's actually approximately 5a²/2
  + 12a + 8. Some analysis at [blondihacks-151011].
- $FF69: Monitor entry point.

$F689-$F7FC Sweet-16 interpreter:

#### Autostart ROMs only

$D000-$F7FF Applesoft BASIC?

#### Non-Autostart ROMs Only

$F500-$F63C, $F666-$F668 Mini-assembler:
- $F666: Mini-assembler entry point

$F425-$F4FB, $F63D-$F65D Floating point routines:

$E000-$F424 Integer BASIC:

$D000-$D7FF Programmer's Aid #1:


Zero Page
---------

`b`=byte; `w`=word.

    20  32 b  text window left edge (0-38)
    21  33 b  text window width (1-40, 1-80)
    22  34 b  text window top row (0-23)
    23  35 b  text window bottom row (1-24)
    24  36 b  cursor pos., horizontal (0-39)
    25  37 b  cursor pos., vertical (0-23)
    2B  43 b  boot slot * 16
    31  49 b  MODE: something to do with monitor mode?
    32  50 b  text output (normal:$FF/255, inverse:$3F/63, flash:$7F/127)
    33  51 b  prompt character
    4E  71 w  random number field
    67 103 w  start of Applesoft program (ptr-1 byte must be 0 for NEW)
    69 105 w  LOMEM (start of Applesoft variable space, approx end of prog.)
    6B 107 w  start of array space
    6D 109 w  end of array space
    6F 111 w  start of string storage
    73 115 w  HIMEM (one past highest usable addr)
    AF 175 w  end of Applesoft program

    45  69 b  ACC: A register; set by monitor on BRK, loaded by G command
    46  70 b  XREG: X register
    47  71 b  YREG: Y register
    48  72 b  STATUS: P register (flags)
    49  73 b  SPNT: S register (stack)


Page $300 Vectors
-----------------

$3F0-$3FF is used by the monitor/OS. Entries marked `(+)` are
Autostart ROM-only; all others are both Autostart and Monitor ROM.
Default values given in parens at end of entry. Default values when
DOS loaded are for a 48K system.

$3D0-$3F0 is used by [DOS 3.3](dos.md) and [ProDOS](prodos.md); see
those docs for details.

     3F0   1008  w  (+) Address of BRK handler ($FA59)
     3F2   1010  w  (+) "Soft entry vector"; RESET handler ($E003, DOS:$9DBF)
     3F4   1012  b  Power-up byte (distinguishes cold/warm reset)
                    EOR of $3F3 and #$A5
     3F5   1013  c  JMP to Applesoft & routine (-, DOS:$FF58)
     3F8   1016  c  JMP to monitor Ctrl-Y routine (-, DOS:$654C)
     3FB   1019  c  JMP to NMI routine (-, DOS:$FF65)
     3FE   1022  w  Address if IRQ routine (-, $FF65)

Sources: [a2ref-65]


References
----------

References:
- \[a2ref] [_Apple II Reference Manual_][a2ref], 1979 edition.


<!-------------------------------------------------------------------->
[a2ref-61]: https://archive.org/details/Apple_II_Reference_Manual_1979_Apple/page/n71/mode/1up
[a2ref-65]: https://archive.org/details/Apple_II_Reference_Manual_1979_Apple/page/n75/mode/1up
[a2ref]: https://archive.org/details/Apple_II_Reference_Manual_1979_Apple

[blondihacks-151011]: https://blondihacks.com/apple-iic-plus-fixing-the-beep/
