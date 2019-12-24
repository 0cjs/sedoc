MACLISP
=======

References:
- David Moon, [_Maclisp Reference Manual_][moonual] revision 0.
  Project Mac, MIT. 1974-04.

Implementations:
- ITS: MIT AI Lab DEC PDP-10
- Multics: Project MAC Honeywell 6180 (GE-645)
- DEC-10 : TOPS-10 on PDP-10 (and Tenex via TOPS-10 emulator)


Language
--------

Reader:
- Usually mixed case, but upper-case only systems accept input in
  lower case and translate it to upper.
- `'foo` is expanded by the reader to `(quote foo)`.
- `;` for comment; it and rest of line is discarded.

The general classes of types and objects are
- Atomic: numbers, atomic symbols, strings, subr-objects.
- Non-atomic: structures constructed out of other objects.
- Composite: indivisible objects with subcomponents that can be
  extracted and modified but not removed.

Types:
- _fixnum_: Signed fixed-point binary integer, size of machine word
  (usually 36 bits). In more general usage includes bignum as well.
  Sequence of digits, usually octal; end with `.` for decimal.
- _flonum_: Machine floating-point number. Digits containing embedded
  or leading `.` and/or trailing exponent using `e` or `E`.
- _bignum_: Arbitrary-precision integer; never overflows.



<!-------------------------------------------------------------------->
[moonual]: https://en.wikipedia.org/wiki/David_A._Moon
