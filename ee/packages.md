Device Packages
===============

Transistor Outline
------------------

JEDEC standardized:
- __[TO-18]:__ Largish metal case; 2-3 leads; tab is 45° from pin 1.
  E.g. original 2N2222 transistor.
- __[TO-92]:__ Common transistor package; cylindrical with flat side which
  is front. Leads 1-3 (read left to right when looking at front) at .05"
  (1.27mm) pitch. Typ. E-B-C for American devices, E-C-B for Japanese.
  E.g., 2N3904 NPN, PN2222A (plastic version of TO-18 2N2222).
- __[TO-220]:__ 3 through-hole leads with .1" pitch (2/4/5/7 lead variants
  avail.) and a heatsink "tab" with hole. E.g., 7805 linear voltage regulator.
- __[TO-252] / DPAK:__ Smaller variant of TO-263/D2PAK. 3-pins @2.3 mm
  pitch or 5 pins @1.1 mm pitch.
- __[TO-263] / D2PAK / DDPAK:__ Surface-mount version of TO-220 but with
  neither extended metal tab (covers back of device only) nor mounting hole.


IC Packages
-----------

                    Pin Pitch    Body Width
    Abbr.           in     mm    in  Wb  mm   Leads  Standards
    ───────────────────────────────────────────────────────────────────────
    SIPP            .1"   2.54
    DIP-W           .1"   2.54   .6"  15.24   24-64
    DIP-N           .1"   2.54   .3"   7.62    8-28

    SOIC            .05"  1.27         3.9           MS-012
    SOIC            .05"  1.27         7.5           MS-013
    SOP             .05"  1.27         5.3

    SSOP            .025  0.635
    TSOP Type I                        0.55   28
    TSOP Type I                        0.5    28-56
    TSOP Type II          1.27        10.16   20-32
    TSOP Type II          0.8         10.16   40-54
    TSOP Type II          0.65        10.16   66

    HSOP 20ld             1.27        11.00   20     gull wing, heatsink
    HSOP 30ld             0.80        11.00   30     gull wing, heatsink
    HSOP 44ld             0.65        11.00   44     gull wing, heatsink

### Lead Styles

- _Through Hole_: [DIP], ZIP.
- [_Chip carrier_][wp cc] packages (e.g., PLCC) usually have connectios on
  all four sides and either J-leads curling inward (which can be soldered
  to the surface of a PCB) or are _leadless_ with metal pads (requiring a
  socket).
- [_(Quad) flat pack_][wp fp] (QFP) have gull wing (or "S") leads on all
  four side and are soldered to the surface of a PCB. Pin spacings are
  typically 50, 30 and 20 [mil][] (1.27, 0.51 and 0.30 mm)

### 0.1"/2.54mm lead spacing:

- [SIP]/SIPP: Single In-line (Pin) Package. Mainly RAM and resistor blocks.
- [DIP]/PDIP: (Plastic) Dual In-line Package.
- [QIP]/QIL: Quad In-line Package. Half-pitch leads but staggered outward
  into two rows, .1" apart.

### 0.05"/1.27mm lead spacing

- [SOIC]: JEDEC  Small Outline Package. MS-012 Wb=5.3, MS-013 Wb=7.5.
  Also Wb=6.52, Wb=6.57 versions from TI.
- [SOP]: EIAJ Small Outline Integrated Circuit. Wb=3.9. EIAJ (Japan).
  EIAJ TYPE II is wider, Wb=7.5.
- SOJ: SOIC with J-leads curving inward.
- [ZIP]: Zig-zag in-line package. Through-hole two-row with each pin .05"
  from the next but alternating rows, providing more spacing between pins.
  Leads project from the edge of the package, which sits "vertically."

### Smaller lead spacing

- SOP/PSOP: (Plastic) Small-Outline Package.
- SSOP: Shrink Small-Outline Package.
- [TSOP]: Thin Small-Outline Package. Type I have leads on the shorter
  side, Type II on the longer.
- [TSSOP]: Think-Shrink Small-Outline Package.


Sources
-------

- [JEDEC] \(JEDEC Solid State Technology Association)
  - [MS-012] Plastic dual small outline gull wing, 1.27 mm pitch package.
  - [MS-013] Very thick profile, Plastic dual small outline family,
    1.27 mm pitch package, 7.5 mm body width.
- [JEITA] (Japan Electronics and IT Industries Association), previously
  [EIAJ] (Electronic Industries Association of Japan)
  - [Semiconductor Device Packages][JEITA sdp]
- [TI Analog and Logic Packging Information][ti pkginfo]
  - [Terminology][ti terms]
  - [DIP Specifications][ti dip]. Useful to sort by pin count.
  - [SO (Small Outline) Specifications][ti so]. Useful to sort by pin
    count.
- Freescale Semiconductor, [AN2388] Heatsink Small Outline Package (HSOP).
- Vishay, [SOIC Packages (Narrow and Wide Body)][vishay]
- Wikipedia
  - [Dual in-line package][DIP].
  - [Small outline integrated circuit][SOIC].
    Was quite wrong about "SOP," but I fixed it.
  - [Thin Small Outline Package][TSOP].

Identification/Logos:
- [Elnec IC Logos](https://www.elnec.com/en/support/ic-logos/)
- [Fandom How-to Wiki](https://how-to.fandom.com/wiki/How_to_identify_integrated_circuit_(chip)_manufacturers_by_their_logos). Includes list of reference sites.



<!-------------------------------------------------------------------->

<!-- transistor -->
[TO-18]: https://en.wikipedia.org/wiki/TO-18
[TO-92]: https://en.wikipedia.org/wiki/TO-92
[TO-220]: https://en.wikipedia.org/wiki/TO-220
[TO-252]: https://en.wikipedia.org/wiki/TO-252
[TO-263]: https://en.wikipedia.org/wiki/TO-263

<!-- generic terms -->
[DIP]: https://en.wikipedia.org/wiki/Dual_in-line_package
[QIP]: https://en.wikipedia.org/wiki/Dual_in-line_package#Quad_in-line
[SIP]: https://en.wikipedia.org/wiki/Dual_in-line_package#Single_in-line
[SOIC]: https://en.wikipedia.org/wiki/Small_outline_integrated_circuit
[TSOP]: https://en.wikipedia.org/wiki/Thin_Small_Outline_Package
[TSSOP]: https://en.wikipedia.org/wiki/Small_outline_integrated_circuit#Thin-shrink_small-outline_package_(TSSOP)
[ZIP]: https://en.wikipedia.org/wiki/Zig-zag_in-line_package
[mil]: https://en.wikipedia.org/wiki/Thousandth_of_an_inch

<!-- sources -->

[EIAJ]: https://en.wikipedia.org/wiki/EIAJ
[JEDEC]: https://en.wikipedia.org/wiki/JEDEC
[JEITA sdp]: https://www.jeita.or.jp/cgi-bin/standard_e/list.cgi?cateid=5&subcateid=40
[JEITA]: https://en.wikipedia.org/wiki/JEITA
[MS-012]: https://www.jedec.org/system/files/docs/MS-012G-01.pdf
[MS-013]: https://www.jedec.org/system/files/docs/MS-013F.pdf

[AN2388]: https://www.farnell.com/datasheets/1853267.pdf
[ti dip]: http://www.ti.com/packaging/docs/searchtipackages.tsp?packageName=DIP
[ti pkginfo]: www.ti.com/analogpackaging
[ti so]: http://www.ti.com/packaging/docs/searchtipackages.tsp?packageName=SO
[ti terms]: http://www.ti.com/support-packaging/packaging-resources/packaging-terminology.html
[vishay]: https://www.vishay.com/docs/72130/tape_soic.pdf

[wp cc]: https://en.wikipedia.org/wiki/Chip_carrier
[wp fp]: https://en.wikipedia.org/wiki/Quad_flat_package
