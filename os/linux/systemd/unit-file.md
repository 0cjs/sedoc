Systemd Unit File Directives
=============================

See [unit](unit.md) for an overview of how units work and how unit
files are found. This lists the sections, type(s) of unit file where
each section applies, and some of the directives, occasionally with a
summary of use. See the linked manpages for full details.

[[Unit]] (all types)
--------------------

    [Unit]
    Description=
    Documentation=
    Requires=
    Requisite=
    Wants=
    Bindsto=
    PartOf=
    Conflicts=
    Before=
    After=
    OnFailure=
    PropagatesReloadTo=
    ReloadPropagatedFrom=
    JoinsNamespaceOf=
    RequiresMountsFor=
    OnFailureJobMode=
    IgnoreOnIsolate=
    StopWhenUnneeded=
    RefuseManualStart=
    RefuseManualStop=
    AllowIsolate=
    DefaultDependencies=
    JobTimeoutSec=
    JobRunningTimeoutSec=
    JobTimeoutAction=
    JobTimeoutRebootArgument=
    StartLimitIntervalSec=
    StartLimitBurst=
    StartLimitAction=
    RebootArgument=
    Condition*=
    Assert*=
    SourcePath=

[[Install]] (all types)
-----------------------

Used by `systemctl enable` and `disable` commands. These may not
appear in `.d/*.conf` unit file drop-ins.

    [Install]
    Alias=
    WantedBy=
    RequiredBy=
    Also=
    DefaultInstance=

Install specifiers that can be used in the values for settings above are
as follows. The first column is the escaped version, the second the
unescaped version.

    %n  %N  Full unit name
    %p  %P  Prefix name (part before `@` or unit without type suffix)
    %i  %I  Instance name (part after `@`)
        %f  Filename
        %t  Runtime directory (`/run` or `$XDG_RUNTIME_DIR`)
        %u  User name
        %U  User UID
        %h  User homedir
        %s  User shell
        %m  Machine ID
        %b  Boot ID
        %H  Host name
        %v  Kernel release (`uname -r`)
        %%  Percent sign

### [Exec] (service, socket, mount, swap)

The most common options follow as reminders; there are many more.
There's extensive ability to restrict what the process can do and
access.

    [Exec]
    WorkingDirectory=
    RootDirectory=
    User=uid|name
    Group=gid|name
    DynamicUser=false|true
    SupplementaryGroups=
    Environment=
    StandardOutput=journal|inherit|null|...
    SyslogLevel=info|...

### [Kill] (scope, service, socket, mount, swap)

Configured in [Service], [Socket], [Mount] or [Swap] sections.

    KillMode=
    KillSignal=
    SendSIGHUP=
    SendSIGKILL=

### [Resource Control] (slice, scope, service, socket, mount, swap)

Configured in the [Slice], [Scope], [Service], [Socket], [Mount], or
[Swap] sections, depending on unit type. See manpage for options.

### [Target] (target)

No specific options.

### [Service] (service)

See manpage for full set of options.

    [Service]
    Type=simple|forking|oneshot|dbus|notify|idle
    RemainAfterExit=no|yes
    ExecStart=
    ExecStop=

If `Type=oneshot`, systemd will not start following units until this
one exits (usually also use `RemainAfterExit=yes`). You may also
specify multiple commands.

`Exec*=` executable paths may be prefixed with `@` (second token is
`argv[0]`), `-` (ignore failure return code), `+`, `!`, `!!` (various
forms of full privs, ignoring `User=` etc.).

### [Socket] (socket)

Common options and reminders only. Listens on all specified addrs if
there's more than one. Service name defaults to
_unit-prefix_`.service`.

    ListenStream=address
    ListenDatagram=address
    BindIP=
    BindIPv6Only=
    BindToDevice=
    FreeBind=false|true     # Bind even if addr doesn't (yet) exist
    Symlinks=
    TriggerLimit*=          # Rate limiting

    Accept=false|true       # spawn new service for each connection?
    MaxConnections=         # Only when Accept=true
    MaxConnectionsPerSource=

    Service=                # Only when Accept=false

Address formats include:

    /path/to/socket         # AF_UNIX
    @socket                 # AF_UNIX; @ becomes NULL (see unix(7))
    0.0.0.0:8080            # IPv4
    8080                    # IPv6 port (also v4 if BindIPv6Only=false)
    [x]:y                   # IPv6 addr x on port y
    vsock:x:y               # CID in AF_VSOCK



[Exec]: https://www.freedesktop.org/software/systemd/man/systemd.exec.html#Options
[Install]: https://www.freedesktop.org/software/systemd/man/systemd.unit.html#%5BInstall%5D%20Section%20Options
[Kill]: https://www.freedesktop.org/software/systemd/man/systemd.kill.html#Options
[Resource Control]: https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html#Options
[Service]: https://www.freedesktop.org/software/systemd/man/systemd.service.html
[Socket]: https://www.freedesktop.org/software/systemd/man/systemd.socket.html
[Target]: https://www.freedesktop.org/software/systemd/man/systemd.target.html
[Unit]: https://www.freedesktop.org/software/systemd/man/systemd.unit.html#%5BUnit%5D%20Section%20Options
