Docker Configuration
====================

* [Overview](README.md) | [Install](install.md) | [Config](config.md)
  | [Image Build](image.md) | [Registries](registries.md)
  | [Security](security.md) | [Misc](misc.md) | [Tips](tips.md)
  | [Compose](compose.md)


Managment Systems
-----------------

* [Docker Compose](compose.md) for configuration of mulitple local containers.
* [Docker Machine] provisions virtual machines (local VMs, cloud
  instances, whatever) configured with Docker Engine that then let you
  use the `docker` command to use them just like a local Docker
  Engine. (Docker Machine used to be used to set up a VM and Docker
  Engine on Linux and Mac, though that's now been replaced by the
  "native" versions of Docker Engine.)
* [Deis Workflow] builds on Kubernetes to provide developer-driven app
  deployment.

See also [`server.md`](./server.md) for more on servers, contexts and
orchestration. (That should probably be merged into this and other files.)



<!-------------------------------------------------------------------->
[Deis Workflow]: https://deis.com/docs/workflow/
[Docker Machine]: https://docs.docker.com/machine/overview/
