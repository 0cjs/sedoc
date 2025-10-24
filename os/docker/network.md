Docker Container Networking
===========================

References:
- [Networking overview][net]
- [Packet filtering and firewalls][pf]


'Host' below refers to the Linux machine running the container processes.
On Windows (and probably MacOS) systems running Docker Desktop; this is the
VM running Linux and all network interfaces and virtual networks are on the
Linux host. The Windows/MacOS system does not have direct access to the
Docker bridge network internal to the Linux host. It's not clear if the
Linux VM is configured to route between the external network and internal
bridge network, but by default the routing table on the Windows host does
not use the Linux VM as a gateway.

By default Docker creates an internal bridge (using the `bridge` driver) on
which it puts network 172.17.0.0/16, with the Docker host on address
172.17.0.1 and containers receiving addresses 172.17.0.2 upwards. An
`/etc/hosts` file will be bind-mounted into the container containing the
loopback addresses/names and the internal bridge address/name of that
container.

User-defined networks can be created with `docker network create -d DRIVER
NETNAME` and used with run option `--network=NETNAME` (and optionally
`--name=CONTAINER-HOSTNAME`).

`docker compose` can also set up networks.

### /etc/hosts

You can add other hosts to the container's `/etc/hosts` with run command
options. (Other containers are still reachable on their addresses,
regardless of whether or not they're listed in `/etc/hosts`.)
- `--link CONTAINER-NAME` will add additional address/name entries for each
  _container-name_ you specify.
- `--add-host HOSTNAME:ADDR`.
- `--add-host host.docker.internal=host-gateway`.

### Network Drivers

* `bridge` (default): Internal bridge. Multiple bridge networks may be
  created; the default one is 172.17.0.0/16.
* `host`: Remove network isolation between the container and the Docker host.
* `none`: Completely isolate a container from the host and other containers.
* `overlay`: Overlay networks connect multiple hosts (running separate
  Docker daemons).
* [`ipvlan`]: IPvlan networks are configured as sub-interfaces on a
  specified parent interface and provide full control over the container's
  IPv4/IPv6 addressing, L2 VLAN tagging and L3 routing. Operating modes are
  `l2` (default), `l3` and `l3s`. Mode flags are `bridge` (default),
  `private`, `vepa`.
* [`macvlan`]: Creates a new sub-interface on the host for the container on
  a specified parent interface. Modes are `bridge` (default), `vepa`,
  `passthru`, `private`.



<!-------------------------------------------------------------------->
[`ipvlan`]: https://docs.docker.com/engine/network/drivers/ipvlan/
[`macvlan`]: https://docs.docker.com/engine/network/drivers/macvlan/
[net]: https://docs.docker.com/network/
[pf]: https://docs.docker.com/engine/network/packet-filtering-firewalls/
