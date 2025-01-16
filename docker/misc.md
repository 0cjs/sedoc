Docker Miscellaneous Documentation
==================================

* [Overview](README.md) | [Install](install.md) | [Config](config.md)
  | [Image Build](image.md) | [Registries](registries.md)
  | [Security](security.md) | [Misc](misc.md) | [Tips](tips.md)
  | [Compose](compose.md)

Object Labels
-------------

[Object labels][labels] are key-value pairs that can be added to most
Docker objects, including images, containers, local daemons, volumes,
networks, and swarm nodes and services. They are displayed with other
metadata when `inspect`ing objects.

With the exception of swam nodes and services, labels are specified at
creation time and may not be changed after that.

_Keys_ may use alphanumeric characters and non-consecutive `-` and
`.`. The following further guidelines are suggested:
- Begin and end with a letter and use only lower-case letters.
- Prefix labels with a _namespace_, the reversed DNS domain of the
  managing organization, e.g., `com.example.some-label`. The following
  namespaces are reserved for internal use: `com.docker.*`,
  `io.docker.*`, `org.dockerproject.*`.
- Use non-namespaced keys only for command-line use, where it's good
  for them to be typing-friendly.

_Values_ may be any string. (Docs are not clear about "text" vs. "binary.")

### Commands

Many command-line commands take a `--label` option, sometimes
abbreviated with `-l`. If no value is supplied it defaults to the
empty string. E.g.:

    docker build . --label version=1.0 maintainer='Joe <joe@example.com>'
    docker run -l keepme -l owner=me ubuntu bash -l

Labels may also be loaded from files by specifying one or more
`--label-file=...` options. Labels are one `key=value` pair per line;
blank lines and lines starting with `#` are ignored.

The `LABEL` command may be used in Dockerfiles:

    LABEL version="1.0" maintainer="Joe <joe@example.com>"

[labels]: https://docs.docker.com/config/labels-custom-metadata/
