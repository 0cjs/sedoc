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

After loading `conftest.py` and `__init__.py` files (see below), each
discovered file is imported as a module using its [test package
name] derived from the first parent directory not containing an
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

When a file is found during discovery  a recursive search is done
through all parent directories (up to the root of the filesystem) for
`conftest.py` files and these are remembered. The loading then
proceeds in this order:
1. The `conftest.py` files found for the first-discovered test file
   are loaded in order from highest to deepest in the directory
   hierarchy.
2. Step 1 is repeated for each additional discovered test file, but
   previously loaded files are excluded.
3. If there is a `conftest.py` in the rootdir (see below), it is
   loaded if it hasn't already been.
4. The discovered test files are loaded in the order they were
   discovered, as per the section above.

As per standard Python module loading, if an `__init__.py` file is
present in any directory from which a file is loaded, it will be
loaded first, preceded (recursively) by any `__init__.py` files in
direct parent directories. Note that this means files under test may
be loaded before all `conftest.py` files discovered this way have been
loaded and thus `conftest.py` cannot reliably be used for
configuration of the load environment (e.g., to set the warnings
configuration under which the top level of an `__init__.py` will run).
Possibly using the `-p` option to load a named plugin would be a way
to deal with this.

Unless an `__init__.py` file is also present in the same directory as
a `conftest.py` (and perhaps directories immediately above), making it
a regular package, the loaded module will have a fully-qualified name
of `conftest` and it will overwrite any previous entry for that name
in `sys.modules`. Without fully specified package configuration for
all directories searched by pytest, `import conftest` cannot be
reliably used in test files.

[Pytest import mechanisms][import] discusses stuff about this.

`conftest.py` files are considered plugins, and the `--trace-config`
flag will print information about them along with builtin and
registered external plugins.

Uses include:
* [Sharing fixture functions][fixture-conftest] amongst many modules
* [Per-directory plugins][plugin-conftest] using [hook functions] such
  as [`pytest_runtest_setup()`]; also see the [hooks] reference and
  [writing hooks].
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

Pytest has a [rootdir] for each test run used for storing
information between test runs (e.g., the cache, below). The
documentation claims it's also used for assigning nodeids but, from
changing rootdir and looking at `.pytest_cache/v/cache/nodeids`, this
doesn't seem to be the case. It does however affect the locations set
for nodes.

rootdir is set as follows:

1. Use the `--rootdir=path` option if passed on the command line. (Not
   clear if this can be read from any inifile overriding the
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


Warnings Filter Configuration
-----------------------------

For assertion information and testing warnings within code, see See
[Warnings](pytest-assert.md#warnings) in Pytest Assertions and Checks.

Python [warnings](../exeptions.md#warnings) are [captured by
pytest][pt-warnings] unless `-p no:warnings` is specified. By default
warnings are displayed at the end of the sesion. There's also an
ability to record warnings.

### Command-line and Init File Options

The `-W` flag or the `pytest.ini` option `filterwarnings` take filter
specifications as colon-separated tuples:

    action:message:category:module:line

each of which is pushed on to the head of the Python warnings filter
list (`warnings.filters`); thus, the last-specified matching action
will be the one used.

The specifications are similar to, but not the same as [the `-W`
option for the CPython interpreter][python-W]. The main difference is
that `message` and `module` are compiled as case-sensitive regular
expressions with an implicit `^` anchor at the start of the pattern ,
but without a `$` anchor at the end unless explicitly specified.

Examples:

    -W error -W ignore::UserWarning`

    filterwarnings =
      error
      ignore::UserWarning
      ignore::DeprecationWarning:thing

In the last example, the _module_ pattern `thing` will match
`thing.subthing` and `thingie` but not `other.thing`.

### Programatic Configuration

It's difficult to find a hook to do [programatic configuration of
warnings](../exceptions.md#api) because it must be done after
`pytest.main()` has initialized the test framework but before it
starts discovering and loading the test and code modules. Pytest must
suppress certain warnings during initialization; adding `('error',
None, Warning, None, 0)` to filter.warning before calling
`pytest.main()` will cause it to throw an exception.

A `conftest.py` in the root dir gets close, but that still leaves open
the possibility of code under test in `__init__.py` files being loaded
before that `conftest.py` (see above). Perhaps using the `-p` option
to preload a "real" plugin would do the trick.


Cache
-----

Pytest has a [cache] ([new docs][cache-restruc]) supplied by the
included `cacheprovider` [plugin][plugins] (enabled by default). Data
are stored in `.pytest_cache/` under the [rootdir] and accessible
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



<!-------------------------------------------------------------------->
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
[test package name]: https://docs.pytest.org/en/latest/goodpractices.html#test-package-name
[`testpaths`]: https://docs.pytest.org/en/latest/reference.html#confval-testpaths
[basic]: https://docs.pytest.org/en/latest/example/simple.html
[builtin]: https://docs.pytest.org/en/latest/builtin.html
[cache-restruc]: https://docs.pytest.org/en/documentation-restructure/how-to/cache.html
[cache]: https://docs.pytest.org/en/latest/cache.html
[collection-fixture]: https://docs.pytest.org/en/latest/example/special.html
[config-cache-API]: https://docs.pytest.org/en/latest/reference.html#cache-api
[confopts]: https://docs.pytest.org/en/documentation-restructure/how-to/customize.html#builtin-configuration-file-options
[custom-disc]: https://docs.pytest.org/en/documentation-restructure/example/pythoncollection.html
[fixture-conftest]: https://docs.pytest.org/en/latest/fixture.html#conftest-py
[hook functions]: https://docs.pytest.org/en/latest/reference.html#hooks
[hooks]: https://docs.pytest.org/en/documentation-restructure/how-to/writing_plugins.html#pytest-hook-reference
[import]: https://docs.pytest.org/en/latest/pythonpath.html
[nonpython]: http://doc.pytest.org/en/latest/example/nonpython.html
[plugin-conftest]: https://docs.pytest.org/en/latest/writing_plugins.html#conftest-py-plugins
[plugins]: https://docs.pytest.org/en/latest/plugins.html
[pt-warnings]: https://docs.pytest.org/en/latest/warnings.html
[pytest]: https://pytest.org/
[python-W]: ../exceptions.md#command-line-and-environment
[rootdir]: https://docs.pytest.org/en/latest/customize.html
[test discovery]: https://docs.pytest.org/en/latest/goodpractices.html#test-discovery
[writing hooks]: https://docs.pytest.org/en/documentation-restructure/how-to/writing_plugins.html#writing-hook-functions
