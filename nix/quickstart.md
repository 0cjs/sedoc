Nix Quick Start
===============

This is in part based on the [Nix Reference Manual][n-ref].

Contents:
- nix-env
- First Steps
- Nix Subcommands

### Garbage Collection

Do a [gc][n-gc] with either of these; they are mostly the same:

    nix-collect-garbage             # can also delete old profiles
    nix-store --gc

`nix-collect-garbage -d` (or other appropriate arguments) seems to
replace `nix-env --delete-generations old`

To check the store:

    nix-store --gc --print-dead     # see what would be deleted
    nix-store --gc --print-live     # currently in use by profiles or other


nix-env
-------

The [old Quick Start][n18-quick] page suggests using `nix-env`; this is
apparently [considered a bad command][stop-nix-env] and with recent nixpkg
versions can [produce a lot of `trace: warning: …` notices][d-47862] (and
possibly do other incorrect things) when used without `-A`/`--attr-`.

Also, the notice from search.nixos.org:

> __Warning:__ Using nix-env permanently modifies a local profile of
> installed packages. This must be updated and maintained by the user in
> the same way as with a traditional package manager, foregoing many of the
> benefits that make Nix uniquely powerful. Using nix-shell or a NixOS
> configuration is recommended instead.

    nix-env --query                 # Show currently installed packages.
    nix-env --query --available     # Show available packages (very slow!).
                                    #   Lots of warnings; see above.

First Steps
-----------

### Ad-hoc Shell Environments

From the various [First Steps][nix-first] tutorials.

    export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive    # see errors.md
    nix-shell -p hello cowsay --run 'hello | cowsay Hello.'
    nix-shell -p hello cowsay                               # new subshell

Use <https://search.nixos.org> to find packages.

In an interactive `nix-shell` you may run `nix-shell -p …` again to get a
subshell with the additional package.

Using `nix-shell --pure` discards most environment variables, including
$PATH, making only the Nix-provided programs available. Generally not used
in development environments since you use a lot of local commands (`vim`,
etc.), but most packages depend on `coreutils` so all that (`ls` etc.) is
available.

For reproducible builds, you can specify a specific version of `nixpkgs`:

    nix-shell -p git --run "git --version" --pure \
      -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz

### Reproducable Scripts (nix shebang)

    #!/usr/bin/env nix-shell
    #! nix-shell -i bash --pure     # -i = interpreter for rest of file
    #! nix-shell -p hello cowsay
    #! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz

    hello | cowsay

### Declarative Shell Environments

Nix-shell with no args looks for `shell.nix` in the CWD, or you can give
it a path to a file.

    let
      nixpkgs
        = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
      pkgs = import nixpkgs { config = {}; overlays = []; };
    in

    pkgs.mkShellNoCC {
      packages = with pkgs; [ hello cowsay ];
      GREETING = "Hello, Nix!";                 # env var

      #   Optional startup commands; leaves you at a shell prompt after.
      shellHook = ''
          hello -g "$GREETING" | cowsay
      '';
    }

Not all env vars can be set; `nix-shell` sets e.g. $PS1 to its own thing.
This can be overridden in `shellHook`.

See the [`pkgs.mkShell`][p-mkShell] docs for more. It is a specialized
`stdenv.mkDerivation` that removes some repetition when used with
`nix-shell`/`nix develop`. The `mkShellNoCC` variant uses `stdenvNoCC`
(no C compiler) instead of `stdenv` as the base environment.

[Shell functions and utilities][p-shellfunc] may also be helpful for,
e.g., performing `@var@` or string substitutions on files in your build.

### Pinning Nixpkgs

This is convenient, and used often in examples, but does not give a fully
reproducible Nix expression:

    { pkgs ? import <nixpkgs> {} }:

The simplest alternative is to directly fetch the required Nixpkgs version
as a tarball specified via the relevant Git commit hash:

    { pkgs ? import (fetchTarball
            "https://github.com/NixOS/nixpkgs/archive/06278c77b5d162e62df170fec307e83f1812d94b.tar.gz"
        ) {}
    }:

The commit ID of the release you need can be found via [status.nixos.org];
this lists the latest commit that has passed all tests for each release.
Recommended is to follow the latest stable by using a specific version
number (`nixos-24.05`) or `nixos-unstable`.

More at [Pinning Nixpkgs][n-pins]. Described options include:
- `$NIX_PATH` environment variable
- `-I` option to `nix-build`, `nix-shell`, etc.
- `fetchurl`, `fetchTarball` or other [fetchers][p-fetchers] in Nix expressions.

Example URL values:

    http://nixos.org/channels/nixos-22.11/nixexprs.tar.xz
    channel:nixos-22.11                         # shorthand for above
    ./.                                         # ./default.nix

There is also an [`npins`] tool to help with this. It can import the old
`niv` files.


Nix Subcommands
---------------

New, experimental way of doing things; `man nix` for details. Subcommand
man pages are e.g. `man nix3-shell`.



<!-------------------------------------------------------------------->
[`npins`]: https://nix.dev/guides/recipes/dependency-management#dependency-management-npins
[d-47862]: https://discourse.nixos.org/t/after-updatting-from-23-05-to-24-05-i-get-graphical-bugs-and-nix-env-u-deprecated-warnings/47862/5
[n-gc]: https://nix.dev/manual/nix/latest/package-management/garbage-collection.html
[n-pins]: https://nix.dev/reference/pinning-nixpkgs
[n-ref]: https://nix.dev/manual/nix/latest
[n18-quick]: https://nix.dev/manual/nix/2.18/quick-start
[p-fetchers]: https://nixos.org/manual/nixpkgs/stable/#chap-pkgs-fetchers
[p-mkShell]: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell
[p-shellfunc]: https://nixos.org/manual/nixpkgs/stable/#ssec-stdenv-functions
[status.nixos.org]: https://status.nixos.org
[stop-nix-env]: https://stop-using-nix-env.privatevoid.net/
