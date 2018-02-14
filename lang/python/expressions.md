Python Expressions and Statements
=================================

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



[`sys.exec_info()`]: https://docs.python.org/3/library/sys.html#sys.exc_info
[context manager]: https://docs.python.org/3/library/stdtypes.html#context-manager-types
[contextlib-ex]: https://docs.python.org/3/library/contextlib.html#examples-and-recipes
[contextlib]: https://docs.python.org/3/library/contextlib.html#module-contextlib
[exceptions]: https://docs.python.org/3/reference/executionmodel.html#exceptions
[exprs]: https://docs.python.org/3/reference/expressions.html#expression-lists
[stmts]: https://docs.python.org/3/reference/compound_stmts.html
[targets]: https://docs.python.org/3/reference/simple_stmts.html#assignment-statements
