| [Overview](README.md) | [Node](node.md) | [TypeScript](ts.md)
| [NVM](nvm.md) | [NPM Packages](npm-package.md)
| [Async](async.md) | [Jest](jest.md)
|

NPM Packages
============

__WARNING:__ See the warning in [`npm.md`](./npm.md) about package
definitions vs.  NPM configuration.

Note that NPM _configuration_ values (e.g. `bin-links`) do _not_ go in
`package.json`; they go in `.npmrc` or per-user/global/builtin config
files. These are `key=val` form, not JSON, and do not apply to published
versions of modules. See `npm help npmrc`.

#### Identifying NPM Packages

An NPM package is one of:
- A directory with a `package.json`
- A gzipped tarball of such a directory.
- A URL pointing to such a tarball.
- A Git URL pointing to a repo containing a `package.json` in the root.
- `name@version` published on the [registry], giving a tarball URL.
- `name@tag` published on the registry pointing to a version above.
- `name` that has a "latest" tag


Package Definition: `package.json`
---------------------------------

[`package.json`] is not a required file; you can `npm install`
specific packages into `node_modules/` under the CWD even if it
doesn't exist.

The `package.json` for installed packages under `node_modules` will
have additional information (in fields starting with `_`) added by NPM
during install about the source and installation of the module.

The top level is always a single object. Fields (and their sub-fields, if
present) have the following types:
- String: e.g. `"version": "1.6.10"`.
- Array: a list of values, e.g. `"keywords": [ "printf", "sprintf" ]`.
- Object: a dictionary, e.g. `"foo": { "bar": "baz", "quux": [1,2,3] }`

Following are the NPM keys for this file. Other programs also read it and
have their own fields as well as sometimes reading the ones below. In
particular:
- [Node](./node.md): `type:commonjs` etc.
- `typescript`
- `jest`

#### Description Fields

- __name__:
  - Cannot start with `.` or `_`; no uppercase; URL-safe.
  - Do not put `js` or `node` in the name. (Use `engines` if not for node.)
  - Don't use names already in <https://www.npmjs.com>.
- __version__: A semver.
- __license__ (default `ISC`) Use a license from the [SPDX License List],
  `SEE LICENSE IN <filename>` or `UNLICENSED`.
- __description__, __keywords__: Used by `npm search`.
- __author__, __contributors__: String, array of strings. Handles sub-objects
  with `name`/`email`/`url` fields or `full name <email@x.y> (http://…)`.
  The `contributors` field defaults to `AUTHORS`, if present, one entry per
  line in the latter format.
- __homepage__, __bugs__, __repository__: Links to issue tracker etc.

#### Development Fields

- __scripts__: map of _name_ → _command_ for `npm run NAME`. List with `npm
  run`. See below for more details and other commands that use the
  `scripts` property.
- __config__: map of name/value pairs that "persists across upgrades." Sets
  `npm_package_config_NAME` env vars. Managed with [`npm config`].
- __devEngines__: More sophisticated version of `engines` that is checked
  before `install`, `ci` and `run` commands. See [devEngines]

Npm has the following top-level commands that execute items defined in the
[`scripts { … }`][scripts] section, using default values in some cases when
the item is not defined. (When no default is available, the command will
exit with a "missing script" error.
- [`test`]: No default.
- [`start`]: Runs `node server.js`. This is not the same as Node's default
  behaviour of running the file specified in the `main` attribute.
- [`restart`]:
  - When `restart` defined, runs:
    - `prerestart`, `restart`, `postrestart`.
  - When `restart` not defined, but `stop` and/or `start` is defined, runs:
    - `prerestart`, `prestop`, `stop`, `poststop`, `prestart`, `start`,
      `poststart`, `postrestart`.
- [`stop`]: No default.

#### Development/Packaging Fields

- __workspaces__: See [`npm.md`](./npm.md).

#### Packaging Fields

- __private__: (default `false`) If `true`, npm will not publish and will
  disable some lint checks for license etc. See also `publishConfig`.
- __files__: List of patterns for files to be installed by this package.
  Defaults to `["*"]`. Some files are always included: `package.json`,
  `README`, `LICENSE`, `LICENCE` (any case/extension for these three), and
  the files from the `main` and `bin` fields.
- __directories__: (Complex.)
- __man__: Manual page(s); string or list.
- __main__, __browser__: Module name of primary entry point; a path
  relative to the root of the package. (`require('pkg')` imports this.)
  Default `./index.js`.
- __exports__: Much more sophisticated, multi-file version of `main`. See
  [Package entry points].

#### __bin__ Field (Executable Files)

The [`bin`] field indicates where to place links to command-line binaries.
- Global installs use `{prefix}/bin/` (Unix) or `{prefix}/` (Windows). This
  is typically in the user's path.
- Local installs use `./node_modules/bin/`. The `npm` command adds this to
  the path so that the commands are available to anything run by `npm`,
  such as tests or other tools started with `npm run`, or directly via `npm
  exec` or `npx`.

The [`bin`] object is a map of command names to filenames. If the
`bin-links` config value is true (the default), `npm install` will create a
link (`.cmd` file on Windows) in the bin directory for every filename
pointing back to file containing the module. (This will typically start
with a `#!/usr/bin/env node` hashbang, but can be other types of scripts.)

However, `npm install` does _not_ create links for the top-level package
under development: just for dependencies. (You can work around this with
`npm link`, but that creates a global symlink to your development package,
which generally you don't want.)

#### System Requirements

- __engines__: Allowable node versions.
- __os__: List of allowed or not (`!`) platforms as returned by
  `process.platform`.  E.g. `["darwin", "linux"]` or `["!win32"]`.
- __cpu__: As `os`, but with `process.arch`.
- __libc__: Linux-only, e.g. `{ "os": "linux", "libc": "glibc" }`.

#### [Dependency Fields]

The following objects specify dependencies:
- __dependencies__: Required for use of the package (as library or script)
- __devDependencies__: For building and testing;
  installed by default by `npm link` or `install`
- __peerDependencies__: Minimum versions of plugins; not installed by default
- __bundledDependencies__: Bundled when publishing the package by `npm pack`
- __optionalDependencies__: Proceed with warning if not available
  (your software needs to handle package absence)

Dependencies are a map of `{ "name": "SPEC" }`, where the spec is
a version spec or direct download specifier.

Version specifiers are [semver]s, including:
- `x`, `x.y`, `x.y.z`
- `''`, `*`: any version
- `>`, `>=`, `<`, `<=` prefixes
- `~` prefix for approximate equivalance
  - patch-level changes if minor version given: `~1.2.3` = `>=1.2.3 <1.3.0`
  - minor version changes if only major version given `~1` = `>=1.0.0 <2.0.0`
- `^` prefix for "compatible with": basically specifies a min ver. without
  ever going past the specified major release.
- `v1 - v2`: range
- `range1 || range2`: either range must be satisfied

There's also a [Semver cheatsheet][semver-cheat] (which may or may not
exactly match NPM) and you may use the [npm SemVer Calculator][semver-calc]
to see what package versions will be matched by a given expression.

Other specifiers are:
- `https://.../package.tar.gz`: URL to tarball
- `git+https://...`: URL to Git repo (also `git`, `git+ssh`, `git+file`, etc.).
  Add `#commit-ish` or `#semver:SEMVER` for a specific version.
  The commit-ish may need slashes escaped with `\`.
- `user/project`: GitHub repo. Optional version as with `git`.
- `./foo/bar`: Local path, starting with `../`, `./`, `~/`, `/` or `file:`.


Dependency Locking: `package-lock.json` and `npm-shrinkwrap.json`
-----------------------------------------------------------------

The `node_modules/` directory generated by NPM from a [`package.json`]
will vary depending on the particular versions of modules currently
available and the particular dependency resolution algorithm used in
your version of NPM. [Package locks] are used to ensure that a
previously generated `node_modules/` can be exactly regenerated for
testing and release.

However, because NPM silently falls back to standard package
resolution if the version in the lockfile is not available, a rebuild
is not entirely deterministic. In this case the lock file will be
updated with the different version that was actually installed.

### npm-shrinkwrap.json and package-lock.json

The locked configuration is stored in either [`npm-shrinkwrap.json`]
or [`package-lock.json`]. (Both use the same format.) `npm-shrinkwrap`
will always take priority, if present, causing `package-lock` to be
ignored. The locked configuration includes the exact versions of
packages that were installed and cached package metadata (source URL,
integrity hash, etc.).

NPM will update the lockfile automatically for most operations that
change the `node_modules/` tree or `package.json` (e.g., `npm install
--save-prod`). The lockfile should always be committed after testing
the new configuration.

`package-lock.json` is intended to record the last known-good
configuration for development/testing etc.; it will be created/updated
by `npm install` and other commands that manipulate `node_modules/`.
This is never included when a package is published. Unless you're
using `npm-shrinkwrap.json` this file should always be committed.

`npm-shrinkwrap.json` is intended to lock down the configuration of a
(stand-alone) application and should not be used for modules imported
by other applications or libraries. It is initially created by the
`npm shrinkwrap` command (which will deal with a pre-existing
`package-lock.json` by moving it to `npm-shrinkwrap.json`). Otherwise
it functions in the same way as `package-lock.json` except that it
will be included in published packages.

### Shrinkwrap Inconsistencies

Depending on the circumstances under which `npm-shrinkwrap.json` was
generated, the contents may differ even for the exact same set of
packages and versions. (This may already be fixed in later versions of
NPM.)

One difference that can appear (discussed in detail in [issue 9550])
is that `from:` field in a package lockfile, which may be taken from
`_resolved:` and/or `_from:` in `node_modules/.../package.json` when
NPM updates the package lock file. It may contain:

1. The name and resolved version number (`async@1.4.2`) if the update
   was done due to an explicit install of the package (`npm install
   --save-prod async`)
2. The resolved package URL from `node_modules/.../package.json` if
   the update was done with the package already installed (`npm
   shrinkwrap`).

The [npm-shrinkwrap package] is a way of fixing this, though it
appears not to work with NPM ≥ 3.x. (Perhaps because it's no longer
necessary?)



<!-------------------------------------------------------------------->
<!-- WARNING: Version numbers
     URLs in this section that include /v11/ or similar version numbers
     need to be updated as NPM is updated. This fragment can be left out
     when going to the top of a page, but if you leave it out fragments
     will not work because they're removed by the redirect.
-->

[`npm-shrinkwrap.json`]: https://docs.npmjs.com/files/shrinkwrap.json
[`package-lock.json`]: https://docs.npmjs.com/files/package-lock.json
[`package.json`]: https://docs.npmjs.com/files/package.json
[issue 9550]: https://github.com/npm/npm/issues/9550
[npm-shrinkwrap package]: https://github.com/uber/npm-shrinkwrap

<!-- Module Definition: `package.json` -->
[Package entry points]: https://nodejs.org/api/packages.html#package-entry-points
[`bin`]: https://docs.npmjs.com/cli/v11/configuring-npm/package-json#bin
[`config`]: https://docs.npmjs.com/cli/commands/npm-config
[`restart`]: https://docs.npmjs.com/cli/commands/npm-restart
[`start`]: https://docs.npmjs.com/cli/commands/npm-start
[`stop`]: https://docs.npmjs.com/cli/commands/npm-stop
[`test`]: https://docs.npmjs.com/cli/commands/npm-test
[devEngines]: https://docs.npmjs.com/cli/v11/configuring-npm/package-json#devengines
[scripts]: https://docs.npmjs.com/cli/v11/using-npm/scripts
[semver-calc]: https://semver.npmjs.com/
[semver-cheat]: https://devhints.io/semver
[semver]: https://docs.npmjs.com/about-semantic-versioning
