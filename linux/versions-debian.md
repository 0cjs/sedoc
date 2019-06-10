Debian Releases and Upgrading
=============================

[Debian][debrel] and Ubuntu LTS releases:

| Date    | Ver   | Codename | EOL      | Kernel    | Notes
| --------|-------|----------|----------|-----------|---------------
| 2018-?? | 10    | Buster   |          |           |
| 2018-04 | 18.04 | Bionic   | 2028-04  | 4.15, TBD |
| 2017-06 | 9     | Stretch  | 2022     | 4.9       |
| 2016-04 | 16.04 | Xenial   | 2021-04  | 4.4, 4.15 | systemd
| 2015-05 | 8     | Jessie   | 2020-06  | 3.16      | systemd
| 2014-04 | 14.04 | Trusty   | 2019-04  | 3.13, 4.4 |
| 2013-03 | 7     | Wheezy   | 2018-05  |           |
| 2012-04 | 12.04 | Precise  | 2017-04  | 3.2       |
| 2011-02 | 6     | Squeeze  | 2016-02  |           |
| 2010-04 | 10.04 | Lucid    |          | 2.6       |
| 2009-10 |  9.10 | Karmic   |          |           |

Unbuntu LTS releases provide optional (but recommended) new (sometimes
major) kernel/X11 versions at point releases; see [LTSEnablementStack].

Debian figures above are end of [Debian LTS] support; regular support
ends two years earlier.


Project and Support Sites
-------------------------

[`alioth.debian.org`] and its subsites have been shutdown, though
there are still many links pointing to it. It's been replaced by
[Salsa], a GitLab instance at <https://salsa.debian.org/>.


Installing
----------

Up to Debian 8, you could `sudo debian-installer-launcher --text` to
run the same installer that the live CD uses. This has been removed
in Debian 9.[so 314792][bug 844611].


Upgrading Debian
----------------

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

4. Update source lists:

        cd /etc
        sed -i -e 's/jessie/stretch/g' apt/sources.list apt/sources.list.d/*
        git diff --word-diff    # Confirm nothing weird happened
        etckeeper commit -m 'apt/sources.list: Update from jessie to stretch'

    (If you don't use `etckeeper`, you may wish to use ` sed -i.old`
    to keep backup copies of the source lists.)

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
[Debian LTS]: https://wiki.debian.org/LTS
[LTSEnablementStack]: https://wiki.ubuntu.com/Kernel/LTSEnablementStack
[Salsa]: https://wiki.debian.org/Salsa
[`alioth.debian.org`]: https://wiki.debian.org/Alioth/FAQ
[bug 844611]: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=844611
[debrel]: https://wiki.debian.org/DebianReleases
[so 314792]: https://unix.stackexchange.com/questions/314792/