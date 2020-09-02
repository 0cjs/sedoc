8080/8085/Z80 Instruction Summaries
===================================

All 16-bit operands are stored little-endian. Timings are given as total T
cycles followed by the T-cycle count for each M-cycle.

Opcde lists: [85 193].


8080
----

- `CP n` / `CPI`: flags ← A - n; SZHP(V)C affected, (N) set.
  - `FE` 7 (4,3)
- `LD HL,nnnn` / `LXI H,nnnn`: HL ← nnnn
- `LD (nnnn),A` / `STA nnnn`: (hhll) ← A
  - `32 nn nn` 13 (4,3,3,3)


Z80 Only
--------

- `LDIR`: (HL) → (DE), HL++, DE++; BC--; repeat unless BC=0. [PM 184]
  - `ED B0`. BC≠0 21 (4,4,3,5,5), BC=0 16 (4,4,3,5)


References
----------

Numbers given in references above are the PDF scan page numbers.

- \[85] [_8080/8085 Assembly Language Programming Manual_][85], Intel, 1981
- \[PM] [_MOSTEK Z80 Programming Manual v2.0_][PM], Mostek Corporation,
  1978. This integrates the errata from p.iv of the original edition.
- \[MR] [_MOSTEK Z80 Microcomputer System Micro-Reference Manual_][MR],
  Mostek Corporation, 1978.



<!-------------------------------------------------------------------->
[MR]: https://archive.org/stream/Mostek_Z80_Microcomputer_Micro-Reference_Manual_1978_Mostek_Corporation#page/n2/mode/1up
[85]: https://archive.org/stream/bitsavers_intelISISIssemblyLanguageProgrammingManualMay81_7150831#page/n4/mode/1up
