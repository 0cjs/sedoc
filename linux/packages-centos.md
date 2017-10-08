CentOS Package Information
==========================

Standard Packages
-----------------

Always install these imediately after installing a new system:

    yum install epel-release        # CentOS only
    yum install etckeeper
    cd /etc && etckeeper init && git commit -m 'Initial commit'

RHEL users need to get an EPEL RPM from the [EPEL] page.

You likely also want [IUS] packages for later versions of certain
software (such as Git). Download the RPM from [IUS-RPM].

[EPEL]: https://fedoraproject.org/wiki/EPEL
[IUS]: https://ius.io/
[IUS-RPM]: https://ius.io/GettingStarted/


Package Management Software
---------------------------

Packages are installed etc. by [RPM]; there are several [front ends] available
for repository management including:
* [yum]: RH/CentSO 5+, Fedora through 21.
* [dnf]: Avail. since Fedora 18; default since Fedora 22

Useful plugins for [yum] (many from the [`yum-utils`] package) include:
* [yum-verify]: Verify installed package is unmodified (good for [FIM])

[RPM]: http://rpm.org/
[front ends]: https://en.wikipedia.org/wiki/Rpm_(software)#Local_operations
[yum]: http://yum.baseurl.org/
[dnf]: https://fedoraproject.org/wiki/DNF
[`yum-utils`]: https://linux.die.net/man/1/yum-utils
[yum-verify]: http://bencane.com/2013/12/23/yum-plugins-verifying-packages-and-configurations-with-yum-verify/
[FIM]: https://en.wikipedia.org/wiki/File_integrity_monitoring


Yum Quickref
------------

Detailed docs are at [yum7] and [yum6].

* `yum update` to update everything (with prompt)
* `yum-config-manager --enable | --disable | --add-repo=REPO`
  (from `yum-utils` package) Adds new repos ([manpage][ycm]).

[yum6]: https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/ch-yum.html
[yum7]: https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/ch-yum.html
[ycm]: http://man7.org/linux/man-pages/man1/yum-config-manager.1.html


Replacing Packages
------------------

To replace a package with dependencies with a different one (e.g., a
newer version of Git from IUS) without uninstalling dependencies, use
a transaction:

    yum shell
    > erase mysql-libs
    > install mysql56u mysql56u-libs mysql56u-server mysqlclient16
    > run

Alternatively, if you have the [yum replace plugin] available
(it's in IUS):

    yum install yum-plugin-replace
    yum replace php --replace-with php56u

[yum replace plugin]: https://github.com/iuscommunity/yum-plugin-replace


Keys
----

Keys are in `/etc/pki/rpm-gpg` and can be checked with, e.g.,

    gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

(Note that this will create a keyring in `${GNUPGHOME:-$HOME}` if it
doesn't exist.)

Keys as of 2017-08-14 from <https://www.centos.org/keys/>:

    pub  4096R/F4A80EB5 2014-06-23 CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>
        Key fingerprint = 6341 AB27 53D7 8A78 A7C2  7BB1 24C6 A8A7 F4A8 0EB5
    pub  2048R/B6792C39 2014-07-15 CentOS-7 Debug (CentOS-7 Debuginfo RPMS) <security@centos.org>
        Key fingerprint = 759D 690F 6099 2D52 6A35  8CBD D0F2 5A3C B679 2C39
    pub  4096R/8FAE34BD 2014-06-04 CentOS-7 Testing (CentOS 7 Testing content) <security@centos.org>
        Key fingerprint = BA02 A5E6 AFF9 70F7 269D  D972 C788 93AC 8FAE 34BD

Keys as of 2017-08-14 from <https://getfedora.org/keys/>:

    4096R/352C64E5 2013-12-16
    Fingerprint 91E9 7D7C 4A5E 96F1 7F3E 888F 6A2F AEA2 352C 64E5
    uid Fedora EPEL (7) <epel@fedoraproject.org>
