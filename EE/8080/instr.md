8080/8085/Z80 Instruction Summaries
===================================

References at end of file.

All 16-bit operands are stored little-endian. Timings are given as total T
cycles followed by the T-cycle count for each M-cycle.


8080
----

- `CP n` / `CPI`: flags ← A - n; SZHP(V)C affected, (N) set.
  - `FE` 7 (4,3)
- `LD HL,nnnn` / `LXI H,nnnn`: HL ← nnnn
- `LD (nnnn),A` / `STA nnnn`: (hhll) ← A
  - `32 nn nn` 13 (4,3,3,3)


Z80 Only
--------

Includes new ops in main area and $EDxx prefix.
Does not yet include bit ops ($CBxx), IX reg ($DDxx), IY reg ($FDxx).

- Data moves:
  - Absolute indirect: `ld (ad16),rr`, `ld rr,(ad16)`
  - Refresh register: `ld r,a`, `ld a,r`
  - Register exchange: `ex (sp),ix`, `ex af,af'`, `exx`
- Arithmetic and logic:
  - 2's complement: `neg`: A ← 0 - A (1's comp is `cpl`/`CMA`)
  - HL 16-bit: `adc hl,rr`, `sbc hl,rr`
  - `rld`: 4-bit left rotataion of 8-bit value (HL) and A
- Relative jumps: `jr a8`, `jr z,a8`, `jr nz,a8`, `jr c,a8`, `jr nc,a8`
- Loop:
  - `djnz a8`: decrement B, jump relative if B ≠ 0.
  - `ldi`: (DE) ← (HL), HL++, DE++; BC--; `ldir` repeats until BC=0 [PM 184]
  - `cpi`: `CP (HL)`, HL++, BC--; `cpir` repeats until A=(HL) _or_ BC=0
  - `ini`: (HL) ← port(C), HL++, B--; `inir` repeats until B=0
  - `outi`: port(C) ← (HL), HL++, B--; `otir` repeats until B=0
  - HL--, DE-- equivalents (B/BC still --):
    - `ldd`, `cpd`, `ind`, `outd`,
    - `lddr`, `cpdr`, `indr`, `outdr`
- Indirect in/out: `in r,(c)`, `out (c),r`
- Interrupt:
  - `reti`: return from interrupt
  - `retn`: return from NMI
  - `im0`, `im1`, `im2`: set interrupt mode


References
----------

Numbers given in references above are the PDF scan page numbers.

Manuals:
- \[8080] [Intel 8080 Assembly Language Programming Manual Rev.B (1975)][8080],
  1975-09.
- \[ISIS] Intel ISIS-II [8080/8085 Assembly Language Programming Manual][ISIS],
  1981-05.
  - Graphical instruction set guide on p. A-6 (P.194)
- \[PM] [_MOSTEK Z80 Programming Manual v2.0_][PM], Mostek Corporation, 1978.
  This integrates the errata from p.iv of the original edition.
- \[MR] [_MOSTEK Z80 Microcomputer System Micro-Reference Manual_][MR],
  Mostek Corporation, 1978.

Websites:
- z80 Heaven, [Instruction Set][z80h-instr], [Opcode Reference Chart][z80h-op].
  Alphabetical list of instrs and table of opcodes, each linked to
  individual page w/clear explanation of each instruction.
- baltazarstuidios.com, [Z80-Opcode-Tables][balt].
  PDF with clearer version of opcode chart above.




<!-------------------------------------------------------------------->
[8080]: https://archive.org/details/intel-8080-assembly-language-programming-manual-1975
[ISIS]: https://archive.org/details/bitsavers_intelISISIssemblyLanguageProgrammingManualMay81_7150831/mode/1up
[MR]: https://archive.org/stream/Mostek_Z80_Microcomputer_Micro-Reference_Manual_1978_Mostek_Corporation#page/n2/mode/1up

[balt]: https://baltazarstudios.com/webshare/A-Z80/Z80-Opcode-Tables.pdf
[z80h-instr]: https://baltazarstudios.com/webshare/A-Z80/Z80-Opcode-Tables.pdf
[z80h-op]: http://z80-heaven.wikidot.com/opcode-reference-chart
