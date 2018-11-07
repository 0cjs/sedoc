Linux Network Configuration
===========================

Tips
----

### What's Listening?

For most of these information will be incomplete unless run as root.

- `ss -lpf inet`: (package `iproute2`) shows sockets listening
  on _inet_ protocols with process name and PID
- `netstat -lp` (package `net-tools`) shows listening sockets with
  PIDs/program names. Add `-t`/`-u` for TCP/UDP.
- `lsof -i ap` (`@`_ap_ optional) shows sockets. _ap_ can be, e.g.,
  `tcp:80`, `:80`.
- `fuser 80/tcp` (package `psmisc`)

### Finding MTU

    tracepath HOST
    ping -c 1 -s $((1500-28)) -M do HOST


Configuration Overview
----------------------

Hostname is configured via `hostnamectl` (from systemd); the local
name must also be in `/etc/hosts`.

[NetworkManager] is typically installed for dynamic management of
interfaces not explicitly configured (see below). `nm-applet` and
`nm-connection-editor` provide a graphical UI; CLI is via `nmcli`.
Shared connection configurations are stored under
`/etc/NetworkManager/system-connections/`. Only one configuration can
be active per interface; multiple autoconfig configurations will be
chosen based on highest priority.

Modern `systemd` systems use configuration in `/etc/systemd/network`;
see the `systemd-networkd` manpage for details.

Debian systems' legacy configuration package is `ifupdown` using
`/etc/network/interfaces`. For more see the [Debian Network Setup
reference][debnet]. The [NetworkConfiguration][dw-netconf] Debian
wiki page also has lots of good info.

Red Hat systems (at least up to RHEL 7) configure via
`/etc/sysconfig/network`; see below for more details. There are also
some [tutorials from BSS][BSS] on RHEL v7 networking and Active
Directory integration.

### Command-line Tools

- `nmcli`, `nmtui*`: NetworkManager CLI and curses interfaces. Can also
  be used to query autoconfig info from DHCP, etc.
- `ip`: (`iproute2` package): Interface, routing, etc. query and set.
- `ethtool DEVNAME` queries and sets driver/hardware settings for
  network interfaces with a particular focus on wired Ethernet
  devices.
- `ifconfig`, `route`: legacy programs replaced by `ip`.

#### nmcli Quickref

All subcommands may be abbreviated to one letter. Completion is available.

- `nmcli`: Long summary of whole system state.
- `nmcli device`: All device states, one per line.
- `nmcli device show [DEV]`: Current interface config details.
- `nmcli connection`: List all connections, one per line.
- `nmcli connection show CON`: Very detailed connection information,
  including NM configuration settings, DHCP option details, etc.
- `nmcli connection up|down CON`: Connect/disconnect.

[BSS]: http://bss.technology/tutorials/
[NetworkManager]: https://en.wikipedia.org/wiki/NetworkManager
[debnet]: https://www.debian.org/doc/manuals/debian-reference/ch05
[dw-netconf]: https://wiki.debian.org/netconf


Interface Naming
----------------

Names start with `en` (Ethernet), `wl` (WLAN) `ww` (WWAN). The
following chars may include `o` (onboard), `s` (hotplug slot), `p`
(PCI bus location), `x` (MAC address follows, e.g.,
`wlx000f009a0b1c`). Numbers are indexes of IDs, ports, etc. Names such
as `eth0` will be used if a name following the scheme above cannot be
constructed.

Debian also has `udev` to try to give fixed names to devices even when
they're moved around (typically by MAC address0); rules are generated
when a new network interface is detected and stored in
`/etc/udev/rules.d/70-local-persistent-net.rules`.

RH has something along those lines as well; possibly it's related to
their `biosdevname` command and package.


RHEL/CentOS Old Static Network Config
-------------------------------------

RHEL and CentOS systems up through RHEL/CentOS 7 use shell variable
files `sysconfig/network-scripts/ifcfg-eth0` and the like for
configuration (though there may be an alternate method for RHEL 7).
This configuration does not use NetworkManager and works without it
installed.

#### Sample Configs

Bridge:

    DEVICE=br1
    TYPE=Bridge
    ONBOOT=yes
    BOOTPROTO=none

Minimal DHCP:

    # Motherboard Ethernet
    DEVICE=enp3s0
    TYPE=Ethernet
    ONBOOT=yes
    BOOTPROTO=dhcp

The install scripts for CentOS 7 add this to the above:

    # All this crap in order made by install
    DEFROUTE="yes"
    PEERDNS="yes"
    PEERROUTES="yes"
    IPV4_FAILURE_FATAL="no"
    IPV6INIT="yes"
    IPV6_AUTOCONF="yes"
    IPV6_DEFROUTE="yes"
    IPV6_PEERDNS="yes"
    IPV6_PEERROUTES="yes"
    IPV6_FAILURE_FATAL="no"

    # Not sure that these are a good idea at all, but install put them here.
    # Can't even figure out what NAME does.
    NAME="enp3s0
    UUID="4f82ea9c-d729-4714-83aa-9970d5c3ca77"

Minimal static:

    # On-board port 1
    DEVICE=eno1
    TYPE=Ethernet
    ONBOOT=yes
    BOOTPROTO=none

    IPADDR=192.168.12.34
    NETMASK=255.255.255.0   # Or PREFIX=24?

Fuller static (not checked):

    # On-board ethernet physical port 1
    DEVICE=eth0
    TYPE=Ethernet
    ONBOOT=yes
    NM_CONTROLLED=no
    BOOTPROTO=none

    IPV4_FAILURE_FATAL=yes
    IPV6INIT=no

    IPADDR=192.168.56.78
    PREFIX=24

    # These are not specific to the interface but are
    # general networking configuration.
    #
    GATEWAY=192.168.90.10
    DEFROUTE=yes
    DNS1=8.8.8.8
    DNS2=8.8.8.4

Loopback (`/etc/sysconfig/network-scripts/if-lo` from both
RHEL 6 and CentOS 7 install):

    DEVICE=lo
    IPADDR=127.0.0.1
    NETMASK=255.0.0.0
    NETWORK=127.0.0.0
    # If you're having problems with gated making 127.0.0.0/8 a martian,
    # you can change this to something else (255.255.255.255, for example)
    BROADCAST=127.255.255.255
    ONBOOT=yes
    NAME=loopback
