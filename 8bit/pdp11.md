Digital PDP-11 Systems
======================

Systems
-------

"MMU" refers to the memory mapping and protection provided by some CPUs or
extra hardware such as the [KS11] on on the /20. This could be implemented
as a Unibus extension or apply to the CPU itself. Later systems provided
split I/D (instruction/data).

Timeline symbology:
- __U__ Unibus, __Q__ LSI-11 Bus.
- __n__ No MMU.
- __6__ 16-bit addressing, __8__ 18-bit, __2__ 22-bit.
- __ᵈ__ Split I/D.

Timeline of PDP-11/_nn_ systems:
- 1970-06: __/20 /15__ (Un6) 4/8 KB, 28KB max. 4K IO page at 28K. Clock
  State CPU control (only non-microcoded machine).
- 1972-06: __/10 /05__ (Un6) Cost-reduced succcessor to /20 /15.
- 1972-06: __/45__  (U8ᵈ) MMU optional. Up to 256K semiconductor RAM. Much
          faster. FP11 floating point coprocessor available.
- 1973-01: __/40 /35__ (U8) Faster successors to /20 /15.
- 1975-??: __LSI-11__ (Q6) 4-chip set for OEMs.
- 1975-03: __/70__ (U2ᵈ) Up to 4 MB physical RAM on private memory bus.
           Only system with Massbus. Best I/O throughput of any PDP-11.
- 1975-06: __/03__ (Q6) First DEC LSI/Q-bus system.
- 1975-09: __/04__ (U6) Cost-reduced /05.
- 1976-03: __/34__ (U8) Cost-reduced /35. Up to 256 KB Unibus memory.
- 1976-06: __/50__ (U8ᵈ) MOS memory for faster CPU than /45.
- 1976-06: __/55__ (U8ᵈ) Bipolor memory for yet faster CPU than /45.
- 1976-??: __LSI-11/2__ (Q6) Improved LSI-11 CPU board.
- 1977-06: __/60__ (U8) Higher-performance /40. Writable control store.
           FP in microcode, hardware FP avaialble.
- 1977-08: __/34a /34c__ Actually internal upgrades to /34 machines?
          "/34a supports fast FP option. /34c supports cache mem option."
- 1978-??: __PDT__ family, in card cage of VT100. Equiv. of 11/2.
           4 KB I/O page.
- 1979-??: __/23__ (Q2ᵈ) F-11 chipset.
- 1979-??: __/24__ (U2) Only F-11 Unibus model.
- 1979-??: __/44__ (U2ᵈ) Low-cost successor to /70. 256K-1MB RAM.
           Last non-microprocessor PDP-11.
- 1983-??: __/73__ (Q2ᵈ) First J-11 (MicroPDP-11), 15 MHz, integrated FPU.
- 1984-??: __/53__ (Q2ᵈ) Stripped down, slower /73. Deskside case.
- 1988-??: __/83__ (Q2ᵈ) 18 MHz J-11.
- 1988-??: __/84__ (U2ᵈ)
- 1990-??: __/93__ (Q2ᵈ) J-11, 2/4 MB RAM, 1 VUPS, fastest PDP-11
- 1990-??: __/94__ (U2ᵈ)

References:
- PDP-11 FAQ, [What different PDP-11 models were made?][faq-models]
- Computer History Wiki, [PDP-11 Models and notes][11mn]. This may have
  some errors in the dates.
- Wikipedia, [PDP-11: Models][wp]


General Programming
-------------------

References:
- [PDP-11 Architecture Handbook][hb-arch]
- wfjm, [DEC Manuals][wfjm]. Many manuals and other docs, some not on
  archive.org.


J11 Processor
-------------

XXX


<!-------------------------------------------------------------------->
[11mn]: https://gunkies.org/wiki/PDP-11
[KS11]: https://gunkies.org/wiki/KS11_Memory_Protection_and_Relocation_option
[faq-models]: https://web.archive.org/web/20160618161413/http://www.village.org/pdp11/faq.pages/11model.html
[wp]: https://en.wikipedia.org/wiki/PDP-11#Models

[hb-arch]: https://archive.org/details/pdp-11-architecture-handbook-dec-eb-23657-18
[wfjm]: https://wfjm.github.io/home/w11/info/manuals.html
