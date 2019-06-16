Docker
======

* [Overview](README.md) | [Install/Config](config.md) | [Image Build](image.md)
  | [Registries](registries.md) | [Security](security.md) | [Tips](tips.md)

Detailed list of pages here:
* [Overview](README.md)
* [Install/Config](config.md): Docker Installation and Configuration
* [Image Build](image.md): Docker Image Creation and Maintenance
* [Registries](registries.md): Docker Registries, Private and Public Images
* [Security](security.md): Docker Security
* [Tips](tips.md): Docker Tips; handy commands and the like

External Documentation:
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
from a registry. Images are identified by a unique __image id__; this
is generated at the time it's built and will be different for another
build from the same image description. (But layer caching!) Images may
also be identified by an __alias__ formed from the __repository name__
and __tag__, e.g. `alpine:latest`. An alias within a store may point
to different images over time.
- The name portion of an alias is slash-separated components
  consisting of lower-case letters, digits, and separators that may
  not start the name. Separators are single `.`, one or two `_`, and
  any number of `-`.
- The name portion is optionally prefixed by a registry hostname that
  cannot contain `_`. The hostname must either contain a `.` or be
  followed by a `:` and port number. If no hostname is present,
  `registry-1.docker.io` is used.
- The tag portion of an alias is separated by a colon from the name,
  no more than 128 characters, may not start with `.`/`-`, and is
  otherwise letters, digits, and `_`/`.`/`-`. If not specified it
  defaults to `:latest`.

Images include a list of references to __layers__ containing the
changed files that [contribute to a derived container's
filesystem][image-ids]. The layers are identified by a __digest__ of
the tarball containing the files changed in that layer in the form
_algo:hexstring_, e.g., `sha256:fc92ee...`. There is also a separate
digest for the compressed version of the layer used in registry
manifests. Layers have no notion of an image or of belonging to an
image, they are merely collections of files and directories.

A __registry__ is an image store from which one can __pull__ images to
or __push__ images from a local Docker instance. Registries use a
standard [HTTP API] currently at version 2. Images in registries are
stored in collections known as __repositories__; each collection
usually contains different versions of an image designed for a
particular purpose (e.g., `alpine`). See the [Docker Hub] registry
(and below) for an example.

[image-ids]: https://windsock.io/explaining-docker-image-ids/


Further Reading
-------------

* [Terra Nullius](https://alexei-led.github.io/).
  Blog that covers "everday hacks for docker," e.g. [multi-stage
  build](https://alexei-led.github.io/post/node_docker_multistage/).


<!-------------------------------------------------------------------->
[engine CLI]: https://docs.docker.com/engine/reference/commandline/cli/
[reference documentation]: https://docs.docker.com/reference/
