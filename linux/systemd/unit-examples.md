Systemd Unit Configuration Examples
===================================

The easiest way to test many of these is to create the unit files in a
directory, link them into your user systemd directory, test manually,
and then remove them:

    systemctl --user link "$(pwd -P)/foo.service"
    # Link is ~/.config/systemd/user/foo.service
    systemctl --user start foo.service
    # Play, stop, etc.
    systemctl disable foo.service


inetd-style startup
-------------------

An echo server based on [socat](../socat); contrast with the example
on that page. See [systemd for Administrators, Part XI][0p-inetd] for
a detailed discussion of converting inetd services.

echo.socket:

    [Unit]
    Description=TCP echo server

    [Socket]
    ListenStream=0.0.0.0:5555
    Accept=true

echo@.server:

    [Unit]
    Description=TCP echo server

    [Service]
    ExecStart=/usr/bin/socat socat stdin exec:/bin/cat
    StandardInput=socket


(This was based on [puyb].)


TCP Proxy
---------

Systemd comes with a [`sytsemd-socket-proxyd`][proxyd] to do generic
stream connection proxying; see that manpage for examples.



[puyb]: http://puyb.net/2012/12/replace-xinetd-with-systemd/
[0p-inetd]: http://0pointer.de/blog/projects/inetd.html
[proxyd] https://www.freedesktop.org/software/systemd/man/systemd-socket-proxyd.html
