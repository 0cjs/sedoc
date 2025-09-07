Docker Container Networking
===========================

References:
- [Networking overview][net]
- [Packet filtering and firewalls][pf]


By default Docker creates an internal bridge (using the `bridge` driver) on
which it puts network 172.17.0.0/16, with the Docker host on address
172.17.0.1 and containers receiving addresses 172.17.0.2 upwards. An
`/etc/hosts` file will be bind-mounted into the container containing the
loopback addresses/names and the internal bridge address/name of that
container.

You can add other hosts to the container's `/etc/hosts` with run command
options. (Other containers are still reachable on their addresses,
regardless of whether or not they're listed in `/etc/hosts`.)
- `--link CONTAINER-NAME` will add additional address/name entries for each
  _container-name_ you specify.
- `--add-host HOSTNAME:ADDR`.
- `--add-host host.docker.internal=host-gateway`.

User-defined networks can be created with `docker network create -d DRIVER
NETNAME` and used with run option `--network=NETNAME` (and optionally
`--name=CONTAINER-HOSTNAME`).

Network drivers:
- `bridge`: The default network driver.
- `host`: Remove network isolation between the container and the Docker host.
- `none`: Completely isolate a container from the host and other containers.
- `overlay`: Overlay networks connect multiple Docker daemons together.
- `ipvlan`: IPvlan networks provide full control over both IPv4 and IPv6 addressing.
- `macvlan`: Assign a MAC address to a container.

`docker compose` can also set up networks.

For more, see [Networking overview][net].



<!-------------------------------------------------------------------->
[net]: https://docs.docker.com/network/
[pf]: https://docs.docker.com/engine/network/packet-filtering-firewalls/
