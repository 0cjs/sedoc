D-Bus Services
==============

[D-Bus] \([Wikipedia]) is a shared IPC mechanism used by desktop
programs. Processes expose their services on D-Bus as _objects_ with
_methods_ that clients can call.

A host usually has a single _system bus_ available to all users and
processes that provides access to OS services and a _session bus_ for
each user login session for integration of the user's desktop session.
The reference `dbus-daemon` can start inactive services when a request
is received for one; this is usually done with `systemd` service
activation.

Model
-----

Each connection to the bus receives a _unique connection name_ (over
the lifetime of the DBus daemon) starting with a colon (which is
illegal in bus names) such as `:1.33`. Typically clients will also
request another connection name, a _bus name_ well-known to others
wanting to use its service, such as `org.freedesktop.Notifications`.
Notifications can be sent to clients when bus names are taken or
released.

Each process on a connection can export _objects_ available only
within the context of that connection. (This is why messages have both
a destination connection and destination object name.) Objects are
identified by _object paths_ prefixed with a slash, e.g.,
`/org/freedesktop/Notifications`. Each object has zero or more
_interfaces_ typically named similar to (but entirely separate from)
connection names, e.g. `org.freedesktop.Notifications`.

The following are the standard interfaces (on object `/`) that support
introspection:
- `org.freedesktop.DBus.Peer`: Liveness tests.
- `org.freedesktop.DBus.Introspectable`: XML interface descriptions.
- `org.freedesktop.DBus.Properties`
- `org.freedesktop.DBus.ObjectManager`: Queries for sub-objects and
  their interfaces.

### Connectivity

The DBus _wire protocol_ can run directly between two clients or
between a client and a and DBus daemon. This protocol must be
transported by an IPC mechanism, typically Unix domain or sometimes
TCP sockets. The IPC mechanism has its own _addresses_ that include
key-value paris, e.g., `unix:path=/tmp/.mysocket` or
`tcp:host=localhost,port=1234,family=ipv4`.


Software
--------

DBus daemons:
- `dbus-daemon` built on libdbus.
  - System bus usually started as `messagebus` systemd service.
  - Options:
    - `--session`: = `--config-file=/usr/share/dbus-1/session.conf`
    - `--system`: = `--config-file=/usr/share/dbus-1/system.conf`
    - `--address[=ADDR]`: Listen address overrides config file.
    - `--print-address[=FILEDESC]`: Print listen address.
- `dbus-launch`: Used to start a session `dbus-daemon` in user startup
  files. Normally these should take the
  `DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1765/bus` or similar
  it prints and set that in the process environment.

Client libraries:
- `libdbus`: Reference implementation. [Python bindings][dbus-python].
- `sd-bus`: Part of `systemd`
- GDBus: GNOME
- QtDBus: Qt/KDE
- `dbus-java`

Development/debugging Clients:
- `dbus-monitor`: Command line client
- `dbus-send`: Command line client. Not general enough to call all functions.
- [gdbus]: Commnad line client to introspect, monitor and call objects.
- [d-feet]: A graphical a D-Bus object browser, viewer and debugger.

#### gdbus examples:

Also see the manpage for better examples. Arguments are:
- `-e` for session bus, `-y` for system bus, `-a ADDR` for another bus.
- `-d`: destination connection name.
- `-o`: object path. Add `-r` to recurse through child objects.

    #   Show all objects exported by org.freedesktop.DBus process
    gdbus introspect -e -d org.freedesktop.DBus -o / -r

    gdbus call -e -d org.freedesktop.DBus -o /org/freedesktop/DBus \
        -m org.freedesktop.DBus.Peer.Ping

    gdbus introspect -e \
        -d org.freedesktop.Notifications \
        -o /org/freedesktop/Notifications

    gdbus call -e \
        -d org.freedesktop.Notifications \
        -o /org/freedesktop/Notifications \
        -m org.freedesktop.Notifications.GetServerInformation

    gdbus call -e \
        -d org.freedesktop.Notifications \
        -o /org/freedesktop/Notifications \
        -m org.freedesktop.Notifications.Notify \
        manual-test-app                     # Params: app_name
        0                                   #   replaces_id
        ''                                  #   app_icon
        'test sumary'                       #   summary
        'test body'                         #   body
        '[]'                                #   actions
        '{}'                                #   hints
        5000                                #   expire_timeout

#### dbus-send examples (newlines and comments must be removed):

    dbus-send --print-reply --session \
        --dest=org.freedesktop.DBus / org.freedesktop.DBus.Peer.Ping

The following doesn't work, because the `dict:string:variant` type
can't be specified. It produces a type mismatch of called
`(susssasa{ss}i)` expected `(susssasa{sv}i)`.

    dbus-send
      --print-reply                         # Otherwise silent
      --session                             # Default, or --system for system bus.
      --dest=org.freedesktop.Notifications  # Bus name, pseudo-optional
      /org/freedesktop/Notifications        # Object path
      org.freedesktop.Notifications.Notify  # Interface.Member
      'string:manual-test-app'              # Params: app_name
      'uint32:0'                            #   replaces_id
      'string:'                             #   app_icon
      'string:test summary'                 #   summary
      'string:test body'                    #   body
      'array:string:'                       #   actions
      'dict:string:variant:'                #   hints
      'int32:10'                            #   expire_timeout


Files and Sockets
-----------------

Relevant directories:
- `/usr/share/dbus-1`: Service descriptions



<!-------------------------------------------------------------------->
[D-Bus]: https://www.freedesktop.org/wiki/Software/dbus/
[Wikipedia]: https://en.wikipedia.org/wiki/D-Bus
[d-feet]: https://wiki.gnome.org/Apps/DFeet
[dbus-python]: https://pypi.org/project/dbus-python/
