LISP Implementation Notes
=========================

### General Terminology

- _compiled open_: Compiled inline, rather than making a function call.
- _push-down list_, _PDL_: A stack.

### LISP I and 1.5

`(CAR A)` where `A` is an atom is always -1. (That's how you know it's
an atom.) Thus, `(CDR A)` is its property list.

If `COND` runs out of clauses an error is raised, unless it's at
the top level of a `PROG`.

Special forms in `PROG` are `COND`, `GO`, `RETURN`, `SETQ`, `SET`.

The description of "TEN" mode on the LISP-Flexo system in the 1960
_LISP I Programmer's Manual_ (p.75) is pretty hilarious. (Sample
session starts on p.79.) As is the rest of the stuff about how to
punch your decks.

### Maclisp (1974, Moonual)

Maclisp had two additional functions: `PLUS` took any numbers as
arguments and converted all to flonums if any one was a flonum,
otherwise returned fixnum or bignum depending on size. `+` took
fixnums only and did modular addition. Interestingly, with no args
`(+)` returned `0`, the identity element. Design or just fallout from
the implementation?

`(fix x)` and `(float x)` to convert to fixnum/bignum or
flonum. `(minus x)` returns the negative of its argument.

(§12.1) Top level function description. `toplevel` global contains the
form to be executed or, if `nil` system standard one is executed. That
sill store the result of last eval in `*` which references itself at
startup and after an error. `errlist` global is a list of forms to
execute on error.

### Maclisp (post-1974)

AIM-421 1977-09 Steele "Fast Arithmetic in MACLISP":
`PLUS` is generic; `+` is fixnum only, `+$` is flonum only.
`(DECLARE (FIXNUM I J K) (FLONUM (CUBE-ROOT FLONUM)))` for compiler.
Dropped small fixnums in tagged pointers because that needed format
check/convert before open-coded machine arithmetic instructions.
Avoided GC by pushing numbers on PDL (in same format as heap),
making subroutine call, then popping. Much stuff re safety of this.

### Interlisp (1974, Xerox manual)

(§13.1) Large integers and floating point numbers are 36 bits, and
boxed (stored in heap). Small integers have absolute value less
than 1536 and are boxed "by offsetting them by a constant so that they
overlay an area of INTERLISP's address sapce that does not correspond
to any INTERLISP data type. Thus boxing small numbers does not use any
storage, and furthermore, each small number has a unique
representation, so that `eq` may be used to check equality." (`eqp` or
`equal` must be used for large integers and floating point.)

(§13.0): "1000 is an integer, 1000. a floating point number, as are
1E3 and 1.E3. Note that 1000D, 1000F and 1E3D are perfectly legal
literal atoms." The '83 manual is perhaps more clear: "A litatom is
read as any string of non-delimiting characters that cannot be
interpreted as a number." (`%` was used as the escape character.)
