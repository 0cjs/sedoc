__»__ Overview | [Assertions][sp-a] | [Fixtures][sp-f]
    | [Configuration/Customization][sp-conf]

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

See [Test Discovery](pytest-config.md#test-discvoery) for details of
how to name test functions and files.

Scopes
------

Pytest has at least two different kinds of scoping.

Run scoping (my term) is one of _session_, _module_, _class_ or
_function_ and refers to particular start and end points during a test
session.
* A run scope can be passed (as `scope=...`) to `@pytest.fixture` to
  determine when a [fixture][sp-f] is to be torn down.
* Various [hooks] are called at their defined points in the run scope.

Package or directory scoping is used by `config.py` files; [fixtures][sp-f]
and hooks in a `config.py` are used only by modules in that directory
and below. (XXX confirm this.)


Test Outcomes
-------------

Most of the following would normally be done with decorators; see below.

* `fail(msg='', pytrace=True)`: Fail test with _msg_; no stack traceback
  if _pytrace_ is `False`.
* `skip(msg='')`: Skip (the rest of) the current test.
* `importorskip(modname, minversion=None)`: Checks __version__ attribute
  of module and skips if too low or can't load.
* `xfail(reason='', strict=False, raises=None, run=True)`: Allows test
  failure. Enforces if _strict_. Limit allowed exceptions with _raises_.
  Doesn't run (e.g., to avoid segfault) if not _run_.
* `exit()`: Exit test process.


Markers
-------

`pytest --markers` will list available markers.

[Markers] are set with a `@pytest.mark.MARKERNAME` decorator on the
test function. Unknonwn markers are normally ignored; use `--strict`
on the command line to raise an error instead.

[Condition string]s for _condition_ parameters below are deprecated;
use an expression evaluating to a boolean instead.

#### Skipping and Failing

These may also be used programmatically within the test function; see
'Test Outcomes' above. See [skip] for more details.

* [`skip(*, reason=None)`][api-skip]: Skip the test.
* [`skipif(condition, *, reason=None)`][api-skipif]: Skip if
  _condition_.
* [`xfail(condition=None, *, reason=None, raises=None, run=True,
  strict=False)`][api-xfail]: Expect failure, noting test as 'xfailed'
  or 'xpassed'.
  - _condition_: Not `None` and false, run the test as normal.
  - If _raises_ passed, test still fails with any exception other than
    the expected one.
  - If not _run_, don't run the test at all (in case it crashes
    interpreter).
  - If _strict_, fail the test if it passes instead of noting 'xpass'.

#### Parametrization

You can [parametrize] test functions; they will be run multiple times
(each as an individual test) with the given parameters.

* [`parametrize(argnames, argvalues, indirect=False, ids=None,
  scope=None)`][api-parametrize]
  - _argnames_: comma-separated list of argnames to be bound with each
    function invocation
  - _argvalues_: List (sequence?) of values if one argname; list
    (sequence?) of lists (sequences?) of values if multiple argnames.

To xfail or otherwise mark a single parametrized value, directly build
a `pytest.param` with the mark set:

    [ (1, 2), pytest.param(3, 4, marks=pytest.mark.xfail(reason='blah'), ... ]

Parametrization also occurs with [fixtures][sp-f]  with a `params`
argument, once for each value in the sequence. See [fixtures][sp-f] for
details.

#### Custom Markers

For full details, see [Working with custom markers][markers-custom].

You can add arbitrary markers by simply making up a marker name, e.g.
`@pytest.mark.foo`. It's also possible to [ automatically add markers
based on test names][markers-auto]

Adding markers can be done at many levels:

    #   Function level, in the usual way
    @pytest.mark.foo
    def test_one(): ...

    #   Individual parameterized runs
    @pytest.mark.parametrize('a, b',
        [ (1, 2),  pytest.mark.foo((3, 4)),  (5, 6), ])
    def test_two(): ...

    #   Class level
    @pytest.mark.foo
    class TestStuff:
        def test_three(): ...
        def test_four(): ...

    #   Module level, by defining a global var
    pytestmark = pytest.mark.foo

If you use the `--strict` option, markers need to be
[registered][markers-register]. This is done by setting `markers` in
[pytest.ini] or similar to a sequence of lines, one for each
registered marker. The marker name is followed by a colon and its
description:

    markers =
        foo: A description of the foo marker
        bar: A description of the bar marker


unittest and doctest Tests
--------------------------

Pytest will also run [`unittest`] and [`doctest`] test cases.

#### `unittest`

Collection is slightly different from that for standard pytest:
* Files: the same, matching `python_files` glob
* Classes:  if inherits from `unittest.TestCase` (`python_classes` is ignored)
* Methods: if in a selected class and matching `test*`
  (`python_functions` is ignored)

[`@pytest.mark` decorators][markers] can be used on `unittest` test
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


<!-------------------------------------------------------------------->
[sp-o]: pytest.md
[sp-a]: pytest-assert.md
[sp-f]: pytest-fixture.md
[sp-conf]: pytest-config.md

[PEP 302]: https://www.python.org/dev/peps/pep-0302/
[`@pytest.fixture()`]: https://docs.pytest.org/en/latest/reference.html#fixtures
[`assert`]: https://docs.python.org/3/reference/simple_stmts.html#assert
[`doctest`]: https://docs.pytest.org/en/documentation-restructure/how-to/doctest.html
[`unittest`]: https://docs.pytest.org/en/latest/unittest.html
[api-parametrize]: https://docs.pytest.org/en/latest/reference.html#pytest-mark-parametrize-ref
[api-skip]: https://docs.pytest.org/en/latest/reference.html#pytest-mark-skip-ref
[api-skipif]: https://docs.pytest.org/en/latest/reference.html#pytest-mark-skipif
[api-xfail]: https://docs.pytest.org/en/latest/reference.html#pytest-mark-xfail
[assertions]: https://docs.pytest.org/en/latest/assert.html
[ast-rewrite]: http://pybites.blogspot.jp/2011/07/behind-scenes-of-pytests-new-assertion.html
[builtin]: https://docs.pytest.org/en/latest/builtin.html
[condition string]: https://docs.pytest.org/en/latest/historical-notes.html#string-conditions
[docs]: https://docs.pytest.org/en/latest/contents.html
[examples]:  https://docs.pytest.org/en/latest/example/
[exceptions]: https://docs.python.org/3/library/exceptions.html
[hooks]: https://docs.pytest.org/en/documentation-restructure/how-to/writing_plugins.html#pytest-hook-reference
[markers-auto]: https://docs.pytest.org/en/latest/example/markers.html#automatically-adding-markers-based-on-test-names
[markers-custom]: https://docs.pytest.org/en/latest/example/markers.html
[markers-register]: https://docs.pytest.org/en/latest/example/markers.html#registering-markers
[markers]: https://docs.pytest.org/en/latest/mark.html
[parametrize]: https://docs.pytest.org/en/latest/parametrize.html
[pytest.ini]: pytest-config.md#rootdir-and-configuration
[pytest]: https://pytest.org/
[reference]: https://docs.pytest.org/en/latest/reference.html
[repdemo]: https://docs.pytest.org/en/latest/example/reportingdemo.html
[restruc]: https://docs.pytest.org/en/documentation-restructure/
[skip]: https://docs.pytest.org/en/latest/skipping.html#skip
[wiki]: https://wiki.python.org/moin/PyTest
