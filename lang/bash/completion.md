Bash Command-line Completion
============================

Docs:
- __Programmable Completion__ in the manpage
- [8.6 Programmable Completion][bashref], Bash Reference Manual
- [An introduction to bash completion: part 1][debintro],
  debian-administration.org article


Debian bash-completion Package
------------------------------

In Debian the `bash-completion` package brings in the script framework for
completion and completion definitions for many commands. (It assumes that
the commands are Gnu versions.) It includes:

- `/usr/share/doc/bash/README.bash_completion.gz`: Documentation of
  the Bash completion framework.
- `/etc/profile.d/bash_completion.sh`: Finds bash completion setup
  scripts and sources them. See below.
- `/etc/bash_completion`: Sources the `/usr/share` framework script
  below.
- `/usr/share/bash-completion/bash_completion`: The Bash completion
  framework.
- `/usr/bin/dh_bash-completion`: debhelper script for installing bash
  completions for a package.

#### /etc/profile.d/bash_completion.sh

This will:
- Confirm that the Bash version is ≥4.1, doing nothing if it's not.
- Source `${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion` if present.
  this can be used to set variables (such as `BASH_COMPLETION_COMPAT_DIR`)
  used by the script below.
- If shopt `progcomp` is set, source
  `/usr/share/bash-completion/bash_completion` if present.


bash-completion Framework
-------------------------

The current project site for bash-completion is on [github]. Old versions,
including the one distributed with Debian 9, list the project site as
<http://bash-completion.alioth.debian.org>, which is no longer available.

#### User-specific Configuration

The framework in older versions (including Debian 9) provides no no
user-specific directory for on-demand loading. However, typically users
will not have a large number of their own commands so it's not an issue to
have completions eagerly loaded at startup instead of on-demand.

* The primary mechanism for user completions is `~/.bash_completion`, which
  is sourced just before `/usr/share/bash-completion/bash_completion`
  exits.
* If you're calling `/usr/share/bash-completion/bash_completion` yourself,
  you can do whatever setup you like before it, such as setting variables
  (e.g., `BASH_COMPLETION_COMPAT_DIR`) that it uses.
* If you're using Debian's `/etc/profile.d/bash_completion.sh`, that will
  source `${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion`, if present,
  before sourcing `/usr/share/bash-completion/bash_completion`;

The [latest version][github] of bash-completion does appear to offer
user-specific load-on-demand from `$BASH_COMPLETION_USER_DIR/completions`,
defaulting to `${XDG_DATA_HOME:-.local/share}/bash-completion`.

#### Standard Completions and Helpers Directories

It expects to find completion setup scripts and helpers in the following
directories:
- `/etc/bash_completion.d`: Obsolete; for backwards compatibility only.
  Files in this directory are loaded at shell startup, not on-demand.
- `/usr/share/bash-completion/completions`: Scripts and symlinks to them
  loaded on-demand when a completion is first attempted on a command with
  that name.
- `/usr/share/bash-completion/helpers`: ???

Completions are loaded on demand based on the command name from:

    $ pkg-config --variable=completionsdir bash-completion
    /usr/share/bash-completion/completions

#### Framework Functions

The framework provides various helper functions that you can use in
your own completion scripts, e.g., `_known_hosts_real` which will
search SSH configuration files among others (including custom files
if specified) for hosts.

Using these can be as simple as, e.g., `complete -F _known_hosts myssh`.



[bashref]: https://tiswww.case.edu/php/chet/bash/bashref.html#Programmable-Completion
[debintro]: https://debian-administration.org/article/316/An_introduction_to_bash_completion_part_1
[github]: https://github.com/scop/bash-completion
