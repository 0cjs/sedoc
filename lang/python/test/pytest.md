Python Pytest Library
=====================

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


Test Discovery
--------------

#### Default Discovery

Pytest from the command line will [discover tests] by searching paths
from the first of: the command line; the [`testpaths`] configuration
variable; the current directory. Files are added directly; directories
(excepting those in [`norecursedirs`]) are recursed to find
`test_*.py` and `*_test.py` files. All are imported by their [`test
package name`] derived from the first parent directory not containing
an `__init__.py` file). (This directory is added to `sys.path`.) PEP
420 namespace packages without `__init__.py` files may also work, but
this needs to be investigated.

The test functions are those matching `test_*` that are at the
top-level (within the module) or within a `Test*` class that has no
`__init__` method.

#### [Customizing Discovery]

`--collect-only` is useful for checking what discovery is finding. It
can also be used to check for missing dependencies the code attempts
to import.

Command-line options:

* `--ignore=PATH`: Ignore directories/modules; may be used multiple times.
* `--keep-duplicates`: (Normally they are removed.)
* `--collect-in-virtualenv`: Do not ignore tests in local virtualenv dirs.
* `deselect=NODEID_PREFIX`: Delect items during collection (multi allowed).
* `--pyargs`: Try to interpret all args as Python packages.

[Config file][confopts] (see below) / `-o name=value` options:

* `python_files`, `python_classes`, `python_functions`: Glob patterns
  determining what files, classes and functions will be selected as
  test modules, classes containing tests, and test functions/methods.
  This does not apply to `unittest` collecting, which selects
  subclasses of `unittest.TestCase`.
* `testpaths`: Paths to search when none are given explicitly on the
  command line.
* `norecursedirs`: Glob patterns determining what directories should
  be ignored. Default `.* build dist CVS _darcs {arch} *.egg venv`.
  (Virtualenvs are also detected via their activiation scripts and
  ignored unless `--collect-in-virtualenv` is given, but
  `norecursedirs` ignore patterns precedence over this.)

You can set `collect_ignore` in `conftest.py` to programatically
ignore certain modules. See [Customizing test collection] for an
example.

You can also set [a session-fixture which can look at all collected
tests][collection-fixture].


conftest.py
-----------

`conftest.py` files anywhere under the rootdir are loaded and used.
automatically by `pytest`. This seems to be some sort of way to get
deep into the guts of pytest. XXX need to expand this info.

[Pytest import mechanisms][import] discusses stuff about this.

Uses include:
* [`pytest_runtest_setup()`]
* [Sharing fixture functions][fixture-conftest] amongst many modules
* [Per-directory plugins][plugin-conftest] (also see the [hooks]
  reference and ][writing hooks])
* [Basic patterns and examples][basic] has many examples of other
  things
* [Non-Python Test Execution][nonpython]

Command-line options:
* `--noconftest`: Don't load `conftest.py` files.
* `confcutdir`: Where `conftest.py` search stops


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


Rootdir and Configuration
-------------------------

`pytest -h` will print out the [configuration] determined by the
command line options and config file settings. The rootdir and inifile
are also printed at the start of non-quiet test runs and available in
Python as `config.rootdir` (guaranteed to exist) and `config.inifile`
(may be `None`).

Pytest has a [rootdir][] for each test run used for storing
information between test runs (e.g., the cache, below). The
documentation claims it's also used for assigning nodeids but, from
changing rootdir and looking at `.pytest_cache/v/cache/nodeids`, this
doesn't seem to be the case. It does however affect the locations set
for nodes.

rootdir is set as follows:

1. Use the `--rootdir=path` option if passed on the command line. (Not
   clear if this can be ready from any inifile overriding the
   discovered one below.)
2. Determine common ancestor directory (CAD) of all path args and
   current working directory. (The docs don't make it clear that, even
   with path args, the CWD is still used in this calculation.)
3. The rootdir is the first condition matched below.
   1. `{pytest,tox}.ini`/`setup.cfg` are found CAD-upwards.
   2. `setup.py` is found CAD-upwards.
   3. `{pytest,tox}.ini`/`setup.cfg` are found in any of `args`-upwards.  
      (Does this also check CWD?)
   4. CAD is rootdir.

The files found in steps 1 and 3 above must also meet certain
conditions:
* `pytest.ini` is always used, but but breaks if no `[pytest]` section.
* [`tox.ini`](tox.md) must have a `[pytest]` section.
* `setup.cfg` must have a `[tool:pytest]` section

Pytest has (non-overlapping) command line options and configuration
variables. Command line options can also be set in a config file using
the [`addopts`] config option; config file options can be set on the
command line with `-o option=value` or `--override-ini=option=value`.


Cache
-----

Pytest has a [cache] ([new docs][cache-restruc]) supplied by the
included `cacheprovider` [plugin][plugins] (enabled by default). Data
are stored in `.pytest_cache/` under the [rootdir][] and accessible
via the [`config.cache`] ([API docs][config-cache-API]) object. The
plugin adds the following command line options:

* `--cache-show`: Display cache content (no tests will be run)
* `--cache-clear`: Clear all cache files and values
* `--lf`/`--last-failed`: Re-run only failures
* `--ff`/`--failed-first`: Run failures before remainder of tests
* `-last-failed-no-failures`: Behaviour when last run had no failures
  * `all` (default): Run all tests
  * `none`: Run no tests

The [`cache_dir`] configuration option (≥3.2) moves it elsewhere; it's
an absolute path or relative to `rootdir`.

There is also a [`pytest-cache`] PyPI module which appears to be an
older version of the above `cacheprovider` plugin. (Last release was
2013.)


XXX To-do
---------

* [`pytest-xdist`](https://pypi.org/project/pytest-xdist/)
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
* [Development mode](https://docs.pytest.org/en/documentation-restructure/how-to/existingtestsuite.html)
* [tox](https://docs.pytest.org/en/documentation-restructure/background/goodpractices.html#use-tox)
* [background](https://docs.pytest.org/en/documentation-restructure/background/)



[Configuration]: https://docs.pytest.org/en/latest/customize.html
[PEP 302]: https://www.python.org/dev/peps/pep-0302/
[`@pytest.fixture()`]: https://docs.pytest.org/en/latest/reference.html#fixtures
[`addopts`]: https://docs.pytest.org/en/documentation-restructure/how-to/customize.html#confval-addopts
[`assert`]: https://docs.python.org/3/reference/simple_stmts.html#assert
[`cache_dir`]: https://docs.pytest.org/en/documentation-restructure/how-to/customize.html#confval-cache_dir
[`config.cache`]: https://docs.pytest.org/en/latest/cache.html#config-cache
[`doctest`]: https://docs.pytest.org/en/documentation-restructure/how-to/doctest.html
[`norecursedirs`]: https://docs.pytest.org/en/latest/customize.html#confval-norecursedirs
[`pytest-cache`]: https://pypi.org/project/pytest-cache/
[`pytest_runtest_setup()`]: https://docs.pytest.org/en/latest/reference.html?highlight=%22pytest_runtest_setup%22#_pytest.hookspec.pytest_runtest_setup
[`test package name`]: https://docs.pytest.org/en/latest/goodpractices.html#test-package-name
[`testpaths`]: https://docs.pytest.org/en/latest/reference.html#confval-testpaths
[`unittest`]: https://docs.pytest.org/en/latest/unittest.html
[assertions]: https://docs.pytest.org/en/latest/assert.html
[ast-rewrite]: http://pybites.blogspot.jp/2011/07/behind-scenes-of-pytests-new-assertion.html
[basic]: https://docs.pytest.org/en/latest/example/simple.html
[builtin]: https://docs.pytest.org/en/latest/builtin.html
[cache-restruc]: https://docs.pytest.org/en/documentation-restructure/how-to/cache.html
[cache]: https://docs.pytest.org/en/latest/cache.html
[collection-fixture]: https://docs.pytest.org/en/latest/example/special.html
[config-cache-API]: https://docs.pytest.org/en/latest/reference.html#cache-api
[confopts]: https://docs.pytest.org/en/documentation-restructure/how-to/customize.html#builtin-configuration-file-options
[customizing discovery]: https://docs.pytest.org/en/documentation-restructure/example/pythoncollection.html
[customizing test collection]: https://docs.pytest.org/en/latest/example/pythoncollection.html#customizing-test-collection
[discover tests]: https://docs.pytest.org/en/latest/goodpractices.html#test-discovery
[docs]: https://docs.pytest.org/en/latest/contents.html
[examples]:  https://docs.pytest.org/en/latest/example/
[exceptions]: https://docs.python.org/3/library/exceptions.html
[fixture-conftest]: https://docs.pytest.org/en/latest/fixture.html#conftest-py
[hooks]: https://docs.pytest.org/en/documentation-restructure/how-to/writing_plugins.html#pytest-hook-reference
[import]: https://docs.pytest.org/en/latest/pythonpath.html
[marks]: https://docs.pytest.org/en/latest/mark.html
[nonpython]: http://doc.pytest.org/en/latest/example/nonpython.html
[plugin-conftest]: https://docs.pytest.org/en/latest/writing_plugins.html#conftest-py-plugins
[plugins]: https://docs.pytest.org/en/latest/plugins.html
[pytest]: https://pytest.org/
[reference]: https://docs.pytest.org/en/latest/reference.html
[repdemo]: https://docs.pytest.org/en/latest/example/reportingdemo.html
[restruc]: https://docs.pytest.org/en/documentation-restructure/
[rootdir]: https://docs.pytest.org/en/latest/customize.html#initialization-determining-rootdir-and-inifile
[wiki]: https://wiki.python.org/moin/PyTest
[writing hooks]: https://docs.pytest.org/en/documentation-restructure/how-to/writing_plugins.html#writing-hook-functions
