Bash Tricks
===========

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
