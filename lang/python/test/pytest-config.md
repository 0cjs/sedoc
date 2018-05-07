Pytest Configuration
====================

For information on writing Pytest tests, see [pytest](pytest.md).


Test Discovery
--------------

This is a summary of [test discovery]. For default values of
configuration parameters, see 'Customizing Discovery' below.

`--collect-only` is useful for checking what discovery is finding. It
can also be used to check for missing dependencies the code attempts
to import.

#### Default Discovery

If `--pyargs` is given, no file searching is done and instead all
arguments are interpreted as Python module names to load.

When a directory is searched, all subdirs not matching `norecursedirs`
are also searched. Files to search for tests are:

1. All `.py` files given directly on the command line.
2. For each directory given on the command line, all files matching
   `python_files`.
3. If no files or directories are given on the command line:
   - If the current working directory is the rootdir, paths in the
     config param `testpaths` (default rootdir) will be searched.
   - Otherwise, the current working directory will be searched.

Each file is imported as a module using its [`test package name`]
derived from the first parent directory not containing an
`__init__.py` file. (This directory is added to `sys.path`.) Thus,
[PEP 420 namespace packages][PEP 420] without `__init__.py` files have
their internal paths added to `sys.path` and their files imported at
the root of the namespace.

Top-level functions in the collected modules are selected  as test
functions if their names match `python_functions`. Functions within
classes must also be in a class that matches `python_classes` and has
no `__init__` method.

#### Customizing Discovery

[Changing standard (Python) test discovery][custom-disc] describes
both ad hoc and configured methods of changing test discovery.

Command-line options:

* `--pyargs`: Do not search the filesystem; interpret all args as
  Python module names to load.
* `--ignore=PATH`: Ignore directories/modules; may be used multiple times.
* `--keep-duplicates`: (Normally they are removed.)
* `--collect-in-virtualenv`: Do not ignore tests in local virtualenv dirs.
* `deselect=NODEID_PREFIX`: Delect items during collection (multi allowed).

[Config file][confopts] (see below) / `-o name=value` options:

* [`python_files`]: Prefixes/glob patterns of files to match during
  discovery. Default: `test_*.py *_test.py`:
* [`python_classes`]: Prefixes/glob patterns of classes to match as
  test suites during discovery. Default: `Test*`. Classes inheriting
  from `unittest.TestCase` also always match (via `unittest`'s
  collection framework).
* [`python_functions`]: Prefixes/glob patterns of functions and methods
  to consider tests. Default: `test*`. (Does not apply to functions in
  `unittest.TestCase` descendants.)
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



[PEP 420]: https://www.python.org/dev/peps/pep-0420/
[`addopts`]: https://docs.pytest.org/en/documentation-restructure/how-to/customize.html#confval-addopts
[`cache_dir`]: https://docs.pytest.org/en/documentation-restructure/how-to/customize.html#confval-cache_dir
[`config.cache`]: https://docs.pytest.org/en/latest/cache.html#config-cache
[`norecursedirs`]: https://docs.pytest.org/en/latest/customize.html#confval-norecursedirs
[`pytest-cache`]: https://pypi.org/project/pytest-cache/
[`pytest_runtest_setup()`]: https://docs.pytest.org/en/latest/reference.html?highlight=%22pytest_runtest_setup%22#_pytest.hookspec.pytest_runtest_setup
[`python_classes`]: https://docs.pytest.org/en/latest/reference.html#confval-python_classes
[`python_files`]: https://docs.pytest.org/en/latest/reference.html#confval-python_files
[`python_functions`]: https://docs.pytest.org/en/latest/reference.html#confval-python_functions
[`testpaths`]: https://docs.pytest.org/en/latest/reference.html#confval-testpaths
[assertions]: https://docs.pytest.org/en/latest/assert.html
[basic]: https://docs.pytest.org/en/latest/example/simple.html
[builtin]: https://docs.pytest.org/en/latest/builtin.html
[cache-restruc]: https://docs.pytest.org/en/documentation-restructure/how-to/cache.html
[cache]: https://docs.pytest.org/en/latest/cache.html
[collection-fixture]: https://docs.pytest.org/en/latest/example/special.html
[config-cache-API]: https://docs.pytest.org/en/latest/reference.html#cache-api
[confopts]: https://docs.pytest.org/en/documentation-restructure/how-to/customize.html#builtin-configuration-file-options
[custom-disc]: https://docs.pytest.org/en/documentation-restructure/example/pythoncollection.html
[fixture-conftest]: https://docs.pytest.org/en/latest/fixture.html#conftest-py
[hooks]: https://docs.pytest.org/en/documentation-restructure/how-to/writing_plugins.html#pytest-hook-reference
[import]: https://docs.pytest.org/en/latest/pythonpath.html
[nonpython]: http://doc.pytest.org/en/latest/example/nonpython.html
[plugin-conftest]: https://docs.pytest.org/en/latest/writing_plugins.html#conftest-py-plugins
[plugins]: https://docs.pytest.org/en/latest/plugins.html
[pytest]: https://pytest.org/
[test discovery]: https://docs.pytest.org/en/latest/goodpractices.html#test-discovery
[writing hooks]: https://docs.pytest.org/en/documentation-restructure/how-to/writing_plugins.html#writing-hook-functions
