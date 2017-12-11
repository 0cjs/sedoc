Python [unittest] Library
=========================

[unittest] is part of the standard library and commonly used, but not
very good in terms of the assertions provided. See [pytest](pytest.md)
for a library with better assertions.


unittest
--------

JUnit-style with a typical [API][ut-api]:

    import unittest as ut

    class TestGood(ut.TestCase):                # test suite
        def test_nothing(t):                    # `t` often called `self`
            None

        def setUp(t):
            t.actual = 'expected'

        def tearDown(t):
            t.actual = None

        def test_good(t):                       # test case
            t.maxDiff = None                    # show full diff (def. 80 chars)
            t.assertEqual(t.actual, 'expected')
            with t.assertRaises(LookupError):
                raise KeyError

        def test_subtests(t):
            for i in range(0, 6):
                with t.subTest(i=i):            # make separate tests so all
                    t.assertEqual(i % 2, 0)     # are run even if some fail
                # FAIL: test_even (__main__.NumbersTest) (i=1)

    class TestOther(ut.TestCase):
        import sys
        @ut.skipUnless(sys.platform.startswith('win'), 'need Windows')
        def test_win():
            t.fail()                            # setUp(), tearDown() not run

        # Other decorators: skip(msg), skipIf(P, msg), expectedFailure
        # Also works for entire classes.
        # `railse SkipTest(msg)` to do it dynamically

    if __name__ == '__main__':
        ut.main()                               # test runner

Run with:

    python3 tests.py [-v]
    python3 -m unittest [-v] foo bar.baz ...    # __name__ test not needed
    python3 -m unittest foo.py bar/baz.py       # filename completion is handy
    python3 -m unittest discover [-p PAT]       # test discovery
    python3 -m unittest -h                      # help

[Test discovery][ut-disc] matches `test*.py` by default; `-p` changes
it. `-t` specifies the top dir of the modules. `-s` is the dir or
module prefix at which to start discovery.

There's [no real standard][so-where] for test locations or naming;
they range from in the file under test itself to a completely separate
file hierarchy à la Java. For `foo.py` putting tests in
`tests/test_foo.py` is common, but subdirs can be problematic because
if the file is run as the top-level `__main__` module, it can't import
the code from dirs above it (at least not without special help). It's
helpful to have the file under test also be able to run the tests:

    if __name__ == '__main__':
        import foo_ut as t
        t.runtests()

You can set up suites manually:

    def suite():
        s = unittest.TestSuite()
        s.addTest(WidgetTestCase(0))
        s.addTest(WidgetTestCase(1))
        # This mainly for backwards compatibility libraries:
        s.addTest(unittest.FunctionTestCase(f, setUp=..., tearDown=...))
        return s

    if __name__ == '__main__':
        runner = unittest.TextTestRunner()
        runner.run(suite())

The [`load_tests` protocol][ut-load] can implement custom loading.



[unittest]: https://docs.python.org/3/library/unittest.html
[ut-api]: https://docs.python.org/3.6/library/unittest.html#classes-and-functions
[ut-disc]: https://docs.python.org/3/library/unittest.html#test-discovery
[so-where]: https://stackoverflow.com/q/61151/107294
[ut-load]: https://docs.python.org/3/library/unittest.html#load-tests-protocol
