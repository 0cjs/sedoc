Snap Packaging System
=====================

Snap, developed by Canonical, is a "universal" package system whose
self-contained packages should run on any Linux using systemd init.
Packages are run in sandboxes with only mediated access to the host system.
([Wikipedia][wp], [About].)

Unlike e.g. [Flatpak], Snap supports server applications (relying on the
host systemd to deal with startup, making ports available, etc.) and GUI
applications, including those that need access to host hardware such as
USB. Snaps may also share data between themselves via Unix domain sockets
to them to provide services to other snaps.

Snap relies on AppArmor; its security is degraded when SELinux is also in
use. (Fedora and some other distros enable SELinux by default.)

Glossary:
- _snap:_ a package
- `snapd`: the service managing things
- `snap`: command line utility to control snapd
- [Snap Store][store]
- `snapcraft`: command and framework for building and publishing snaps

Commands:
- `apt install snapd`: Initial installation (updates will come through Snap).
- `sudo snap install «app»`
- `snap list`: list installed snaps
- `snap run «app»` (add `&` to run GUI apps in background)

Motivating applications:
- [`authy`]: Twilo Authy desktop

Other snaps:
- `snapd`: Downloaded automatically on first use after `apt install snapd`.
- `core18`: Downloaded automatically; some sort of dependency?
- `bare`: ???

There's a whole desktop/web ecosystem connected to the snap store to allow
GUI installs, etc. if you're not into `snap install …`. Haven't looked at
this.


Technical Details
-----------------

`apt install snapd` installs a base version; on first use it will download
a new `snapd` snap.

Updates are automatic, atomic, and transfer deltas to minimise download
size. Channels are named in the form _track/risk;_ the default channel is
for most apps is `latest/stable`.

#### Storage

The packages are stored as a [squashfs][] (a compressed, read-only
filesystem) image ending in `.snap` which is then mounted via the loopback
driver on `/snap/PKGNAME/VER`, where _VER_ is a version number. (`current`
under the _PKGNAME_ directory is a symlink to the current version).



<!-------------------------------------------------------------------->
[`authy`]: https://snapcraft.io/authy
[about]: https://snapcraft.io/about
[flatpak]: https://en.wikipedia.org/wiki/Flatpak
[squashfs]: https://en.wikipedia.org/wiki/SquashFS
[store]: https://snapcraft.io/store
[wp]: https://en.wikipedia.org/wiki/Snap_(software)
