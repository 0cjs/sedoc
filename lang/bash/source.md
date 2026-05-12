The Bash `source` / `.` Command
===============================

The `source FILE` / `. FILE` builtin reads commands from _file,_ executes
them in the current shell environment, and returns:
- false if the file was not found or couldn't be read;
- `0` if no commands were executed; or
- the exit status of the last command executed.

$PATH is searched if _file_ does not contain a slash; this can be turned
off with `shopt -u sourcepath`.

The file need not be executable, and typically isn't if it's intended to be
sourced. (See [pactivate] for an example of how to check that you're being
sourced, along with checks that the shell is Bashful enough.)

### Positional Parameters

If any parameters are supplied, `"$@"` will be set to these for the
duration of the `source` execution. If none are supplied, `"$@"` is left
unchanged.

This can be a problem if you want to use parameters only if explicitly
supplied. The easiest solution to this is to have your `source`'d script
take a `--` argument for end-of-options and have the caller always supply
that after any potential options they might also supply.


BASH_SOURCE, BASH_LINENO, FUNCNAME
----------------------------------

The $BASH_SOURCE, $BASH_LINENO, and $FUNCNAME arrays give access to the
call stack for functions and the `source` command. The first element in the
array is the current level in the call stack.

In an interactive environment:
- When no functions are active, $BASH_SOURCE is an empty array and
  $FUNCNAME is unset.
- When in a function, $BASH_SOURCE will have a an element `main` for every
  function level, and $FUNCNAME will have a corresponding element with the
  name of each function.

When a script is running, the last element in $BASH_SOURCE is the name of
the script.
- When no functions are active, $FUNCNAME will be unset. Elements in
  $BASH_SOURCE before the last, if there are any, will be the names of
  `source`d files.
- When in a function, the last element of $FUNCAME is set to `main`, and
  earlier elements are either `source` or a function name. $BASH_SOURCE
  elements are the names of the files.


<!-------------------------------------------------------------------->
[pactivate]: https://github.com/cynic-net/pactivate
