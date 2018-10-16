Python Exceptions
=================

_Note:_ Ian Bicking's [Re-Raising Exceptions][bicking] tutorial ranks
high in searches, but is from 2007 and covers only the obsolete Python
2 method of reraising.

All [Exceptions] are instances of [`BaseException`], which has the
following properties:
- `args`: The arguments with which the exception was instantated.
- `with_traceback(tb)`: Sets the traceback, returning self. See below.
- `__cause__`: The chained exception (`raise ... from ...`), if any.
- `__str__()`: String representation of the args.

The [`sys.exc_info()`] function returns a 3-tuple `(type, value, tb)`
of information about the current exception being handled, or `(None,
None, None)` if no exception is currently being handled.
- _type_: The exception class (a subclass of `BaseException`)
- _value_: The exception object (an instance of _type_)
- _tb_: A traceback object suitable to be passed to `with_traceback()`.


The `try` Statement
-------------------

The [`try`] statement must have an `except` or a `finally`; in either
case in the other one is optional and `else` is always optional.

    try: ...
    except ...: ...
    else: ...
    finally: ...

`except` matches all exceptions unless given an expression in which
case it matches only if resulting object is 'compatible' with the
exception. A 'compatible' object is either:
1. An exception class where the thrown exception is an instance of or
   subclass of that class;
2. A tuple one of whose members is such an exception class.

An `except` with an expression may have an additional `as` clause
giving an idenitifer to which to bind the exception:

    try:
        ...
    except (FileNotFoundError, ImportError) as e:
        raise NotFoundError(e.args).with_traceback(sys.exc_info()[2])


The `raise` Statement
---------------------

The [`raise`] statement comes in three forms.

#### No Arguments

Re-raises the previously caught exception, raising a `RuntimeError` if
no exception is active.

    try:
        ...
    except:
        cleanup()
        raise

#### Expression Argument

The expression is evaluated to get the exception object, which must be
an instance or subclass of `BaseException`. The [`with_traceback`]
method can be used to set the traceback:

    try:
        ...
    except SomeException:
        raise OtherException('...') \
            .with_traceback(sys.exc_info()[2])

#### Chained Exception

`raise e0 from e1` will set `e0.__cause__` to _e1_ and the entire
chain will be printed inner to outer if the outmost exception is not
handled.

When an exception is raised in a `except` or `finally` clause, the
previous exception is attached automatically, unless (Python ≥ 3.3)
suppressed with `from None`.

#### Three-argument Form

Python 2 only; not compatible with Python 3. Takes a tuple of `class,
instance/arg-tuple, traceback`. See [the documentation][raise-py2] for
details.

The [six library] offers the following [syntax compatibility]
functions that work in both Python 2 and 3:

* `six.raise_from(e0, e1)`:
  - Python 3: Same as `raise e0 from e1`.
  - Python 2: Same as `raise e0`
* `six.reraise(type, value, tb)`:
  Reraises an exception, including the `reraise()` stack frame.
  Often called as `six.reraise(*sys.exc_info())`.


Exception-related APIs
----------------------

The reentrant `contextlib.suppress` context manager is a convenient way of
suppressing/ignoring exceptions:

    from contextlib import suppress
    with suppress(FileNotFoundError):
        os.remove('somefile')


Exception Hierarchy
-------------------

These are just the most important exceptions; for a full list see the
[standard library exception hierarchy][hierarchy].

- `BaseException`
  - `SystemExit`
  - `KeyboardInterrupt`
  - `GeneratorExit`
  - `Exception`
    - `StopIteration`
    - `StopAsyncIteration` (≥3.6)
    - `ArithmeticError`
    - `AssertionError`
    - `AttributeError`
    - `EOFError`
    - `ImportError`
      - `ModuleNotFoundError`
    - `LookupError`: not found in collection
      - `IndexError`
      - `KeyError`
    - `NameError`: unbound variables etc.
    - `OSError`: system call failed, etc.
      - `ConnectionError`
        - `ConnectionRefusedError`: `ECONNREFUSED`
        - `ConnectionResetError`: `ECONNRESET`
        - ...
      - `FileExistsError`: `EEXIST`
      - `FileNotFoundError`: `ENOENT`
      - ...
    - `RuntimeError`: usual generic error
      - `NotImplementedError`
      - `RecursionError`
    - `SystemError`
    - `TypeError`
    - `ValueError`: value not valid, e.g., bad Unicode encoding
    - `Warning`
      - `UserWarning`: default category for [`warnings.warn()`]
      - `DeprecationWarning`
      - `RuntimeWarning`
      - `FutureWarning`: warnings intended for end-users (of apps)
         about deprecated features
      - `UnicodeWarning`
      - `BytesWarning`: warnings related to `bytes` and `bytearray`
      - `ResourceWarning`: warning about resource usage


Warnings
--------

Python [warning] categories are subclasses of the [`Warning`]
exception. Rather than being explicitly raised, [`warnings.warn()`] is
called with a category (a `Warning` subclass, default `UserWarning`)
at which point it decides what action to take based on with which
action the [warnings filter] has been configured:

| Action    | Description
|----------:|:-------------------------------------------------------------
| `default` | Print only first occurrence at that module/lineno.
| `module`  | Print only first occurrence in that module.
| `once`    | Print only first occurrence in interpreter process.
| `always`  | Print every occurrence, even at some module/lineno.
| `error`   | Raise exception for that warning category.
| `ignore`  | Print and raise nothing.

There is also a [`catch_warnings`] context manager to locally override
the configured action. (This does not work in multi-threaded apps.)

Entries in the filter are _(action, message, category, module, lineno)_
tuples:
- _action_: string from table above
- _message_: regexp to match message
- _category_: `Warning` subclass
- _module_: regexp to match module name
- _once_: If true, print only first match of this filter entry,
  regardless of location.

The warnings filter is configured with `-W`, `-b` and/or
`$PYTHONWARNINGS`. Tuple elements are separated with `:` and the
tuples themselves with `,`, separate lines or separate `-W` options.
There's also an API for configuration at runtime. The default list of
filters is:

    default::DeprecationWarning:__main__        # ≥ 3.7
    ignore::DeprecationWarning
    ignore::PendingDeprecationWarning
    ignore::ImportWarning
    ignore::ResourceWarning

Warnings are printed to `stderr`, but can be redirected through the
logging system with [`logging.captureWarnings()`].



[Exceptions]: https://docs.python.org/3/library/exceptions.html
[`BaseException`]: https://docs.python.org/3/library/exceptions.html#BaseException
[`Warning`]: https://docs.python.org/3/library/exceptions.html#Warning
[`catch_warnings`]: https://docs.python.org/3/library/warnings.html#warnings.catch_warnings
[`logging.captureWarnings()`]: https://docs.python.org/3/library/logging.html#logging.captureWarnings
[`raise`]: https://docs.python.org/3/reference/simple_stmts.html#the-raise-statement
[`sys.exc_info()`]: https://docs.python.org/3/library/sys.html#sys.exc_info
[`try`]: https://docs.python.org/3/reference/compound_stmts.html#the-try-statement
[`warnings.warn()`]: https://docs.python.org/3/library/warnings.html#warnings.warn
[`with_traceback`]: https://docs.python.org/3/library/exceptions.html#BaseException.with_traceback
[bicking]: http://www.ianbicking.org/blog/2007/09/re-raising-exceptions.html
[hierarchy]: https://docs.python.org/3/library/exceptions.html#exception-hierarchy
[raise-py2]: https://docs.python.org/2.7/reference/simple_stmts.html#the-raise-statement
[reentrant]: https://docs.python.org/3/library/contextlib.html#reentrant-context-managers
[six library]: https://pythonhosted.org/six/
[syntax compatibility]: https://pythonhosted.org/six/index.html#syntax-compatibility
[warning]: https://docs.python.org/3/library/warnings.html
[warnings filter]: https://docs.python.org/3/library/warnings.html#the-warnings-filter
