LISP Bibliography
=================

Within the sections these are in (at least approximately)
chronological order.

### General

- John McCarthy, [Recursive functions of symbolic expressions and
  their computation by machine, Part I][mccarthy], Communications of
  the ACM Volume 3 Issue 4, April 1960.
- Berkeley and Bobrow (ed.), [_The Programming Language LISP: Its Operation
  and Applications_][prog64]. MIT Press. 1964-03. Elementary and
  advanced instruction; full listings for METEOR etc.
- Sussman and Steele, ["Scheme: An Interpreter for the Extended Lambda
  Calculus."][r0rs] AIM-349, MIT. 1975-12. Contains examples, theory
  and a detailed description of implementation, including
  multiprocessing.
- [_BYTE: LISP_ issue][byte7908]. Vol 04 No 08, August 1979.
- [SICP Interactive Version][isicp]


### Manuals

- [_LISP I Programmer's Manual_][lisp1.0]. 1960.
- [LISP 1.5 Programmer's Manual][lisp1.5] 2nd Ed. MIT Press, 1962. See
  §VII p.36 for internal data structures.
- John L. White, [_An Interim LISP User's Guide_][aim-190]. MAC
  AIM-190. 1970-03. MACLISP for the PDP-10. pp.34-39 cover the
  compiler and LAP assembler, both written in LISP.
- David Moon, [_Maclisp Reference Manual_][moonual] revision 0.
  Project Mac, MIT. 1974-04.
- Warren Tietelman, [_Interlisp Reference Manual_][interlisp74]. Xerox
  Palo Alto Research Center. 1974. (Formerly BBN LISP; originally
  developed on PDP-1 at Bolt, Beranek and Newman in 1966.)

### Internals and Implementation

- Guy Lewis Steele Jr., ["Data Representations in PDP-10
  MACLISP"][aim-420]. MIT AI Memo 420. 1977-09.
- StackOverflow, [Memory representation of values in Lisp][so 28128620].
- Stackoverflow, [Memory allocation in Lisp][so 6758308].
- Retrocomputing StackExchange, [How were Lisps usually implemented on
  architectures that has no stack or very small stacks?][rc 1681]

#### PDP-1

- Peter Deutsch, [PDP-1 LISP][pdp1-memo]. 4-page memo on how to load
  and use his implementation. "All numbers are octal integers: to
  input the number -1 it is necessary to type 777776."
* L. Peter Deutsch and Edmond C. Berkeley, DECUS 85 [The LISP
  Implementation for the PDP-1 Computer][pdp1], 1964.


#### Microcomputer Implementations

- Keith Packard, [A Tiny Lisp for AltOS][altos-lisp]. 25+3 KB ROM+RAM.
  RAM. Altus Metrum microcontroller STM32F042 (ChaosKey board,
  [AltOS]).
- S Tucker Taft, ["The Design of an M6800 LISP Interpreter."][taft79]
  _BYTE_ magazine Vol 04 No 08, August
  1979. p.132.
- [`stamourv/pikobit`][picobit], a very small Scheme for PIC18 and ARM.

#### Multiple

- Dusty Decks: Preserving historic software, [Category: LISP][dusty].
  Lots of links to different historical implementations, books,
  documents, etc.

#### Histories

- Guy Steele, ["The History of Scheme"][steele06] presentation slides.
  Sun Microsystems Laboratories. 2006-10. Implementation in LISP
  (simplified version of R0RS); FUNARG problem; actors; "A Sequence of
  AI Languages at MIT" (p.30).
- Steel and Gabriel, ["The Evolution of Lisp"][eol93] (uncut version).
  Proceedings of the Second ACM SIGPLAN Conference on History of
  Programming Languages (HOPL-II). 1993.

#### Related Languages

- Brian Harvey, [_Computer Science Logo Style _Volume 2:_ Advanced
  Techniques_][csls2]. MIT Press. 1997. This especially, but also the
  companion volumes I and III are great demonstrations of the power of
  Logo.



<!-------------------------------------------------------------------->

<!-- General -->
[altos-lisp]: https://keithp.com/blogs/AltOS-Lisp/
[byte7908]: https://archive.org/details/BYTE_Vol_04-08_1979-08_Lisp
[isicp]: https://xuanji.appspot.com/isicp/
[mccarthy]: https://dl.acm.org/citation.cfm?id=367199
[prog64]: http://www.softwarepreservation.org/projects/LISP/book/III_LispBook_Apr66.pdf
[r0rs]: https://web.archive.org/web/20171201033214/http://repository.readscheme.org/ftp/papers/ai-lab-pubs/AIM-349.pdf

<!-- Manuals -->
[aim-190]: http://www.softwarepreservation.org/projects/LISP/MIT/AIM-190-White-Interim_LISP_Users_Guide.pdf
[interlisp74]: https://archive.org/details/bitsavers_xeroxinterfMan_35779510
[lisp1.0]: http://history.siam.org/sup/Fox_1960_LISP.pdf
[lisp1.5]: http://web.cse.ohio-state.edu/~rountev.1/6341/pdf/Manual.pdf
[moonual]: https://en.wikipedia.org/wiki/David_A._Moon

<!-- Internals and Implementation -->
[aim-420]: https://dspace.mit.edu/bitstream/handle/1721.1/6278/AIM-420.pdf
[rc 1681]: https://retrocomputing.stackexchange.com/q/1681/7208
[so 28128620]: https://stackoverflow.com/q/28128620/107294
[so 6758308]: https://stackoverflow.com/q/6758308/107294

<!-- PDP-1 -->
[pdp1-alt]: https://archive.computerhistory.org/resources/text/DEC/pdp-1/DEC.pdp_1.1964.102650371.pdf
[pdp1-memo]: https://archive.org/details/bitsavers_mitrlepdp1P_420747
[pdp1]: https://www.computerhistory.org/pdp-1/_media/pdf/DEC.pdp_1.1964.102650371.pdf

<!-- Microcomputer Implementations -->
[altos]: https://altusmetrum.org/AltOS/
[picobit]: https://github.com/stamourv/picobit
[taft79]: https://archive.org/details/BYTE_Vol_04-08_1979-08_Lisp/page/n133

<!-- Multiple -->
[dusty]: https://mcjones.org/dustydecks/archives/category/lisp/

<!-- Histories -->
[eol93]: https://dreamsongs.com/Files/HOPL2-Uncut.pdf
[steele06]: https://web.archive.org/web/20190526064413/www-mips.unice.fr/~roy/JAOO-SchemeHistory-2006public.pdf

<!-- Related Languages -->
[csls2]: https://people.eecs.berkeley.edu/~bh/v2-toc2.html
