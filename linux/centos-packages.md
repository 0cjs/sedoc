CentOS Package Information
==========================

Standard Packages
-----------------

Always install these imediately after installing a new system:

    yum install epel-release
    yum install etckeeper
    cd /etc && etckeeper init && git commit -m 'Initial commit'


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
