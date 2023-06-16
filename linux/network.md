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

### Finding and Setting MTU

    tracepath HOST
    ping -c 1 -s $((1500-28)) -M do HOST

    sudo ip link set wlp3s0 mtu 1426


Configuration Overview
----------------------

Hostname is configured via `hostnamectl` (from systemd); the local
name must also be in `/etc/hosts`.

[Netplan] reads `/etc/netplan/*.yaml` for config placed there by
packages/apps and then generates configuration for "renderers"
(currently NetworkManager and systemd-networkd) that actually manage
the specific interfaces. This seems to have first been delivered on
Ubuntu 18.04. Sounds like a good idea; let's see if it spreads.

[NetworkManager] is typically installed for dynamic management of
interfaces not explicitly configured (see below). `nm-applet` and
`nm-connection-editor` provide a graphical UI; CLI is via `nmcli`.
Shared connection configurations are stored under
`/etc/NetworkManager/system-connections/`. Only one configuration can
be active per interface; multiple autoconfig configurations will be
chosen based on highest priority.

Modern `systemd` systems use configuration in `/etc/systemd/network`;
see the `systemd-networkd` manpage for details.

Debian systems' legacy configuration is in `/etc/network/interfaces`.
See below for more details.

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
- `ifconfig`, `route`, etc. (`net-tools` package): legacy programs
  replaced by `iproute2` tools.
- `iw`: Configures WiFi devices

#### nmcli Quickref

All subcommands may be abbreviated to one letter. Completion is available.

- `nmcli`: Long summary of whole system state.
- `nmcli device`: All device states, one per line.
- `nmcli device show [DEV]`: Current interface config details.
- `nmcli device wifi list`: List access point information.
- `nmcli connection`: List all connections, one per line.
- `nmcli connection show CON`: Very detailed connection information,
  including NM configuration settings, DHCP option details, etc.
- `nmcli connection up|down CON`: Connect/disconnect.
- `nmcli connection edit CON`: Interactive editor with completion and
  help for all settings. The `nm-settings(5)` manpage may provide
  slightly more information.

#### iw Quickref

Some cards supported multiple connections at once via virtual
interfaces [[ause 488604]]:

    iw dev wlan0 interface add wlan1 type station
    ip link set dev <dev-name> address <new-mac-address>  # if on same net
    sudo iw dev wlan1 del

However, for some reason on my Deb9/Linux4.19 system the interface is
immediately renamed from the one I gave to `rename11` or similar, and
NetworkManager says the device is "unavailable" (not "unmanaged").

Documentation at:
- [[iw-doc]], [[iw-doc-vif]]: Old wireless.wiki.kernel.org
  documentation, main page and virtual interfaces/ad-hoc/mesh/monitor.
- [[iw-ict]]: includes command-line `iw`, `iwconfig` and `ifconfig`
  commands for manual configuration of WiFi interfaces.

[BSS]: http://bss.technology/tutorials/
[Netplan]: https://netplan.io
[NetworkManager]: https://en.wikipedia.org/wiki/NetworkManager
[ause 488604]: https://askubuntu.com/a/488604
[iw-doc-vif]: https://web.archive.org/web/20160611122424/https://wireless.wiki.kernel.org/en/users/documentation/iw/vif
[iw-doc]: https://web.archive.org/web/20160422194703/https://wireless.wiki.kernel.org/en/users/documentation/iw
[iw-ict]: http://ict.siit.tu.ac.th/help/iw


Interface Naming
----------------

Names start with `en` (Ethernet), `wl` (WLAN) `ww` (WWAN). The
following chars may include `o` (onboard), `s` (hotplug slot), `p`
(PCI bus location), `x` (MAC address follows, e.g.,
`wlx000f009a0b1c`). Numbers are indexes of IDs, ports, etc. Names such
as `eth0` will be used if a name following the scheme above cannot be
constructed.

### Changing Interface Names

Much of information below is documented in more detail in answers to
question [[unse 386925]] on the Unix StackExchange.

#### udev

Debian also has `udev` to try to give fixed names to devices even when
they're moved around (typically by MAC address0); rules are generated
when a new network interface is detected and stored in
`/etc/udev/rules.d/70-local-persistent-net.rules`. Some docs at
[[weinimo]].

RH has something along those lines as well; possibly it's related to
their `biosdevname` command and package.

#### systemd.link

systemd provides the [`systemd.link(5)`][systemd.link] layer over udev
configure changing of device names. above. Also see [Renaming an
interface][arch-sn-ren] on Archwiki. Example for WiFi interfaces to
fix the bug described below:


    [Match]
    Type=wlan                       # from `networkctl list`
    MACAddress=72:cd:c6:bf:07:b6    # may change each time device inserted?

    [Link]
    Description=USB Wifi Adapter, white, "Eon"
    Name=wlanUw
    MACAddressPolicy=persistent

`systemctl restart systemd-networkd` should reload the config. In
systemd ≥v244 there are also `networkctl reload` and `networkctl
reconfigure` commands.

This is a part of the more general `systemd.networkd(8)` configuration;
see `systemd.network(5)` for more details.

#### iw

See the `iw` command quickref above for adding new devices based on an
existing one; this might be usable as a substitute for changing names.

### Bugs Related to Interface Naming

NetworkManager (as of Debian 9) has a bug where if the WiFi interface
name is too long (like `wlx000f009a0b1c` above) it will authenticate
and then deauth with a message like `aborting authentication with ...
by local choice (Reason: 3=DEAUTH_LEAVING)`. Renaming the interface
using one of the methods above can fix this. More at [[unse 386925]].

If you can't get one of the above solutions working (I can't), `touch
/etc/systemd/network/99-default.link` will inhibit the default
configuration for long name behaviour by overriding
`/lib/systemd/network/99-default.link`. [[deblist 01045]]

[arch-sn-ren]: https://wiki.archlinux.org/index.php/Systemd-networkd#Renaming_an_interface
[deblist 01045]: https://lists.debian.org/debian-user/2017/06/msg01045.html
[systemd.link]: https://www.freedesktop.org/software/systemd/man/systemd.link.html
[unse 386925]: https://unix.stackexchange.com/q/386925/10489
[weinimo]: https://weinimo.github.io/how-to-write-udev-rules-for-usb-devices.html


netconf: Debian Legacy Network Config
-------------------------------------

Debian systems' legacy configuration package is __netconf__, with
`ifupdown` using configuration in `/etc/network/interfaces` (and files
in `interfaces.d/`). This is still set up by the installer as of of
Debian 10, and Debian 11 `pppoeconf` also uses it.

### /etc/network/interfaces

`ifup eth0`/`ifdown eth0` bring up/down the provided config name (the
interface name, when renaming is not used) if an `iface eth0` stanza
exists in `interfaces`. The `-a ` option brings up/down all auto
interfaces; see below. Hook scripts under `if-*.d/` can be provided
for special configuration.

Generally, don't use `ifconfig` etc. on an interface brought up with
`ifup`.

Config file syntax (details in `interfaces(5)`):
- `#`: Full line comment (end-of-line comments not supported)
- `\`: Append next line to current line.
- Patterns can be used to match multiple interfaces.
- Add a period and number after the interface name for VLAN
  interfaces, e.g., `eth0.1`.
- `no-scripts eth0`: Do not run `if-*.d/` scripts.
- `auto eth0`: Start `eth0` on system startup or `ifup -a`.
- `no-auto-down eth0`: Do not stop `eth0` on `ifdown -a`.
- `allow-*`: Sets configs to be brought up automatically by various
  subsystems, e.g., `allow-auto eth0`
- `allow-hotplug eth0`: Bring up when kernel detects hotplug event for
  the device itself (not the network cable).
- `iface <config_name> <addr_family> <method> `: Interface
  configuration stanza. Followed by indented `key value` lines.

The common families are `inet` and `inet6`. Common methods are:
- `loopback`: IPv4 loopback interface
- `auto`: IPv6 autoconfiguration
- `static`
- `manual`: No configuration done by default; hook scripts may configure.
- `dhcp`
- `tunnel`
- `ppp`

Standard options to all `iface` families/methods are:
- `description NAME`: Alias interface by _NAME_.
- `pre-up`, `up`, `post-up`: Commands before/after bringing interface
  up, or down for `-down` variants.

Each family and method has its own additional options, and various
packages may add to these. E.g., the `resolvconf` package adds
`dns-domain` and `dns-nameservers` options.

References:
- `interfaces(5)` manpage.
- [Debian Network Setup reference][debnet]
- [NetworkConfiguration][dw-netconf] Debian wiki page

[debnet]: https://www.debian.org/doc/manuals/debian-reference/ch05
[dw-netconf]: https://wiki.debian.org/netconf


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
