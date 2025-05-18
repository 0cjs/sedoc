SuperAKI-80 Z80 SBC
===================

The SuperAKI-80 is a Z80-based SBC kit released on 2017-01-24 by
[Akizukisenshi][az-s80] (an Akihabara electronics parts shop). It includes
a timer, a couple of serial ports and significant amounts (64 GPIO pins) of
parallel I/O, as well as a memory backup circuit. Originally ¥5700, then
¥2000, as of 2025-04-23 it's available for ¥280 from a discount bin on the
second floor.

### References

Manuals, datasheets and software:
- akizukidenshi.com, [スーパーAKI-80 (基板単体、保守部品)][az-man].
  Manual and technical reference.
- archive.org, [TMPZ84C015BF-10]. Datasheet for CPU plus integrated I/O.
- archive.org, [MBAKIAI], 2018-09-10. Port of Grant Searle's adapation of
  of MS-BASIC 4.7. Binary included; source is for the ARCPIT `XZ80.EXE`
  assembler. (The CTC channel this uses for the baud rate generator appears
  to be wrong; see below.)

Product information and and blog entries.
- akizukidenshi.com, [スーパーAKI-80 (基板単体、保守部品)][az-s80].
  Store product page.
- akizukidenshi.com, [AKI-80(Z80)モニターROM][az-mon]. Monitor ROM (27C256
  EPROM) with bring-up test, "Z-VISION remote" server. ([Manual][az-mon-man])
- cba.sakura.ne.jp, [Super AXI-80][cba]. Kit information and photos.
- ameblo.jp/kissam59, [Super AKI-80に興味を持っています。][kissam59].
  Blog entry briefly describing the Z-VISION development environment.
- kida.asablo.jp, [まな板の上のSuper AKI-80:
  アナクロなコンピューターエンジニアのつぶやき]


Components
----------

### Pre-Installed

The following are surface mount parts already soldered to the 70×50 mm PCB.

* Toshiba __[TMPZ84C015BF-10]__ 10 MHz TLCS-Z80 MPU and I/O devices. This
  is a Zilog Z80-compatible MPU with the following integrated I/O devices
  which are more or less equivalent to the [stand-alone Zilog parts][z-io]
  documented in [this manual][z-io-man]. (Section and PDF page numbers
  refer to the [TMPZ84C015BF-10 datasheet][TMPZ84C015BF-10].)
  - Clock generator/controller and watchdog timer (__CGC__, §3.3 P.60, §3.7
    P.143) on I/O ports $F0-$F1. This uses an external crystal resonator at
    2× the system clock frequency; see below.
  - [Z8430]-equivalent counter/timer circuit (__CTC__, §3.4 P.71) on I/O
    addrs $10-$13.
  - Parallel I/O (__PIO__, §3.5 P.87) on I/O addrs $1C-$1F. Note that this
    is _not_ the same as an Intel 8255; it provides only two ports (A and
    B), each with 8 bits of I/O and one input and one output handshake
    line.
  - Dual Serial I/O (__SIO__, §3.6 P.107) on I/O addrs $18-$1B.
  - Interrupt prioritysystem (§3.9 P.149).

* Toshiba [82C265], two 8255 Programmable Peripheral Interfaces (__PPIs__) in
  a single package. Decoding by a '138 puts these on ports $30-$37. This
  provides 48 pins of GPIO (in addition to the GPIO from the PIO above).

* JEDEC 32K × 8 bit 55 ns SRAM. This is mapped to the top 32K of the
  address space. The RAM jumper should be set to to the "256" side; the
  "64" side is used only to support 8K × 8 bit RAM devices.

* Glue logic:
  - 74AC138 3→8 decoder: decodes `C̅S̅0̅` and `C̅S̅1̅` for 82C265.
  - 74AC32  4× 2-input OR gates: mem/IO and read/write logic
  - 74AC00  4× 2-input NAND gates:
    1 for RAM `C̅S̅`, 3 unused with inputs tied to ground.
  - 74HC14  6× Schmitt-trigger inverters:
    2 for reset logic, 4 unused with inputs tied to Vcc.

### User-supplied

You will need to add the following components. The board diagram in the
manual is an important reference here as the locations are not clearly
marked on the board. Note that most resistors must be mounted vertically.

Clock:
- 19.6608 MHz crystal resonator, giving a 9.830 MHz system clock. Other
  frequencies can be used, but given a 1/16 prescaler on the CTC, this lets
  it generate clocks for the SIO to standard serial speeds from 300 bps
  through 38.4 kbps. (See more below.)
- 2× 33 pF caps for `Cin` and `Cout` lines.

Hardwired jumpers:
- If you hardwire the RAM and/or ROM jumper (see below), it's easier to do
  these hardwired ones now rather than after taller components have been
  installed around them.

Control line pullups:
- 6× 10K resistors (three lower right, but one is for the reset circuit;
  two above RAM, one next to PIO header above that).

Reset and RAM enable:
- 1× 100 KΩ resistor between `A15` and `BND` (A15/select pull-up)
- 1× 10k resistor
- 1× 1 μF cap
- [1S1588] diode. [1N4148] can substitute; meets or exceeds all 1S1588
  specs.
- S-8054ALB or [S-8054ALR] voltage detector.
  - These seem to be hard to get, need to look for a substitute.
  - It's the only thing that brings the reset circuit high so without it:
    - Solder jumper diode cathode to Vcc (look up S-8054ALR pins).
    - Use a jumper wire to connect `R̅S̅T̅I̅N̅` (CN2 p4) first to GND (CN2
      p37/38) to force into reset state, and then to to Vcc (CN2 p35/36)
      to bring out of reset state.

RAM power:
- 2× [11EQS04] Schottky diodes for power from Vcc to RAM/74AC00 and power
  from battery to the same place. [1N5819] has same specs.
- 3.6V lithium battery for RAM backup.

Decoupling/bypass caps:
- 7× decoupling caps. The manual suggests 1 μF, but I don't see why you'd
  not use the standard 0.1 μF.
- The manual BoM also lists 5× 0.1 μF that can't be found on the schematic
  or the board diagram.

Jumpers:
- __Warning:__ RAM/ROM jumpers are are 0.07" pitch, not 0.1" pitch.
- 1× 0.07" for RAM config if you don't hardwire the RAM jumper. (But
  recommended you hardwire it, since the 32K × 8 RAM is soldered in.)
- 1× 0.07" for ROM config. Right-angle (w/extension?) if under a ZIF socket.
- 2× 0.10" for config of `CN4` if you are using a MAX232.

ROM:
- 2764 (8K × 8 bits), 27128 (16K) or 27256 (32K) EEPROM.
- DIP-28W socket for the EPROM. This must _not_ have a cross-bar in the
  middle because the RAM sits under the ROM. (We really need to figure
  out how to use a ZIF socket here.)

Power:
- 100 μF cap.
- 1× LM2930 or LM7805 voltage regulator. (Or use an external regulated PSU.)
  - Pinout (looking at front): 3=IN, 2=GND, 1=OUT.

RS-232 Serial:
- 1× [MAX232] for ±12 V RS-232 levels on `CN4` (optional).
- 5× electrolytic capacitors for the MAX232 charge pumps.
  - The SuperAKI-80 manual gives a 10 μF values, which is suitable only for
    the exact models listed there
  - Modern versions (e.g. TI or [this MAX232EN][aki-MAX]) use 1 μF; use
    what the datasheet for your model suggests. Note that the [datasheet]
    for that model linked has pin 2 configured wrong; the TI datasheet and
    the board are correct.

Connectors:
- Header pins: for single row, one 1×40 should cover it.
  - Male interfaces: three 2×40 male.
  - Female interfaces: three 2×40 female (ideally, two 2×25 and one 2×20),
    optionally a few 2×nn male for a few jumper blocks.


Connectors
----------

These include suggested colours to make identification of signals on system
connectors easier.

### CN2

- `↑` = 10kΩ pullup. Horizontal arrows indicate inputs/outputs/bidirectional.
- Color code:
  - yellow/green/red: power input/ground/Vcc(+5V)
  - black: control outputs (`◀`, `▶`)
  - white: control inputs (`▷`,`◁`)
  - red: address bus (outputs, `◀`, `▶`)
  - blue: data bus (bidirectional, `↔`)

Diagram:

                  ┌─────┐
       ↑    /NMI ▷│ 1  2│▶ CLKOUT     white
         /RSTOUT ◀│ 3  4│◁ /RSTIN     black
             IEI ▷│ 5  6│▶ /WDTOUT    white
             IEO ◀│ 7  8│  n/c        white
              D1 ↔│ 9 10│↔ D0         blue
              D3 ↔│11 12│↔ D2          │
              D5 ↔│13 14│↔ D4          │
              D7 ↔│15 16│↔ D6         blue
              A1 ◀│17 18│▶ A0         black
              A3 ◀│19 20│▶ A2          │
              A5 ◀│21 22│▶ A4          │
              A7 ◀│23 24│▶ A6         black
       ↑ /BUSREQ ▷│25 26│▶ /M1        white
         /BUSACK ◀│27 28│◁ /WAIT   ↑   │
       ↑    /INT ▷│29 30│▶ /HALT      white
             /WR ◀│31 32│▶ /MERQ      black
             /RD ◀│33 34│▶ /IORQ      black
                  │35 36│  Vcc(+5V)   red
                  │37 38│  GND        green
                  │39 40│← Ext.PWR    yellow
                  └─────┘


Memory Map
----------

### Memory

The system memory is hardwired to enable the ROM when A15 is low, and the
RAM when A15 is high, giving:
- __$0000-$7FFF:__ 32K ROM (8K and 16K ROMs are mirrored up to 32K).
  - External ROM/RAM with its own decoding can be used by leaving the ROM
    out of the on-board socket.
- __$8000-$FFFF:__ 32K RAM.
  - External ROM/RAM cannot be used here without cutting traces.

### I/O Ports

    Port Device Register    Description                         Documentation
    ───────────────────────────────────────────────────────────────────────────
     F4         INTPR       interrupt priority register         §3.9  P.149
     F1    CGC  HALTMCR     halt mode control
     F0    CGC  HALTMR      halt mode setting                   §3.7  P.143

     37    PPI1             PPI #1 control register
     36    PPI1             PPI #1 port C
     35    PPI1             PPI #1 port B
     34    PPI1             PPI #1 port A
     33    PPI0             PPI #0 control register
     32    PPI0             PPI #0 port C
     31    PPI0             PPI #0 port B
     30    PPI0             PPI #0 port A

     1F    PIO              port B command
     1E    PIO              port B data
     1D    PIO              port A command
     1C    PIO              port A data                         §3.5  P.87

     1B    SIO              channel B command
     1A    SIO              channel B data
     19    SIO              channel A command
     18    SIO              channel A data                      §3.6  P.107

     13    CTC              channel 3 control word
     12    CTC              channel 2 control word
     11    CTC              channel 1 control word
     10    CTC              channel 0 control word              §3.4  P.71

Decoding for all but the PPI is done internally in the TMPZ84C015BF-10;
presumably it strictly decodes just those ports and all others are
available (but this has not been confirmed).

The PPI is decoded by a 74AC138; this is enabled by `A7`=0 `A6=0` `A5`=1,
with C=`A4`,B=`A3`,A=`A2`. (`A1`,`A0` are connected directly to the PPI.)
Thus, it decodes:

      A4 A3 A2   Addr   Output
      ────────────────────────────────
       0  0  0  $20-23  Y̅0̅  nc
       0  0  1  $24-27  Y̅1̅  nc
       0  1  0  $28-2B  Y̅2̅  nc
       0  1  1  $2C-2F  Y̅3̅  nc
       1  0  0  $30-33  Y̅4̅  PPI C̅S̅0̅
       1  0  1  $34-37  Y̅5̅  PPI C̅S̅1̅
       1  1  0  $38-3B  Y̅6̅  nc
       1  1  1  $3C-3F  Y̅7̅  nc


Notes
-----

#### Power Supply

Power is supplied/made available on `CN2`:

    36:+5V  38:GND  40:POWER
    36:+5V  37:GND  39:POWER

If an LM2390 (LM7805) regulator is installed, input power is expected to be
connected to `POWER` above, and `+5V` will be the regulator output. If you
are using external regulated power it can be connected directly to `+5V`,
but if you have a regulator installed you must ___also___ connect it to
`POWER` to avoid damaging the regulator.

The board apparently requires about 100 mA.

#### Serial Connectivity

The board wires the CTC timer 3 output `ZC/TO₃` to the `T̅X̅C̅A̅` and `R̅X̅C̅A̅`
clock inputs on the SIO for use as a baud rate generator. `T̅X̅C̅B̅` and `R̅X̅C̅B̅`
are not connected; to use the second serial port you can wire the same or
another CTC output to them.

__WARNING:__ The [MBAKIAI] BASIC setup uses CTC timer 2, not 3. You
probably need to change it and rebuild if you're going to use it.

If you have a MAX232, RS-232 levels are available on `CN4`. If you use
either the second serial port or CTS/RTS, you will need to set jumpers
below the MAX232. The `CN4` pinout is:

    TXD/RXD     1:GND  2:R̅X̅D̅A̅  3:T̅X̅D̅A̅  4:R̅X̅D̅B̅  5:T̅X̅D̅B̅
    RTS/CTS     1:GND  2:R̅X̅D̅A̅  3:T̅X̅D̅A̅  4:CTSA  5:RTSA

If not using a MAX232, TTL serial is available on CN1:

    14:R̅X̅C̅A̅  16:TXDA  18:R̅T̅S̅A̅  20:D̅C̅D̅A̅  22:C̅T̅S̅B̅  24:D̅T̅R̅B̅  26:T̅X̅C̅B̅  28:RXDB
    13:RXDA  15:T̅X̅C̅A̅  17:D̅T̅R̅A̅  19:C̅T̅S̅A̅  21:D̅C̅D̅B̅  23:R̅T̅S̅B̅  25:TXDB  27:R̅X̅C̅B̅

CTC timer 0 is connected the SIO `R̅X̅C̅A̅` and `T̅X̅C̅A̅`: with the standard
crystal use 1/16 CTC prescale, 1/16 mode on the SIO, and CTC divisor:
1/1=38.4 kbps; 1/2=19.6 kbps; 1/4=9600 bps; ...; 1/128=300 bps.

If you use a 20 MHz crystal instead of 19.6608 Mhz, the bps rates using
the divisors above be about 1.73% fast. This _may_ be all right for async
serial, but if not the lower BPS rates can use slightly tweaked divisors
to get more exact.


Monitor ROM
-----------

The [documentation][az-mon-man] for the [AKI-80(Z80)モニターROM][az-mon]
monitor ROM covers only the test mode: reset with PIO A0 held low and it
will turn all GPIO pins on and off at 1 Hz. If you start it without PIO A0
held low it will print an `@`. Responding with `CR` will enter something
like a BASIC; responding with any other character will enter the monitor.

#### Monitor Mode

This monitor is designed to be used by a program running on the other end
of the serial link, and so has very little error checking or anything else
to make it friendly for direct use by a human.

Commands (all _nn_ values are ASCII hex digits):
- `DTaaaacccc`: Print _cccc_ bytes of memory at _aaaa_ as binary.
  (Output is prefixed by a `D`.)
- `GOnnnn`: Jump to address _nnnn_
- `INnnhh`: Read from port _hhnn_ and display value.
- `LH`: Load Intel hex records. End with type `01` EOF record followed by
  LF or CR+LF. All input outside of records ignored to `:` ignored.
- `OPnnvvhh`: Write value _vv_ to port _hhnn__.
- `SVaaaacccc`: Read _cccc_ bytes from serial, depositing starting at _aaaa_.
- `T`: Does nothing.
- `XR`: Print 26 hex values of memory from $FF09-$FF22.
- `XMnn…`: Read 26 ASCII hex bytes and deposit to $FF09-$FF22. (Registers?)
- `Znnnnxxxx`: Sets $FF03 = _nnnn_, $FF05 = _xxxx_.
- `V`: Print version string (`AKM20220` in my copy).

#### "BASIC" Mode

XXX This needs to be researched.



<!-------------------------------------------------------------------->
[az-mon-man]: https://akizukidenshi.com/goodsaffix/AKI-80_monitor_rom.pdf
[az-mon]: https://akizukidenshi.com/catalog/g/g117738/
[az-s80]: https://akizukidenshi.com/catalog/g/g111324/
[cba]: https://cba.sakura.ne.jp/kit01/kit_130.htm
[kissam59]: https://ameblo.jp/kissam59/entry-12475096740.html
[mbakiai]: https://archive.org/details/MBAKIAI

[82C265]: https://archive.org/details/TMP82C255A
[TMPZ84C015BF-10]: https://archive.org/details/TMPZ84C015BF-10
[az-man]: https://akizukidenshi.com/goodsaffix/A003_SuperAKI-80.pdf
[z-io-man]: http://www.z80.info/zip/um0081.pdf
[z-io]: ../../EE/periph/z80.md

[11EQS04]: https://ele.kyocera.com/assets/products/power-semicon/specification/11EQS04-file.pdf
[1N4148]: https://www.vishay.com/docs/81857/1n4148.pdf
[1N5819]: https://www.st.com/content/ccc/resource/technical/document/datasheet/26/db/14/60/52/47/47/5b/CD00001625.pdf/files/CD00001625.pdf/jcr:content/translations/en.CD00001625.pdf
[1S1588]: https://download.datasheets.com/pdfs/2008/11/10/semi_ap/manual/tos/ds/1s1585.pdf
[S-8054ALR]: https://www.datasheetarchive.com/datasheet/S-8054ALR/EPSON

[MAX232]: https://www.ti.com/lit/gpn/max232
[aki-MAX232-ds]: https://akizukidenshi.com/goodsaffix/max232.pdf
[aki-MAX232]: https://akizukidenshi.com/catalog/g/g116063/
