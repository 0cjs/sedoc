» [Overview][sp-o] | Assertions | [Configuration/Customization][sp-conf]

Pytest Assertions and Checks
============================

See pytest docs on [assertions] for the basics, and [builtin] for
details on the API and fixtures. The following is an incomplete
summary.

Assertions
----------

### Exceptions

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

[`ExceptionInfo`] attributes include:
- `type`: The exception class.
- `typename`: The name of the exception class.
- `value`: The exception object itself.
- `tb`: The exception's raw traceback.
- `traceback`: The traceback as a `_pytest._code.Traceback` instance.
- `errisinstance(exc)`: Return `True` if exception is instance of _exc_.
- `match(regexp)`: Match _regexp_ against the string representation of
  the exception.
- `exconly(tryshort=False)`: Return the exception as a string. If
  _tryshort_ is `True`, remove 'AssertionError:' from the beginning if
  the exception is a `_pytest._code._AssertionError`.
- `getrepr(showlocals=False, style='long', abspath=False,
  tbfilter=True, funcargs=False, truncate_locals=True)`:
  Return `str()`able representation of the exception info.
  - `showlocals`: Show locals per traceback entry.
  - `style`: One of `long|short|no|native`.
    (`native` ignores _tbfilter_ and _showlocals_).
  - `tbfilter`: Hide entries (where _tracebackhide_ is `True`).

### Warnings

Python [warnings](../exeptions.md#warnings) are captured by pytest
unless `-p no:warnings` is specified. See [Warnings Filter
Configuration] in the pytest configuration document for configuration
details.

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

### Other Things

* `approx(expected, rel=None, abs=None, nan_ok=False_)` should be
  used to compare floating point numbers:

      {'a': 0.1 + 0.2, 'b': 0.2 + 0.4} == approx({'a': 0.3, 'b': 0.6})

* The `deprecated_call` context manager ensures a block of code
  triggers a `DeprecationWarning` or `PendingDeprecationWarning`.

### Tricks

You can assert things that won't fail in order to add useful
information to the error output:

    for name, params in config.items():
        #   _name_ will appear if the params check fails
        assert name and expected_params == params


Capturing Output (stdout/stderr)
--------------------------------

See [capture] for full details.

### capsys, capfd Fixtures

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



<!-------------------------------------------------------------------->
[sp-o]: pytest.md
[sp-a]: pytest-assert.md
[sp-conf]: pytest-config.md

[Warnings Filter Configuration]: pytest-config.md#warnings-filter-configuration
[`ExceptionInfo`]: https://docs.pytest.org/en/latest/reference.html#exceptioninfo
[assertions]: https://docs.pytest.org/en/latest/assert.html
[builtin]: https://docs.pytest.org/en/latest/builtin.html
[capture]: https://docs.pytest.org/en/latest/capture.html
[exceptions]: https://docs.pytest.org/en/latest/assert.html#assertions-about-expected-exceptions
[issue 3671]: https://github.com/pytest-dev/pytest/issues/3671
