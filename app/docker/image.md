Docker Image Creation and Maintenance
=====================================

Images may be ["base" images created `FROM scratch`][base] (or without
a `FROM` line in the Dockerfile) or a layer on top of [another image],
e.g. `alpine`.

Images are built from a [`Dockerfile`][] (see also [best practices])
using `docker build . -t name:tag`.


Sample Build and Run
--------------------

[Alpine] is a popular small distro based on musl libc and Busybox with
a fairly large [package collection][alp-pkg]. This `Dockerfile`:

    FROM alpine:3.8
    RUN apk add bind
    EXPOSE 53 53/udp
    ENTRYPOINT ["named"]

is built and run with:

    docker build . -t capps-bind
    docker run capps-bind -v        # Runs `named -v` to show version
    docker run -p 53:53 -p 53:53/udp capps-bind
    #   We don't use -P; that binds to random ports on host side.


Dockerfile Commands
-------------------

See the [Dockerfile reference][`Dockerfile`] for full details.

Lines starting with `#` are comment lines; mid-line comments are not
allowed.

Build-time commands:
- `FROM name:tag`: Use _name:tag_ as the base image for the new image.
- `RUN`: Run command and add results to new lyaer

Run-time commands:
- `ENTRYPOINT`: Takes exec list (`["executable", "arg1", "arg2"]`) or
  remainder of line is passed to `/bin/sh -c` (this will not pass
  signals to the subprocess). `docker run` command arguments (or `CMD`
  args in a list) will be appened to an exec list, but not shell form.
  Can override with `docker run --entrypoint ''` and then specify
  command in the normal way.
- `CMD`: Default command args if none specified on command line. Must
  be exec list if `ENTRYPOINT` is using exec list.
- `EXPOSE`



[`Dockerfile`]: https://docs.docker.com/engine/reference/builder/
[alp-pkg]: https://pkgs.alpinelinux.org/packages
[alpine]: https://hub.docker.com/_/alpine/
[another image]: config.md#public-docker-images
[base]: https://docs.docker.com/develop/develop-images/baseimages/
[best practices]: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
