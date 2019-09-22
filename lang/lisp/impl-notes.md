LISP Implementation Notes
=========================

### Maclisp (1974, Moonual)

Maclisp had two additional functions: `PLUS` took any numbers as
arguments and converted all to flonums if any one was a flonum,
otherwise returned fixnum or bignum depending on size. `+` took
fixnums only and did modular addition. Interestingly, with no args
`(+)` returned `0`, the identity element. Design or just fallout from
the implementation?

`(fix x)` and `(float x)` to convert to fixnum/bignum or
flonum. `(minus x)` returns the negative of its argument.

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
