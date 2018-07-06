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
[exceptions]: https://docs.pytest.org/en/latest/assert.html#assertions-about-expected-exceptions
[capture]: https://docs.pytest.org/en/latest/capture.html
