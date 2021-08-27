Serial Interfaces
=================

This covers RS-232-style asynchronous serial interfaces. See also:
- [D-sub (D-subminiature) Connectors](dsub.md) for pin numbering etc.
- "DIN-6" in [DIN](din.md) for Commodore (IEC) serial bus.

kayasan86's [ＲＳ２３２Ｃプロジェクト][kayasan86] contains a _lot_ of
useful information, including things like the "S parameter" on PC-8801
RS-232C configuration (in-band signal for kana on 7-bit links). Also
includes notes on accessing and saving to serial in BASIC on many Japanese
computers.


DE-9 and DE-25 RS-232 Serial Ports
----------------------------------

Pinouts [from Wikipedia][wp-serpin]. Signal names are from DTE point of
view, so `dir` is DTE→DCE or DTE←DCE.

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


Apple IIc Serial DIN-5 (cjs v1)
-------------------------------

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
[wp-serpin]: https://en.wikipedia.org/wiki/Serial_port#Pinouts
[kayasan86]: http://kasayan86.web.fc2.com/old/rs232c1.html
