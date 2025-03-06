Creating and Building Debian Packages
=====================================

See also [`pkg-debian`](./pkg-debian.md) for maintance of Debian packages.

Debian packages are used by many different distros: Debian, Ubuntu, Debian
GNU/kFreeBSD (GNU userland, FreeBSD kernel), Debian GNU/Hurd, Nexenta OS
(OpenSolaris-based) etc.,

References:
- Below, "DAH" is the _Debian Administrator's Handbook._
- DAH, [5 Packaging System: Tools and Fundamental Principles][dah5]


Binary Packages
---------------

A Debian binary package is a [`.deb` file], which is simply an `ar` archive
that can be extracted with `ar x`. It contains three files:
- `debian-binary`: A text file containing the version number (`2.0\n`).
- `control.tar.xz`: Package metadata, checksums, etc. This is built from
  the `DEBIAN/` directory (with that prefix removed) in the filesystem
  layout of a binary package.
- `data.tar.xz`: The files to be installed, including ownership information
  and permissions. This may be "installed" with `tar -C / -p -x -f
  data.tar.xz`

Packing and unpacking `.deb` files is generally handled with the
`dpkg-deb(1)` program, and installation and removal of binary packages by
`dpkg(1)`.

#### Metadata

The following files may be found in the control archive:
- `control` (required): Package metadata: version, runtime dependencies
  (other packages), description, etc. It's an RFC-2822-like format; defined
  by `deb822(5)` and `deb-control(5)` (a subset of `deb-src-control(5)`).
- `md5sums`: Checksums of all files in the data archive.
- `conffiles`: Data archive files that should be treated as configuration
  files (often under `/etc/`) that should not be overwritten during an
  update unless specified.
- `preinst`, `postinst`, `prerm`, `postrm`: Scripts executed before/after
  installing/removing the package.
- `shlibs`: Shared library dependencies.
- `config`: [Debconf] configuration.

#### Notes

Individual packages may be signed, but this is rarely used; instead signing
of `apt` repository metadata covers this.

#### References

- DAH, [5.1 Structure of a Binary Package][dah5.1]
- DAH, [5.2 Package Meta-information][dah5.2]
- Manpages: `deb822(5)`, `deb-control(5)`, `deb-src-control(5)`


Source Packages
---------------

A [source package][dah5.3], from which multiple binary packages may be
generated, includes the original source, the package maintainer's
modifications to it, and metadata. This generally comes in three files:
- `….dsc`: Debian Source Control file, RFC 2822 header format. Describes
  the source package and indicates what other files are part of it. Usually
  ASCII-armored PGP-signed by the maintainer. See `deb-src-control(5)`.
- `….orig.tar.gz`: The upstream source code.
- `….debian.tar.xz` or `….diff.xz`: Package maintainers modifications to
  the original source.
- (It appears that a `.dsc` may also be an archive that includes the files
  below. But `apt source NAME` downloads all three separately.

Notes:
- Multiple binary packages (multiple architecture-dependent bins/libs/etc.,
  architecture-indpendent shared files, etc.) may be generated from a
  single source package. The `.dsc` indicates what these are, including
  architecture tags.
- Format `3.0` may include multiple upstream archives
  (`….orig-COMPONENT.tar.gz` files).
- The `.dsc` will generally include a `Build-Depends:` to indicate what
  distribution-supplied packages must be installed to build the source
  package; this is distinct from the runtime dependencies.

References:
- DAH, [5.3 Structure of a Source Package][dah5.3]
- Manpages: `deb822(5)`, `deb-src-control(5)`


Building Packages
-----------------

At the lowest level, a Debian binary package can be built with just `ar`
and `tar`, if you know what you're doing and understand the binary package
standard. There are a multitude of higher-level tools for building and
assisting with building Debian packages, ranging from essentially wrappers
around the above to sophisticated multi-level systems involving source
packages, upstream code fetching and patches, changelog generation, and the
like.

### dpkg-deb and dpkg --build

The simplest step above `ar`/`tar` is `dpkg-deb`, which packs and
unpacks `.deb` files and can also be used (in a more limited way) via the
`dpkg --build` option.

`dpkg-deb --build BINDIR [ARCHIVE|DIR]` works from a "binary directory"
_bindir_ containing the files to be packaged and a `DEBIAN/` subdir with
the `control` file and other other metadata. From this it creates a `.deb`
file with `DEBIAN/**` in `control.tar.gz` (without the `DEBIAN/` prefix)
and the remainder in `data.tar.xz`.

Unless given `--nocheck`, `dpkg-deb --build` does a certain amount of
syntax checking (e.g., on `DEBIAN/control`) and permission checking.

It has many more options to inspect and extract package information.

### Others

- `dpkg-buildpackage`


Minimal Package Build
---------------------

`dpkg` expects package names to be in the `pkgname-ver-rel-arch.deb`
format, and other tools (not used here) also extract information from
filenames and directory names in that format, so that's what we use here.

    bdir=shello.0.1-1-all
    #   The "binary directory" whence the package is built.
    mkdir $bdir/
    mkdir $bdir/bin/
    echo > $bdir/bin/shello -e '#!/bin/sh\necho hello'
    chmod 0755 $bdir/bin/shello
    mkdir -m 0755 $bdir/DEBIAN/

Create a `$bdir/DEBIAN/control` file containing the following:

    Package: shello
    Version: 0.0.1-1
    Maintainer: E. Xample <example@example.com>
    Architecture: all
    Depends: dash
    Description: Bourne shell "Hello, world" program.

Build and check the package:

    #   Output .deb is placed in dir that contains $bdir.
    dpkg-deb --build --root-owner-group $bdir
    ar tv $bdir.deb
    dpkg-deb -c $bdir.deb

The `--root-owner-group` option ignores the current owners of files in the
binary directory and instead marks them all as owned by UID/GID 0/0 in
`data.tar.xz`. This is useful for rootless builds, but does not work if
your package needs to include any files owned by non-root users.

Install with one of:

    dpkg -i $bdir.deb
    apt-get install ./$bdir.deb     # Note './' to install from file.

Further documentation:
- `deb-control(5)`: The control file format and required files.
- `deb-version(1)`: Format of the `Version:` field.
- [[earthly]] shows how to create a package in a way similar to this and
  also set up an apt server to serve it.


----------------------------------------------------------------------

XXX Cruft to be cleaned up and integrated above
===============================================

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
- Debian [Recommended layout for Git packaging repositories][deb-gitlay]


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

XXX much of this moved to §"Minimal Package Build".

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
[`.deb` file]: https://en.wikipedia.org/wiki/Deb_(file_format)
[dah5.1]: https://www.debian.org/doc/manuals/debian-handbook/packaging-system.en.html#sect.binary-package-structure
[dah5.2]: https://www.debian.org/doc/manuals/debian-handbook/sect.package-meta-information.en.html
[dah5.3]: https://www.debian.org/doc/manuals/debian-handbook/sect.source-package-structure.en.html
[dah5]: https://www.debian.org/doc/manuals/debian-handbook/packaging-system.en.html
[deb-dr-pkgs-dist]: https://www.debian.org/doc/manuals/developers-reference/pkgs.en.html#distribution
[deb-gitlay]: https://dep-team.pages.debian.net/deps/dep14/
[debconf]: https://en.wikipedia.org/wiki/Debian_configuration_system
[earthly]: https://earthly.dev/blog/creating-and-hosting-your-own-deb-packages-and-apt-repo/
