Docker
======

Documentation:
* [Docker Image Creation and Maintenance](image.md)
* [Docker Installation and Configuration](config.md)
* [Docker Security](security.md)
* [Docker Tips](tips.md) for handy commands and the like.
* [Reference documentation] for complete documentation.
* [Engine CLI] for `docker` command details.
  (This provides a lot of information not in the manpages.)


Terminology
-----------

A Docker __container__ is one or more process with their own
configuration for access to disk/network resources, UIDs/GIDs, etc. on
the host. Each container has its own disk store for the root volume
and may also have host resources mounted in it. The initial disk store
for a container is created from an __image__.

Each Docker instance has a local set of images; these are either
created locally using the [docker build] process or pulled (copied)
from a registry. Images are identified by a unique __digest__; this is
generated at the time it's built and will be different for another
build from the same image description. Images may also be identified
by a __tag__ local to the image store (e.g. `alpine:latest`); the tag
within a store may point to different images over time.

A __registry__ is an image store from which one can __pull__ images to
or __push__ images from a local Docker instance. Registries use a
standard [HTTP API] currently at version 2. Images in registries are
stored in collections known as __repositories__; each collection
usually contains different versions of an image designed for a
particular purpose (e.g., `alpine`). See the [Docker Hub] registry
(and below) for an example.


