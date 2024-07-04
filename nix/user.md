Nix User Configuration
======================

Old versions of Nix use these legacy paths:

    ~/.nix-profile          symlink to current env
    ~/.nix-channels         file listing channels
    ~/.nix-defexpr/         (see nix-env(1) manpage)

Newer versions that support the [`use-xdg-base-directories`][n-xdg]
option directly use the following if it's set to `true`. (`$XDG_STATE_HOME`
defaults to `~/.local/state/` if unset.) With the default `false`, `false`,
new installations will still symlink the legacy paths to the XDG paths if
the legacy paths don't exist.

    ~/.nix-profile      →  $XDG_STATE_HOME/nix/profile
    ~/.nix-defexpr      →  $XDG_STATE_HOME/nix/defexpr
    ~/.nix-channels     →  $XDG_STATE_HOME/nix/channels


Profiles
--------

[Profiles][n-prof] are managed by `nix-env` (legacy, with [many
problems](./quickstart.md) or `nix profile` ("experimental"). They
are stored in:

    $NIX_STATE_DIR/profiles/per-user/root   # root user
    $XDG_STATE_HOME/nix/profiles/           # regular user
    ~/.nix-profile/                         # legacy regular user


Building Software
-----------------

Your project dir will have a `default.nix` in it; generally you'll also
want a `shell.nix` containing a [declarative shell environment][decshell]
for development, per [Dependencies in the development shell][r-sharedep].
Nix's [direnv][r-direnv] can be used to automatically launch a nix-shell
when entering the top-level dir of your project.


<!-------------------------------------------------------------------->
[decshell]: ./quickstart.md#declarative-shell-environments
[n-prof]: https://nix.dev/manual/nix/latest/command-ref/files/profiles
[n-xdg]: https://nix.dev/manual/nix/latest/command-ref/conf-file#conf-use-xdg-base-directories
[r-sharedep]: https://nix.dev/guides/recipes/sharing-dependencies
