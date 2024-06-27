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
