__»__ [Overview][sp-o] | [Assertions][sp-a] | Fixtures
    | [Configuration/Customization][sp-conf]

Pytest Fixtures
===============

Fixtures are functions that are automatically called when a parameter to a
test function has the same name, with the returned or yielded value bound
to that parameter name. E.g.:

    @pytest.fixture
    def greeter():
        g = Greeter()
        yield g             # or just `return g` if no cleanup necessary
        g.cleanup()

    def test_foo_hello(greeter):
        assert "Hello, Fred." == greeter.greet("Fred")

Fixtures may also be added by marking the test:
`@pytest.mark.usefixtures("my_fixture")`. This can be is useful on
`unittest` tests and similar.

#### Parametrization

As with tests, fixtures can be [parametrized](pytest.md#parametrization).
Tests using the fixture will be called once for each value in the sequence
provided as the [`params` argument][parametrizing-fixtures]; the fixture is
responsible for changing its behaviour appropriately, usually by checking
`request.param`.

Multiple parameterized fixtures generate tests using the set product of all
`params` arguments (i.e., all possible combinations).

    @pytest.fixture(params=['a', 'b', 'c'])
    def myfixture(request):
        return request.param

#### Scope

By default fixtures are set up and torn down for each test. This can be
changed by passing a `scope` parameter set to `'function'` (default),
`'class'`, `'module'`, `'package'` or `'session'` (the entire test run),
e.g., `@pytest.fixture(scope='module')`.


Sharing Fixtures and Discovery
------------------------------

Fixtures in [`conftest.py`](pytest-config.md#conftest.py) will be
automatically discovered and made available for all tests in that directory
and all subdirectories. See [the documentation][fixture-conftest]) for more
information on sharing, such as [scoping](pytest.md#scopes) a shared
fixture to load test data only once.

### Discovery

You can also set [a session-fixture which can look at all collected
tests][collection-fixture].

    def test_run_mutiple_times(myfixture):
        assert 'b' == myfixture             # Passes once, fails twice



<!-------------------------------------------------------------------->
[sp-o]: pytest.md
[sp-a]: pytest-assert.md
[sp-f]: pytest-fixture.md
[sp-conf]: pytest-config.md

[collection-fixture]: https://docs.pytest.org/en/latest/example/special.html
[fixture-conftest]: https://docs.pytest.org/en/latest/fixture.html#conftest-py
[fixture-scope]: https://docs.pytest.org/en/latest/fixture.html#scope-sharing-a-fixture-instance-across-tests-in-a-class-module-or-session
[parametrizing-fixtures]: https://docs.pytest.org/en/latest/fixture.html#parametrizing-fixtures
