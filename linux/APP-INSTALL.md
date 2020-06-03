Application Installation under Linux
====================================

cjs/njr Technique
-----------------

### Installation Directories

The tree under which an application is installed, which should be
treated as read-only to the application user, is called `$prefix`.It's
organized with `bin/`, `share` etc. subdirectories (see `hier(8)`).

Common `$prefix` directories are:
- `/usr/`: System-wide apps from the OS/distribution vendor.
- `/usr/local/`: System-wide apps installed by the sysadmin.
- `/opt/...`: App installations intended to be "standalone."
- `$HOME/.local/`: "User installations" of software. This is not
  (usually) read-only, but applications should treat it as such
  anyway.

"Development" installations can be built under a build directory in
the source (e.g., `.build/local/`) or can be the source dir itself
(with top-level `bin/`, `share/`, etc.) if all installed files are
source files. A developer might have several of these for different
versions of a single application.

### Finding $prefix

An executable should find its `$prefix` by assuming that `$0` is the
path to itself, recursively resolving all symlinks, and then removing
the final two components.

Bash always sets `$0` to the path to the executable, taken from
`argv[0]`. However, `argv[0]` itself is set by the interpreter that
ran the program; if it did not do this correctly you will not have a
path to your executable. It's not clear yet how to detect and deal
with this situation.

### Configuration and Data Directories

User-specific configuration and data file directories should be
searched before `$prefix` directories. Configuration and data files
installed with the application will typically be stored in
`$prefix/share/` (files common to all architectures) or `$prefix/lib`
(files for specific architectures); this implies that
`$HOME/.local/{share,lib}` should never be written to by the
application, and users should never be expected to put things there.

User-specific config/data/etc. directories should follow the [XDG Base
Directory Specification][xdg-spec]. These supply an `_HOME` directory
which is always searched first and which is expected to be writable,
and a `_DIRS` list of paths which are searched in order after `_HOME`.

- __DATA__: Data files. (These are files supplied by the user to
  override installed data files, not files that the application is
  expected to write.)
- __CONFIG__: Configuration files. These may be created independently
  by the user and/or (re-)written by the application.
- __CACHE__: Non-essential (cached) data.
- __RUNTIME__: Things relevant when the program is running, e.g.,
  sockets. This has many special conditions (ownership, lifetime)
  described in [the spec][xdg-spec].

The environment variables and their defaults values are:

    XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share/}
    XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}

    XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config/}
    XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/etc/xdg }

    XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

The `$XDG_RUNTIME_DIR` variable will be set on login on many Linux
systems (particularly those using systemd) to `/run/user/${uid}` or
similar. If it's not set, a runtime dir partially compliant with the
XDG spec can be created as follows. However, this will _not_ be
compliant with the "created on login, and cleared on logout" part of
the specification. Programs using this should thus remove their files
from the dir as early as reasonably possible.

    #   Use `set -e` or add appropriate error handling for all commands.
    [[ -n $UID ]]
    TMPDIR=${TMPDIR:-/tmp}
    XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$TMPDIR/xdgrun-$UID}
    mkdir -m 0700 -p "$XDG_RUNTIME_DIR"
    #   Ensures user owns the dir, since it will fail if he doesn't.
    chmod 0700 "$XDG_RUNTIME_DIR"
    export XDG_RUNTIME_DIR

A Bash function that can be used for searching for a file in the XDG
directories is:

    xdg_search() {
        local type="$1"; shift      # CONFIG or DATA
        local path="$2"; shift
        # XXX fill this in to search for $path in the list of paths
        # created from $XDG_${type}_HOME:$XDG_${type}_DIRS.
    }



<!-------------------------------------------------------------------->
[xdg-spec]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
