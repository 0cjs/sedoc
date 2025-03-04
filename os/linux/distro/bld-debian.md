Creating and Building Debian Packages
=====================================

See also [`pkg-debian`](./pkg-debian.md) for maintance of Debian packages.

Note that the source packages include a `debian/` dir with patches, build
configuration, extra Debian files beyond the upstream, etc. This is
different from the `DEBIAN/` subdir (found under `debian/pkgname/DEBIAN/`)
in the directory used by `dpkg --build` which simply makes a `.deb` from
that file tree.

Packages with package build tools (each depends on all earlier):
- `dpkg-dev`: Includes `dpkg-buildpackage`. `dpkg-source`, …
- `debhelper`: Programs (`dh`, `dh_*`) for use in a `debian/rules` file to
  install files, compress files, fix file permissions, integrate with
  debconf/doc-base/etc. Most packages use this as part of the package build
  process.
- `devscripts`: Various tools for package development/building, including:
  - `debuild` wrapper for `dpkg-buildpackage`
  - `debchange`/`dch` to modify `debian/changelog` and manage version nos.
    (Adds new version entry to top of `debian/changelog` and leaves you
    editing it.)

References:
- [[earthly]] offers a lower-level view of creating a package and setting
  up an apt server, mainly by just editing text files.


Debian Source Packages
----------------------

These are useful as examples of what's in a package. Ensure that `deb-src`
is enabled in `/etc/apt/sources.list` and then `apt-get source PKGNAME`.
Bring in build dependencies with `apt-get -y build-dep PKGNAME`.

`apg` is a good example: /etc/apg.conf, a couple of bins, a lib, a manpage,
and lots of `/usr/share/doc/apg/` stuff. This will leave you with:

- `apg_2.2.3.dfsg.1.orig.tar.gz`: Upstream source code.
- `apg_2.2.3.dfsg.1-5.dsc`: PGP-signed ascii-armored `Packages` file (for
  just this package), maybe created with `dpkg-scanpackages`.
- `apg_2.2.3.dfsg.1-5.debian.tar.xz`: `debian/control` and many other
  things under `debian/` dir.
- `apg-2.2.3.dfsg.1/`: Extracted contents of both tar files above, with all
  `debian/patches/` files applied.

(A `.dfsg` or `+dfsg` in the name indicates that the package has been
modified to comply with the Debian Free Software Guidelines.)

The final directory above is not created if you `apt-get --download-only`;
it can be built with `dpkg-source --extract FILE.dsc [DIRNAME]`.

To build the source package itself, change into the dir, run `debchange -n`
if you want to update the changelog with a new version number and change
info, and then `debuild`. This will produce:
- The upstream build products in `./`
- `debian/apg/` with the installed files, `DEBIAN/control`, etc.


Simple Build from Files
-----------------------

- Package binary output dirs generally in `pkgname-ver-rel-arch` format.
  (_Rel_ allows you to update the package with patches etc. even when based
  on the same upstream release.) Some tools take info from this naming
  format.
- _Arch_ can be `all` for platform-independent stuff (e.g. scripts).
- Stuff under that dir can be created entirely by hand:
  - Build amd64 version, and copy to  `hello_0.0.1-1_amd64/usr/bin/hello`
    (or wherever).
  - Create a `DEBIAN/control` file along the lines of:

      Package: hello-world
      Version: 0.0.1
      Maintainer: example <example@example.com>
      Depends: libc6
      Architecture: amd64
      Homepage: http://example.com
      Description: A program that prints hello

- Build with `dpkg --build …/hello_0.0.1-1_amd64`, creating
  `…/hello-world_0.0.1_amd64.deb`. This will complain if perms are bad,
  e.g., "dpkg-deb: error: control directory has bad permissions 750 (must
  be >=0755 and <=0775)". (Not sure what other perms are used.)
- View info with `dpkg-deb --info` and `dpkg-deb --contents`.
- Install with `apt-get install -f …/hello_0.0.1-1_amd64.deb`.

Things missing:
- `debian/changelog` file (has a specific format).
  - [§5.5 Picking a distribution][deb-dr-pkgs-dist]
    - Normally `unstable`; that and `experimental` use that suite name in
      the changelog entry, otherwise use the suite codename (e.g.
      `stretch`, `stretch/updates`).
    - The above is for Debian-distributed packages; third-party
      distribution seems to use usually the oldest release supported, e.g.,
      `jessie` (Debian 8) for Slack.

Further work: see [[earthly]] for setting up an apt server for packages
like the above.



<!-------------------------------------------------------------------->
[deb-dr-pkgs-dist]: https://www.debian.org/doc/manuals/developers-reference/pkgs.en.html#distribution
[earthly]: https://earthly.dev/blog/creating-and-hosting-your-own-deb-packages-and-apt-repo/
