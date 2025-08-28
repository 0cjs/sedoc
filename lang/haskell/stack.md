Haskell Stack
=============

The [Haskell Stack][docs] is a sandboxed cross-platform dependency
management (for compiler and libraries) and sandboxed, reproducable build
system. As well as being able to fetch and use a given version of GHC, the
`stack.yaml` specifies _exactly_ the versions of third-party packages used
by the build.

Stack uses [Hpack] and the Cabal library for builds. Also see:
- [Other Haskell Tools][st-other]: Overview of tools in the Haskell
  ecosystem and how stack relates/compares to them. (A must-read!)
- ["stack.yaml versus package.yaml versus a Cabal file"][package-files]:
  Explain how Stack project configuration is separate from configuration
  of the package(s) in the project.
- ["Why is stack not cabal?"][boes15]: differences from `cabal-install`
- [FAQ]

[Installation] and updating. Note that this will automatically `sudo
apt-get install` any system packages that it needs, as well as install
`stack` to `/usr/local/bin/stack`.

    curl -sSL https://get.haskellstack.org/ | sh
    stack upgrade       # Upgrade Stack itself
    stack update        # Update the package index; usually done automatically

### Dependencies

Stack uses and always must have an _exact_ version of any dependency
specified in `stack.yaml`. This version number will come from one
of two settings specified in [`stack.yaml`]:

* `snapshot:` (or its alias `resolver:`), defining the GHC version, package
  version of packages available for installation, build flags, etc.
  - Typically an `lts-NN.MM` snapshot, but may also be
  - a nightly snapshot (`nightly-YYYY-MM-DD`),
  - no snapshot but just packages that came with GHC (`ghc-N.M.P`), or
  - a custom snapshot (URL or path).

* `extra-deps:` giving exact package versions from a package source,
  specified as
  - latest revision of a specific version from [Hackage] (`name-N.M.P…`),
  - exact revision of a specific Hackage version (`name-N.m.P…@rev:R`),
  - a URL for a tarball or a Git/Mercurial repo at a specific commit.

Package revisions available from the snapshot will be overridden by
`extra-deps:`. Missing packages or non-existent versions will cause a build
failure, usually with a suggestion about the versions available from
Hackage.

Dependencies for packages within a project [must still be listed in the
package dependency specification][st-package-deps-twice]. The _project_
package sources specification in `stack.yaml` merely says, "_if_ you need
to build package `foo`, here's where you get it and what version you use."
The _package_ dependencies actually trigger fetching, building and linking
to a particular dependency.

Extensive further tuning of the dependency management and build can be done
using both [project-specific configuration directives][`stack.yaml`] (which
may appear only in the project's `stack.yaml`) and [non-project-specific
directives][non-project] which may be in the project's configuration or
setting global configuration defaults (`~/.stack/config.yaml`). Examples of
common changes:

    compiler: ghc-9.8.2
    notify-if-nix-on-path: false

### Projects

A Stack _project_ is a directory containing a [`stack.yaml`] file
specifying project-specific configuration and sources for fetching
dependencies. Projects must also contain either a `package.yaml` file from
which `.cabal` files will be generated (via Hpack) or stand-alone `.cabal`
files.

Support is available for [building in a Docker image or with
Nix][docker], for build isolation giving consistent system libraries,
and for installing to a Docker image for deployment.


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

Use [`stack script`] to reliably run source-only Haskell scripts (e.g., as
part of the build system). (Compare with [Cabal's single-file Haskell
scripts][cab-script].




<!-------------------------------------------------------------------->
[FAQ]: https://docs.haskellstack.org/en/stable/faq/
[Hpack]: https://github.com/sol/hpack
[boes15]: https://academy.fpblock.com/blog/2015/06/why-is-stack-not-cabal/
[docs]: https://docs.haskellstack.org/en/stable/README/
[installation]: https://docs.haskellstack.org/en/stable/install_and_upgrade/
[package-files]: https://docs.haskellstack.org/en/stable/topics/stack_yaml_vs_cabal_package_file/#why-specify-dependencies-twice
[st-other]: https://docs.haskellstack.org/en/stable/tutorial/#other-haskell-tools

[Hackage]: https://hackage.haskell.org/
[`stack.yaml`]: https://docs.haskellstack.org/en/stable/configure/yaml/project/
[docker]: https://docs.haskellstack.org/en/stable/GUIDE/#docker
[non-project]: https://docs.haskellstack.org/en/stable/configure/yaml/non-project/
[st-package-deps-twice]: https://docs.haskellstack.org/en/stable/topics/stack_yaml_vs_cabal_package_file/#why-specify-dependencies-twice

[`stack script`]: https://docs.haskellstack.org/en/stable/topics/scripts/
[cab-script]: https://cabal.readthedocs.io/en/stable/getting-started.html#running-a-single-file-haskell-script
