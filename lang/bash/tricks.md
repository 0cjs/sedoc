Bash Tricks
===========

### Assigning Default Values

To assign a default value to a variable if it's empty or unset:

    : ${SOMEVAR:=default value}

### Run Initial Commands Before Going Interactive

Use process substitution to provide an rc file. This replaces the
standard system and user rc files, so you need to source those
explicitly if necessary. (From [so-586272].) This is particularly
useful when you want to pop up a terminal started with a particular
command.

    urxvt -g +400+100 -e bash --rcfile <(echo '. ~/.bashrc; lf')

[so-586272]: https://serverfault.com/a/586272/7408
