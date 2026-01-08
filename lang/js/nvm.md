| [Overview](README.md) | [Node](node.md) | [TypeScript](ts.md)
| [NVM](nvm.md) | [NPM Packages](npm-package.md)
| [Async](async.md) | [Jest](jest.md)
|

nvm - Node Version Manager
==========================

[nvm] installs and allows switching between different versions of Node.js.

### Installation

The nvm [install instructions][inst] suggust useing of the latest release
of of the install script, but as of this writing that's almost a year old
(released 2025-04). The latest version on `main` has some bugfixes, and is
used with:

    curl -L -o- https://github.com/nvm-sh/nvm/raw/refs/heads/master/install.sh | bash

If your profile (`~/.bashrc` or similar) does not contain the string
`/nvm.sh`, it will be updated with the nvm initialisation code.

### Version Specifications

Throughout this document, _ver_ or _VER_ refers to a _version
specification._ This may be a complete version number, partial version
number (e.g. `v22`) or alias; use `nvm version VER` to resolve it to the
actual version that best matches it. `nvm version-remote VER` will do the
same for the list of all versions available to install.

The special version `current` will use `node` from $PATH, if present, or
give varying errors if there is no `node` in the path. This is documented
for some commands (e.g., `nvm which`), but not for others (`nvm exec`, `nvm
run`). This appears to override use of `.nvmrc` (see below). See also
[[nvm#3755]].

### Aliases

`nvm alias` will list all aliases for specific versions of `node`. (These
are also included in `nvm list`.)

Built-in aliases may never be deleted, and include:

    node        The latest vesion of `node`.
    iojs
    stable      (Deprecated: do not use.)
    unstable    (Deprecated: do not use.)

Other aliases (whether manually or automatically created) are stored as
files (containing a version number) and symlinks (to other aliases) under
`~/.nvm/alias` and may be deleted with `nvm unalias`. Well-known aliases
include:
* `default`: If present, the of `node` added to your path when you start a
  new shell. (This is done via `source "$NVM_DIR/nvm.sh"`, which, unless
  it's already present, is installed automatically when you install NVM.)
* `lts/*`: Alias to the latest LTS release alias (e.g.,
  `lts/krypton`).

Note that the LTS release aliases will sometimes be the latest installed
release, but sometimes the latest _available_ release. E.g., `lts/jod` may
be an uninstalled `v22.3.4`, rather than pointing to a locally installed
`v22.1.2`. It's unclear what circumstances produce this situation.

### `.nvmrc`

The `exec`, `run`, `use`, and `install` commands use an [`.nvmrc`] file
if found in the CWD or any parent directory. The `npm which` (with no
further arguments) command also uses this if present, but gives an error
(and help output) if no `.nvmrc` is found.

This file may contain a version specification or alias. Commands that find
and use `.nvmrc` will print a line indicating the full path to the file
being used and its contents.

### Commands

Below, _VER_ may be an alias or partial version specification. It may also
often (but not always?) be `current` to run `node` from $PATH.

    #   These use .nvmrc if available and VER is omitted.
    nvm run [VER] [ARGS]    Runs `node` with given args.
    nvm exec [VER] [CMD]    Runs given (shell) command with `node`
                            Uses default version if no VER given.

    nvm which current|VER   Print absolute path to `node`.

    nvm use VER             Add `node` VER to path.
    nvm deactivate          Remove NVM's `node` from path.

    nvm list                List all local node versions and aliases.
    nvm version VER         List resolved local version.
    nvm ls-remote           As above for all version that may be installed.
    nvm version-remote

    nvm alias NAME [VER]    Print or set an alias.
    nvm unalias NAME
    nvm install VER
    nvm uninstall VER



<!-------------------------------------------------------------------->
[`.nvmrc`]: https://github.com/nvm-sh/nvm?tab=readme-ov-file#nvmrc
[inst]: https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating
[nvm#3755]: https://github.com/nvm-sh/nvm/issues/3755
[nvm]: https://github.com/nvm-sh/nvm
