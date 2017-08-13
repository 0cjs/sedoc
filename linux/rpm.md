RPM Package Manager
===================

The standard package name format is `name-version-release` where
_version_ is the upstream release of the software and _release_ is the
version of the package itself, usually just `1` etc. This name is
stored as the **package label** in the `.rpm` file and in the system's
package database.

Other conventions related to names:
* Append `-devel` to a library package name for the package with
  header files etc.
* Append `mdv` (Mandriva Linux), `rhl9` (Red Hat Linux 9) etc. to
  package release to indicate specific distro it's intended for.

The name of the file containing the package is conventionally
`name-version-release.arch.rpm` with the first three components the
same as above, _arch_ being `noarch`, `i686`, `x86_64`, etc. Where
_arch_ is `src` the file contains source code, patches and build
information (`.spec` file); it's not clear if this is or can be
installed as a package in the same manner as "binary" packages.


### `.rpm` File Format

* Lead: identifies file as a package file and obsolete info.
* Signature: cryptographic sig to ensure integrity/authenticity
* Header: List of tagged blocks with metadata: package name, version
  info, arch, etc.
* Payload: Usually gzip-compressed cpio archive containing the files
  for the package itself.

`rpm2cpio` will extract the payload; to extract the files use
`rpm2cpio foo.rpm | cpio -ivd`.

There are also `.drpm` files which are delta RPMs containing only
changes from a previous package.


### RPM Database

Every system using RPM has a central database in `/var/lib/rpm/` with
information on all installed packages and their files. This is a set
of Berkeley DB files. `Packages` is the master file, all the rest are
indexes dervived from that, lock files, etc.

Handy database-related commands (see `rpmdb(8)` manpage):

    rpm --initdb        # Create new DB if not already existing
    rpm --rebuilddb     # Rebuild indices from `Packages`


### Installing Packages

Normally you'd use your higher-level package manager (e.g., `yum`) to
install files from your distro's package repo as this will
automatically download and install the request package's dependencies
as well.

    rpm -U foo.rpm          # --upgrade; replace older version or install
