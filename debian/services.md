Start/Stopping/Etc. Services
============================

Systemd
-------

(The usual.)


System-V-style `init.d` (older systems)
---------------------------------------

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

If asked to create links, `update-rc.d` if any links already exist.
(This avoids overwriting custom configurations.)

https://askubuntu.com/questions/19320/how-to-enable-or-disable-services#19324
