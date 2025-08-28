Cabal Build Tools
=================

- [Documentation]: (searchable)

Version notes:
- ≥3.12: `cabal path` available

Quick hints:
- `cabal update` when `cabal build` can't find a package from Hackage.

### Directories and Files

For the user configuration file, [discovery][cfdisc] uses first found of:
- `--config-file`
- `$CABAL_CONFIG`.
- `$CABAL_DIR/config`.
- `~/.cabal/config` (if `~/.cabal/` dir exists, stop here?)
- `$XDG_CONFIG_HOME/cabal/config`, if $XDG_CONFIG_HOME set
- `$HOME/.config/cabal/config`

All data are stored in `$CABAL_DIR`, if set, or `~/.cabal/` if it exists,
otherwise:
- As above for user configuration.
- `$XDG_CACHE_HOME/cabal/`: downloaded packages and script executables.
  This may be removed at any time; it will be rebuilt when necessary.
- `$XDG_STATE_HOME/cabal/`: Cabal store, compiled artifacts, etc. Removing
  this may cause installed programs to stop working.
- `~/.local/bin/`: executables installed with `cabal install`.


cabal.project Files ("Configuration")
------------------------------------

The [`cabal.project`] configuration set is built from the last-found
of each setting in the following files, in order:

    ~/.config/cabal/config    # Actually user configuration; see above
    cabal.project
    cabal.project.freeze
    cabal.project.local

These files configure general details of the build such as the compiler to
use, optimization levels, and so on. Many fields share names with
command-line flags that do the same thing.

Related commands:
* [`cabal freeze`]: Creates `cabal.project.freeze` with repository
  information and a `constraints:` field locking all dependencies to
  specific versions.
* `cabal configure`: Writes new full config to `cabal.project.local`
  - E.g., `cabal configure -w ghc-9.8.1` will leave a file with only
    `ignore-project: False` and `with-compiler: ghc-9.8.1` in it.
  - Previous config ignored/wiped, but copied to `cabal.project.local~`,
    unless `--disable-backup` used.
  - Use `--enable-append` to insteda replace existing options in and append
    new options to the current config. (This still copies the previous
    config to `cabal.project.local~`.)
  - Probably `--enable-append --disable-backup` wants mainly to be used.

### Configuration Directives

The full list of configuration directives is in the [`cabal.project`]
documentation. The more important directives and notes on them are given in
sections relating to function below.

#### Local Packages

- There _must_ be a `packages` or `optional-packages` field listing the
  packages in this project to be built. If no `cabal.project` exists, this
  is taken to be `packages: ./*.cabal`.
- `optional-packages:`: As `packages:`, but packages that are not found are
  ignored, rather than being errors.
- `extra-packages:` External packages from Hackage, mainly designed to let
  you bring in non-dependencies for use in ghci etc.

__Note:__ Local packages always override packages with the same name from
Hackage, etc., including use as dependencies of external packages. (E.g.,
you can replace even `base` with your own local `base` package.) The manual
refers to this as _vendoring._

#### Build Outputs

There is a `--builddir=DIR` option; this _cannot_ be used in a
configuration file for [complex reasons related to caching][cabal-#5271].
(The sample `~/.cabal/config` or `~/.config/cabal/config` does include `--
builddir:`; despite this hint it will be ignored if set.)

Relative paths are relative to the root of the project (i.e., the directory
containing `cabal.project`).

There is also a `CABAL_BUILD` [environment variable]; this does _not_
affect the above. It's not clear what this does; it apparently affects
`dist/` but not `dist-newstyle/`.

#### Other Configuration Directives

- [Conditionals], except only at the top level (`*.cabal` can have them
  anywhere).
- Local packages (i.e., the ones built from this repo); see above.
- Dependencies from source code repositories: use
  [`source-repository-package`] stanzas. Directives within these stanzas
  include `type: git`, `location: URL`, `branch: NAME`, `tag: REF`,
  `subdir: PATH` and `post-checkout-command: …`.



<!-------------------------------------------------------------------->
[Documentation]: https://cabal.readthedocs.io/

[`cabal configure`]: https://cabal.readthedocs.io/en/stable/cabal-commands.html#cabal-configure
[`cabal freeze`]: https://cabal.readthedocs.io/en/stable/cabal-commands.html#cabal-freeze
[`cabal.project`]: https://cabal.readthedocs.io/en/stable/cabal-project-description-file.html
[`source-repository-package`]: https://cabal.readthedocs.io/en/stable/cabal-project-description-file.html#taking-a-dependency-from-a-source-code-repository
[`with-compiler:`]: https://cabal.readthedocs.io/en/stable/cabal-project-description-file.html#cfg-field-with-compiler
[cabal-#5271]: https://github.com/haskell/cabal/issues/5271
[cfdisc]: https://cabal.readthedocs.io/en/stable/config.html#configuration-file-discovery
[conditionals]: https://cabal.readthedocs.io/en/stable/cabal-package-description-file.html#conditional-blocks
[config]: https://cabal.readthedocs.io/en/stable/config.html
[environment variable]: https://cabal.readthedocs.io/en/stable/config.html#environment-variables
