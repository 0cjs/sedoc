DEC PDP-1
=========

Digital Equipment Corporation delivered the [PDP-1][wp] in Nov. 1960.
Models A and B were prototypes; C was the first released; D was an
improved version. The cycle time (single memory access) was 5
microseconds, about 200 Khz.


Architecture
------------

Numbers starting with `0` are octal.

- 1s complement arithemetic.
- 18-bit word size with bits numbered MSB 0 through LSB 17 (the
  opposite of the standard convention today).
- 12-bit addresses `0000..7777`. Memory module is 4096 words of
  core, but two memory controllers were available to manage up to
  four/eight 4 Kword modules. (Extends `PC` from 12 to 15/16 bits.)
- Registers etc. (also see [regdiag][]):
  - `AC` Accumulator, `IO` input/output.
  - `PC` Program counter.
  - Memory register holds word just read from mem (not generally accessible).
  - Overflow flag.
  - 6 "program flag" flip-flops
  - 6 console "sense" switches.
  - 18 console "test word" switches.
  - 15 console address switches.
- 1-channel "sequence break" system (interrupts); optional from 16-256.
- High speed channels option adds DMA.

Words were generally divided into:

### Instructions

Notation:  
- AC, IO registers. Y is address part of instruction (bits 5:17).
- DEC docs use C(AC)/C(Y) for contents of AC/Y; we don't bother here.
  (This may not be a good idea; AC ≠ Y vs. AC ≠ (Y)?)
- We use M(n) for contents of memory location _n_.
- AC‖IO: 35-bit double-precision. AC is MSW; sign bits at AC(0) and IO(17).

Bits `0`…`4` select the instruction.
- Memory Reference: `5` is "i" (indirect) bit, `6`‥`17` is address.
  Set `i` indicates load address from target core word; recurses.
- Augmented: `5`…`17` specify variants.

Load/store:
- `lac Y`: AC ← Y; load accumulator.
- `law N`: Load accumulator immediate from address word; `i` negates.
- `dac Y`: Y ← AC; deposit accumulator.
- `dip Y`: Y(0:4) ← AC(0:4); deposit instruction part.
- `dap Y`: Y(5:17) ← AC(5:17); deposit address part.
- `lio Y`: IO ← Y; load I/O register.
- `dio Y`: Y ← IO; deposit I/O register.
- `dzm Y`: Y ← 0; deposit zero to memory.
- `idx Y`: AC ← Y+=1. Index (increment).

Arithmetic/Logical:
- `and Y`, `ior Y`, `xor Y`: AC ← AC and/or/xor Y.
- `add Y`, `sub Y`: AC ← AC +,- Y.
  Sets overflow. -0 changed to +0 except -0 - +0 → -0.
- `mus Y`: Multiplication step. (Early machines; `mul` on later.)
- `dis Y`: Division step. (Early machines; `div` on later.)
- `mul Y`: AC‖I ← AC × Y. (Full multiply/divide; hardware option on early mach.)
- `div Y`: quotent AC, remainder I ← AC‖I ÷ Y. IO(17) ignored.

Skips:
- `isp Y`: Index (`idx Y`) and skip if positive (including -1→+0). No overflow.
- `sas Y`: PC+=1 if AC = Y. Skip if AC same.
- `sad Y`: PC+=1 if AC ≠ Y. Skip if AC differs.
- ...

Jumps:
- For the following "AC ← status" means:
  - AC(0) ← overflow.
  - AC(1) ← extend flip-flop. AC(2:5) ← extended PC.
  - AC(6:17) ← PC (pointing at following instruction).
- `jmp Y`: PC ← Y. Jump.
- `jsp Y`: AC ← status, PC ← Y. Jump and save program counter.
- `cal`: (i=0) M(0100) ← AC, AC ← status, PC ← #0101. Call subroutine.
- `jda Y`: (i=1, not indir) Y ← AC, AC ← status, PC ← Y+1.
   Jump and deposit AC. Same as `dac Y`, `jsp Y+1`.

Misc:
- `xct Y`: Execute; load instruction at Y and execute it. PC unchanged
  unless skip/jump executed. PC+=1 on skip-false, PC+=2 on skip-true.
  May use indirect.

### Macro Assembler

- Slash introduces comment.
- Number followed by slash sets PC: `77/`.
- Left paren before insn `and (-jmp` means what? XXX
- Labels are 1-3 lower case letters followed by comma.
- `define` and `termin` start and end macros. `define` takes a name
  and, optionally, a space and comma-separated arguments (upper case
  letters). `repeat` does arithmetic on args, e.g., `repeat 6, B=B+B`
  to shift B left by 6 bits.


Bibliography
------------

General:
* [PDP-1 Wikipedia Page][wp] (and lots of links from here)

Reference:
* [PDP-1 Handbook (HTML version)][handbook-html]
  Describes hardware, instructions, I/O equipment, etc.
  Includes instr and character code tables.
* [Register diagram][regdiag]
* [ISP][isp]: Instruction interpretation state machine.
  Serves as a good instruction reference.
* [greeng3@rpi.edu] Page w/above stuff, pictures, LISP listing/simulator.
* [Inside Spacewar! masswerk.at Instruction List][mass-instr]. Brief.
* MIT [PDP-35 PDP-1 Instruction list][pdp35] ([PDF][pdp35pdf]).
  Has extra instructions they added, e.g., `lxr` (12₈) to load index register

Programming:
* [Inside Spacewar!][mass-isw] (masswerk.at). Excellent detailed
  disassembly of Spacewar! game. Also many other resources.
* DECUS 85 [The LISP Implementation for the PDP-1 Computer][lisp].
  L. Peter Deutsch and Edmond C. Berkeley, 1964.



<!-------------------------------------------------------------------->
[handbook-html]: https://web.archive.org/web/20110514105011/http://www.dbit.com/~greeng3/pdp1/pdp1.html
[isp]: https://web.archive.org/web/20110514105000/http://www.dbit.com/~greeng3/pdp1/pdp1.isp
[mass-instr]: https://www.masswerk.at/spacewar/inside/pdp1-instructions.html
[mass-isw]: https://www.masswerk.at/spacewar/inside/
[pdp35]: https://archive.org/details/bitsavers_mitrlepdp1aug68_4111482
[pdp35pdf]: https://archive.org/details/bitsavers_mitrlepdp1aug68_4111482
[regdiag]: https://web.archive.org/web/20110514104923/http://www.dbit.com/~greeng3/pdp1/pdp1.rt
[wp]: https://en.wikipedia.org/wiki/PDP-1
[lisp]: https://www.computerhistory.org/pdp-1/_media/pdf/DEC.pdp_1.1964.102650371.pdf
