Start/Stopping/Etc. Services
============================

Systemd
-------

(The usual.)


System-V-style `init.d`
-----------------------

Older systems without systemd use `init.d` startup scripts and even
some packages on `systemd` systems (such as `webfs` on Debian 9) still
appear use this old system. However, in the latter case you usually
can still use, e.g., `systemctl disable webfs` and it will handle
this:

    # systemctl disable webfs
    webfs.service is not a native service, redirecting to systemd-sysv-install.
    Executing: /lib/systemd/systemd-sysv-install disable webfs

`service` changes the current state, but not what happens on bootup:

    service --status-all
    service NAME status
    service NAME stop|start|restart
    service NAME start

`update-rc.d` installs and removes System-V style init script links.
This correctly handles disabling by adding `K00...` files so that
updates and re-installs do not enable the service again.

    update-rc.d -n ...                  # Just say what it would do
    update-rc.d NAME defaults           # Starts in 2345, stops in 016
    update-rc.d NAME enable|disable
    update-rc.d NAME start ...          # Complex; don't use this

If asked to create links, `update-rc.d` will do nothing if any links
already exist. (This avoids overwriting custom configurations.)

Some information here is from a [StackExchange answer][354600].

[354600]: https://askubuntu.com/a/19324/354600
