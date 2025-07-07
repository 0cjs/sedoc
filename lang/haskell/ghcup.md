GHCup - Find/Install GHC, Cabal, Stack and HLS Versions
=======================================================

[GHCup] is a stand-alone program that can download and install various
versions of GHC, Cabal, Haskell Stack and HLS (the Haskell Language
Server). These are stored under `~/.ghcup/`, with links to the executables
in `~/.ghcup/bin/`, which is expected to be added to your path.

### Installation

    sudo apt install -y \
        build-essential curl libffi-dev libffi8 libgmp-dev libgmp10 \
        libncurses-dev libncurses5 libtinfo5 pkg-config
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
    source ~/.ghcup/env     # Path setup

The get-ghcup script will ask various questions. Usual answers are:
1. Channel: Use `D`efault GHCup maintained to get tested versions of GHC
   etc. builds.
2. Experimental builds: generally no.
3. HLS: Only if you use editors or IDEs that use this.
4. Better integration with Stack: XXX need to discuss this below.


Locations and Tool Versions
---------------------------

`source ~/.ghcup/env` will add the GHCup bin directory and standard Cabal
bin directory (`~/.cabal/bin/`, where `cabal install` puts binaries) to the
_end_ of your path.
* Binaries with specific version numbers (Haskell`ghc-N.M.P` etc.) are always
  available.
- Using `ghcup set …` will make available "plain" binaries (`ghc` etc.);
  these can be disabled with `ghcup unset …`.
- System-installed "plain" binaries (`ghc`) will always override the
  `ghcup set …` versions.

The tools that GHCup provides (and settable with `ghcup set …`) are:

    ghc     Glasgow Compiler tools, including ghci etc.
    cabal   Cabal
    stack   Haskell Stack
    hls     Haskell Language Server


Usage
-----

Queries:

    ghcup list -c set           # What's available as `ghc` etc.
    ghcup list -c installed     # All installed tools
    ghcup list -t ghc           # All GHC versions available for install

Installation and removal:

    ghcup tui                   # Interactive interface.
    ghcup install ghc 9.6.6     # Install specific version.

Setting defaults (global for all commands run by the user!):

    ghcup set TOOL VERSION
    ghcup unset TOOL VERSION


Environment Variables
---------------------

See [environment variables] in the documentation for more details.

    GHCUP_USE_XDG_DIRS          see XDG support below
    GHCUP_INSTALL_BASE_PREFIX   the base of ghcup (default: $HOME)
    GHCUP_CURL_OPTS             additional options that can be passed to curl
    GHCUP_WGET_OPTS             additional options that can be passed to wget
    GHCUP_GPG_OPTS              additional options that can be passed to gpg
    GHCUP_SKIP_UPDATE_CHECK     Skip the (possibly annoying) update check
                                when you run a command
    CC/LD etc.



<!-------------------------------------------------------------------->
[GHCup]: https://www.haskell.org/ghcup/
[User Guide]: https://www.haskell.org/ghcup/guide/
[environment variables]: https://www.haskell.org/ghcup/guide/#env-variables
