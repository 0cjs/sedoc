Pytest Assertions and Checks
----------------------------

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

