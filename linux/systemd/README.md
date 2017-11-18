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

| Systemd | Distribution
|--------:|-------------------
| 232     | Debian 9
| 229     | Ubuntu 16.04


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



[systemd]: https://www.freedesktop.org/wiki/Software/systemd/
[manpages]: https://www.freedesktop.org/software/systemd/man/
