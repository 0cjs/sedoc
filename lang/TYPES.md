Language and Type Notes
=======================

XXX still in progress


In _reference-typed_ languages, the reference to storage has a type; and
the storage always exists with data in it, albeit the data may be
nonsensical or, for languages with null references, "not pointing to an
object."

In _value-typed_ languages, references are of type top type ⊤, inhabited by
all values of all types, or effectively untyped. These languages may or may
not have "null" references; interpreted languages such as Lisp, Python and
Ruby don't because `nil` and `None` are actual objects, not lack of an
object.
