Docker Compose
==============

* [Overview](README.md) | [Install](install.md) | [Config](config.md)
  | [Image Build](image.md) | [Registries](registries.md)
  | [Security](security.md) | [Misc](misc.md) | [Tips](tips.md)
  | [Compose](compose.md)

Compose v2 has been rewritten in Go; the previous version was in Python.
[`compose-switch`] can translate old `docker-compose` command lines into
the new `docker compose` form.

References:
- GitHub [docker/compose][gh] project
- [Overview of Docker Comppose][overview] (still has obsolete v1 info)


Installation
------------

Ignore old instructions that talk about downloading a binary or using Pip
to install `docker-compose`. The new version is included in Docker Desktop
for Windows and MacOS.

### Local (for user)

    mdcd -p ~/.docker/cli-plugins
    #   Check version number and platform in URL below.
    curl -L -o docker-compose https://github.com/docker/compose/releases/download/v2.33.1/docker-compose-linux-x86_64
    chmod a+x docker-compose

The other instructions after this probably shouldn't be used.

### Debian (Global)

    mkdir -p /usr/local/libexec/docker/cli-plugins
    curl -L https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64 -o /usr/local/libexec/docker/cli-plugins/docker-compose
    chmod -R a+rX /usr/local/libexec
    chmod a+x /usr/local/libexec/docker/cli-plugins/*

    docker compose version      # as non-root user, confirm it worked

The Docker debian packages use `/usr/libexec/docker/cli-plugins` already:

    $ dpkg -S /usr/libexec/docker/cli-plugins/*
    docker-ce-cli: /usr/libexec/docker/cli-plugins/docker-app
    docker-ce-cli: /usr/libexec/docker/cli-plugins/docker-buildx
    docker-scan-plugin: /usr/libexec/docker/cli-plugins/docker-scan

### Generic (including single-user)

Download the appropriate binary from the [releases][gh-rel] page, copy it
to one of the following locations, and `chmod a=rx` it:

    $HOME/.docker/cli-plugins/docker-compose
    /usr/local/lib/docker/cli-plugins/docker-compose
    /usr/local/libexec/docker/cli-plugins/docker-compose
    /usr/lib/docker/cli-plugins/docker-compose
    /usr/libexec/docker/cli-plugins/docker-compose



<!-------------------------------------------------------------------->
[`compose-switch`]: https://github.com/docker/compose-switch
[gh-rel]: https://github.com/docker/compose/releases
[gh]: https://github.com/docker/compose
[overview]: https://docs.docker.com/compose/
