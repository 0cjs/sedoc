Linux VLAN Configuration
------------------------

Ethernet ports supporting 801.2Q VLAN may have frames that are:
  * Untagged
  * Tagged without VLAN ID
  * Tagged with VLAN ID


Tagged with VLAN ID are emitted/received by setting up on a new
interface for that VLAN layered above the interface on which the
tagged frames will be sent/received.

    ip link add link eth0 name eth0.123 type vlan id 123
    ip link set eth0.123 up
    ip addr add 10.0.0.1/24 dev eth0.123
    ip link show dev eth0.123
    ip link delete dev eth0.123

Adding `gvrp on` or `mvrp on` to the `link add` command will use GVRP
or MVRP to send a registration message to the switch, asking that this
port be added to the VLAN. (Whether this actually succeeds or not
depends on the switch configuration.) Note that the registration
message is not sent when the link is configured, but when the link is
brought up.

XXX on or off by default? XXX By default these appear to be off.


RHEL/CentOS `/etc/` VLAN Config
--------------------------

In `/etc/sysconfig/network-scripts`:

    ifcfg-eno2:
        # Onboard port 2 (physical interface for VLANs)
        DEVICE=eno2
        TYPE=Ethernet
        ONBOOT=yes
        BOOTPROTO=none

    ifcfg-eno2.110
        DEVICE=eno2.110
        ONBOOT=yes
        BOOTPROTO=none
        VLAN=yes
        BRIDGE=br110    # Or IPADDR, NETMASK etc. if directly used
