Haskell Modules, Imports and Exports
====================================

References:
- [Modules][h2010-modules]
- [Import][hw-import] on the Haskell Wiki.

Modules import and export _entities_: variables, value constructors,
types, etc. They may be mutually recursive. Modules themselves are not
first-class values.

Module names are a sequence of one or more capitalized identifiers,
separated by periods. The apparent hierarchy is a convention; the
namespace may be treated as flat.

Special modules (all of this may be tweaked):
- `Prelude`: fixed semantics; imported into all modules by default.
  - Prelude names must be explicitly hidden/not imported if you shadow them.
  - `import Prelude hiding (...)` to hide some names.
  - `import qualified Prelude` to qualify all Prelude names.
  - `import Prelude ()` to hide all Prelude names.
  - Prelude instances (`Show Char` etc.) cannot be hidden.
  - (`PreludeList`, `PreludeIO` etc. are not standard, just explanatory.)
- `Main`: (by convention) contains the top-level function `main`.
- The [Standard Library] is always present, and has fixed semantics.


Module Declaration
------------------

    module Mod.Name (exports) where
    import ...      -- body is import declarations
    ...             -- followed by top-level declarations

The first line can be left out; it will be assumed to be `module Main
(main) where`. Standard layout rules apply unless the first lexeme is `{`.


Import Declarations
-------------------

You need import only what you actually reference; associated types
etc. do not need to be mentioned. (The compiler will still need to
find them, of course.)

Unqualified imports import names at the top level of the importing
module and under the module name (`f` and `Mod.Name.f`). The latter
can be used to get around local shadowing.

    import Mod.Name                 -- import all entities at top level
    import Mod.Name hiding (...)    -- all but specified
    import Mod.Name (...)           -- only specified; () may be empty

The same module may be imported by more than one import declaration.

When explicitly specified, types/classes have their
constructors/methods/field names imported separately via parens
(`MyType (A, B)`); use `(..)` for all constructors functions. Data
constructors are hidden using only the name (`hiding (B)`).

Modules may have different local names with `as`:

    import Mod.Long.Name as MLN     -- still brings in bindings at top level too

Qualified imports do not create top-level bindings:

    import qualified A (f)                  -- A.f
    import qualified B as M (g)             -- M.g
    import qualified C as M (h)             -- M.h
    import qualified D as M hiding (g, h)   -- ok so long as no binding conflict

Name clashes can happen only for bindings that are referenced:

    module A (a,x) where ...
    module B (b,x) where ...
    import A; import B          -- Fine so long as `x` not referenced

If the same binding (to the same value) is exported into two different
modules and re-exported, it may be safely imported from both and used.

All instance declarations are always imported, since they do not
interfere with the local namespace.

The Haskell Wiki [Import modules properly][hw-proper] page gives
some tips on using `import` well.


GHC Import and Export Extensions
--------------------------------

These are detailed in [Import and export extensions][ghc-ex-impexp].

#### Hiding Bindings Not Exported

GHC allows `import A hiding (f)` when `A` does not export `f`. (This
is illegal in Haskell 2010.) `-W` or `-Wdodgy-imports` will warn when
hiding a non-exported binding.

#### Package-qualified Imports

The `PackageImports` extension (≥6.10.1) allows declarations to be
qualified by a package name. This disambiguates modules present in
multiple packages (including the current one vs. an external one).

    import "network" Network.Socket
    import "this" Network.Socket        -- Current package being built

#### Safe Imports

`Safe` (≥7.2.1), `Trustworthy` (≥7.2.1) and `Unsafe` (≥7.4.1) language
flags allow `import safe ...` etc. as used with [Safe Haskell].

#### Explicit Namespaces

The `ExplicitNamespaces` extension (≥7.6.1), implied by
`TypeOperators` and `TypeFamilies`, allows imports and exports of
[type operators] and [pattern synonyms] by preceeding the binding with
`type` or `pattern`.



<!-------------------------------------------------------------------->
[ghc-ex-impexp]: https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/glasgow_exts.html#import-and-export-extensions
[h2010-modules]: https://www.haskell.org/onlinereport/haskell2010/haskellch5.html
[hw-proper]: https://wiki.haskell.org/Import_modules_properly
[hw-import]: https://wiki.haskell.org/Import
[pattern synonyms]: https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/glasgow_exts.html#patsyn-impexp
[safe haskell]: https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/safe_haskell.html
[standard library]: https://www.haskell.org/onlinereport/haskell2010/haskellpa2.html
[type operators]: https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/glasgow_exts.html#type-operators
