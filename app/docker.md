Docker
======

Handy Commands
--------------

### Shell in Docker Container

    docker exec -it CONTAINER bash -l

* `-i`: Interactive, keep STDIN open even if not attached
* `-t`: Allocate a pseudo-TTY


[Docker Machine]
----------------

Use [Docker Machine] to provision virtual machines (local VMs, cloud
instances, whatever) configured with Docker Engine that then let you
use the `docker` command to use them just like a local Docker Engine.
(Docker Machine used to be used to set up a VM and Docker Engine on
Linux and Mac, though that's now been replaced by the "native"
versions of Docker Engine.)



[Docker Machine]: https://docs.docker.com/machine/overview/
