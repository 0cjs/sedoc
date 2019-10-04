Bash Tips
=========

### Error Aborts



For more reliable scripts, set error-catching [options] at the start
and catch ERR to print a message on error exit:

    #!/usr/bin/env bash
    set -euo pipefail
    trap 'code=$?; echo 1>&2 ERROR!; exit $code' ERR

Useful [options]:

    -e          Exit on pipeline/list/compound command exiting with untested
                non-zero status. (For pipeline, only for last command.)
    -o pipefail Return status of pipeline is rightmost failure, if any,
                instead of rightmost command.
    -u          Error on use of undefined variable/param, except @ and *.
    -E          Traps on ERR inherited by functions, command substitutions
                and subshells.
    -T          Traps on DEBUG, RETURN inherited as above.

[options]: http://www.tldp.org/LDP/abs/html/options.html

### Inline Comments

In a multiline bash statement, inline comments (in the middle of a
command, with more command after them) can be handy. Use a subshell
with an "no effect" `:` command:

    wget --no-verbose \
        $(: '--mirror options: recursive, infinite levels, timestamp checks') \
        -r -l inf -N "$@"

### Assigning Default Values

To assign a default value to a variable if it's empty or unset:

    : ${SOMEVAR:=default value}

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
