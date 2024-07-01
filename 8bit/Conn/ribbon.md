Micro Ribbon ("Centronics") Connectors
======================================

Amphenol's [Micro Ribbon] connector, often referred to as "Centronics"
(especially with printers, standardised as [IEEE 1284]) has D-shaped casing;
- Jack: equal number of flat contacts on either side of the interior ring;
- Plug: a bar in the middle with flat contacts on top/bottom of the bar.
- Two sizes, with contact pitches of:
  - 0.085" (2.16mm): original size ("Centronics"); IEEE 1284 type B
  - 0.050" (1.27 mm): "mini-Centronics", "SCSI"; IEEE 1284 type C (also MDR36 or HPCN36

I call these:
- "MR-nn" (2.16mm): aka IEEE 1284 type B, Centronics
- "MRS-nn" (1.27mm): aka IEEE 1284 type C), MDR36, HPCN36
- IEEE 1284 includes a type A, which is DB-25.

Uses:
- MR-14: PC-88/MSX/etc. printer ports
- MR-24: IEEE 488 (GPIB, HP-IB, CBM) interface
- MR-36: IEEE 1284 parallel interface
- MR-50: RJ21X "telco" connector for multi-line telephone systems
- MR-50: SCSI-1 interface
- MRS-50: SCSI-2 interface

Wikipedia's [IEEE 1284] page has standard cable specs and wire colors.


Centronics Protocol
-------------------

Pins (computer view):
- Outputs:
  - Data 0-7
  - /STROBE
  - /Initialize: Pulse low; Epson/IBM printers will emit CR and set
    current line to top of page.
- Inputs:
  - /ACK
  - BUSY
  - Out of Paper
- Unknown:
  - Selected
  - /ERR
  - /Auto-Feed
  - /Select

1. Place data on data lines; wait 500 ns.
2. Wait for BUSY to go low.
3. /STROBE for min. 500 ns.
4. Hold data for min. 500 ns after /STROBE deasserted.
5. Optionally, go do something else while waiting for /ACK pulse
   (that should come just before BUSY is being released, and both
   deasserted at the same time).

### Pinouts

### References

- U.Illinois ECE 390, [13. Parallel Communcation][iu390]. Hardware
  (including simplified logic diagram of computer-side and printer-side
  interfaces), timing, PC BIOS/DOS, use for input.
- MD's Technical Sharing, [Capturing data from a Tektronix 1230 logic
  analyzer by emulating a parallel port printer][mindanh], 2014-02-02.
  Using a PIC to receive info, interpret Epson graphics escape codes and
  generate an image to an SD card.
- Seiko Epson, [Epson ESC/P Reference Manual][esc/p], 1997-12. Escape code
  and command list for 8- and 24-pin printers, including graphics, color
  and scalable fonts. (ESC/P 2, ESC/P and 9-pin ESC/P levels marked.)
  Missing 2nd half after command list.



<!-------------------------------------------------------------------->
[IEEE 1284]: https://en.wikipedia.org/wiki/IEEE_1284
[Micro Ribbon]: https://en.wikipedia.org/wiki/Micro_ribbon_connector

[esc/p]: https://web.archive.org/web/20140606195537/https://dl.dropboxusercontent.com/u/5881137/Epson%20escape%20codes.pdf
[iu390]: https://web.archive.org/web/20140921051412/https://courses.engr.illinois.edu/ece390/books/labmanual/parallel-comm.html
[mindanh]: https://web.archive.org/web/20151120075902/http://minhdanh2002.blogspot.com/2014/02/capturing-data-from-tektronix-1230.html
