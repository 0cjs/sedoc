Python [pytest] Library
=======================

[pytest] ([docs], [wiki]) uses Python's [`assert`] statement
instead of assertion functions and introspection to display values
that fail assertions:

        def test():
            expected = { 1: 'one', 2: 'two', }
            actual   = { 1: 'ichi', 3: 'san', }
    >       assert expected == actual, 'optional message'
    E       AssertionError: optional message
    E       assert {1: 'one', 2: 'two'} == {1: 'ichi', 3: 'san'}
    E         Differing items:
    E         {1: 'one'} != {1: 'ichi'}
    E         Left contains more items:
    E         {2: 'two'}
    E         Right contains more items:
    E         {3: 'san'}
    E         Use -v to get the full diff

    test.py:2: AssertionError

See the [reporting demo][repdemo] for more examples of how failures
are displayed, and [assertions] for details of how to define
`pytest_assertrepr_compare(`_config, op, left, right_`)` to define
custom comparisons and failure displays.

Under the hood, pytest [modifies the AST of test modules][ast-rewrite]
as they are loaded using [PEP 302] import hooks. Can this cause issues
with test frameworks that do their own loading?


Test Discovery
--------------

Pytest from the command line will [discover tests] using paths from
the first of the command line, the [`testpaths`] configuration
variable and the current directory. Files are added directly;
directories (excepting those in [`norecursedirs`]) are recursed to
find `test_*.py` and `*_test.py` files. All are imported by their
[`test package name`] derived from the first parent directory not
containing an `__init__.py` file). (This directory is added to
`sys.path`.) PEP 420 namespace packages without `__init__.py` files
may also work, but this needs to be investigated.

The test functions are those matching `test_*` that are at the
top-level (within the module) or within a `Test*` class that has no
`__init__` method.


Assertions
----------

See [assertions] for the basics, and [builtin] for details on the API
and fixtures. The following is an incomplete summary:

#### [Exceptions]

    import pytest
    def test_exceptions():
        with pytest.raises(ZeroDivisionError):
            1 / 0

        def forever(): forever()

        with pytest.raises(RuntimeError, match=r'max.*exceeded'):
            forever()

        with pytest.raises(RuntimeError) as e:      # e is ExceptionInfo
            forever()
        assert 'maximum recursion' in str(e.value)

Handy `ExceptionInfo` attributes include `type`, `typename`, `value`,
`tb` (raw traceback), `traceback` (Traceback instance),
`match(regexp)` and more.

#### Other Things

* `approx(`_expected, rel=None, abs=None, nan_ok=False_`)` should be
  used to compare floating point numbers:

      {'a': 0.1 + 0.2, 'b': 0.2 + 0.4} == approx({'a': 0.3, 'b': 0.6})

* The `deprecated_call` context manager ensures a block of code
  triggers a `DeprecationWarning` or `PendingDeprecationWarning`.

#### Test Outcomes

Most of the following would normally be done with decorators; see below.

* `fail(msg='', pytrace=True)`: Fail test with _msg_; no stack traceback
  if _pytrace_ is `False`.
* `skip(msg='')`: Skip (the rest of) the current test.
* `importorskip(modname, minversion=None)`: Checks __version__ attribute
  of module and skips if too low or can't load.
* `xfail(reason='')`:
* `exit()`: Exit test process.


[Configuration]
---------------

`pytest -h` will print out out the command line options and config
file settings, if any. The `pytest` command line tool finds the config
file by looking in the current then parent dirs for the first of the
following files:

* `pytest.ini` (used but breaks if no `[pytest]` section)
* [`tox.ini`](tox.md) with a `[pytest]` section
* `setup.cfg` with a `[tool:pytest]` section


XXX To-do
---------

* Marking failing tests with the decorator (mentioned in [assertions])
  [assertions] mentions the decorator `@pytest.mark.xfail(raises=IndexError)`.
  <https://docs.pytest.org/en/latest/skipping.html> and `pytest --markers`.
* `pytest_skipping` plugin
* <https://docs.pytest.org/en/latest/fixture.html#conftest-py> and
  fixture stuff from <https://docs.pytest.org/en/latest/builtin.html>
* <https://docs.pytest.org/en/latest/customize.html>
* <https://docs.pytest.org/en/latest/existingtestsuite.html>
  <https://docs.pytest.org/en/latest/usage.html#calling-pytest-from-python-code>
* Anything else left out from <https://docs.pytest.org/en/latest/contents.html>



[Configuration]: https://docs.pytest.org/en/latest/customize.html
[PEP 302]: https://www.python.org/dev/peps/pep-0302/
[`assert`]: https://docs.python.org/3/reference/simple_stmts.html#assert
[`norecursedirs`]: https://docs.pytest.org/en/latest/customize.html#confval-norecursedirs
[`test package name`]: https://docs.pytest.org/en/latest/goodpractices.html#test-package-name
[`testpaths`]: https://docs.pytest.org/en/latest/customize.html#confval-testpaths
[assertions]: https://docs.pytest.org/en/latest/assert.html
[ast-rewrite]: http://pybites.blogspot.jp/2011/07/behind-scenes-of-pytests-new-assertion.html
[builtin]: https://docs.pytest.org/en/latest/builtin.html
[discover tests]: https://docs.pytest.org/en/latest/goodpractices.html#test-discovery
[docs]: https://docs.pytest.org/en/latest/contents.html
[exceptions]: https://docs.python.org/3/library/exceptions.html
[pytest]: https://pytest.org/
[repdemo]: https://docs.pytest.org/en/latest/example/reportingdemo.html
[wiki]: https://wiki.python.org/moin/PyTest
