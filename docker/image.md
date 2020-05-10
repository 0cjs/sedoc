Docker Image Creation and Maintenance
=====================================

* [Overview](README.md) | [Install/Config](config.md) | [Image Build](image.md)
  | [Registries](registries.md) | [Security](security.md) | [Misc](misc.md)
  | [Tips](tips.md) | [Compose](compose.md)

Images may be ["base" images created `FROM scratch`][base] (or without
a `FROM` line in the Dockerfile) or a layer on top of [another image],
e.g. `alpine`.

Images are built from a [`Dockerfile`][] (see also [best practices])
using [`docker build`]. The build happens in a "context", the set of
files that can be referred to in the build by `COPY` and similar
instructions. This is:
- A directory (most frequently `.`).
- A URL to a Git repo (cloned by the current user). A `#ref:subdir`
  fragment may be appended to the URL to indicate which ref is to be
  checked out and which subdir is to be used as the context.
- A URL to a tarball (fetched by the daemon) which will use the
  context.
- `-` to indicate that the `Dockerfile` is being given on `stdin`.
  `-f`/`--file` is ignored in this case, and commands requiring
  the context such as `COPY` cannot be used.

A `.dockerignore` file in the context dir can list patterns matching
files not to upload to the daemon when uploading context.

`docker build` options include:
- `-f`, `--file`: Use the given filename instead of `Dockerfile` in the
  context as the list of instructions for building the image. Must be
  within the build context.
- `-q`, `--quiet`: Suppress build output; print image ID on success.
- `-t`, `--tag`: Name and optional tag for image in `name:tag` format.
- `--no-cache`: Do not re-use cached image layers. Useful when the
  exact same `RUN` command may produce different output.
- `--ssh`: SSH agent socket/keys to expose to build.
- `--build-arg`: Set build-time variable.
- `--label`: Set image metadata.

For ideas about testing docker images and the software they contain,
see [Testing Strategies for Docker Containers][terra-testing].


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

### Variables

Expansion:
- References `$name` or `${name}` are expanded to values set by `ARG`
  and `ENV` (but not to values in the build process environment).
- Prevent expansion with a backslash: `\$foo`.
- `${name:-value}` evaluates to `value` if `$name` is not set.
- `${name:+value}` evaluates to `value` if `$name` is set, otherwise
  it evaluates to an empty string.
- Additional env vars in `value` will be expanded.
- Happens with `ADD COPY ENV EXPOSE FROM LABEL STOPSIGNAL USER VOLUME
  WORKDIR`

Setting values:
- `ARG name[=value]`: Set a build-time variable that is expanded with
  `$name` references and can be overridden with
  `--build-arg=name=value` options. `--build-arg` cannot set values
  not declared with `ARG`.
- `ENV name=value ...`: Set variables to be expanded in `$name`
  references and set in the process environment for both `RUN`
  commands and the container itself when run (like `--env`).
  - To avoid setting env vars in the container process, use `RUN
    name=value command`.
  - Space must be escaped with `\` or quoted with `"`. The `ENV key
    value etc.` does not require escapes.


### Build-time commands

Configuration:
- `FROM name:tag`: Use _name:tag_ as the base image for the new image.
- `ONBUILD`: Store a command to be run in an immediate child build
  based on this image (stored commands are executed immediately after
  the child build's `FROM`).

Layer filesystem updates:
- `RUN`: Run command and add results to new layer.
- `ADD`: Copy files from the build context into the container. Arg is
  - `["<src>", ... "<dest">]` but may be unquoted if no whitespace.
  - `<src>` files/dir paths are relative to the build context.
    Wildcards are matched using Go's [filepath.Match] rules; escape
    special chars that you do not want be patterns. Only contents of a
    dir are copied.
  - `<src>`, if _local_ and contents are tar+gz/bzip2/xz, is unpacked
    into dest.
  - `<src>` may be a remote URL (HTTP authentication not supported);
    dest perms will be `0600`.
  - `<dest>` is absolute or relative to `WORKDIR`. Trailing slash
    forces directory name into which files will be copied. All missing
    intermediate dirs are created.
  - Dest perms/timestamp are that of source file, or
    `0600`/`Last-modified:` for remote URLs.
  - Default UID:GID is 0:0; `--chown=<user>:<group>` option available
    in Linux containers.
- `COPY`: Similar to `ADD`, but copies only from build context.
  - `--from=<name|index>` copies from a previous build stage.
    - `<index>`th previous build stage with a `FROM` instruction.
    - Build stage created with `FROM ... AS <name>`.
    - Image named `<name>`.

### Run-time configuration

- `CMD`: Default command or args if none specified on `docker run`
  ocommand line. Without `ENTRYPOINT` this specifies default command
  to run. With `ENTRYPOINT`, specifies additional arguments. to be
  appended to `ENTRYPOINT`. Must be an exec list if `ENTRYPOINT` is an
  exec list.
- `ENTRYPOINT`: Takes exec list (`["executable", "arg1", "arg2"]`) or
  remainder of line is passed to `/bin/sh -c` (this will not pass
  signals to the subprocess). `docker run` command arguments (or `CMD`
  args in a list) will be appened to an exec list, but not shell form.
  Can override with `docker run --entrypoint ''` and then specify
  command in the normal way.
- `EXPOSE`



<!-------------------------------------------------------------------->
[`Dockerfile`]: https://docs.docker.com/engine/reference/builder/
[`docker build`]: https://docs.docker.com/engine/reference/commandline/build/
[alp-pkg]: https://pkgs.alpinelinux.org/packages
[alpine]: https://hub.docker.com/_/alpine/
[another image]: config.md#public-docker-images
[base]: https://docs.docker.com/develop/develop-images/baseimages/
[best practices]: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
[filepath.Match]: http://golang.org/pkg/path/filepath#Match
[terra-testing]: https://alexei-led.github.io/post/docker_testing/
