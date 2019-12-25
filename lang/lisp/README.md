LISP Notes
==========

- [Bibliography](bibliography.md)
- [Implementation Notes](impl-notes.md)
- [MacLisp Reference](maclisp.md) from the Moonual


#### Concise Intro

From [A Concise Introduction to LISP][matuszek] by David L. Matuszek.

_Atoms_ are integers or identifiers. `NIL` is false and empty list,
and is both atom and list. `T` is the usual non-`NIL` true value. Any
atom immediately following a paren names a function.

Basic functions:
- `DEFUN` has three auto-quoted params: function name, parameter list
  and S-expression of function body. Returns name of function.
- `QUOTE`, `CAR`, `CDR`, `CONS`, `ATOM`, `NULL`.
- `EQ` to compare _atoms_ (only) for identity.
- `(COND (p1 c1) (p2 c2) (T cN))`; usu. error if no match.

Other functions:
- `'s` is `(QUOTE s)`
- Fundamental: `LIST`, `CAAR`, `CADR`, `CDAR`, `CDDR`, `SETQ`
- Lists: `LIST`, `(MEMBER a l)`, `APPEND`, `REVERSE`, `LENGTH`
- Predicates: `LISTP`, `NUMBERP`, `NOT` (= `NIL`), `EQUAL` (like `EQ`
  but can be used on anything), `ZEROP`, `PLUSP`, `MINUSP`, `EVENP`,
  `ODDP`.
- Arithmetic: `+`, `-`, `*`, all take 2+ args. `/` is reciprocal with
  1 arg, divide with 2+. `1+` (increment), `1-` (decrement).

I/O functions:
- `(LOAD f)`: Load a source file whose name without extension is _f_.
- `(DRIBBLE f)`: Record current session to file _f_. Pass no parameter
  to stop recording.
- `PRIN1`: Evaluate arg and print it on the current line.
- `TERPRI`: Print a newline.


[matuszek]: https://www.cis.upenn.edu/~matuszek/LispText/lisp.html
