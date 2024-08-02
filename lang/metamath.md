Metamath
========

[Metamath] is an extremely simple and low-level language for "rigorously
verifying, archiving, and presenting mathematical proofs." The [Metamath
Proof Explorer Home Page][pexp] is a good place to start to get an
overview. The [book], _Metamath: A Computer Language for Mathematical
Proofs_ (Norman Megill, 248 pp.) provides tutorials and in-depth
information. It's available in several formats, including [PDF][book-pdf].


The Metamath Language
---------------------

All § references below are to the _Metamath_ book.

Misc:
- All tokens must be surrounded by whitespace.
- `$(`,`$)`: comment (no nesting)
- `$[`,`$]`: file inclusion
  - only in outermost scope and not in statement
  - no `$` or space in filename
  - later refrences to same file are not included again; self-ref is ignored

_Statements:_
- `${`,`$}` begin/end block (zero or more tokens; may contain blocks).
  - __Outermost block__ is outside these.
- `$v` _math-symbol_ … `$.`: __declare__ variable(s)
  - becomes __active__ when declared, __inactive__ when block ends
- `$c` _math-symbol_ … `$.`: as `$v` but for constant(s)
  - must be in outermost block
- `$d`: _disjoint/distinct variable restriction_

_Hypotheses:_
- _label_ `$f` _typecode_ _actvar_ `$.`: __varible-type__ (floating)
  - expresses nature or __type__ of var ("let _x_ be an integer")
  - must be used to set type of var before var is used in `$[eap]`
- _label_ `$e` _typecode_ _actvar_ … `$.`: __logical__ (essential)
  - expresses logical truth ("assume _x_ is prime") that must be established

_Assertions:_
- _label_ `$a` _typecode_ _sym_ … _sym_ `$.`:
  - __Axiomatic assertion,__ referenced by its _label._ Usually syntax,
    axiom (typ. "af-…") or definition (typ. "df-…") of ordinary
    mathematics.
- _label_ `$p` _typecode_ _sym_ … _sym_ `$=` _proof_ `$.`:
  - __Provable assertion.__ A claim followed by its proof.
  - _proof_ may be `?` when entirely unknown; the verifier will accept but
    warn about this. Compressed proof data may have `?`s in it for
    partially developed proofs. (§4.4.6)

Other:
- `|-`: "is a theorem"/"the following is provable" (def. w/`$c |- $.`?)



<!-------------------------------------------------------------------->
[Metamath]: https://us.metamath.org/
[book-pdf]: https://us.metamath.org/downloads/metamath.pdf
[book]: https://us.metamath.org/#book
[pexp]: https://us.metamath.org/mpeuni/mmset.html
