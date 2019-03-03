Haskell Stack
=============

The [Haskell Stack][docs] is a sandboxed cross-platform
dependency-management (including GHC itself) and reproducable build
system. It is built on top of the Cabal build system (but generates
the `.cabal` files and shares the underlying package format with Cabal
and [other tools]. Dependency management is normally done via a
curated standard set of packages specified with the `resolver` setting
in `stack.yaml`, though depndency-solving can also be used.

The [User guide] starts with an an intro/tutorial.

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
[docs]: https://docs.haskellstack.org/en/stable/README/
[installation]: https://docs.haskellstack.org/en/stable/install_and_upgrade/
[other tools]: https://docs.haskellstack.org/en/stable/GUIDE/#comparison-to-other-tools
[st-docker]: https://docs.haskellstack.org/en/stable/GUIDE/#docker
[user guide]: https://docs.haskellstack.org/en/stable/GUIDE/
