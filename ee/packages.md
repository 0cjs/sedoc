IC Packages
===========

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

### 0.1"/2.54mm lead spacing:

- [SIPP]: Single In-line Package. Mainly RAM and resistor blocks.
- [DIP]/PDIP: (Plastic) Dual In-line Package.
- [QIP]/QIL: Quad In-line Package. Half-pitch leads but staggered outward
  into two rows, .1" apart.

### 0.05"/1.27mm lead spacing

- [SOIC]: JEDEC  Small Outline Package. MS-012 Wb=5.3, MS-013 Wb=7.5.
  Also Wb=6.52, Wb=6.57 versions from TI.
- [SOP]: EIAJ Small Outline Integrated Circuit. Wb=3.9. EIAJ (Japan).
  EIAJ TYPE II is wider, Wb=7.5.
- SOJ: SOIC with J-leads curving inward.

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
- Vishay, [SOIC Packages (Narrow and Wide Body)][vishay]
- Wikipedia
  - [Dual in-line package][wp dip].
  - [Small outline integrated circuit][wp soic].
    Was quite wrong about "SOP," but I fixed it.
  - [Thin Small Outline Package][wp tsop].



<!-------------------------------------------------------------------->
[EIAJ]: https://en.wikipedia.org/wiki/EIAJ
[JEDEC]: https://en.wikipedia.org/wiki/JEDEC
[JEITA sdp]: https://www.jeita.or.jp/cgi-bin/standard_e/list.cgi?cateid=5&subcateid=40
[JEITA]: https://en.wikipedia.org/wiki/JEITA
[MS-012]: https://www.jedec.org/system/files/docs/MS-012G-01.pdf
[MS-013]: https://www.jedec.org/system/files/docs/MS-013F.pdf

[ti dip]: http://www.ti.com/packaging/docs/searchtipackages.tsp?packageName=DIP
[ti pkginfo]: www.ti.com/analogpackaging
[ti so]: http://www.ti.com/packaging/docs/searchtipackages.tsp?packageName=SO
[ti terms]: http://www.ti.com/support-packaging/packaging-resources/packaging-terminology.html
[vishay]: https://www.vishay.com/docs/72130/tape_soic.pdf
[wp dip]: https://en.wikipedia.org/wiki/Dual_in-line_package
[wp soic]: https://en.wikipedia.org/wiki/Small_outline_integrated_circuit
[wp tsop]: https://en.wikipedia.org/wiki/Thin_Small_Outline_Package

