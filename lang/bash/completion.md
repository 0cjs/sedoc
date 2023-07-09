Bash Command-line Completion
============================

Docs:
- __Programmable Completion__ in the manpage
- [8.6 Programmable Completion][bashref], Bash Reference Manual
- [An introduction to bash completion: part 1][debintro],
  debian-administration.org article

The [bash-completion][gh-bc] framework is separate from Bash itself; it is
what provides the completion code for many commands, helper functions for
creating new completions and completion code autoload.

Contents:
- [Bash Completion](#bash-completion)
- [Debian bash-completion Package](#debian-bash-completion-package)
- [bash-completion Framework](bash-completion-framework)


Bash Completion
---------------

When completion is requested (usually with `Tab`), Bash first determines
the command name and then tries to find a completion specification, called
a _comspec_ for that name, using a default comspec if a specific one is not
found. The comspec is used to generate the list of matching words, and is
defined with the `complete` command, which is roughly:

    complete -p [CMD]           # show comspec for CMD (default: all)
    complete -r [CMD]           # remove comspec for CMD (default: all)
    complete -F FN CMD          # Use function FN to complete CMD
    complete -C CCMD CMD        # Execute CCMD in a subshell to complete CMD

A comspec function called for completion is given:
- `$1`: name of command to be completed
- `$2`: the word being completed
- `$3`: the word preceeding the word being completed
- `$COMP_TYPE`: integer for various completion types; values unclear
- `$COMP_LINE`: the current command line
- `$COMP_WORDS`: array of individual words in current command line
- `$COMP_CWORD`: index into `$COMP_WORDS` of the word containing the current
  cursor position.
- Various other `COMP_*` variables are also available; see the manpage.

The comspec function should set the `COMPREPLY` array variable to the list
of possible completions. The `compgen` command is useful for this; it takes
the same options as `complete` for generating completions based on
filenames, etc. The output is one completion per line; to set the
`COMPREPLY` array from this:

    mapfile -t COMPREPLY < <(compgen -W "various words" -- "$2")

If you need to do something more sophisticated, such as complete only
executable files that are in another path, and you don't want the full path
to that being displayed, you need to build `COMPREPLY` yourself, making
sure that you include only the options that match any partial word being
completed:

    COMPREPLY=()
    local i
    for i in "$bindir/"*; do
        [[ ! -x $i && ! -L $i ]] && continue    # not executable
        i="$(basename "$i")"
        [[ $i == ${word}* ]] && COMPREPLY+=( "$(basename "$i")" )
    done


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

The current project site for bash-completion is on [gh-bc]. Old versions,
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

The [latest version][gh-bc] of bash-completion does appear to offer
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



<!-------------------------------------------------------------------->
[bashref]: https://tiswww.case.edu/php/chet/bash/bashref.html#Programmable-Completion
[debintro]: https://debian-administration.org/article/316/An_introduction_to_bash_completion_part_1
[gh-bc]: https://github.com/scop/bash-completion
