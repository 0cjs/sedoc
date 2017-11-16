[systemd]
=========

Documentation:
* [Main project page][systemd]
* [Manual pages][manpages]

For information about the logging system see
[systemd-journal](systemd-journal.md).


Systemd Units
-------------

A simple example of setting up a daemon and a network server to be run
by systemd can be found in [this blog entry][fabianlee].


Systemd User Units
------------------

Systemd can also be used by regular users to run services and even
manage an entire desktop session, though at the moment there seem to
be a lot of issues with this. See the [Arch Linux
Systemd/User][arch-systemd-user] page, which also links to William
Giokas' [Converting to systemd --user][kaisforza] page and zoqaeski's
[systemd-user-units] repo. The gtmanfred page (on managing your Xorg
session) mentioned on zoqaeski's page is available from [the Wayback
Machine][gtmanfred].



[systemd]: https://www.freedesktop.org/wiki/Software/systemd/
[manpages]: https://www.freedesktop.org/software/systemd/man/
[arch-systemd-user]: https://wiki.archlinux.org/index.php/Systemd/User
[kaisforza]: https://bitbucket.org/KaiSforza/systemd-user-units
[zoqaeski]: https://github.com/zoqaeski/systemd-user-units
[gtmanfred]: https://web.archive.org/web/20130205193653/http://blog.gtmanfred.com/?p=26
[fabianlee]: https://fabianlee.org/2017/05/21/golang-running-a-go-binary-as-a-systemd-service-on-ubuntu-16-04/
