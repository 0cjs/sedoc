Python Functions and Callables
==============================

Functions are first class values of type `function`; variables
referencing them are in the same namespace as any other variables. `f`
refers to the function object and `f()` [calls] the function. (The
cpython `tp_call` field on C structs for objects points to the
function to be called; how this is set is dependent on the type of the
object and how it was constructed.)

Function definitions may be nested; free variables access variables in
the enclosing function (standard lexical closure).

Other objects besides functions can also be called in the same way;
these are _callables_:
  * built-in functions
  * user-defined functions (including lambdas and comprehensions)
  * methods of built-in objects
  * class objects (the call is expected to construct an instance)
  * methods of class instances
  * objects of classes having a callable `__call__` property

Use the built-in [`callable()`] function (not in Python 3.0/3.1) to
determine whether an object is (probably) callable or (definitely)
not. This can return false positives. E.g., the `__call__` property is
not checked to be callable itself because this can result in infinite
recursion (`self.__call__ = self`).

Note that objects may be [callable without having a `__call__()`
property][so-111255].

See also:
* Python Language Reference: [Function definitions][funcdef]
* Python Language Reference: [Calls]
* [How functions work][hfw] for low-level details


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

When [calling][calls] a function you may specify argument values by
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
be omitted.

Default values are evaluated left to right when the `def` statement is
executed. If the result is a reference to a mutable value, mutating
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


Recursion
---------

CPython does not have tail call optimization, though there's an
amusing (if inefficient) pure Python TCO implementation using
exceptions and `tail_return(foo, *args)` at [`tail_calling.py`].

The CPython interpreter limits the number of Python stack frames to
avoid overrunning its C stack, which would produce a segmentation
fault or similar. Exceeding the recursion limit will raise
`RecursionError` (≥3.5) or `RuntimeError` (≤3.4). The limit is
checked/changed with `sys.{get,set}recursionlimit()`. Setting the
limit lower than the current recursion depth will raise
`RecursionError` (≥3.5.1).


Decorators
----------

Decorators, documented as part of [function definitions][funcdef] are
syntatic sugar for passing a defined function, class, or coroutine to
a 'wrapping' function and assigning the result to the original
function's name. They may be nested.

    def foo(f):      return lambda s: 'Foo(' + f(s) + ')'
    def prefix(arg): return lambda f: lambda s: arg + '(' + f(s) + ')'

    @prefix('Bar')
    @foo
    def decorated(s): return s

    def manual(s): return s
    manual = prefix('Bar')(foo(manual))

    manual('Hi')            # ⇒ Bar(Foo(Hi))
    decorated('Hi')         # ⇒ Bar(Foo(Hi))

To wrap functions taking arbitrary args, you'll need to pass through
`*args` and `**kwargs`:

    def decorate(f):
      def wrapper(*args, **kwargs)
        f(*args, **kwargs)
      return wrapper

Wrappers can take optional arguments via kwargs
(`def w(_f=None, *, ...)`) or [via functools.partial][pycook9.6].

It's a common technique for decorators to return the original object
as-is (or with attributes added not affecting the call) but record
information about the object, such as a list of functions or classes
registered as added to an API.

* For a tutorial, see [Primer on Python Decorators][primer].
* For a clever combination of wrapping and further registration based
  on the original function (using added attributes, almost as if using
  a class), see [functools.singledispatch] and [PEP 443].

#### Support Functions for Decorators

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

[`operator.attrgetter()`], `itemgetter()` and `methodcaller` are
particularly useful for accessing attributes with functional control
structures:

    T = ntup('T', 'name count')
    ts = ( T('a',3), T('b',9), T('a',4) )
    map(operator.attrgetter('name', 'count'), ts)   # returns [('a',3), ...]

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

[The standard type hierarchy][typehier] has a section 'Callable types'
(scroll down to get to it).

- User-defined function: created by a [function definition[funcdef].
  Special attributes are as follows; all are writable (most checking
  the type of the assigned value) unless marked 'RO'.
  - `__doc__`: Docstring; `None` if not available; not inherited.
  - `__name__`, `__qualname__`: Name and (≥3.3) qualified (with
    module) name.
  - `__module__`: Name (as `str`) of module in which func was defined,
    or `None`.
  - `__defaults__`, `__kwdefaults__`: Tuple of default argument values
    and dict of default keyword arg values; either may be `None`.
  - `__code__`: Compiled function body
  - `__globals__`: (RO) Reference to global namespace of module in
    which function was defined.
  - `__dict__`: Namespace for arbitrary function attributes.
  - `__closure__`: (RO) Tuple of cells binding 's free vars, or
    `None`. Each has a writable `cell_contents` attribute.
  - `__annotations__`: Dict with parameter annotations; keys are
    parameter names and `return`.
- Instance method: combines class, class instance and a callable.
  There are various further details in the documentation. Additional
  attributes include:
  - `__self__`: Class instance object.
  - `__func__`: Function object.
  - `__doc__`, `__name__`, `__module__`: Refer to attrs on `__func__`.
- Generator function: a user-defined function using `yield`; always
  returns an [iterator](iter.md).
- Coroutine function: defined using `async def`.
- Asynchronous generator function: defined using `async def` and using
  `yield`.
- Built-in functions and methods: wrapper around a C function.
  `type()` returns `builtin_function_or_method`. Does not have
  user-settable attributes.
- Classes: calling them is usual object constructor; calls
  `.__new__()`, which defaults to calling `.__init__()`.
- Class instances: callable when `.__call__()` defined.

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


Descriptors
-----------

The [descriptor protocol][descriptor] allows customizing of object
attribute access. It's the core of method dispatch and the like.
There's a simple introduction at [Python Descriptors Demystified][beaumont]

The protocol is implemented by implementing at least one of the
following methods:

    .__get__(self, obj, type=None)  # ⇒ value
    .__set__(self, obj, value)      # ⇒ None
    .__delete__(self, obj)          # ⇒ None

These are often used with the [`property()`] function, especially as a
decorator, to make attribute access call a function.

[The complete summary of this is yet to be written.]



[PEP 3102]: https://www.python.org/dev/peps/pep-3102/
[PEP 362]: https://www.python.org/dev/peps/pep-0362/
[PEP 443]: https://www.python.org/dev/peps/pep-0443/
[PEP 448]: https://www.python.org/dev/peps/pep-0448/
[`callable()`]: https://docs.python.org/3/library/functions.html#callable
[`functools`]: https://docs.python.org/3/library/functools.html
[`operator.attrgetter()`]: https://docs.python.org/3/library/operator.html#operator.attrgetter
[`operator`]: https://docs.python.org/3/library/operator.html
[`property()`]: https://docs.python.org/3/library/functions.html?highlight=property#property
[`tail_calling.py`]: https://gist.github.com/iksteen/7948168640bdd67017c8
[beaumont]: https://nbviewer.jupyter.org/urls/gist.github.com/ChrisBeaumont/5758381/raw/descriptor_writeup.ipynb
[calls]: https://docs.python.org/3/reference/expressions.html#calls
[descriptor]: https://docs.python.org/3/howto/descriptor.html
[fpmods]: https://docs.python.org/3/library/functional.html
[funcdef]: https://docs.python.org/3/reference/compound_stmts.html#function-definitions
[functools.singledispatch]: https://docs.python.org/3/library/functools.html#functools.singledispatch
[hfw]: https://stupidpythonideas.blogspot.com/2015/12/how-functions-work.html
[iterable]: https://docs.python.org/3/glossary.html#term-iterable
[mapping]: https://docs.python.org/3/glossary.html#term-mapping
[primer]: https://realpython.com/primer-on-python-decorators/
[pycook9.6]: https://github.com/dabeaz/python-cookbook/blob/master/src/9/defining_a_decorator_that_takes_an_optional_argument/example.py
[so-111255]: https://stackoverflow.com/a/111255/107294
[typehier]: https://docs.python.org/3/reference/datamodel.html#the-standard-type-hierarchy
