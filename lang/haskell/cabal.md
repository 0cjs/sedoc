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
- `${XDG_CACHE_HOME:-$HOME/.cache}/cabal/`: downloaded packages and script
  executables. This may be removed at any time; it will be rebuilt when
  necessary.
- `${XDG_STATE_HOME:-$HOME/.local/state}/cabal/`: Cabal store, compiled
  artifacts, etc. Removing this may cause installed programs to stop
  working.
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

If the `--project-dir` opton is given, Cabal searches for `cabal.project*`
files in just that directory. Without that option, it will search the
current working directory and every parent directory up to the root.

The existence of a `project.cabal*` file(s) found by Cabal has several
implications:
1. The project directory will be set to the directory containing the
   `cabal.project*` file(s).
2. If a `cabal.project` file is found, the default `packages: .` setting
   will be removed. If you do not add an explict  `packages:` setting to
   `cabal.project` it will never find any .cabal files and you will recieve
   the (usually incorrect) message, "There is no <pkgname>.cabal package
   file or cabal.project file." Thus you must generally add `packages: .`
   or similar to `cabal.project` if it exists.
3. If you are using any `cabal.project*` files and you have not yet
   generated your .cabal files, you must use
   `--project-dir=path/to/empty/directory --with-compiler=…` when using
   commands such as `cabal update` or `cabal install`.

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


Cabal Files ("Configuration")
-----------------------------

XXX


Package Data Files
------------------

References:
- Neil Mitchell's Blog, ["Adding data files using Cabal"][mitch08]
- Cabal docs, [`data-files:`]
- Cabal docs, [1.7. Accessing data files from package code][cd§1.7]

The top-section of the .cabal file may contain a [`data-files:`] stanza
giving patterns whose matching files in the source repo will be included in
the run-time package and accessible at run time. These are relative to the
project directory by default; `data-dir:` can change this. (Similar stanzas
include `extra-source-files:`  and `extra-files:` for the source repo,
`extra-doc-files` for the generated Haddock generation, and
`extra-tmp-files:` to be removed by `cabal clean`.)

Wildcards are limited as follows. Use at least Cabal 3.8 or there will be
further limitations not documented here.
- The filename in the path may include a `*` wildcard, but only of the form
  `*.ext`: there must be a trailing file extension, and there cannot be any
  prefixes. So `…/chapter-*.html`, `…/foo*` and `…/*` are all not allowed.
- The path leading to the filename may include `**` wildcard (recursive
  matching) only as the final component before the filename, and the
  filename must use a `*` wildcard. Generally, always have a subfolder
  before the `**` wildcard because otherwise the search will be done from
  the top level, including `dist-newstyle/`, `.git/`, etc.

Cabal generates a module `Paths_PKGNAME` providing various functions to get
paths, `getBinDir ∷ IO FilePath`, `getDataDir ∷ IO FilePath`, etc. (This
can be found under an `autogen/` directory in the Cabal build dir.) The
commonly used function for this case is:

    getDataFileName :: FilePath -> IO FilePath
    getDataFileName name = do
      dir <- getDataDir
      return (dir `joinFileName` name)

It's not clear whether this correctly deals with `/` versus `\\` in the
arguments its given vs. the platform it's on. There may also be issues with
use during development; see below.

Other useful things provided there are `version ∷ Version` (see
[Data.Version]), `joinFileName` and `pathSeparator ∷ Char`.

There's also a `PackageInfo_PKGNAME` that exports `version ∷ Version` as
above, and `String`s  with information from the .cabal file: `name`,
`synopsis`, `copyright` and `homepage`.

#### Package Data Files During Development

According to GPT-5 mini, though the data paths point to the installed
location, using `cabal run` will change the paths to use the in-tree files.
It also suggests the "provide your own" solution below. It also appears
from the generated code that you can set `PKGNAME_datadir` in the
environment to override the path that `Paths_PKGNAME` will choose.

Back in 2008, [Neil Mitchell found][mitch08] that the above worked when
the package was installed, but not during development. (An examination
of a `Paths_*.hs` indicates that it references `~/.cabal/…`, which does
not even exist on the machine checked.)

Mitchell suggests adding your own `Paths_PKGNAME` module alongside your
other modules, such as the following which returns data paths as relative
to the current working directory:

    module Paths_myproject where

    getDataFileName :: FilePath -> IO FilePath
    getDataFileName = return

But it appears this may have worked because in development he was not
building with Cabal:

> While developing the program our hand-created Paths module will be
> invoked, which says the data is always in the current directory. When
> doing a Cabal build, Cabal will choose its custom generated Paths module
> over ours...



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

<!-- Packaging -->
[Data.Version]: https://hackage.haskell.org/package/base-4.21.0.0/docs/Data-Version.html
[`data-files:`]: https://cabal.readthedocs.io/en/stable/cabal-package-description-file.html#pkg-field-data-files
[cd§1.7]: https://cabal.readthedocs.io/en/stable/cabal-package-description-file.html#accessing-data-files-from-package-code
[mitch08]: https://neilmitchell.blogspot.com/2008/02/adding-data-files-using-cabal.html
