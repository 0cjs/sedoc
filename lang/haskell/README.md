Haskell
=======

General Documentation:
- The [Haskell.org Documentation page][h.org-docs] links to many things.
- [Haskell 2010 Language Report][h2010] also available [in PDF][h2010-pdf]
  and branch `h2010` of <https://github.com/haskell/haskell-report>.
- [GHC User Guide][ghcdoc].
- [The Typeclassopedia][typeclass].
- API searches with [Hoogle] and [Hayoo!].

SEDoc documentation pages:
- [Modules, Imports and Exports](module.md).
- [Haskell Stack](stack.md).


Language
--------

Expressions evaluate to a _value_ that has a (static) _type_. Values
and types are not mixed. Errors are semantically equivalant to ⊥
(bottom), and technically indistinguishable from non-termination, though
GHC provides exceptions for this.

Namespaces:
- Values: variables (lc) and value constructors (uc).
- Types: type variables (lc), type constructors (uc) and type classes (uc).
- Module names.

An identifier cannot name both a type constructor and type class in
the same scope.


<!-------------------------------------------------------------------->
[Hayoo!]: http://hayoo.fh-wedel.de/
[Hoogle]: http://www.haskell.org/hoogle/
[h.org-docs]: https://www.haskell.org/documentation/
[h2010-pdf]: https://haskell.org/definition/haskell2010.pdf
[h2010]: https://haskell.org/onlinereport/haskell2010/
[typeclass]: https://wiki.haskell.org/Typeclassopedia
[ghcdoc]: http://www.haskell.org/ghc/docs/latest/html/users_guide/
