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
  of MS-BASIC 4.7. Binary includes; source is for to ARCPIT `XZ80.EXE`
  assembler.

Product information and and blog entries.
- akizukidenshi.com, [スーパーAKI-80 (基板単体、保守部品)][az-s80].
  Store product page.
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
  which are more or less equivalent to the [stand-alone Zilog parts][z-io].
  (Section and PDF page numbers refer to the [datasheet][TMPZ84C015BF-10].)
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

* Toshiba 82C265, two 8255 Programmable Peripheral Interfaces (__PPIs__) in
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

### Required

You will need to add the following components. The board diagram in the
manual is an important reference here as the locations are not clearly
marked on the board. Note that most resistors must be mounted vertically.

Power:
- 1× LM2930 or LM7805 voltage regulator. (Or use an external regulated PSU.)
  - Pinout (looking at front): 3=IN, 2=GND, 1=OUT.

Clock:
- 19.6608 MHz crystal resonator, giving a 9.830 MHz system clock. Other
  frequencies can be used, but given a 1/16 prescaler on the CTC, this lets
  it generate clocks for the SIO to standard serial speeds from 300 bps
  through 38.4 kbps.
- 2× 33 pF caps for `Cin` and `Cout` lines.

RAM enable:
- 1× 100 KΩ resistor between `A15` and `BND`
- 1S1588 diode, 10k resistor, 1 μF capacitor. (Holds high 74AC00 pin 13.)
- 2× [11EQS04] Schottky diodes for power from Vcc to RAM/74AC00 and power
  from battery to the same place. [1N5819] has same specs.
- S-8054ALB or [S-8054ALR] voltage detector. These seem to be hard to get,
  but it appears we can run without it (so long as the parts above are in
  place), and simply can't (safely) use battery backup. See notes in
  manual about pinout and diode direction.
- 3.6V lithium battery for RAM backup.

Decoupling, pull-ups, pull-downs:
- 8× 1 μF caps in various locations.
- 5× 10 KΩ resistors in various locations

ROM:
- 2764 (8K × 8 bits), 27128 (16K) or 27256 (32K) EEPROM.
- DIP-28W socket for the EPROM. This must _not_ have a cross-bar in the
  middle because the RAM sits under the ROM. (We really need to figure
  out how to use a ZIF socket here.)

RS-232 Serial:
- 1× MAX232 for ±12 V RS-232 levels on `CN4` (optional).

Connectors:
- Header pins: for single row, one 1×40 should cover it.
  - Male interfaces: three 2×40 male.
  - Female interfaces: three 2×40 female (ideally, two 2×25 and one 2×20),
    optionally a few 2×nn male for a few jumper blocks.
- Jumpers:
  - 1× for ROM config.
  - 1× for RAM config if you don't hardwire the RAM jumper. (But
    recommended you hardwire it, since the 32K × 8 RAM is soldered in.)
  - 2× for config of `CN4` if you are using a MAX232.


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



<!-------------------------------------------------------------------->
[az-s80]: https://akizukidenshi.com/catalog/g/g111324/
[cba]: https://cba.sakura.ne.jp/kit01/kit_130.htm
[kissam59]: https://ameblo.jp/kissam59/entry-12475096740.html
[mbakiai]: https://archive.org/details/MBAKIAI

[TMPZ84C015BF-10]: https://archive.org/details/TMPZ84C015BF-10
[az-man]: https://akizukidenshi.com/goodsaffix/A003_SuperAKI-80.pdf
[z-io]: http://www.z80.info/zip/um0081.pdf

[11EQS04]: https://ele.kyocera.com/assets/products/power-semicon/specification/11EQS04-file.pdf
[1N5819]: https://www.st.com/content/ccc/resource/technical/document/datasheet/26/db/14/60/52/47/47/5b/CD00001625.pdf/files/CD00001625.pdf/jcr:content/translations/en.CD00001625.pdf
[S-8054ALR]: https://www.datasheetarchive.com/datasheet/S-8054ALR/EPSON
