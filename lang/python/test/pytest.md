Python Pytest Library
=====================

For information on configuration and customization of Pytest, see
[pytest-config](pytest-config.md).

Documentation:
* [Standard Homepage/Documentation][pytest]
  * [Reference]: Functions, objects, variables, configuration options
  * [Examples and customization tricks][examples]
* [Restructed Documentation][restruc] (sometimes better; kind of a secret!)

Overview
--------

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

See [Test Discovery](pytest-config.md#test-discvoery) for details of
how to name test functions and files.

Scopes
------

Pytest has at least two different kinds of scoping.

Run scoping (my term) is one of _session_, _module_, _class_ or
_function_ and refers to particular start and end points during a test
session.
* A run scope can be passed (as `scope=...`) to [`@pytest.fixture`] to
  determine when a fixture is to be torn down.
* Various [hooks] are called at their defined points in the run scope.

Package or directory scoping is used by `config.py` files; fixtures
and hooks in a `config.py` are used only by modules in that directory
and below. (XXX confirm this.)


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

* `approx(expected, rel=None, abs=None, nan_ok=False_)` should be
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


unittest and doctest Tests
--------------------------

Pytest will also run [`unittest`] and [`doctest`] test cases.

#### `unittest`

Collection is slightly different from that for standard pytest:
* Files: the same, matching `python_files` glob
* Classes:  if inherits from `unittest.TestCase` (`python_classes` is ignored)
* Methods: if in a selected class and matching `test*`
  (`python_functions` is ignored)

[`@pytest.mark` decorators][marks] can be used on `unittest` test
methods. This includes things like the following. (See the
documentation linked above for considerably more detail.)
* `@pytest.mark.skip(reason='foo')`
* `@pytest.mark.usefixtures("my_fixture")`

Supported features:
* `@unittest.skip`-style decorators
* `setUp()`/`tearDown()`
* `setUpClass()`/`tearDownClass()`

Unsupported features:
* `load_tests` protocol
* `setUpModule()`,`tearDownModule()`
* subtests/`subTest()` context manager

#### `doctest`

Doctest options:

* `--doctest-modules`: Run doctests in all .py modules.
* `--doctest-report`: Format of doctest failure output:
  `{none,cdiff,ndiff,udiff,only_first_failure}`
* `--doctest-glob=PAT`: Doctests on files matching PAT. Default: `test*.txt`.
* `--doctest-ignore-import-errors`: ignore doctest ImportErrors
* `--doctest-continue-on-failure`: Continue after first doctest
  failure in a file.

Doctest config options:

* `doctest_optionflags`: Option flags for doctests.
* `doctest_encoding`: Encoding used for doctest files.



[PEP 302]: https://www.python.org/dev/peps/pep-0302/
[`@pytest.fixture()`]: https://docs.pytest.org/en/latest/reference.html#fixtures
[`assert`]: https://docs.python.org/3/reference/simple_stmts.html#assert
[`doctest`]: https://docs.pytest.org/en/documentation-restructure/how-to/doctest.html
[`unittest`]: https://docs.pytest.org/en/latest/unittest.html
[assertions]: https://docs.pytest.org/en/latest/assert.html
[ast-rewrite]: http://pybites.blogspot.jp/2011/07/behind-scenes-of-pytests-new-assertion.html
[builtin]: https://docs.pytest.org/en/latest/builtin.html
[docs]: https://docs.pytest.org/en/latest/contents.html
[examples]:  https://docs.pytest.org/en/latest/example/
[exceptions]: https://docs.python.org/3/library/exceptions.html
[hooks]: https://docs.pytest.org/en/documentation-restructure/how-to/writing_plugins.html#pytest-hook-reference
[marks]: https://docs.pytest.org/en/latest/mark.html
[pytest]: https://pytest.org/
[reference]: https://docs.pytest.org/en/latest/reference.html
[repdemo]: https://docs.pytest.org/en/latest/example/reportingdemo.html
[restruc]: https://docs.pytest.org/en/documentation-restructure/
[wiki]: https://wiki.python.org/moin/PyTest
