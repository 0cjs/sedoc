Debian Releases and Upgrading
=============================

[Debian][debrel] and Ubuntu LTS releases:

| Date    | Ver   | Codename | EOL      | Kernel | Notes
| --------|-------|----------|----------|--------|---------------
| 2018-?? | 10    | Buster   |          |        |
| 2018-04 | 18.04 | Bionic   |          |        |
| 2017-06 | 9     | Stretch  | 2022     | 4.9    |
| 2016-04 | 16.04 | Xenial   |          | 4.?    | systemd
| 2015-05 | 8     | Jessie   | 2020-06  | 3.16   | systemd
| 2014-04 | 14.04 | Trusty   |          | 3.13   |
| 2013-03 | 7     | Wheezy   | 2018-05  |        |
| 2012-04 | 12.04 | Precise  |          | 3.2    |
| 2011-02 | 6     | Squeeze  | 2016-02  |        |
| 2010-04 | 10.04 | Lucid    |          | 2.6    |
| 2009-10 |  9.10 | Karmic   |          |        |

Debian figures above are end of [Debian LTS] support; regular support
ends two years earlier.


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



[Debian LTS]: https://wiki.debian.org/LTS
[debrel]: https://wiki.debian.org/DebianReleases
