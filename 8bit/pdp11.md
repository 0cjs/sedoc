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
- 1972-06: __/45__  (U8ᵈ) MMU optional. Up to 256K core RAM. Much faster. CPU.
           FP11 floating point coprocessor available.
- 1973-01: __/40 /35__ (U8) Faster successors to /20 /15. /45 architecture,
           but less power. Initially core memory, later MOS.
- 1973-07: __/50__ (U8ᵈ) Same KB11-A CPU as /45; faster due to MOS/fastbus mem.
- 1975-??: __LSI-11__ (Q6) 4-chip set for OEMs.
- 1975-03: __/70__ (U2ᵈ) Up to 4 MB physical RAM on private memory bus.
           Only system with Massbus. Best I/O throughput of any PDP-11.
- 1975-06: __/03__ (Q6) First DEC LSI/Q-bus system.
- 1975-09: __/04__ (U6) Cost-reduced /05.
- 1976-03: __/34__ (U8) Cost-reduced /35. Up to 256 KB Unibus memory.
- 1976-06: __/55__ (U8ᵈ) KB11-D CPU and bipolor memory; faster than /50.
- 1976-??: __LSI-11/2__ (Q6) Improved LSI-11 CPU board.
- 1977-06: __/60__ (U8) Higher-performance /40. Writable control store.
           FP in microcode, hardware FP avaialble.
- 1977-08: __/34a /34c__ Actually internal upgrades to /34 machines?
          "/34a supports fast FP option. /34c supports cache mem option."
- 1978-??: __PDT__ family, in card cage of VT100. Equiv. of 11/2.
           4 KB I/O page.
- 1979-??: __/23__ (Q2ᵈ) F11 chipset.
- 1979-??: __/24__ (U2) Only F11 Unibus model.
- 1979-??: __/44__ (U2ᵈ) Low-cost successor to /70. 256K-1MB RAM.
           Last non-microprocessor PDP-11.
- 1983-??: __/73__ (Q2ᵈ) First J11 (MicroPDP-11), 15 MHz, integrated FPU.
- 1984-??: __/53__ (Q2ᵈ) Stripped down, slower /73. Deskside case.
- 1988-??: __/83__ (Q2ᵈ) 18 MHz J11.
- 1988-??: __/84__ (U2ᵈ)
- 1990-??: __/93__ (Q2ᵈ) J11, 2/4 MB RAM, 1 VUPS, fastest PDP-11
- 1990-??: __/94__ (U2ᵈ)

Notes:
- Release dates are all over the place for the 11/50, from '73 to '76. But
  an 11/50 was [definitely shipped][rcse 28404] in Sept. '75 as DEC's
  50,000th system.

References:
- PDP-11 FAQ, [What different PDP-11 models were made?][faq-models]
- Computer History Wiki, [PDP-11 Models and notes][11mn].
  Definitely has some errors in the dates.
- Wikipedia, [PDP-11: Models][wp]


General Programming
-------------------

References:
- [PDP-11 Architecture Handbook][hb-arch]
- wfjm, [DEC Manuals][wfjm]. Many manuals and other docs, some not on
  archive.org.


J11 Processor
-------------

References:
- [DCJ11 Microprocessor User's Guide (preliminary)][j11-mugp]
- Original [PDP-11/HACK][madrona] ([archive][madrona-ar]): Breadboarded CPU, 16 KB RAM, console.
  - [HACK/128]: 128 KW version
- [5volts.ch PDP-11/Hack]: ECB bus (Eurocard connector) "QBUS64" system
  using CPLD glue logic, RL01/02 disk emulation. Runs RSX-11M-Plus.



<!-------------------------------------------------------------------->
[11mn]: https://gunkies.org/wiki/PDP-11
[KS11]: https://gunkies.org/wiki/KS11_Memory_Protection_and_Relocation_option
[faq-models]: https://web.archive.org/web/20160618161413/http://www.village.org/pdp11/faq.pages/11model.html
[rcse 28404]: https://retrocomputing.stackexchange.com/a/28404/7208
[wp]: https://en.wikipedia.org/wiki/PDP-11#Models

<!-- General Programming -->
[hb-arch]: https://archive.org/details/pdp-11-architecture-handbook-dec-eb-23657-18
[wfjm]: https://wfjm.github.io/home/w11/info/manuals.html

<!-- J11 Processor -->
[5volts.ch PDP-11/Hack]: https://www.5volts.ch/pages/pdp11hack/
[HACK/128]: https://web.archive.org/web/20161116035835/http://www.cs.ubc.ca/~hilpert/e/pdp11hack/pschranz.html
[j11-mugp]: https://archive.org/details/dcj11-microprocessor-users-guide-dec-1983-10-ek-dcj-11-ug-pre-preliminary
[madrona-ar]: https://web.archive.org/web/20161103213716/http://www.cs.ubc.ca:80/~hilpert/e/pdp11hack/index.html
[madrona]: http://madrona.ca/e/pdp11hack/index.html
