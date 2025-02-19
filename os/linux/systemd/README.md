[systemd]
=========

Contents:
* [Systemd Units](unit.md)
* [Systemd Journal](./journal.md)

Documentation:
* [Main project page][systemd]
* [Manual pages][manpages]


Systemd Versions
----------------

| Systemd | Distribution    | Notes
|--------:|-----------------+-----------------------------------------
| 232     | Debian 9        |
| 229     | Ubuntu 16.04    |
| 219     | CentOS 7        | `--user` removed (see below)


Known Issues
------------

* RHEL/CentOS 7 do not and will not support user systemd (`systemctl
  --user`); it's [disabled entirely][1121451]. See [CentOS bug 8767].


Misc. Notes
-----------

Systemd configures a unique [machine-id] for each machine, usually
stored in `/etc/machine-id` at install time.


Process Tree
------------

The process tree supervised by systemd can be seen with `systemctl
status`. It will usually consist of:
* `init.scope` supervising `/sbin/init`
* `system.slice` supervising system daemons etc.
* `user.slice` with a sub-slice (e.g., `user-cjs.slice`) for each
  logged-in user, continaing
  * a user service (e.g., `user@1765.service`)
  * a scope for each login session (e.g., `session-37.scope`)
* `machine.slice` for [containers] spawned with [`systemd-nspawn`]


Failed Units
------------

Units that have failed will persist in the status listing even after
the units themselves have been removed (the status will usually be
`Loaded: not-found`). To remove these from the status use `systemctl
reset-failed`.



[1121451]: https://superuser.com/a/1121451/26274
[CentOS bug 8767]: https://bugs.centos.org/view.php?id=8767
[manpages]: https://www.freedesktop.org/software/systemd/man/
[systemd]: https://www.freedesktop.org/wiki/Software/systemd/
