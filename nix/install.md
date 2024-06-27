Nix Installation
================

Nix may be installed in one of two ways.
- Multiuser (`--daemon`), where `/nix/` is owned by root and a Nix daemon
  manages the directory and does the builds. 
- Single user (`--no-daemon`), where `/nix/` is owned by a user whose tools
  manage the directory and do the builds.

In a multi-user configuration where you do not have the system starting
the daemon (e.g., in a Docker container), you can start it yourself with:

    sudo nix-daemon --daemon &

An installation is probably working if you can run (without errors)
`nix-store --gc` and `nix-shell -p cowsay --run 'cowsay Hello.'`. (The
latter will also expose missing locale databases.)


Vendor (NixOS.org)
------------------

The version from NixOS.org is almost invariably far more recent
than those supplied by packages from Linux distributions. Note that
doing a re-install without properly cleaning up from a previous install
may cause the install and the installation to break. At least part of
the cleanup can be done with:

    sudo rm -rf /nix/ ~/.nix-profile ~/.local/state/nix/

### Source Install

See [the manual][nix instsrc].

### Multi-User Binary Install

    sh <(curl -L https://nixos.org/nix/install) --daemon

### Single-User Binary Install

The single-user-mode install will invoke sudo to create the
`/nix/` directory if it doesn't exist; you can pre-create it
(owned by your account) if necessary. Install with:

    sudo apt install xz-utils
    sudo install -d -m 755 -o $(id -u) /nix/    # optional; install will do this
    sh <(curl -L https://nixos.org/nix/install) --no-daemon

Nix itself will be installed under `~/.nix-profile/{etc,bin,...}`
(actually simlinks to `~/.local/state/nix/…`) and the following
line will be added to `.bash_profile`:

    if [ -e /home/cjs/.nix-profile/etc/profile.d/nix.sh ]; then
        . /home/cjs/.nix-profile/etc/profile.d/nix.sh;
    fi # added by Nix installer

### Docker Containers

Bind-mount `/nix/` or `/nix/store/` plus the socket into the container?
See more at
<https://discourse.nixos.org/t/sharing-nix-store-between-containers/9733/5>


Debian
------

Multi-user only.
- `apt-get install nix-bin`
- Add yourself to the `nix-users` group.
- Add the default channel:

      nix-channel --add https://nixos.org/channels/nixpkgs-unstable
      nix-channel --update

If you use `--no-install-recommends` to exclude the `nix-setup-systemd`
package you can still run the daemon with `sudo nix-daemon --daemon &`. But
you will get complaints about the missing `nixbld` group and perhaps
missing `nixbld*` users. Further, for some reason `nix-channel --update`
doesn't work. Probably just don't do this.

In Docker containers, the Debian package (with `nix-setup-systemd`) brings
with it quite a number of extra packages, including `util-linux-locales`
(probably fine) and various `systemd-*` and `dbus` (probably unwanted). But
these seem to do no harm and `nix-setup-systemd` seems required for proper
operation (see above).

Arch
----

For the native package, `nix`, you will need some manual configuration.
This is discussed in §2 on the [wiki page][arch], but includes setting up
the channels:

    nix-channel --add https://nixos.org/channels/nixpkgs-unstable
    nix-channel --update

It also discusses other methods, including:
- The upstream (vendor) script, `https://nixos.org/nix/install`, described
  in this file in its own section above.
- The "Zero to Nix" script provided by Determinate Systems, a company
  providing third party support for Nix.
- The Lix script provided by passionate Nix community members aiming for
  improvements in Nix ecosystem by providing a hard fork version from the
  Nix package manager.

Some of the above sections are being considered for removal, so you may
need to check the page history for that information.


<!-------------------------------------------------------------------->
[nix instsrc]: https://nixos.org/manual/nix/stable/#ch-installing-source

[arch]: https://wiki.archlinux.org/title/Nix
