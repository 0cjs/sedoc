Bash Tips
=========

Also see [Bash Error Handling](errors.md) for error handling tips.

### Finding Location of Your Script

To do this portably in all shells, but giving the symlink location when
you're running a symlink:

    export PROJDIR=$(command cd "$(dirname "$0")/.." && pwd -P)

If you need the actual script file itself, rather than the symlink location
if there was one, the only portable version across Mac and Linux needs the
`realpath` command, available in GNU coreutils 8.15 (2012) and MacOS 10.13
(2017). But this may not be present in minimal userlands.

    export PROJDIR=$(command cd "$(dirname "$(realpath "$0")")/.." && pwd -P)

### Passing Parameters to a Script Read from stdin

    curl -sSL … | bash -s -- -…

### Inline Comments

In a multiline bash statement, inline comments (in the middle of a
command, with more command after them) can be handy. Use a subshell
with an "no effect" `:` command:

    wget --no-verbose \
        $(: '--mirror options: recursive, infinite levels, timestamp checks') \
        -r -l inf -N "$@"

### Assigning Default Values

The following will assign a default value to a variable if it's empty or
unset, and will not trigger an `ubound variable` error when using the `-u`
option.

    : ${SOMEVAR:=default value}

### Optional Arguments Based on Presence of Parameters

    #configfile="My Config"     # Uncomment to use config file
    someprogram ${configfile:+--config-file "$configfile"}

### Determining If a Glob Pattern Matched

`for i in *.c` will run the loop once with the glob pattern itself if
it didn't match anything. This can be fixed with:
* `shopt -s nullglob` will make unmatched patterns expand to no items.
* `compgen -G '<glob-pattern>' >/dev/null` returns 1 if no match.
  (Note that the glob pattern must be quoted to prevent shell
  expansion.)
These two methods avoid corner cases that `test -e` and the like have.
(Further discussion at [so-2937407].)

[so-2937407]: https://stackoverflow.com/q/2937407

### Run Initial Commands Before Going Interactive

Use process substitution to provide an rc file. This replaces the
standard system and user rc files, so you need to source those
explicitly if necessary. (From [so-586272].) This is particularly
useful when you want to pop up a terminal started with a particular
command.

    urxvt -g +400+100 -e bash --rcfile <(echo '. ~/.bashrc; lf')

[so-586272]: https://serverfault.com/a/586272/7408
