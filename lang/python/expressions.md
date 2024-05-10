Python Expressions and Statements
=================================

Python reference documentation:
- [Expressions]
- [Compound statements][stmts]


Operators
---------

The list of [special method names] gives the method name equivalant of
each operator for use when overriding/overloading, and in particular
see the [emulating numeric types] section.

#### Precedence

This table includes information from [operator precedence] and [PPR].
All operators in subgroups have equal precedence. From highest to lowest:

- Literals and Comprehensions
  - `{...}`         dict, set and their comprehensions
  - `[...]`         list; list comprehension
  - `(...)`         tuple; expression; generator expression
- References
  - `x.attr`        attribute reference
  - `x(...)`        call (function, method, class, other [callable])
  - `x[i:j:k]`      slicing (all bounds optional). Also `x[slice(i,j,k)]`.
  - `x[i]`          indexing (sequence, mapping, others)
- `await x`
- `x**y`            exponentiation
- `-x`, `+x`, `~x`  urnary negation, identity, bitwise NOT
- Multiplication
  - `*`             product; repetition
  - `@`             matrix product (not used by builtins)
  - `%`             remainder, (legacy) string formatting
  - `/`             division (Py3 always produces floating point result)
  - `//`            floor division (always produces int)
- `+ -`             addition, subtraction
- `x<<y, x>>y`      bitwise shift left, right by _y_ bits
- `&`               bitwise AND, set intersection
- `^`               bitwise XOR, set symmetric difference
- `|`               bitwise OR, set union
- [Comparisons] (when chanined, each _x_ evaled only once)
  - `== !=`         equality
  - `< <= > >=`,    ordering, set subset and superset
  - `is`, `is not`  object identity
  - `in`, `not in`  membership of iterable or set
- `not`             logical negation
- `and`             shortcut logical evaluation
- `or`              shortcut logical evaluation
- if
  - `if p: x`, `else: y`
  - `x if y else z` (_x_ evaluated only if _y_ is true)
- `lambda args: expr`
- `yield x`         generator function `send()` protocol

#### Operator Details

For more details on the slice operator `xs[i:j:k]`,  see
[Python Sequences Types and Interfaces](sequence.md).

Comprehensions, which execute in a separate scope (variables don't
'leak' out) are an expression followed by at least one `for`
_target-list_ `in` _..._ clause and then zero or more `for`/`if`
clauses. E.g.:

    >>> [ (x,y) for x in range(5) for y in range(6) if y%2== 0 if x>2 ]
    [(3, 0), (3, 2), (3, 4), (4, 0), (4, 2), (4, 4)]

In CPython comprehensions implement a separate scope by creating a new
stack frame; this can cause unexpected `RecursionError`s because a
recursive function calling itself from a comprehension will generate
twice as many stack frames as you have recursive calls. See [Batchelder].


Packing and Unpacking with `*` and `**`
---------------------------------------

The `*` and `**` operators are used in various places to convert
between sequences and mappings and multiple variables. This is a
summary of blog post [Asterisks in Python][hunner].

When calling a function, asterisks unpack sequences and mappings to
parameters in the definition. They can be used multiple times in a
function call in Python ≥ 3.5. Key collisions from different
dictionaries will result in an exception.

    f(*list, *tuple, **map1, **map2)

In function definitions they pack individual arguments passed when called:

    def f(*args, **kwargs): ...
    f(1, 2, 3, foo=1, bar=2)        # args=[1,2,3], kwargs={'foo':1,'bar':2}

    def f(a, b=1, *, c=2, d): ...   # kwargs forced _after_ * or param *foo
    f(0, d=4)
    f(0)            # TypeError: f() missing 1 required keyword-only argument: 'd'
    f(1, 2, 3, 4)   # TypeError: f() takes from 1 to 2 positional arguments but 4 were given

Iterable unpacking ([PEP 3132], Python ≥3.0):

    fst, *mid, lst = (0,1,2,3,4)            # fst=0, mid=(1,2,3), lst=4
    (s0, *ss), *ts = ('abc', 'def', 'ghi')  # s0='a', ss='bc', ts=('def','ghi')
    first, rest = seq[0], seq[1:]           # Python 2

    #   Note carefully tuple vs. list creation from iterables:
    *lst, =  range(0,3)     # lst = [0, 1, 2]
    tup   = *range(0,3),    # tup = (0, 1, 2)

Additional iterable unpacking ([PEP 448], Python ≥ 3.5)

    [ *seq, *reversed(seq) ]            # list
    ( *seq[1:], seq[0] )                # tuple
    { *xs, *(x.upper() for x in xs) }   # set

    #   In dicts later ovrrides earlier: c=6
    { **dict(a=1, b=2), 'c':3, **{ 'd':4, 'e':5 }, 'c':6 }


Compound Statements
-------------------

Full details at [Compound Statements][stmts] in the Python docs.

- `if P: ...` / `elif P: ...` / `else: ...`
- `while EXPR: ...` / `else: ...`
  - `else` always executed at end of loop.
- `for TARGETS in EXPRS: ...` / `else: ...`
   - Comma-separate _[targets]_ and _[exprs]_ .
   - Use `range(10)` for 0..9.
   - Assignments in _targets_ override all previous assignments even in loop.
   - Careful when mutating _exprs_; copy (`for x in xs[:]:x`) if necessary.
- `break` / `continue`
  - Work as expected in `while` and `for`.
  - `break` in the first part causes `else` to be skipped.
- `try: ...` / `finally: ...`  
  `try: ...` / (`except [EXPR [as ID]]: ...`)+ / [`else: ...`] / `finally: ...`
  - Searches through multiple `except` clauses for match.
  - `else` is executed if no exception is thrown
  - `finally` is always executed
  - _ID_ is cleared at end of `except` clause; assign to other var if necessary.
  - [`sys.exc_info()`] gives exception info; not available in `else`/`finally`.
  - More info in [Exceptions].
- `with EXPR [as TARGET] [, EXPR [as TARGET] ...]: ...`
  - _expr_ produces a [context manager] having methods:
    - `__enter__(self)` returning object assigned to _target_.
    - `__exit__(self, exceptiontype, exceptionvalue, traceback)` returning
        - `False`, `None` etc. to continue exception (do not re-raise).
        - `True` etc. to suppress exception.
        - Throw exception to replace original.
  - Enter/exit can be called directly.
  - See [contextlib] for useful stuff, including:
    - `with closing(o)`: ensures `o.close()`
    - `with suppress(excs)`: suppresses listed exceptions
    - `with redirect_stdout(f)`: sends `sys.stdout` to `f` (similar for stderr)
    - `class mycon(ContextDecorator):` to use as `@mycon()` wrapping function
    - `ExitStack` to ammend context in `with` block (like nested `with`)
  - [Examples and recipes][contextlib-ex], e.g., optional context managers
    (particularly note rentrancy and reusability considerations)
- [Function definitions](functions.md)
- [Class definitions][classdef]
- Coroutines



<!-------------------------------------------------------------------->
[Batchelder]: https://nedbatchelder.com/blog/201812/a_thing_i_learned_about_python_recursion.html
[PEP 3132]: https://www.python.org/dev/peps/pep-3132/
[PEP 448]: https://www.python.org/dev/peps/pep-0448/
[PPR]: http://shop.oreilly.com/product/0636920028338.do
[`sys.exec_info()`]: https://docs.python.org/3/library/sys.html#sys.exc_info
[callable]: functions.md
[classdef]: https://docs.python.org/3/reference/compound_stmts.html#class-definitions
[comparisons]: https://docs.python.org/3/reference/expressions.html#comparisons
[context manager]: https://docs.python.org/3/library/stdtypes.html#context-manager-types
[contextlib-ex]: https://docs.python.org/3/library/contextlib.html#examples-and-recipes
[contextlib]: https://docs.python.org/3/library/contextlib.html#module-contextlib
[emulating numeric types]: https://docs.python.org/3/reference/datamodel.html#emulating-numeric-types
[exceptions]: https://docs.python.org/3/reference/executionmodel.html#exceptions
[expressions]: https://docs.python.org/3/reference/expressions.html
[exprs]: https://docs.python.org/3/reference/expressions.html#expression-lists
[hunner]: https://treyhunner.com/2018/10/asterisks-in-python-what-they-are-and-how-to-use-them/
[operator precedence]: https://docs.python.org/3/reference/expressions.html#operator-precedence
[special method names]: https://docs.python.org/3/reference/datamodel.html#special-method-names
[stmts]: https://docs.python.org/3/reference/compound_stmts.html
[targets]: https://docs.python.org/3/reference/simple_stmts.html#assignment-statements
