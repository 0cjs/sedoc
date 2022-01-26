Haskell Executable Entry Point / Main.main
==========================================

The default entry point for a Haskell program is `Main.main`; the `main`
definition must be a function that is an `IO ()` action. (The process exit
code defaults to "success"; it may be specified explicitly with one of the
actions from [`System.Exit`] if necessary:
- `exitSuccess ∷ IO a`; `exitFailure ∷ IO a`.
- `exitWith ∷ ExitCode → IO a`
  (construct `ExitCode` with `ExitSuccess` or `ExitFailure Int`).
- `die ∷ String → IO a`
  (writes given message to `stderr`, then `exitFailure`).
- [`System.Exit.Codes`] gives BSD `sysexits.h` definitions.

### main-is

GHC provides the [`-main-is <thing>`] option to specify a different module
and/or top-level definition for the entry point; give an identifier (`bar`
for `Main.bar`), module name (`Foo` for `Foo.main`) or both (`Foo.bar`).

The Cabal [`main-is: <filename>`] is an entirely different option that
gives the name of the `.hs` file (possibly generated from an `.lhs` or
other preprocessor) containing the main module. The module [must be named
`Main`][cabal#1847] unless `-main-is` is specified in `ghc-options:`. (From
`cabal-version: 1.18` you may specifiy a C/C++/objC source file instead.)

[hpack]'s `package.yaml` has a `main:` option that if given a filename will
set `main-is: Filename` in the Cabal file. If the parameter is not a
filename it is parsed similar to GHC above and `main-is: <module-name>.hs`
and `ghc-options: -main-is <thing>` are added to the Cabal file.

### Non-Haskell main()

GHC's [`-no-hs-main`] option suppresses the (C language) `main()` function
normally supplied by the RTS at link time, allowing you to link your own
`main()`. See the option documentation and [Using your own main()] for
more details, including how to use `ghc` to help link this.



<!-------------------------------------------------------------------->
[Using your own main()]: https://downloads.haskell.org/~ghc/9.2.1-rc1/docs/html/users_guide/exts/ffi.html#using-own-main
[`-main-is <thing>`]: https://downloads.haskell.org/~ghc/9.2.1-rc1/docs/html/users_guide/phases.html#ghc-flag--main-is%20%E2%9F%A8thing%E2%9F%A9
[`-no-hs-main`]: https://downloads.haskell.org/~ghc/9.2.1-rc1/docs/html/users_guide/phases.html#ghc-flag--no-hs-main
[`System.Exit.Codes`]: https://hackage.haskell.org/package/exit-codes-1.0.0/docs/System-Exit-Codes.html
[`System.Exit`]: https://hackage.haskell.org/package/base-4.16.0.0/docs/System-Exit.html
[`main-is: <filename>`]: https://cabal.readthedocs.io/en/3.6/cabal-package.html#pkg-field-executable-main-is
[cabal#1847]: https://github.com/haskell/cabal/issues/1847
[hpack]: https://github.com/sol/hpack
