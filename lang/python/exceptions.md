Python Exceptions
=================

* [Exceptions]
* [Ian Bicking's Re-Raising Exceptions][bicking]

Syntax
------

### raise

`raise` alone will re-raise the previous exception:

    try:
        f()
    except:
        do_whatever()
        raise

Three-argument:

    import sys
    einfo = sys.exc_info()
    raise einfo[0], einfo[1], einfo[2]


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
    - `LookupError`: not found in collection (IndexError, KeyError)
    - `NameError`: unbound variables etc.
    - `OSError`: system call failed, etc.
    - `RuntimeError`: usual generic error
      - `NotImplementedError`
      - `RecursionError`
    - `SystemError`
    - `TypeError`
    - `ValueError`: value not valid, e.g., bad Unicode encoding
    - `Warning`
      - `DeprecationWarning`
      - `RuntimeWarning`
      - `FutureWarning`


[Exceptions]: https://docs.python.org/3/library/exceptions.html
[bicking]: http://www.ianbicking.org/blog/2007/09/re-raising-exceptions.html
[hierarchy]: https://docs.python.org/3/library/exceptions.html#exception-hierarchy
