Python Functions
================

Functions are first class values of type `class function`; variables
referencing them are in the same namespace as any other variables. `f`
refers to the function object and `f()` [calls][Calls] the function.

Function definitions may be nested; free variables access variables in
the enclosing function (standard lexical closure).

Other objects besides functions can also be called in the same way;
these are _callables_:
  * built-in functions
  * user-defined functions
  * methods of built-in objects
  * class objects (the call is expected to construct an instance)
  * methods of class instances
  * all objects having a `__call__()` method

See also:
* Python Language Reference: [Function defintions][funcdef]
* Python Language Reference: [Calls]


Syntax
------

#### Basic Definition

    def f(x): return x + 1      # 'return' required
    g = f
    h = lambda x: x + 1         # no 'return'!

Function definitions are executable statements that create a function
object and bind it to a name in the local namespace. The object
contains a reference to the global namespace at time of creation and
will use that when the function is called.

#### Keyword Arguments

When [calling][Calls] a function you may specify argument values by
parameter name after any non-named arguments are bound in order:

    def f(a, b, c, d): return (a, b, c, d)

    f(1, 2, 3, 4)       # ⇒ (1,2,3,4)
    f(1, 2, d=4, c=3)   # ⇒ (1,2,3,4)
    f(1, d=4, 2, c=3)   # SyntaxError: non-keyword arg after keyword arg

Parameters with default values (see below) need not be specified.

#### Default Parameter Values

    def f(x = None, y = 13): return (x, y)

    f()         # ⇒ (None, 13)
    f(3)        # ⇒ (3, 13)
    f(y = 7)    # ⇒ (None, 7)

All parameters to the right of the first with a default value must
also have default values. On call, parameters with default values can
be ommitted.

Default values are evaluated left to right when the `def` statement is
executed. If the result is a refererence to a mutable value, mutating
that value will change the default args at runtime:

    def f(x = []):
        x.append(0)
        return x
    f()     # ⇒ [0]
    f()     # ⇒ [0, 0]

    def g(x = None):        # Workaround
        if x is None:
            x = []
        ...

#### Star Parameters and Arguments

* `*param` binds to _param_ a **tuple** with all excess positional args
* `**param` binds to _param_ a **dict** with all excess keyword args

(From Python 3.0. See [Calls] and [PEP 3102].)

    def f(x, *args, y='Y', **kwargs): return (x, args, y, kwargs)

    f(1)                    # ⇒ (1, (), {})
    f(1, 2, 3, a=7, bee=8)  # ⇒ (1, (2, 3), 'Y', {'a': 7, 'bee': 8})
    f(1, 2, 3, a=7, y='N')  # ⇒ (1, (2, 3), 'N', {'a': 7})

Passing in `*iter`, where _iter_ is an [iterable], will expand that as
additional positional arguments.

    a = [1, 2, 3, 4]
    f(a)            # ⇒ ([1, 2, 3, 4], (), 'Y', {})
    f(*a)           # ⇒ (1, (2, 3, 4), 'Y', {})
    f(y='N', *a)    # ⇒ (1, (2, 3, 4), 'N', {})
    f(*a, 5)        # SyntaxError: only named arguments may follow *expression

Passing in `**m`, where _m_ is a [mapping], will expand that as
additional keyword arguments:

    m = { 'a': 1, 'b': 2 }
    f(0, m)                 # ⇒ (0, ({'a': 1, 'b': 2},), 'Y', {})
    f(0, *m)                # ⇒ (0, ('b', 'a'), 'Y', {})
    f(0, **m)               # ⇒ (0, (), 'Y', {'a': 1, 'b': 2})
    f(0, **{'y':9})         # ⇒ (0, (), 9, {})
    f(0, y=9, **{'y':9})    # TypeError: f() got multiple values for keyword argument 'y'
    f(0, **{1:'a'})         # TypeError: f() keywords must be strings

[PEP 448] (Python 3.5) specifies additional unpacking generalization
allowing multiple `*`/`**` args and positional/keyword arguments after
them:

    f(0, *[10, 11], *[12], 13, **{'a':20, 'b':21}, **{'c':22}, d=23)

#### Annotations

Using `def`, parameters and the return may be annotated per [PEP 3107]
"Function Annotations" (Python 3.4, maybe even 3.0). Lambdas cannot be
annotated. Parameters are annotated as `identifier: expr` and the
return as `) -> expr:`. 

    def f(n: int = 0) -> str:
        return str(n)

    f.__annotations__   # ⇒ {'n': builtins.int, 'return': builtins.str}

This is syntax only; semantics are provided by libraries that
interpret the `__annotations__` attribute. (See [Type Annotations](
types.md#type-annotations).

Libraries that use annotations include:
* [typing] (3.5)


Decorators
----------

Decorators are syntatic sugar:

    def foo(f):      return lambda s: 'Foo(' + f(s) + ')'
    def prefix(arg): return lambda f: lambda s: arg + '(' + f(s) + ')'

    @prefix('Bar')
    @foo
    def decorated(s): return s

    def manual(s): return s
    manual = prefix('Bar')(foo(manual))

    manual('Hi')            # ⇒ Bar(Foo(Hi))
    decorated('Hi')         # ⇒ Bar(Foo(Hi))

[`functools`] (see more below) provides `update_wrapper()` and the
`@wraps` decorator to help preserve the names and docstrings:

    from functools import wraps

    def my_decorator(f):
        @wraps(f)
        def wrapper(*args, **kwds):
            return 'my_decorator(' + str(f(*args, **kwds)) + ')'
        return wrapper

    @my_decorator
    def f():
        """ a docstring """
        return 'f'

    f()             # ⇒ 'my_decorator(f)'
    f.__name__      # ⇒ 'f'
    f.__doc__       # ⇒ ' a docstring '


Higher-order Functional Programming
-----------------------------------

The [functional programming modules][fpmods] include:
* [`operator`]: standard operators (`+`, `=`, etc.) as functions
* [`functools`]: higher order functions and operations on callable objects

#### Partial Application

    from functools import partial
    from operator import add        # + function

    add(3, 4)                       # ⇒ 7
    add3 = partial(add, 3)
    add3(4)                         # ⇒ 7

    int('0b101', base=2)            # ⇒ 5
    b2int = partial(int, base=2)
    b2int('0b101')                  # ⇒ 5

#### Reduction (Folds)

    from functools import reduce
    import operator
    reduce(operator.add, [1,2,3], 4)         # ⇒ 10

### Currying

Various techniques are linked from SO [Currying decorator in python](
https://stackoverflow.com/q/9458271/107294).


Function Objects
----------------

#### Function Signature Objects

Available with [PEP 362] (Python 3.3).  

Use `inspect.signature(f)` to get the signature of function _f_.

    from inspect import signature
    def f(x, y=0, *args, z=0, **kwargs): pass
    s = signature(f)

    x = s.parameters['x']
    x.name                          # ⇒ 'x'
    x.kind                          # ⇒ x.POSITIONAL_OR_KEYWORD
    x.default                       # ⇒ inspect._empty
    x.annotation                    # ⇒ inspect._empty

    from inspect import Parameter
    s.parameters['y'].default       # ⇒ 0
    s.parameters['args'].kind       # ⇒ Parameter.VAR_POSITIONAL
    s.parameters['z'].kind          # ⇒ Parameter.KEYWORD_ONLY
    s.parameters['kwargs'].kind     # ⇒ Parameter.VAR_KEYWORD

C functions that use `PyArg_ParseTuple()` may also have
`POSITIONAL_ONLY` parameters.


[Calls]: https://docs.python.org/3/reference/expressions.html#calls
[funcdef]: https://docs.python.org/3/reference/compound_stmts.html#function-definitions
[PEP 3102]: https://www.python.org/dev/peps/pep-3102/
[iterable]: https://docs.python.org/3/glossary.html#term-iterable
[mapping]: https://docs.python.org/3/glossary.html#term-mapping
[PEP 448]: https://www.python.org/dev/peps/pep-0448/
[fpmods]: https://docs.python.org/3/library/functional.html
[`operator`]: https://docs.python.org/3/library/operator.html
[`functools`]: https://docs.python.org/3/library/functools.html
[PEP 362]: https://www.python.org/dev/peps/pep-0362/
