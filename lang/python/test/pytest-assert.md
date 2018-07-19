Pytest Assertions and Checks
============================

See [assertions] for the basics, and [builtin] for details on the API
and fixtures. The following is an incomplete summary:

Assertions
----------

#### Exceptions

See also [Assertions about expected exceptions][exceptions].

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

#### Warnings

Python [warnings](../exeptions.md#warnings) are [captured by
pytest][pt-warnings] unless `-p no:warnings` is specified.

By default warnings are displayed at the end of the sesion. The `-W`
flag or the `pytest.ini` option `filterwarnings` can be used with
action values from the [warnings filter] to change the behaviour
(`error` and `ignore` would be the only ones commonly used); the last
matching option is used. Examples:

    -W error -W ignore::UserWarning`

    filterwarnings =
      error
      ignore::UserWarning

Some functions are supplied to help with testing warnings:

    # turns all warnings into errors for this module
    pytestmark = pytest.mark.filterwarnings("error")

    def test_warnings():
        pytest.warns(RuntimeWarning, warn, 'a message', RuntimeWarning)
        with pytest.warns(UserWarning, match='number \d+$'):
            warn('warning number 42', UserWarning)

    #   The filterwarnings marker takes an action followed by:
    #     1. A double colon and a warning class
    #     2. A single colon and a regex to match the warning
    #   It will generate a large message full of `INTERNALERROR` if
    #   the string is not correct; look for the actual message at the
    #   bottom (e.g., warnings._OptionError: invalid action: 'foo')
    @pytest.mark.filterwarnings('ignore::RuntimeWarning')
    @pytest.mark.filterwarnings('ignore:nisanshi')
    def test_filterwarnings():
        warn('ichi', RuntimeWarning)
        warn('nisanshi', UserWarning)

BUG: filterwarnings is not a valid marker; you need to manually
register it if you run pytest with `--strict`. See [issue 3671].

There's also an ability to record warnings.

#### Other Things

* `approx(expected, rel=None, abs=None, nan_ok=False_)` should be
  used to compare floating point numbers:

      {'a': 0.1 + 0.2, 'b': 0.2 + 0.4} == approx({'a': 0.3, 'b': 0.6})

* The `deprecated_call` context manager ensures a block of code
  triggers a `DeprecationWarning` or `PendingDeprecationWarning`.

#### Tricks

You can assert things that won't fail in order to add useful
information to the error output:

    for name, params in config.items():
        #   _name_ will appear if the params check fails
        assert name and expected_params == params


Capturing Output (stdout/stderr)
--------------------------------

See [capture] for full details.

#### capsys, capfd Fixtures

`capsys` captures `sys.{stdout,stderr}` as strings. `capfd` captures
OS-level file descriptors as well. In pytest ≥ 3.3 there is also
`capsysbinary` and `capfdbinary` capturing `bytes`.

`readouterr()` returns a named tuple (`out`, `err`) of the captured
output and clears the capture buffer. `disabled()` pauses capture.

    def test(capsys):
        print('abc')
        print('def', file=sys.stderr)
        assert ('abc\n', 'def\n') == capsys.readouterr()

        print('ghi')                    # Buffer has been reset
        outerr = capsys.readouterr()    # Returns named tuple
        assert 'ghi\n' == outerr.out
        assert ''      == outerr.err

        with capsys.disabled():
            print('uncaptured output appearing on stdout of test run')
        assert ('', '') == capsys.readouterr()



[assertions]: https://docs.pytest.org/en/latest/assert.html
[builtin]: https://docs.pytest.org/en/latest/builtin.html
[capture]: https://docs.pytest.org/en/latest/capture.html
[exceptions]: https://docs.pytest.org/en/latest/assert.html#assertions-about-expected-exceptions
[issue 3671]: https://github.com/pytest-dev/pytest/issues/3671
[pt-warnings]: https://docs.pytest.org/en/latest/warnings.html
[warnings filter]: https://docs.python.org/3/library/warnings.html#the-warnings-filter
