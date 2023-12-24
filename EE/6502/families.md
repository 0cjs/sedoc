6502 CPU Families
=================

There are four basic families of the 6502 CPU:
- __N__ 6502: Original NMOS (with and without the ROR bug)
- __S__ 65SC02: 65C02 but without the bit manipulation instructions.
- __C__ [65C02] or 65CE02: Bugfixes, more instructions, etc.
- __8__ 65C802 or 65C816: 16-bit processor in 8-bit mode

The CMOS versions should draw between 4 mA and 16 mA; the NMOS between
70 mA and 160 mA.

Many CPUs described as a "65C02" are actually __S__ models without the
bit instructions. (These are not that useful outside of embedded
systems anyway, since they can only be used on the ZP without
indexing.) Examples include GTE and NCR CPUs, and whatever Apple used
in the IIc and Enhanced IIe. (NCR called their model with bit
instructions the 65CX02.)

References:
- Roger Wagner, ["Assembly Lines" part 33][al33]  _Softalk_, June 1983.
- Wilson Mines Co., [Differences between NMOS 6502 and CMOS 65c02][wm-diff]
- Chromatix, [Re: R65C02P4 fake chips][6f p74156].

### 6502 Cores

- __Ricoh RP2A03__ (NTSC), __RP2A07__ (PAL): Nintendo Famicon/NES CPU.
  Different [pinout][console5]. No decimal mode. Programmable sound
  generator ("APU"), game controller polling, rudamentary DMA


Variant List
------------

    CPU       Inst  ClkOut     RDY  TS  ML  Pn
    ------------------------------------------------------------------------
    6502      N      Φ12       R    -   -
    6512      N       Φ2 Φ1in  R     D  -
    65C02     C,R    Φ12       RW   -   -
    65C102    C,R     Q        RW   AD  +   39:Q
    65C112    C,R     Φ2       RW   AD  +
    65SC02    C      Φ12       RW   -   -
    65SC12    C       Φ2       -?    D  -
    65SC102   C       Q        RW   AD  +   39:Q
    65SC112   C       Φ2       RW   AD  +
    65CE02    C,E    Φ12       RW   -   -
    W65C802S  C,W,L  Φ12       RWH  AD  +   1:/VP
    W65C816S  C,W,L      Φ2in  RWH  AD  +   1:/VP 7:VPA 38:MX 39:VDA
    W65C02S   C,R,W  Φ12       RWH  AD  +   1:/VP

- Inst (instruction set):
  N=NMOS, C=CMOS, R=Rockwell, E=Extended, W=WDC, L=Long.
- ClkOut: Q=quadrature out
- `RDY` (ready pin halts on): R=read, W=write, H=halt.
- TS (bus tristate): A=address, D=data.
- ML (memory lock)
- Pn (special pins):
  - Pin 1 is normally GND, but `/VP` (interrupt vector being read) on WDC CPUs
  - Pin 39 Φ2out is 1/4 clock speed on Q (quadrature out) CPUs
  - '816 replaces 7:SYNC,38:/SO,39:Φ2out with VPA,MX,VDA.

[Source][variant-chart].


Model Detection
----------------

### Hardware

A CMOS version draws between 4-16 mA; an NMOS one between 70-160 mA.
([BillIO][73307])


### Software

This [program from Chromatix][73317] leaves an ASCII code in the
accumulator indicating the family of the CPU it's run on.

This will detect as `S` NMOS simulators that do only documented
opcodes, since the $47 $83 sequence will be a `NOP` (or whatever)
instead of the merge of `LSR $83` and `EOR $83` that the original NMOS
implementation happened to do.

    ; Left in A register at end:
    ;      'N' - NMOS 6502
    ;      'S' - 65SC02
    ;      'C' - 65C02 or 65CE02
    ;      '8' - 68C816 or 65C802
    2B0 : A9 00     lda   #0
    2B2 : 85 84     sta  $84
    2B4 : 85 85     sta  $85
    2B6 : A9 1D     lda  #$1D       ; 'N' EOR 'S'
    2B8 : 85 83     sta  $83
    2BA : A9 6B     lda  #$6B       ; 'N' EOR 'S' EOR '8'
    2BC : 85 1D     sta  $1D
    2BE : A9 4E     lda  #$4E       ; 'N'
    2C0 : 47 83     rmb4 $83        ; magic $47 opcode
    2C2 : 45 83     eor  $83
    2C4 : 60        rts


Additional Features
--------------------

References:
- Page 1-10 of the [Rockwell R65C02 datasheet][r65c02]
- Wilson Mines Co., ["Differences between NMOS 6502 and CMOS 65c02"][wm-diff]
- Roger Wagner, ["Assembly Lines" part 33][al33] (wrong on some details)

New addressing modes (__S__+):
- Implicit `INC`/`DEC`: on accumulator. (Sometimes `INA` or `INC A`.)
- `BIT` gains immediate and zp/absolute indexed: `#$nn`, `$addr,X`.
- `JMP` gains indexed absolute indirect `(addr,X)`
- Indirect `(zp)` (without X, Y registers).
  `LDA`, `STA`, `CMP`, `ADC`, `SBC`, `AND`, `EOR`, `ORA`.

New instructions (__S__+):
- `STZ addr` stores zero.
- `PHX`/`PLX`/`PHY`/`PLY`: Direct stack push/pull for X and Y registers.
- `BRA`: Branch always.

New instructions (__C__):
- `SMBbit zp`/`RMBbit zp`: Set or reset bit _bit_ of address _zp_.
  Zero page only.
- `BBS bit,zp,dest`/`BBR`: Branch to _dest_ if bit _bit_ in location
  _zp_ is set/reset. Zero page only.
- `TSB zp`/`TRB xp`: AND A with _zp_ to set flags then set/clear in
  _zp_ the bits set in A.

New instructions (WDC):
- `STP`: Halt until hardware reset.
- `WAI`: Halt until IRQ (or NMI?). (Intererupt vector is not taken?)



<!-------------------------------------------------------------------->
[65C02]: https://en.wikipedia.org/wiki/WDC_65C02
[6f p74156]: http://forum.6502.org/viewtopic.php?f=4&t=5929&start=45#p74156
[al33]: https://archive.org/details/softalkv3n10jun1983/page/199/mode/1up
[console5]: https://console5.com/wiki/RP2A03
[r65c02]: http://archive.6502.org/datasheets/rockwell_r65c00_microprocessors.pdf
[variant-chart]: http://forum.6502.org/viewtopic.php?f=4&t=6027&view=unread#p73881
[wm-diff]: http://wilsonminesco.com/NMOS-CMOSdif/


[73307]: http://forum.6502.org/viewtopic.php?f=4&t=5929&view=unread#p73307
[73317]: http://forum.6502.org/viewtopic.php?f=4&t=5929&view=unread#p73317
