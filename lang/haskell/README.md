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
- [Haddock](haddock.md).

Other handy stuff:
- [Pronounceable names for common Haskell operators][so 7746894]


Code Sources
------------

* GHC comes with a standard set of _boot packages._ Particularly important
  are [`base`][] (which is compiler-dependent, and includes the `Prelude`
  module) and  [`Cabal`].
* [Hackage] is the canonical distribution point for third-party packages,
  similar to PiPy for Python.
* [Stackage] provides sets of GHC and specific versions of packages known
  to work together. These sets are used as "snapshots" or "resolvers" for
  [Haskell Stack](./stack.md). These are always a subset of packages
  available from Hackage; see [Stackage Maintainers] for how to add a
  package to Stackage.


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
[ghcdoc]: http://www.haskell.org/ghc/docs/latest/html/users_guide/
[h.org-docs]: https://www.haskell.org/documentation/
[h2010-pdf]: https://haskell.org/definition/haskell2010.pdf
[h2010]: https://haskell.org/onlinereport/haskell2010/
[typeclass]: https://wiki.haskell.org/Typeclassopedia

[Hackage]: https://hackage.haskell.org/
[Stackage Maintainers]: https://github.com/commercialhaskell/stackage/blob/master/MAINTAINERS.md#adding-a-package
[Stackage]: https://www.stackage.org/
[`Cabal`]: https://hackage.haskell.org/package/Cabal
[`base`]: https://hackage.haskell.org/package/base

[so 7746894]: https://stackoverflow.com/q/7746894/107294
