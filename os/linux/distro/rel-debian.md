Debian Releases and Upgrading
=============================

[Debian][debrel] and Ubuntu LTS releases:

| Date    | Ver   | Codename | EOL      | Kernel    | Notes
| --------|-------|----------|----------|-----------|---------------
|         | 14    | Forky    |          |           |
|         | 13    | Trixie   |          |           |
| 2024-05 | 24.04 | Noble    | 2029/34  |           |
| 2023-06 | 12    | Bookworm | 2028-06  |           |
| 2022-04 | 22.04 | Jammy    | 2027/32  | 5.15      |
| 2021-08 | 11    | Bullseye | 2026-08  | 5.10      | release on 2021-08-14
| 2020-04 | 20.04 | Focal    | 2025/30  |           |
| 2019-07 | 10    | Buster   | 2024-07  | 4.19      | wayland,apparmor,bash5
| 2018-04 | 18.04 | Bionic   | 2028-04  | 4.15, TBD |
| 2017-06 | 9     | Stretch  | 2022-07  | 4.9, 4.19 |
| 2016-04 | 16.04 | Xenial   | 2021-04  | 4.4, 4.15 | systemd
| 2015-05 | 8     | Jessie   | 2020-06  | 3.16      | systemd
| 2014-04 | 14.04 | Trusty   | 2019-04  | 3.13, 4.4 |
| 2013-03 | 7     | Wheezy   | 2018-05  |           |
| 2012-04 | 12.04 | Precise  | 2017-04  | 3.2       |
| 2011-02 | 6     | Squeeze  | 2016-02  |           |
| 2010-04 | 10.04 | Lucid    |          | 2.6       |
| 2009-10 |  9.10 | Karmic   |          |           |

Unbuntu LTS releases EOL 20gg/ss are end dates for general and security
support. LTS releases provide optional (but recommended) new kernel/X11
versions at point (and sometimes major) releases; see [LTSEnablementStack].

Debian figures above are end of [Debian LTS] support (done by a separate
set of volunteers); regular support ends two years earlier; commercial
[Debian ELTS] ends five years later.

There is a set of "current" names for Debian releases that roll forward to
different releases when a new release is made. These may be used instead of
actual release names in [source lists][debsources] to automatically roll
systems forward as these change. See also [Debian Package
Information](pkg-debian.md) for information on backports and the like.
- [_stable_][debstable]: the current Debian release
- _oldstable_: the previous stable release
- [_testing_][debtest]: current development state of the next stable
  release. See the link for instructions to upgrade from _stable_.
- _unstable_: New packages start here and are moved to _testing_ if no
  issues are seen after ten days.

#### Release Notes

* [Debian 10][deb10]:
  - Uses the Wayland display server instead of XOrg for GNOME (3.3), but
    XOrg is still installed by default and the display manager allows
    choosing it for the next session.
  - AppArmor is also now installed and enabled by default.
  - `nf_tables` is now available along with the traditional `iptables`;
    _alteratives_ chooses between them.
  - Bash is now version 5.
  - The [/usr merge][usr-merge] of /bin etc. into /usr/bin etc. started.
  - [Calamares installer][calamares] (for Live only?)


Project and Support Sites
-------------------------

[`alioth.debian.org`] and its subsites have been shutdown, though
there are still many links pointing to it. It's been replaced by
[Salsa], a GitLab instance at <https://salsa.debian.org/>.


Installing
----------

### From USB Media

Download from [Debian Internet Install image page][dinst]. See
[Installation Guide §4.3][dig-4.3] for details on preparing a USB
stick. Options include:

- (§4.3.1) Hybrid CD/DVD image copied to `/dev/sdX`, wiping out
  anything else on USB stick. May leave room to create a DOS partition
  for additional files and other use.
- (§4.3.2) Bootable 1 GB DOS partition table/filesystem (`zcat
  hd-media/boot.img.gz >/dev/sdX`) to which you can copy install
  files.
- (§4.3.3) Manually configured DOS loader and files
  (`hd-media/{vmlinuz,initrd.gz}`) on existing or new DOS partition.

The third option is roughly as follows. Package names containing the
commands are given in parens. The netinst image is an ISO file such as
the "Small CDs or USB sticks" image from [[dinst]].

    install-mbr /dev/sdX        # (mbr)
    cfdisk /dev/sdX             # (util-linux) create partitions
    mkdosfs /dev/sdX1           # (dosfstools)
    syslinux /dev/sdX1          # (syslinux, mtools)
    mount /dev/sdX1 /mnt
    cp vmlinuz initrd.gz /mnt/
    echo 'default vmlinuz initrd=initrd.gz' >/mnt/syslinux.cfg
    echo 'prompt 1' >>/mnt/syslinux.cfg
    #   copy a netinst image to /mnt/
    #   copy driver packages to /mnt/

For booting on an EFI-only system, consider using `gdisk` to create a
GPT partition table and `cgdisk` to set up the partitions.

### From an Already Booted System

Up to Debian 8, you could `sudo debian-installer-launcher --text` to
run the same installer that the live CD uses. This has been removed
in Debian 9.[so 314792][bug 844611].


Upgrading Debian
----------------

Also see the stable to testing upgrade instructions at
[DebianTesting][debtest].

1. Ensure `/etc/` is clean and all committed:

        cd /etc
        git status              # Commit your stuff if not clean
        etckeeper init          # Ensure perms match repo

2. Make sure system is fully up-to-date with current version:

        apt-get update          # Fefresh package information
        apt-get dist-upgrade    # Update all packages and dependencies
        apt-get -f install      # Fix any broken packages
        shutdown -r now         # If necessary

3. Consistency and hold-back checks:

        dpkg -C
        apt-mark showhold

4. Update [source lists][debsources]. (If you don't use `etckeeper`, you may
   wish to use ` sed -i.old` to keep backup copies of the source lists.)

        cd /etc
        sed -i -e 's/bullseye/bookworm/g' apt/sources.list apt/sources.list.d/*
        git diff --word-diff    # Confirm nothing weird happened
        etckeeper commit -m 'apt/sources.list: Update from bullseye to bookworm'

    You also may need to check `/etc/apt/apt.conf.d/00default-release` to
    ensure the installation is not fixed to a specific release.

    The Bullseye (Debian 11) security repo name [has changed][deb-bullseye-faq]:

        deb http://deb.debian.org/debian bullseye main
        deb http://security.debian.org/debian-security bullseye-security main
        deb http://deb.debian.org/debian bullseye-updates main

    (Probably append `contrib non-free` to the above.)

5. Upgrade:

        apt-get update          # Update package index
        apt list --upgradable   # If you really want to see what will be changed
        apt-get dist-upgrade    # Choose "restart without asking" when prompted
        shutdown -r now

6. Optional cleanup:

        apt autoremove
        apt-clean


Upgrading Ubuntu
----------------

    aptitude update && aptitude full-upgrade
    aptitude install update-manager-core
    # One of the following
    do-release-upgrade
    update-manager -c
    update-manager -c -d        # for devel upgrade


Sources
-------

* [LinuxBabe.Com](
https://www.linuxbabe.com/debian/upgrade-debian-8-jessie-to-debian-9-stretch)
* Philipp Wiendl



<!-------------------------------------------------------------------->
[Debian ELTS]: https://wiki.debian.org/LTS/Extended
[Debian LTS]: https://wiki.debian.org/LTS
[LTSEnablementStack]: https://wiki.ubuntu.com/Kernel/LTSEnablementStack
[Salsa]: https://wiki.debian.org/Salsa
[`alioth.debian.org`]: https://wiki.debian.org/Alioth/FAQ
[bug 844611]: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=844611
[calamares]: https://calamares.io/about/
[deb-bullseye-faq]: https://wiki.debian.org/DebianBullseye#FAQ
[deb10]: https://www.debian.org/News/2019/20190706
[debrel]: https://wiki.debian.org/DebianReleases
[debsources]: https://wiki.debian.org/SourcesList
[debstable]: https://wiki.debian.org/DebianStable
[debtest]: https://wiki.debian.org/DebianTesting
[dig-4.3]: https://www.debian.org/releases/stable/amd64/ch04s03.en.html
[dinst]: https://www.debian.org/distrib/netinst
[so 314792]: https://unix.stackexchange.com/questions/314792/
[usr-merge]: https://www.freedesktop.org/wiki/Software/systemd/TheCaseForTheUsrMerge/
