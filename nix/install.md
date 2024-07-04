Nix Installation
================

Contents
- Introduction
- Vendor (NixOS.org)
- Linux Distros
  - Debian
  - Arch
- Custom Binary Cache


Introduction
------------

Nix may be installed with one of two security models: multi-user (usually
preferred and the default) or single-user. This affects only package
_management_ operations (updates to the `/nix/` tree); normally all users
can read this and use the Nix packages.

XXX The command-line programs appear first to try to contact the daemon and, if
it's not running, fall back to accessing the store directly, which may
partially work.

### Multi-user (--daemon install)

`/nix/` is owned by root and `nix-daemon` manages `/nix` and does the
builds. This allows any users with access to the daemon (often just those
in a `nix-users` group) to install new software etc., but the deamon will
ensure the integrity of the packages there. (A user cannot, e.g. insert a
trojan into the packages there.)

__Limitation:__ Only root and a set of trusted users in `nix.conf` can
specify arbitrary binary caches. All users of the daemon can install
packages from arbitrary Nix expressions, but they may be forced to build
instead of getting pre-built binaries if they or the cache are not
configured to be allowed.

[Multi-user Mode][nix-mum] describes the installation details (build users,
running the daemon, restricting access); these are generally taken care
of by the installer.

### Single-user (--no-daemon install)

A single user (usually root or the sole user of a system) owns `/nix/` and
the command line tools do all management operations directly on the files.

- Single user (`--no-daemon`), where `/nix/` is owned by a user whose tools
  manage the directory and do the builds.

In a multi-user configuration where you do not have the system starting
the daemon (e.g., in a Docker container), you can start it yourself with:

    sudo nix-daemon --daemon &

An installation is probably working if you can run (without errors)
`nix-store --gc` and `nix-shell -p cowsay --run 'cowsay Hello.'`. (The
latter will also expose missing locale databases.)

### Checking Install Type

There seems to be no official way to distinguish between single-user and
multi-user installs.

- Checking for existence of `/nix/var/nix/daemon-socket/socket` is not
  reliable; it won't be there if the daemon is not running, or may be
  there but refusing connections.
- [nix-env.fish] offers some techniques, but seems wrong;
  `/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh` does not
  exist in a Debian multi-user install. (It does when using the vendor
  installer.)

### Starting the Daemon

With a Linux distribution install, usually `nix-daemon` is in the path and
you can start it with `sudo nix-daemon --daemon &`. But for vendor install,
see below.

### Command-line Utility Choice of Store

Command-line programs have a `--store` option to specify the [store
URL][n-store]. If not specified this uses the `store` [setting][nc-conf]
which defaults to `auto`, which behaviour is:
1. Use local store `/nix/store/` if the current user can write
   `/nix/var/nix/`.
2. Connect to `/nix/var/nix/daemon-socket/socket`, if it exists.
3. Create and use [local chroot store][n-store-local]
   `~/.local/share/nix/root` (Linux only).
4. Use local store `/nix/store/`.

Instead of building, _substitutes_ can be fetched from remote stores; see
["Custom Binary Cache"](#custom-binary-cache) below.


Vendor (NixOS.org)
------------------

The version from NixOS.org is almost invariably far more recent
than those supplied by packages from Linux distributions. Note that
doing a re-install without properly cleaning up from a previous install
may cause the install and the installation to break. At least part of
the cleanup can be done with:

    sudo rm -rf /nix/ ~/.nix-profile ~/.local/state/nix/

### Source Install

See [the manual][nix-instsrc].

### Multi-User Binary Install

This requires `xz` (Debian `xz-utils` package) and sudo access. The script
is heavily interactive, starting with displaying some information about
what it will do.

    sh <(curl -L https://nixos.org/nix/install) --daemon

The install will, among other things:
- Add a group and users for the build users.
- Add `/etc/nix/nix.conf`
- Back up and modify `/etc/bashbashrc` and other shell startup files.
- If systemd is present, install Nix daemon startup scripts and start the
  daemon.
- Update the channels.

The bashrc change is:

    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi

(This is nothing to do with running the daemon; the name is indicating that
it's for an installation _using_ a daemon. There's also a `nix.sh` for
single-user installations.)

If systemd is not present, you'll need to start it yourself. The daemon
is under `/nix/store/`. Try

    sudo /nix/store/*-nix-*/bin/nix-daemon --daemon &

Logging will be done to stdout.

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

For a multi-user installation you will have to start the daemon in one of
your containers, and it will be killed when you exit. Per above, something
along the lines of the following:

    sudo /nix/store/*-nix-*/bin/nix-daemon --daemon &

### Docker Containers: Shared

Bind-mount `/nix/` or `/nix/store/` plus the socket into the container?
See more at
<https://discourse.nixos.org/t/sharing-nix-store-between-containers/9733/5>


Linux Distros
-------------

### Debian

__Warning:__ It's probably better to use the vendor install. Debian 12 has
a rather old version of Nix (2.8.0, vs. the current 2.23.1) and some
slightly unusual installation decisions:
- No `/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`, which
  exists in _all_ vendor installs
- No default channel installed.

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

### Arch

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


Custom Binary Cache
-------------------

The Nix [configuration variable][nc-conf] `substitute` is set to true
by default, causing the 

By default nix uses 

[settings][nc-conf]

[nc-conf]: https://nix.dev/manual/nix/latest/command-ref/conf-file.html



<!-------------------------------------------------------------------->
[n-store-local]: https://nix.dev/manual/nix/latest/store/types/local-store
[n-store]: https://nix.dev/manual/nix/latest/store/types/#store-url-format
[nix-env.fish]: https://github.com/lilyball/nix-env.fish/blob/master/conf.d/nix-env.fish
[nix-instsrc]: https://nixos.org/manual/nix/stable/#ch-installing-source
[nix-mum]: https://nix.dev/manual/nix/2.18/installation/multi-user

[arch]: https://wiki.archlinux.org/title/Nix
