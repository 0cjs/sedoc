Linux Network Configuration
===========================

What's Listening?
-----------------

For most of these information will be incomplete unless run as root.

- `ss -lpf inet`: (package `iproute2`) shows sockets listening
  on _inet_ protocols with process name and PID
- `netstat -lp` (package `net-tools`) shows listening sockets with
  PIDs/program names. Add `-t`/`-u` for TCP/UDP.
- `lsof -i ap` (`@`_ap_ optional) shows sockets. _ap_ can be, e.g.,
  `tcp:80`, `:80`.
- `fuser 80/tcp` (package `psmisc`)


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
