Haskell Stack
=============

The [Haskell Stack][docs] is a sandboxed cross-platform
dependency-management (for compiler and libraries) and reproducable
build system. It can work with various lower-level build tools, most
commonly [Cabal]. The [User guide] starts with an an intro/tutorial,
and there is a [comparison with other tools][st-comparison].

A Stack _project_ is a directory containing a [`stack.yaml`] file
specifying project-specific configuration and sources for fetching
dependencies. Projects contain one or more [_packages_][st-package]
specified by a `.cabal` file or an [Hpack] `package.yaml` file.

The most usual source for dependencies is a curated GHC and standard
set of packages specified with the `resolver` setting in `stack.yaml`.
However, the resolver can specify just a specific compiler version
with no additional packages, and packages on [Hackage], Git URLs and
other sources can be added, with dependency-solving to find unlisted
dependencies.

Dependencies for packages within a project [must still be listed in
the package dependency specification][st-package-deps-twice]. The
_project_ package sources specification merely says, "_if_ you need to
build package `foo`, here's where you get it and what version you
use." The _package_ dependencies actually trigger fetching, building
and linking to a particular dependency.

Support is available for [building in a Docker image or with
Nix][st-docker], for build isolation giving consistent system
libraries, and for installing to a Docker image for deployment.

### Installation and Upgrade

Non-OS [installation] puts the binaries in `~/.local/bin/`.
Configuration, downloaded compilers and dependencies, etc. always go
in `~/.stack/`.

    curl -sSL https://get.haskellstack.org/ | sh
    wget -qO- https://get.haskellstack.org/ | sh

    stack upgrade       # Upgrade Stack itself (builds from source?)
    stack update        # Update the package index; usually done automatically


Project Commands
----------------

    stack templates     # list templates available for `stack new`

    stack new [--force] PACKAGE-NAME [TEMPLATE-NAME] [DIR]
    #   DIR defaults to current working directory
    #   --force overwrite existing stack.yaml

`stack build` can use `--resolver` to override the resolver specified
in `stack.yaml`; this is useful for testing against different versions
of compiler/libraries/etc. Common resolvers are `lts-X.Y`,
`nightly-YYYY-MM-DD`, and `ghc-X.Y.Z` for GHC with no additional
packages. All or a trailing part of the version number may be left off
to select the latest matching version.

A specific vesion of GHC can be installed with `stack setup VERSION`.

When using stack to build a non-Stack (e.g., regular Cabal) project,
do a `stack init` in the project directory first to create a
`stack.yaml` file based on the `.cabal` file; Stack will do its best
to select an appropriate resolver. `stack solver` can help solve
dependency issues.

Use `stack script` to reliably run source-only Haskell scripts (e.g., as
part of the build system).




<!-------------------------------------------------------------------->
[Hackage]: https://hackage.haskell.org/
[Hpack]: https://github.com/sol/hpack
[`stack.yaml`]: https://docs.haskellstack.org/en/stable/yaml_configuration/
[docs]: https://docs.haskellstack.org/en/stable/README/
[installation]: https://docs.haskellstack.org/en/stable/install_and_upgrade/
[st-comparison]: https://docs.haskellstack.org/en/stable/GUIDE/#comparison-to-other-tools
[st-docker]: https://docs.haskellstack.org/en/stable/GUIDE/#docker
[st-package-deps-twice]: https://docs.haskellstack.org/en/stable/stack_yaml_vs_cabal_package_file/#why-specify-deps-twice
[st-package]: https://docs.haskellstack.org/en/stable/stack_yaml_vs_cabal_package_file/
[user guide]: https://docs.haskellstack.org/en/stable/GUIDE/
