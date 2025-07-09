GHCup - Find/Install GHC, Cabal, Stack and HLS Versions
=======================================================

[GHCup] is a stand-alone program that can download and install various
versions of GHC, Cabal, Haskell Stack and HLS (the Haskell Language
Server). These are stored under `~/.ghcup/`, with links to the executables
in `~/.ghcup/bin/`, which is expected to be added to your path.

The source is in the GitHub [`haskell/ghcup-hs`]; repo.
Do not confuse this with the deprecated `haskell/ghcup` code.

### Installation

    #   Commonly used by Haskell packages
    sudo apt install -y zlib1g-dev
    #   From `ghcup tool-requirements`.
    sudo apt install -y \
        build-essential curl libffi-dev libffi8 libgmp-dev libgmp10 \
        libncurses-dev libncurses5 libtinfo5 pkg-config
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org \
        | BOOTSTRAP_HASKELL_MINIMAL=1 \
          BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
          GHCUP_USE_XDG_DIRS=1 \
          sh

The "minimal" setting prevents modifying `.bashrc` etc. and the automatic
installation and setting-to-default of recommended GHC, Cabal etc.
versions.

It's best not to use `GHCUP_USE_XDG_DIRS=1` for several reasons:
- XDG dirs [do not work well for GHCup][issuecomment-1363335336].
- `GHCUP_USE_XDG_DIRS` must be set for _every use_ of both the GHCup
  installer and `ghcup` itself, or it will revert to using `~/.ghcup/`.
- You can't (easily) to remove all `ghc-N.M.x` etc. from your path
  because they are placed in `~/.local/bin/`.
- Sharing of ghcup into containers is more difficult.
- (For details, see `lib/GHCup/Utils/Dirs.hs`.)

If not using non-minimal interactive mode, you will be asked a fair number
of questions. Typical answers are:
1. Channel: Use `D`efault GHCup maintained to get tested versions of GHC
   etc. builds.
2. Experimental builds: generally no.
3. HLS: Only if you use editors or IDEs that use this.
4. Better integration with Stack: XXX need to discuss this below.

For more, see §"Installer Hacking" below.

#### Configuration

Configuration is stored in [`~/.ghcup/config.yaml`]. Later entries override
earlier ones; command-line options override the config file.

(If `GHCUP_USE_XDG_DIRS` is set, `~/.config/ghcup/config.yaml` is used
instead, but don't do this for reasons described in §"Installation" above.)

Typical changes you may want to make include:

    key-bindings:
        down:   { KChar: 'j' }  # Down/up arrow keys still work with this.
        up:     { KChar: 'k' }

    meta-cache: 86400           # Update meta cache daily, not every 5 min.


Locations and Tool Versions
---------------------------

`source ~/.ghcup/env` will add the GHCup bin directory and standard Cabal
bin directory (`~/.cabal/bin/`, where `cabal install` puts binaries) to the
_end_ of your path. (But also see `ghcup run` below.)

* Binaries with specific version numbers (Haskell`ghc-N.M.P` etc.) are
  always available.
* Using `ghcup set …` will make available "plain" binaries (`ghc` etc.);
  these can be disabled with `ghcup unset …`.
* System-installed "plain" binaries (`ghc`) will always override the
  `ghcup set …` versions.
* See `ghcup run` below for setting up with a specifc `ghc`/`cabal`/etc.
  at the _front_ of the path.

The tools that GHCup provides (and settable with `ghcup set …`) are:

    ghc     Glasgow Compiler tools, including ghci etc.
    cabal   Cabal
    stack   Haskell Stack
    hls     Haskell Language Server


Usage
-----

As well as specific version numbers (e.g., `9.8.2` for GHC), you can
use `recommended` and `latest` as version specifiers; listing the
versions available will also indicate which versions these are.

Queries:

    ghcup list -c set           # What's available as `ghc` etc.
    ghcup list -c installed     # All installed tools
    ghcup list -t ghc           # All GHC versions available for install

Installation and removal:

    ghcup tui                   # Interactive interface.
    ghcup install ghc 9.6.6     # Install AND SET specific version.
                                #   (--set is useless?)

Setting defaults (global for all commands run by the user!):

    ghcup set TOOL VERSION
    ghcup unset TOOL VERSION

Prepending toolchains to path:

    #   Run an arbitrary comand (`code` in this case) that wants to use
    #   just `ghc`, `cabal`, etc. by putting the paths for the appropriate
    #   versions at the *front* of the path before executing the command.
    ghcup run --install \
      --ghc 8.10.7 --cabal latest --hls latest --stack latest \
      -- code Setup.hs


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
[More on installation]: https://www.haskell.org/ghcup/guide/#more-on-installation
[User Guide]: https://www.haskell.org/ghcup/guide/
[`haskell/ghcup-hs`]: https://gitlab.haskell.org/haskell/ghcup-hs
[`~/.ghcup/config.yaml`]: https://github.com/haskell/ghcup-hs/blob/master/data/config.yaml
[bs]: https://github.com/haskell/ghcup-hs/blob/master/scripts/bootstrap/bootstrap-haskell
[environment variables]: https://www.haskell.org/ghcup/guide/#env-variables
[issuecomment-1363335336]: https://github.com/haskell/ghcup-hs/issues/729#issuecomment-1363335336
