Creating and Building Debian Packages
=====================================

See also [`pkg-debian`](./pkg-debian.md) for maintance of Debian packages.

References:
- [[earthly]] offers a lower-level view of creating a package and setting
  up an apt server, mainly by just editing text files.


Simple Build from Files
------------------------

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
