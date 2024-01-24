BASH_SOURCE, BASH_LINENO, FUNCNAME
==================================

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
- When in a function, the last element of $FUCNAME is set to `main`, and
  earlier elements are either `source` or a function name. $BASH_SOURCE
  elements are the names of the files.
