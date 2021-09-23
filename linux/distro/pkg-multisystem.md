Multi-system Package Managers
=============================

These are distribution-agnostic package management and software
deployment systems that work across multiple Linux platforms. They
often also sandbox their applications.

[Nix Package Manager](./pkg-nix.md) has its own file.


AppImage
========

Previously __klik__ (2004) then __PortableLinuxApps__. [AppImage] does
not need superuser permissions.


Flatpak
=======

Previously __xdg-app__ (2015). [Flatpak].

Primary repo is `flathub.org`, but others can be used.


Snap
====

[Snap][] (2014) is an Ubuntu/Canonical package manager originally
designed for Ubuntu Touch Phone. Packages are `.snap` files containing
a squashfs compressed filesystem mounted by `snapd`. Root permissions
required to install.

Competing sandboxed package/deployment systems include [Flatpak]
(previously xdg-app) and [AppImage]

Primary repo is the [Snapcraft store][scstore] (Snapcraft is also a
tool for building packages); others can be used.

### Setup and Use Example

    sudo apt install snapd
    sudo snap install hello-world
    snap list
    snap run hello-world        # or /snap/bin/hello-world



<!-------------------------------------------------------------------->
[flatpak]: https://en.wikipedia.org/wiki/Flatpak

[appimage]: https://en.wikipedia.org/wiki/AppImage

[scstore]: https://snapcraft.io/store
[snap]: https://en.wikipedia.org/wiki/Snap_(package_manager)
