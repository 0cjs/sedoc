Nix Errors and Problems
-----------------------

nixpkgs not found
-----------------

    error: file 'nixpkgs' was not found in the Nix search path
        (add it using $NIX_PATH or -I)

This indicates that Nix cannot find the `nixpkgs` package repository. You
can confirm this with `nix-channel --list`. As the message says, you can
get an arbitrary one with e.g.,

    export NIX_PATH=nixpkgs=https://github.com/NixOS/nixpkgs/archive/74e2faf5965a12e8fa5cff799b1b19c6cd26b0e3.tar.gz

But probably more sensible is:

    nix-channel --add https://nixos.org/channels/nixpkgs-unstable
    nix-channel --update

References: [[so 73164546]]

[so 73164546]: https://stackoverflow.com/q/73164546/107294


nixbld group not found
----------------------

    error: the group 'nixbld' specified in 'build-users-group' does not exist

Probably a Debian install that's missing the `nix-setup-systemd` package.


Setting Locale Failed
---------------------

A command such as `nix-shell -p cowsay --run 'cowsay Hello'` produces:

    perl: warning: Setting locale failed.
    perl: warning: Please check that your locale settings:
            LANGUAGE = (unset),
            LC_ALL = (unset),
            LC_COLLATE = "C",
            LANG = "en_US.UTF-8"
        are supported and installed on your system.
    perl: warning: Falling back to the standard locale ("C").

Note that `LANG` is set here; the issue is that the local database is not
available. It's not entirely clear what's going on with this, but the
commonly suggested solution is to

    #   In the external environment, to use your system's version
    export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

    #   To use the version that comes with the Nix glibc you're using
    nix-shell --pure --run \
      'export LOCALE_ARCHIVE="/nix/store/<hash>-glibc-<version>/lib/locale/locale-archive"; exec bash'

    #   In shell.nix (typically in the project root dir)
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";

    #   In flake.nix
    LOCALE_ARCHIVE = optionalString isLinux "${glibcLocales}/lib/locale/locale-archive";

Further references:
- NixOS/nixpkgs #38991 [glibc 2.27 breaks locale support][nn#38991].
  This references some other discussions as well.

[nn#38991]: https://github.com/NixOS/nixpkgs/issues/38991
