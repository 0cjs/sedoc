Python Summary/Quickref
=======================

Python's reference implementation is the [CPython] interpreter.
There are two major versions:
* 2.7 (2010): [legacy], supported until 2020 (latest 2.7.13 2016-12)
* 3.6.3 (2017-10): current (3.7 releasing 2018-06)

A good REPL is available via [ipython](./ipython.md).

Python variables are untyped; their values are typed. All variables
are references to objects or builtin types. [Functions](functions.md)
define variables in the same namespace and these reference function
objects.

There is limited implicit conversation, mainly between numeric types
and any type to boolean.


Syntax
-------

Statements are separated by semicolons or newlines. Indenting
introduces a new block that closes at the next dedent. Statements that
introduce blocks (`def`, `if`, `else`, etc.) are followed by a colon
and may not be on the same line as another block-introducing
statement. Following the colon may be a list of semicolon-separated
statements on the same line or an indented block on subsequent lines.
E.g.:

    if x == 0:  pass  # statement must be present so do nothing
    elif x > 0: foo; bar; baz()
    else:
        baz(0, 1, 2)
        quux('............................................')

For further details see the [lexical][lex] and [statement][stmts]
documentation.

If `return` is not used in a function it always returns `None`.
`lambda: expr` however returns `expr` and may not use `return`.

### [Compound Statements][stmts]

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
  * See [contextlib] for useful stuff.
* [Function definitions](functions.md)

### Types

See [types.md] for more information on the types below.

### Literals

Numbers: the usual: `0`, `-1`, `3.4`, `3.5e-8`.

String (`str`) Literals:

    'foo'           # C-style backslash sequences interpolated
    '''foo'''       # newlines are literal
    r'foo'          # no `\x` interpolation; useful for regexes

    'a' "b"         # adjacent literals are concatenated
    len('a'  # 1    # Good for commenting parts of strings.
        'b') # 2    # len('ab') => 2

Tuples, Lists, Dictionaries, Sets:

    1, 2                    # tuple
    (1, 2)                  # tuple
    ()                      # empty tuple

    [0, 'a', (), []]        # list
    list({4,2,3})           # list: [2,3,4] (from set; see below)

    { 1:'one', 'two':2 }    # dict
    {}                      # empty dict

    { 0, 'a', (), [] }      # set
    set()                   # empty set
    frozenset(['a',2,'a'])  # frozen set: frozenset({2, 'a'})


Objects
-------

`dir()` returns a list of names in local scope; `dir(obj)` returns the
list of `obj`'s attributes.


Further Reading
---------------

* Wikipedia, [Python syntax and semantics][wp].
* [The Python Language Reference][pyref].



[CPython]: https://en.wikipedia.org/wiki/CPython
[Exceptions]: https://docs.python.org/3/reference/executionmodel.html#exceptions
[`sys.exec_info()`]: https://docs.python.org/3/library/sys.html#sys.exc_info
[context manager]: https://docs.python.org/3/library/stdtypes.html#context-manager-types
[contextlib]: https://docs.python.org/3/library/contextlib.html#module-contextlib
[exprs]: https://docs.python.org/3/reference/expressions.html#expression-lists
[lambda]: https://docs.python.org/3/reference/expressions.html#lambda
[legacy]: https://wiki.python.org/moin/Python2orPython3
[lex]: https://docs.python.org/3/reference/lexical_analysis.html
[pyref]: https://docs.python.org/3/reference/
[stmts]: https://docs.python.org/3/reference/compound_stmts.html
[targets]: https://docs.python.org/3/reference/simple_stmts.html#assignment-statements
[wp]: https://en.wikipedia.org/wiki/Python_syntax_and_semantics
