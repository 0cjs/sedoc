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
that can be extracted with `ar x`. (But it's generally handled with the
`dpkg` program). It contains three files:
- `debian-binary`: A text file containing the version number (`2.0\n`).
- `control.tar.xz`: Package metadata, checksums, etc. This is built from
  the `DEBIAN/` directory (with that prefix removed) in the filesystem
  layout of a binary package.
- `data.tar.xz`: The files to be installed, including ownership information
  and permissions. This may be "installed" with `tar -C / -p -x -f
  data.tar.xz`

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


----------------------------------------------------------------------
- XXX Following sections need rewriting in view of the above.
- XXX read `dpkg-buildpackage` documentation

Source vs. Binary Packages
--------------------------

XXX `dpkg --build` vs. `dpkg-buildpackage`

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
[`.deb` file]: https://en.wikipedia.org/wiki/Deb_(file_format)
[dah5.1]: https://www.debian.org/doc/manuals/debian-handbook/packaging-system.en.html#sect.binary-package-structure
[dah5.2]: https://www.debian.org/doc/manuals/debian-handbook/sect.package-meta-information.en.html
[dah5.3]: https://www.debian.org/doc/manuals/debian-handbook/sect.source-package-structure.en.html
[dah5]: https://www.debian.org/doc/manuals/debian-handbook/packaging-system.en.html
[deb-dr-pkgs-dist]: https://www.debian.org/doc/manuals/developers-reference/pkgs.en.html#distribution
[deb-gitlay]: https://dep-team.pages.debian.net/deps/dep14/
[debconf]: https://en.wikipedia.org/wiki/Debian_configuration_system
[earthly]: https://earthly.dev/blog/creating-and-hosting-your-own-deb-packages-and-apt-repo/
