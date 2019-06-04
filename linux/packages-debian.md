Debian Package Information
==========================

### Quick Info

To make available the standard extra stuff, add `contrib` and
`non-free` to the lines in `/etc/apt/sources.list`. (Remember to
`apt-get update` after.) The most commonly wanted packages are:

* `firmware-iwlwifi`: Thinkpad and other Intel WiFi chips
* `firmware-realtek`: Realtek Ethernet/WiFi/Bluetooth adapters
* `firmware-linux-nonfree`: general stuff

Other commonly wanted packages are:

* `build-essential`: Tools to build programs (gcc, make, etc.)

### Installed Packages and Sizes

`apt list --installed` lists only packages intalled by `apt`, not
other packages installed with `dpkg` that did not come through the OS
distribution mechanism. To list all installed packages with their sizes,
sorted by size:

    dpkg-query -W --showformat='${Installed-Size;10}\t${Package}\n' | sort -k1,1n

Note that this shows what would be the installed size of removed but
non-purged packages.

Backports
---------

Debian supplies a ["backports" repository][backports] with packages
from the next release ported back to the previous release. For Debian
9 (stretch) this is `stretch-backports`. The definitions are normally
already installed in `/etc/apt/sources.list`, and are also shown
below.

All backports are deactivated by default via using
`ButAutomaticUpgrades: yes` (which pins them to 100) in the Release
files. The `-t` option to apt commands tweaks the policy engine to
prefer the backports packages.

    #   Upgrade just kernel
    apt-get -t stretch-backports upgrade linux-headers-amd64 linux-image-amd64
    #   Upgrade everything with new versions in backports
    apt -t stretch-backports full-upgrade


But though [Jensd's I/O buffer][jensd] suggests upgrading everything,
the [backports] page suggests upgrading only the individual packages
you need.

For kernels, maybe it's also reasonable to install just the exact
kernel versions:

    apt-get install linux-image-4.19.0-0.bpo.4-amd64


Repository Configuration Format
-------------------------------

The package repositories (remote and local) are listed in

    /etc/apt/sources.list
    /etc/apt/sources.list.d/*.{list,sources}

where `*` is `[A-Za-z0-9._-]`. `.list` is the one-line format;
`.sources` is the deb822 (multiline) format. Both are decribed in the
`sources.list(5)` manpage.

### One-line Format

Sources are listed from most to less preferred.

    deb|deb-src [opt=val opt=val] uri suite component...

1. `deb` or `deb-src`. Normally there will be a pair of otherwise
   identical lines starting with each.
2. `uri` can be the base of the distro or an exact path. Not clear on
   details. Examples:
3. `suite`: Examples include `stretch`, `stretch/updates`,
4. `component`: The standard seems to be `main`, plus optional `contrib`
    and `non-free`.

#### Debian 9 Standard `sources.list`

From an install started with non-free components:

    #deb    cdrom:[Debian GNU/Linux 9.0.0 _Stretch_ - Official amd64 NETINST 20170617-13:06]/ stretch contrib main non-free

    deb     http://ftp.jp.debian.org/debian/            stretch             main non-free contrib
    deb-src http://ftp.jp.debian.org/debian/            stretch             main non-free contrib

    deb     http://security.debian.org/debian-security  stretch/updates     main contrib non-free
    deb-src http://security.debian.org/debian-security  stretch/updates     main contrib non-free

    # stretch-updates, previously known as 'volatile'
    deb     http://ftp.jp.debian.org/debian/            stretch-updates     main contrib non-free
    deb-src http://ftp.jp.debian.org/debian/            stretch-updates     main contrib non-free

    # stretch-backports, previously on backports.debian.org
    deb     http://ftp.jp.debian.org/debian/            stretch-backports   main contrib non-free
    deb-src http://ftp.jp.debian.org/debian/            stretch-backports   main contrib non-free


Cryptographic Keys
------------------

A `NO_PUBKEY 6494C6D6997C215E` error can be fixed with:

    sudo apt-key adv --keyserver keyserver.ubuntu.com \
        --recv-keys 6494C6D6997C215E

You can also directly import keys from stdin via `apt-key add -`.

If the `dirmngr` package is not installed, this may produce the
following error:

    Executing: /tmp/apt-key-gpghome.NjrP5qfAgB/gpg.1.sh --keyserver keyserver.ubuntu.com --recv-keys 6494C6D6997C215E
    gpg: failed to start the dirmngr '/usr/bin/dirmngr': No such file or directory
    gpg: connecting dirmngr at '/tmp/apt-key-gpghome.NjrP5qfAgB/S.dirmngr' failed: No such file or directory
    gpg: keyserver receive failed: No dirmngr


Automated Installs
------------------

* Use `apt-get`; the `apt` interface is not stable. Set
* `DEBIAN_FRONTEND=noninteractive` to avoid complaints from dpkg
  about not having a terminal. In a Dockerfile, make sure you use
  [`ARG`] not [`ENV`] to avoid propagating it to the command running
  in the container, which causes confusion.


Package System Commands and Tips
--------------------------------

#### Listing Packages, Versions and Dependencies

    apt list --installed            # Show all installed packages

    apt-cache depends pkgname       # show what pkgname depends on
    apt-cache rdepends pkgname      # pkgs that directly depend on pkgname

    dpkg -L pkgname                 # List files installed by pkgname.
    dpkg -S /etc/ssh/ssh_config     # Show package whence file comes
    apt-file search PATH            # Search for file in package database
    apt-file list pkgname-pattern   # List files in packages
    apt-file update                 # Update package DB used by apt-file

`apt show` (and `aptitude show`) will show the latest version of a
package in the database (or all versions, with `-a`); this is not
necessarily the one installed. To see which version is installed, use
`dpkg -s PACKAGE`.

#### Restoring Original Package Config Files

If the package has the config file stored, rather than generating it,
you can extract the files as per above and take the config from there.
Some packages, however, such as `openssh-server`, generate their
configuration (`/etc/ssh/sshd_config`) so you need to use [this
technique from SO](https://askubuntu.com/a/67028):

    rm ssh/sshd_config
    apt-get -o Dpkg::Options::="--force-confmiss"
            install --reinstall openssh-server

#### Downloading and Extracting

    apt-get download pkgname    # download current version .deb file
    dpkg -i pkgnameetc.deb      # install
    dpkg -I pkgnameetc.deb      # show info
    dpkg -c pkgnameetc.deb      # show contents (file list)
    dpkg -x pkgnameetc.deb dir  # extract contents to `dir`


Package Verification
--------------------

The `debsums` package/program can perform hash checks of installed
files against packages, like `rpm -v` (from this [StackExchange
question](https://askubuntu.com/q/9463/354600)):

    sudo debsums -c [PACKAGE ...]



<!-------------------------------------------------------------------->
[`ARG`]: https://docs.docker.com/engine/reference/builder/#arg
[`ENV`]: https://docs.docker.com/engine/reference/builder/#env
[backports]: https://backports.debian.org/
[jensd]: http://jensd.be/818/linux/install-a-newer-kernel-in-debian-9-stretch-stable
