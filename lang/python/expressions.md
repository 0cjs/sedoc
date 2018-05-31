Python Expressions and Statements
=================================

Python reference documentation:
* [Expressions]
* [Compound statements][stmts]


[Operator Precedence]
---------------------

Highest to lowest. All operators in subgroups have equal precedence.
Includes info from link above and [PPR].

* Literals and Comprehensions
  * `{...}`         dict, set and their comprehensions
  * `[...]`         list; list comprehension
  * `(...)`         tuple; expression; generator expression
* References
  * `x.attr`        attribute reference
  * `x(...)`        call (function, method, class, other [callable])
  * `x[i:j:k]`      slicing (all bounds optional). Also `x[slice(i,j,k)]`.
  * `x[i]`          indexing (sequence, mapping, others)
* `await x`
* `x**y`            exponentiation
* `-x`, `+x`, `~x`  urnary negation, identity, bitwise NOT
* Multiplication
  * `*`             product; repetition
  * `@`             matrix product (not used by builtins)
  * `%`             remainder, (legacy) string formatting
  * `/`             division (Py3 always produces floating point result)
  * `//`            floor division (always produces int)
* `+ -`             addition, subtraction
* `x<<y, x>>y`      bitwise shift left, right by _y_ bits
* `&`               bitwise AND, set intersection
* `^`               bitwise XOR, set symmetric difference
* `|`               bitwise OR, set union
* Comparisons (when chanined, each _x_ evaled only once)
  * `== !=`         equality
  * `< <= > >=`,    ordering, set subset and superset
  * `is`, `is not`  object identity
  * `in`, `not in`  membership of iterable or set
* `not`             logical negation
* `and`             shortcut logical evaluation
* `or`              shortcut logical evaluation
* if
  * `if p: x`, `else: y`
  * `x if y else z` (_x_ evaluated only if _y_ is true)
* `lambda args: expr`
* `yield x`         generator function `send()` protocol

The list of [special method names] gives the method name equivalant of
each operator for use when overriding/overloading, and in particular
see the [emulating numeric types] section.

#### Python 2 Notes

The following Python-2-isms have been removed in Python 3:

* `<>` replaced by `!=`
* Backticks (\`x\`) no longer call `repr(x)`
* `x/y` no longer truncates (`x//y`) when _x_ and _y_ are ints


[Compound Statements][stmts]
----------------------------

* `if P: ...` / `elif P: ...` / `else: ...`
* `while EXPR: ...` / `else: ...`
  * `else` always executed at end of loop.
* `for TARGETS in EXPRS: ...` / `else: ...`
   * Comma-separate _[targets]_ and _[exprs]_ .
   * Use `range(10)` for 0..9.
   * Assignments in _targets_ override all previous assignments even in loop.
   * Careful when mutating _exprs_; copy (`for x in xs[:]:x`) if necessary.
* `break` / `continue`
  * Work as expected in `while` and `for`.
  * `break` in the first part causes `else` to be skipped.
* `try: ...` / `finally: ...`  
  `try: ...` / (`except [EXPR [as ID]]: ...`)+ / [`else: ...`] / `finally: ...`
  * Searches through multiple `except` clauses for match.
  * _ID_ is cleared at end of `except` clause; assign to other var if necessary.
  * [`sys.exc_info()`] gives exception info; not available in `finally`.
  * More info in [Exceptions].
* `with EXPR [as TARGET] [, EXPR [as TARGET] ...]: ...`
  * _expr_ produces a [context manager] having methods:
    * `__enter__(self)` returning object assigned to _target_.
    * `__exit__(self, exceptiontype, exceptionvalue, traceback)` returning
        * `False`, `None` etc. to continue exception (do not re-raise).
        * `True` etc. to suppress exception.
        * Throw exception to replace original.
  * Enter/exit can be called directly.
  * See [contextlib] for useful stuff, including:
    * `with closing(o)`: ensures `o.close()`
    * `with suppress(excs)`: suppresses listed exceptions
    * `with redirect_stdout(f)`: sends `sys.stdout` to `f` (similar for stderr)
    * `class mycon(ContextDecorator):` to use as `@mycon()` wrapping function
    * `ExitStack` to ammend context in `with` block (like nested `with`)
  * [Examples and recipes][contextlib-ex], e.g., optional context managers
    (particularly note rentrancy and reusability considerations)
* [Function definitions](functions.md)
* Class definitions
* Coroutines



[PPR]: http://shop.oreilly.com/product/0636920028338.do
[`sys.exec_info()`]: https://docs.python.org/3/library/sys.html#sys.exc_info
[callable]: functions.md
[context manager]: https://docs.python.org/3/library/stdtypes.html#context-manager-types
[contextlib-ex]: https://docs.python.org/3/library/contextlib.html#examples-and-recipes
[contextlib]: https://docs.python.org/3/library/contextlib.html#module-contextlib
[emulating numeric types]: https://docs.python.org/3/reference/datamodel.html#emulating-numeric-types
[exceptions]: https://docs.python.org/3/reference/executionmodel.html#exceptions
[expressions]: https://docs.python.org/3/reference/expressions.html
[exprs]: https://docs.python.org/3/reference/expressions.html#expression-lists
[operator precedence]: https://docs.python.org/3/reference/expressions.html#operator-precedence
[special method names]: https://docs.python.org/3/reference/datamodel.html#special-method-names
[stmts]: https://docs.python.org/3/reference/compound_stmts.html
[targets]: https://docs.python.org/3/reference/simple_stmts.html#assignment-statements
