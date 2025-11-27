| [Overview](README.md) | [TypeScript](ts.js) | [Async](async.md)
| [NPM](npm.md) | [NPM Configuration](npm-config.md) | [Jest](jest.md)
|

Jest Test Framework for JavaScript
==================================

Note that Node also includes an internal [test runner][node-test]. It's not
clear how this does test discovery.

References:
- [Documentation]. [GitHub]. [Home Page].
- [Cheatsheet].

If you use TypeScript you'll need to add a compiler (`typescript` and
`ts-jest`, or `babel-jest`, or an alternative) and in in `jest.config.js`
configure a transform, e.g.:

    transform: {
        '^.+\\.ts$': 'ts-jest',     // ts-jest module transforms TypeScript
    },


Processes and Globals
---------------------

Jest runs in one of two modes: _single-process_ mode in which everything
is run in one process, and _multi-process_ mode where the configuration and
global setup/teardown are run in the "main" process but tests are run in
_worker_ sub-processes.

__WARNING:__ Jest may run small numbers of tests, with no more than one
async test, in single-process mode even if you appear to have specified
multi-process mode. This can cause e.g. variables set on `globalThis` in
the global setup to become available to tests in some runs, but not in
others. Generally, _never_ have tests rely on global variables or other
process- or interpreter-internal state for any reason.

In all modes you can get the worker ID (1, 2, …) for that process from
`process.env.JEST_WORKER_ID`. In multi-process mode the worker ID is
`undefined` in the main process; in single-process mode the worker ID is
`undefined` until tests start running and then will be `1`.

In multi-process mode a main process will run the configuration file and
global setup/teardown, but each test file will be run in a worker
subprocess  that shares no global data with the main process. Worker
processes may be re-used to run additional test files; the number of worker
processes can be set with [`--maxWorkersN`][] (_N_ = e.g. `1` or `50%`);
the default is the cores-1, or cores/2 in watch mode.

In single-process mode all tests will be run in the main process, which
will be assigned worker ID 1 after global configuration and setup. This may
be enabled with `--runInBand=true` (not available in the config file),
which is implied by some other options (e.g. `--detectOpenHandles`) or may
happen automatically for certain sets of tests (see above).

In either case, every test _file_ runs in a separate [V8 context/realm]
which means that `globalThis` is fresh (though containing anything set in
configuration or global setup in single-process mode), all modules will be
cleared, and so on: separate test files do not have _any_ global
interpreter information, such as module singletons, set by other test files
or their setup/teardown. (This cannot be changed.) This implies that, e.g.,
you cannot share a database connection between test files and you must shut
down any database connections in a file shutdown hook. You can, however,
set Unix environment variables in the global setup (see below) and they
will be inherited by the worker processes.

Test _within_ a single file do share globals unless you set `resetModules:
true`, in which case modules will be reset between tests (but not
`globalThis`).

#### Checking for Jest

You can check if you're running under Jest with

    process.env.JEST_WORKER_ID !== undefined
      && typeof jest !== 'undefined'
      && typeof expect !== 'undefined'

But note this works only in tests themselves; none of these are set during
global setup.


Tests
-----

Functions that generate tests and other things are documented on the
[Globals][] (meaning global symbols) page.

Tests are generated with functions that take a description (string) and
a function (usually lambda'd: `() => { … }`).

    test                Basic test.
    test.skip           Skip this; skipped count noted in summary.
    test.failing        Must fail or will generate an error.
    test.skip.failing   Skip a test expected to fail.
    test.todo           Takes description only; to-do count noted in summary.
    test.concurent      Experimental. Takes async fn.
    test.each           (See below.)
    test.*.each

When using `.toThrow()`, `.toThrowErrorMatchingSnapshot()` and
`.toThrowErrorMatchingInlineSnapshot()`, pass a _lambda_ to `expect()`:

    expect(() => { f() }).toThrow(new Error('must be this exact message'))

`.toThrow()` takes an optional parameter:
- regexp: error message matches the pattern
- string: error message includes the substring
- error class: error object is an instance of the class.
- error object: message equal to the `.message` property of the object


Assertions
----------

Test assertions are done by giving a value to [`expect()`] which then
returns on object on which you call one of the _matchers_ such as
`toBeTruthy()`, `toBeUndefined()`, `toBe(value)`, etc. There are three
_modifiers,_ `not`, `resolves` and `rejects` that can be used ahead of the
matchers, e.g., `expect(1).not.toBe(2)`. The resolves and rejects modifiers
unwrap a fulfilled or rejected promise and give the value, or fail if the
promise was instead rejected or fulfilled; usually you will need `await` in
front of the `expect()`

[Setup and Teardown] describes how this generally works. The following may
be used multiple times to add setup and teardown; they will all be executed
before and after the test or file, regardles of their order in the file.
Each returns a function to be executed at the appropriate point.
- `beforeAll`: function to execute before any tests in the file.
- `beforeEach`: function to execute before each individual test.
- `afterEach`: function to execute before each individual test.
- `afterEach`: function to execute after all tests in the file.

The configuration variables [`setupFiles`] and [`setupFilesAfterEnv`] are
arrays of paths to modules to be run for each file before and after the
test environment is set up. These too just call the functions above.
Module-level variables that they define are valid for the duration of a
test file only.


Configuration
-------------

Configuration is done with [command line options][cli-options], but many of
them (not all) can be placed in `jest.config.js` in the project root,
removing the leading `--`:

    module.exports = {
        roots:                  [ 'src/', 'lib/' ],
        testRegex:              [ /\.test\.[jt]sx?$/ ],
        testPathIgnorePatterns: [ 'src/notworking/' ],

        globalSetup:            './jest/global-setup.js',
        globalTeardown:         './jest/global-teardown.js',
        setupFilesAfterEnv:     [ './jest/file-setup-post.js', ],
    }

The global setup/teardown files are of the form:

    module.exports = async function(globalConfig, projectConfig) { … }

However, file setup/teardown call e.g.

    beforeEach(() => { … }



<!-------------------------------------------------------------------->
[Documentation]: https://jestjs.io/docs/getting-started
[GitHub]: https://facebook.github.io/jest/
[Home Page]: https://jestjs.io/
[cheatsheet]: https://devhints.io/jest
[node-test]: https://nodejs.org/en/learn/test-runner/using-test-runner

<!-- Tests -->
[Globals]: https://jestjs.io/docs/api

<!-- Assertions -->
[Setup and Teardown]: https://jestjs.io/docs/setup-teardown
[`expect()`]: https://jestjs.io/docs/expect
[`setupFilesAfterEnv`]: https://jestjs.io/docs/configuration#setupfilesafterenv-array
[`setupFiles`]: https://jestjs.io/docs/configuration#setupfiles-array

<!-- Processes and Globals -->
[V8 context/realm]: https://stackoverflow.com/q/49832187/107294

<!-- Configuration -->
[`--maxWorkers=N`]: https://jestjs.io/docs/cli#--maxworkersnumstring
[cli-opts]: https://jestjs.io/docs/cli#running-from-the-command-line
