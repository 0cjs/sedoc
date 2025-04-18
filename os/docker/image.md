Docker Image Creation and Maintenance
=====================================

* [Overview](README.md) | [Install](install.md) | [Config](config.md)
  | [Image Build](image.md) | [Registries](registries.md)
  | [Security](security.md) | [Misc](misc.md) | [Tips](tips.md)
  | [Compose](compose.md)

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

`docker build` options (not all documented in manpage) include:
- `-f`, `--file`: Use the given filename instead of `Dockerfile` in the
  context as the list of instructions for building the image. Must be
  within the build context.
- `-q`, `--quiet`: Suppress build output; print image ID on success.
- `-t`, `--tag`: Name and optional tag for image in `name:tag` format.
- `--no-cache`: Do not re-use cached image layers. Useful when the exact
  same `RUN` command may produce different output. (See "Build Cache" below.)
- `--ssh`: SSH agent socket/keys to expose to build.
- `--build-arg`: Set build-time variable.
- `--label`: Set image metadata.
- `--progress=[auto|plain|tty|rawjson]`: How progress is shown. The default
  seems to be to show "partial window scrolling" output which is good to
  give some sense of progress when interactive. `plain` gives straight
  log output without tty fancyness and is good for debugging.

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


Build Cache
-----------

Each command in `Dockerfile` produces a new (unnamed, intermediate) image
that is used as the parent of the image for the next line. (Comments and
blank lines are ignored.) As well as the file changes in the image's
filesystem layer, the image also records the line that created it,
checksums of the files in the context, and a reference to the parent image.

These images are kept in the local repository a build cache and may be
re-used in subsequent builds if the line producing that image is determined
to be "unchanged." Once a line has been changed, a new image will be built
for that line and all subsequent lines will also be rebuilt due to the
change in parent.

The `--no-cache=true` or `--no-cache` command-line option to `build` will
always rebuild all images.

"Changed" commands are detected by comparing the line in the Dockerfile to
the line recorded in the cached image that was created from the same
parent. The rules for determining whether the line is changed are as
follows:

- Only changes in _commands_ and their arguments can invalidate the cache;
  Dockerfile comments are ignored.

- Any command that is textually different from the line recorded in the
  cached image (even if just a whitespace difference) is considered
  changed. But:

- Syntatic differences at the Dockerfile level do not count as changes if
  they leave you with the same command and arguments. E.g., all of the
  following are the same, and changing any one to any other will not
  invalidate the cache.

      RUN echo hello
      RUN    echo hello
      RUN ["echo", "hello"]
      RUN ["echo",   "hello"]

  But note that adding a second space between the words in `echo hello` in
  the first two examples above _will_ invalidate the cache.

- Other than for the commands discussed below, nothing else is checked.
  In particular, the output of commands is not considered so that `RUN
  date >build-date` will always use the cached image after the first
  build.

Commands with semantic invalidation checking:

* `ADD`, `COPY`: Checksums are generated for the applicable source files in
  the current context and compared against the checksums recorded in the
  image. If the checksums are different, the line is considered changed.
  - The checksums cover the file contents and file metadata, excepting the
    last-modified and last-access times. I.e.,
    - `echo foo >somefile` will not force a rebuild if `somefile` already
      contained `foo`.
    - `chmod +x somefile` will force a rebuild if and only if that changes
      the permissions the file had when doing the cached build.
  - The documentation implies that the files in the image's layer
    (filesytem) itself are checked; this is not the case. E.g., `COPY
    somefile /dev/null` will still work when the contents of `somefile`
    change, even though the contents of `/dev/null` in the image's layer
    never do.

* `ARG`: The image generated by this line itself is not considered changed
  unless there's a textual change. However, the variable value (whether the
  default or supplied with `--build-arg`) is compared with value when the
  cached image was built and, if different, the _next_ image to be
  generated is considered changed. Whether the value is ever used in
  subsequent lines of the Dockerfile makes no difference.

* `ENV`: Unlike `ARG`, the current value is not compared against the value
  used to build the cached image. A rebuild with a different value of that
  environment variable will still use the cached images that used the old
  value.

References (all but first have incomplete information):
- Docker Build manual: [Build Cache Invalidation][dd-bci]
- Docker docs: Dockerfile best practices [§ Leverage build cache][dd-dbp-lbc]
- [[so 49831094]]: Invalidate cache with COPY command
- [[so 37798643]]: Invalidate cache with ARG command


Dockerfile Commands
-------------------

See the [Dockerfile reference][`Dockerfile`] for full details.

Lines starting with `#` are comment lines; mid-line comments are not
allowed.

### Variables

Expansion:
- References `$name` or `${name}` are expanded to values set by `ARG`
  and `ENV`. Variables named by `ARG` are also set in the build process
  environment, but _not_ in the `docker run` process environment.
- Prevent expansion with a backslash: `\$foo`.
- `${name:-value}` evaluates to `value` if `$name` is not set.
- `${name:+value}` evaluates to `value` if `$name` is set, otherwise
  it evaluates to an empty string.
- Additional env vars in `value` will be expanded.
- Happens with `ADD COPY ENV EXPOSE FROM LABEL STOPSIGNAL USER VOLUME
  WORKDIR`

Setting values:
- `ARG name[=value]`: Set a build-time variable that is expanded with
  `$name` references and can be overridden with `--build-arg=name=value`
  options. `--build-arg` cannot set values not declared with `ARG`.
  ARG variables are not exported to the container's environment;
  you must use `ENV foo=$foo` to do this.
- `ENV name=value ...`: Set variables to be expanded in `$name`
  references and set in the process environment for both `RUN`
  commands and the container itself when run (like `--env`).
  - To avoid setting env vars in the container process, use `RUN
    name=value command`.
  - Space must be escaped with `\` or quoted with `"`. The `ENV key
    value etc.` does not require escapes.


### Build-time commands

Base Images and Build Stages:
- [`FROM name:tag [AS stagename]`][df-FROM]:
  - Use _name:tag_ as the base image for the new image, or `scratch`
    for no base image.
  - May [use variables declared by `ARG`][df-argfrom]; that is the only
    instruction that may preceed the first FROM. However, the preceeding
    ARG declarations are cleared at FROM; use `ARG foo` to re-declare the
    var, setting it to the previous value.
  - May be used multiple times. Each stage starts fresh, but may reference
    build products from previous stages with `COPY --from=stagename` and
    `RUN --mount=type=bind,from=stagename`.
- `ONBUILD`: Store a command to be run in an immediate child build
  based on this image (stored commands are executed immediately after
  the child build's `FROM`).

Layer filesystem updates:
- `RUN`: Run command and add results to new layer.
  - [Exec form]: Parsed as JSON array
    - e.g. `RUN [ "echo", "$HOME", 'C:\\Windows' ]`.
    - Backslashes must be escaped.
    - No variable substitution: need `[ "sh", "-c", "echo $HOME" ]`
  - [Shell form]
    - Escape char continues lines; removes whitespace after it!
    - Can use heredocs: `RUN <<END`, `...`, `END`.
    - `SHELL` sets interpreter cmd; default `SHELL ["/bin/bash", "-c"]`?
- `ADD`: Copy files from the build context, a tarfile or a remote URL
  (HTTPS or Git) into the container. Arg is
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
  - `--chown`, `--chmod`, `--link`: As for `COPY`.
- `COPY`: Similar to `ADD`, but copies only from build context.
  - `--from=<name|index>` copies from a previous build stage.
    - `<index>`th previous build stage with a `FROM` instruction.
    - Build stage created with `FROM ... AS <name>`.
    - Image named `<name>`.
  - `--chown=USER[:GROUP]`, `--chmod=PERMS` (octal/ugo±rwX)
  - `--link`: see docs.

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
[df-FROM]: https://docs.docker.com/reference/dockerfile/#from
[df-argfrom]: https://docs.docker.com/reference/dockerfile/#understand-how-arg-and-from-interact

[`docker build`]: https://docs.docker.com/engine/reference/commandline/build/
[another image]: config.md#public-docker-images
[base]: https://docs.docker.com/develop/develop-images/baseimages/
[best practices]: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
[terra-testing]: https://alexei-led.github.io/post/docker_testing/

[alp-pkg]: https://pkgs.alpinelinux.org/packages
[alpine]: https://hub.docker.com/_/alpine/

[dd-bci]: https://docs.docker.com/build/cache/invalidation/
[dd-dbp-lbc]: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#leverage-build-cache
[so 37798643]: https://stackoverflow.com/a/37798643/107294
[so 49831094]: https://stackoverflow.com/a/49831094/107294

[exec form]: https://docs.docker.com/reference/dockerfile/#exec-form
[filepath.Match]: http://golang.org/pkg/path/filepath#Match
[shell form]: https://docs.docker.com/reference/dockerfile/#shell-form
