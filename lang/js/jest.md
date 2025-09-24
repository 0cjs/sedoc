Jest Test Framework (JavaScript)
================================

References:
- [Documentation]. [GitHub]. [Home Page].
- [Cheatsheet].

Installation notes:
- Typically you'll need to install both `jest` and `babel-jest`. (Maybe?)


Processes and Globals
---------------------

Jest runs in one of two modes. In all modes you can get the worker ID
(Jest's process number: 1, 2, …) with from `process.env.JEST_WORKER_ID`.

The default is multi-process mode. A main process will start, with
`JEST_WORKER_ID` undefined, and run the global setup and teardown. Each
test file will be run in a worker subprocess (`JEST_WORKER_ID` will be an
integer) that shares no global data with the main process. Worker processes
may be re-used to run additional test files; the number of worker processes
can be set with [`--maxWorkersN`][] (_N_ = e.g. `1` or `50%`); the default
is the cores-1, or cores/2 in watch mode.

With `--runInBand` (not available in the config file) all tests will be run
in the main process, which will be assigned worker ID 1. Other options such
as `--detectOpenHandles` imply `--runInBand=true`.

In either case, every test _file_ runs in a separate [V8 context/realm]
which means that `globalThis` is fresh, all modules will be cleared, and so
on: separate test files do not have _any_ global information, such as
module singletons, set by other test files or their setup/teardown. (This
cannot be changed.) This implies that, e.g., you cannot share a database
connection between test files and you must shut down any database
connections in a file shutdown hook.

Test _within_ a single file do share globals unless you set `resetModules:
true`, in which case modules will be reset between tests (but not
`globalThis`).


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

<!-- Assertions -->
[`expect()`]: https://jestjs.io/docs/expect

<!-- Processes and Globals -->
[V8 context/realm]: https://stackoverflow.com/q/49832187/107294

<!-- Configuration -->
[`--maxWorkers=N`]: https://jestjs.io/docs/cli#--maxworkersnumstring
[cli-opts]: https://jestjs.io/docs/cli#running-from-the-command-line
