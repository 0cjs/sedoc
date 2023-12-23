Serial Interfaces
=================

This covers RS-232-style asynchronous serial interfaces. See also:
- [D-sub (D-subminiature) Connectors](dsub.md) for pin numbering etc.
- "DIN-6" in [DIN](din.md) for Commodore (IEC) serial bus.

RS-232
------

[interfacebus.com's EIA-232 Bus page][ifb] is a _very_ complete reference.
This also incudes many pinout standards, including DB-25, DE-9 and 8P8C
below.

kayasan86's [ＲＳ２３２Ｃプロジェクト][kayasan86] contains a _lot_ of
useful information, including things like the "S parameter" on PC-8801
RS-232C configuration (in-band signal for kana on 7-bit links). Also
includes notes on accessing and saving to serial in BASIC on many Japanese
computers.



Standardised Pinouts
--------------------

### DB-25, DE-9

Pinouts [from Wikipedia][wp-serpin]. Signal names are from DTE point of
view (TX is transmit _from_ DTE _to_ DCE), so `dir` is DTE→DCE or DTE←DCE.

               DTE/DCE
    DE-9  DB-25  dir   color    Signal (DTE)
    ──────────────────────────────────────────────────────────────
      1     8     ←   yel+blk   DCD data carrier detect
      2     3     ←     grn     RX  recieve data
      3     2     →     red     TX  transmit data
      4    20     →     orn     DTR data terminal ready
      5     7     ↔     blk     GND
      6     6     ←     yel     DSR data set ready
      7     4     →     wht     RTS request to send
      8     5     ←     blu     CTS clear to send
      9    22     ←   wht+blk   RI  ring indicator
            1     ↔             PG  protective ground

My DE-9M/DE-9F crossover adapter does not connect pins 1 and 9.

### 8P8C ("RJ45")

With the contacts facing you and cable exiting down out of the connector,
the pins are numbered 1-8 left to right. Colours may be assigned via [T568A
or T568B][t568] but must be the same at both ends of a straight-through
cable. (A at one end and B at the other is a half-crossover cable;
_Ethernet crossover cables should never be used._)

There are two standards: Cisco/Yost and EIA-561. DB-25 pin numbers before
signal name, DE-9 pin numbers after. Sources: [Wikimedia image][wmcons],
[Cisco EIA/TIA-561][cisco561]. Signal names are always DTE viewpoint.

               connector         Color     │     │  EIA-561  │  Cisco
               facing up      T568A  T568B │ Pin │    DTE    │   DCE
              ────────────┐  ──────────────┼─────┼───────────┼─────────
             ╱ - - - -─── │1   /grn  /orn  │  1  │  6 DSR 6† │  CTS 8
    ─────────  -------─── │2    grn   orn  │  2  │  8 DCD 1  │  DSR 6
      cable    - - - -─── │3   /orn  /grn  │  3  │ 20 DTR 4  │   RX 2
      exit     -------─── │4       blu     │  4  │  7 GND 5  │  GND 5
      from     - - - -─── │5      /blu     │  5  │  3  RX 2  │  GND 5
    connector  -------─── │6    orn   grn  │  6  │  2  TX 3  │   TX 3
    ─────────  - - - -─── │7      /brn     │  7  │  5 CTS 8  │  DTR 4
             ╲ -------─── │8       brn     │  8  │  4 RTS 7  │  RTS 7
              ────────────┘

† Officially EA-561 pin 1 is `22 RI 9`, but RI is not in crossover adapters
and DSR seems more useful anyway so I connect that instead. Cisco also does
this.

The Cisco pinout matches [this USB serial cable][ugrcis]. The Cisco cable
can be "flipped" to create a serial crossover cable, but this is __NOT__
the same crossover as an Ethernet crossover cable (T568A to T568B above).


Vendor-specific Pinouts and Connectors
--------------------------------------

### 5V TTL USB Serial

Generic AliExpress FTDI USB cable with 6-pin .1" female header:

    1  red  +5 V    3  wht  RXD     5  yel  RTS
    2  blk  GND     4  grn  TXD     6  blu  CTS     (no DTR!)

ch341 HW-728 USB TTL board; HDM 340E932 SOIC-10:

    idVendor=1A86, idProduct=7523, bcdDevice= 2.63
    Mfr=0, Product=2, SerialNumber=0  Product=USB2.0-Serial

    1:GND   2:+5V   3:TXD   4:RXD   5:DTR   6:3V3

Z80 MBC2 TTL serial header:

    DCE: 1:DTR  2:RXD  3:TXD  4:Vcc  5:GND  6:N/C  7:RTS  8:CTS

uTerm serial header:

    DTE:  1:DTR  2:RXD  3:TXD  4:Vcc  5:GND  6:N/C  7:RTS  8:CTS

### Apple IIc Serial DIN-5 (cjs v1)

Using Ethernet cable. `Dsub` are my DB-25/DE-9 colors above; `Eth` is
Ethernet cable colors. Orange and green stripe are tied together for
ground.

     Dsub  Eth    pin dir  sig  description
     orn   blue    1  out  DTR  Data Terminal Ready (orange on DB-25/DE-9)
     blk   stripe  2   -   GND
     yel   brown   3  in   DSR  Data Set Ready; input to DCD on ACIA (yel on DB-25/9)
     red   orange  4  out  TD   Transmit Data (red on DB-25/DE-9)
     grn   green   5  in   RD   Receive Data

For [ADTPro], use a cable with hardware handshaking disabled by tying
together DTR and DSR (1 and 3, DIN numbering) on the Apple side, and
RTS and CTS (7 and 8) on the PC side. Here's the DE-9 pinout, looking
into the male connector on the PC and the female jack on the IIc:

    1 2 3 4 5       PC    Apple IIc        ∪
     6 7 8 9                          3         1
             /-- DCD 1 ←                5     4
             |    RD 2 ←  4 TD             2
             |    TD 3  → 5 RD
             +-- DTR 4  →
             |   GND 5    2 GND
             \-- DSR 6 ←
             /-- RTS 7  →
             \-- CTS 8 ←
                 RI  9 ←
                        ← 1 DTR -\
                        → 3 DSR -/



<!-------------------------------------------------------------------->
[adtpro]: http://adtpro.com/connectionsserial.html#DIN5
[cisco561]: https://www.cisco.com/c/en/us/td/docs/routers/ir510-ir530/hig/ir5X0_wpan_HIG.html#pgfId-343777
[ifb]: http://www.interfacebus.com/Design_Connector_RS232.html
[kayasan86]: http://kasayan86.web.fc2.com/old/rs232c1.html
[t568]: https://en.wikipedia.org/wiki/Ethernet_crossover_cable#Pinouts
[ugrcis]: https://www.amazon.co.jp/dp/B072K572P6/
[wmcons]: https://commons.wikimedia.org/wiki/File:DE-9_to_8P8C_console_cable_pinouts.svg
[wp-serpin]: https://en.wikipedia.org/wiki/Serial_port#Pinouts

