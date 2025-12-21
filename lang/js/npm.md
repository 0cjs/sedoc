| [Overview](README.md) | [Node](node.js) | [TypeScript](ts.js)
| [NPM](npm.md) | [NPM Packages](npm-package.md)
| [Async](async.md) | [Jest](jest.md)
|

NPM - Node Package Manager
==========================

References:
- [Top-level documentation page][docs].
- [About packages and modules][docs-pm]
- `npm help KEYWORD` will give help on commands and search results for
  keywords.

NPM is a tool to handle building and installation of _packages._ The
installation of a package is one of two types:
- Global: installed into the library/bin/etc. dirs of the base Node system.
  this is typically used only for command-line programs to be made globally
  available, such as `npm` itself.
- Local: installed into the `node_modules/` of the current package, making
  it a dependency of the current package. For more on how the current
  package is determined, see §"Files and Directories" below.

While packages must have a `package.json` to be identified as such (see
[NPM Packages]) and `npm install` by default installs dependencies
listed in `package.json`, you do not need to have a `package.json` just to
install a package in `node_modules` under the current directory. (But a
`package.json` listing the dependency will be created  unless you use
`--no-save`.)

For details on `package.json` and other files used by NPM see [NPM Packages].

Note that NPM _configuration_ values (e.g. `bin-links`) do _not_ go in
`package.json`; they go in `.npmrc` or per-user/global/builtin config
files. These are `key=val` form, not JSON, and do not apply to published
versions of modules. See `npm help npmrc`.

### "Prefix" and Package Definitions vs. NPM Configuration

__WARNING:__  
There are two kinds of configuration (which overlap) in NPM:
1. The _package_ configuration: name of the package, dependencies, etc.
   This is found in `package.json` and related files/directories.
2. The _NPM_ configuration, some of which can be local to a package and
   some of which is "global", with values in the former defaulting to
   values in the latter if not overridden.

Here we try to refer to the former as "package definition" or "module
definition" and the latter as "NPM configuration," but untangling the two
can be difficult and there may be erronous uses of these in these docs that
need to be fixed.

There are two uses of "prefix" in NPM:

1. The "package prefix," indicating where the package definition and code is.
   * `npm prefix` prints this.
   * $npm_package_json contains the path to this followed by
     `package.json`.
   * Found by searching from the current working directory.
   * `npm run` always does a chdir to this before running any script
     entries. (As do the shortcuts, e.g. `npm test` for `npm run test`.)
   * Overridden by `--prefix`, which _also_ sets the "prefix" used for #2
     below.

2. The "NPM (global) prefix", determining how (non-package) configuration
   is found and where "global" (e.g. `npm install -g`) operations happen.
   * Defaults to the directory in which Node is installed.
   * $npm_config_prefix and $npm_config_global_prefix both contain this.
     (They appear never to be different.)
   * $npm_config_globalconfig is `etc/npmrc` under this.
   * `--prefix` sets this _and_ sets the package directory used for #1.

TLDR: You almost never want to use `--prefix` unless you're trying to
emulate multiple different installations of Node. Instead you must rely on
the upward search from the current working directory to find the package
definition. I.e.,
-  NO: `npx --prefix /my/package jest`
- YES: `(cd /my/package && npx jest)`


Files and Directories
---------------------

`{prefix}` is the Node install location.
- POSIX: `/usr/local/`, `~/.nvm/versions/node/v22.21.1/` or similar. This
  will have standard Unix $prefix subdirs: `bin/`, `lib/node_modules/`,
  etc.
- Windows: usually `%AppData%/npm/`.

To find the current local package, `npm` searches upwards from the CWD for
`package.json` and/or `node_modules/`, and take where that's found as the
root directory for the current package. Otherwise the CWD will be used and
a new module (`package.json` and `node_modules/`) will be created. With
workspaces (see below), the local package is considered the top-level
package, not the nearest workspace of it.

"Global" (`-g`) installs go into the node install location. "Local"
installs go into the root of the current package (determined by searching
upwards as described above—but see §"Workspaces" below), or the CWD if no
current package is found. This is used only for installing command-line
tools (such as `npm`). You can _not_ import or require libraries installed
globally; they may come only from the current package.

Executable files (the `"bin"` field in `package.json`) are linked into the
executable directories below. On Unix this is a symlink; on Windows it's a
`.cmd` file.

#### Global Locations

- Libraries: Unix `{prefix}/lib/node_modules/`; Win `{prefix}`.
- Executables: Unix `{prefix}/bin/`; Win `{prefix}`.
- Man pages: Unix `{prefix}/share/man/`; Win not installed.
- Cache: Unix `~/.npm/`; Win `%LocalAppData%/npm-cache/`.
  (Controlled by `cache` config param; see also `npm cache`.)

#### Local Locations

- Libraries: `./node_modules/` where `.` is the top-level package at or
  above the CWD.
- Executables: `./node_modules/.bin/`
- Man pages: not installed.

#### References

- [CLI » Configuring » Folders][folders], "Folder Structures Used by npm."
  This also contains details of installation of multiple versions of a
  dependency (as required by other dependencies), "hoisting," etc.


Workspaces
----------

[Workspaces] are used to manage multiple packages in a directory tree under
a single top-level root package. (This was first provided by [LernaJS] and
[Yarn] and later added to NPM.) An [article by Julien Roche][roche25]
provides considerable additional detail not in the official documentation.

Note that the workspace packages have no special relationship to the
top-level package; their names and all else (if they are published) are
independent. Workspaces are merely a build system detail to help with repos
containing multiple packages.

These are configured as follows. The top-level package is usually declared
private as it's never intended to be published, though there are somewhat
complex cases where you do want it public.

    "private": true,
    "workspaces": [
        "package",
        "packages/*"
      ]

`npm install` at the top level will `npm link` the workspace packages into
the top-level `node_modules/` and install dependencies for both the
top-level package and all workspace packages. Dependencies will generally
be installed to the top-level `node_modules/` directory except when a
workspace package needs a version incompatible with the top level, where it
will be installed into that workspace package's local `node_modules/`
directory. `npm install` in a workspace package will still use the
top-level `node_modules/` and `package-lock.json`, though it will install
only the dependencies for that workspace package. All workspace packages
are available to be imported into top-level package code.

There is only a single `package-lock.json` at the top level; this contains
all lock information. (It's unclear how one deals with this in workspace
packages that are applications that want to lock their dependencies if
published.)

There are several command line/configuration options relating to
workspaces; these work from anywhere in or under the top-level package.
- `-w WS`/`--workspace=WS`: Change to the directory of workspace _ws_
  (where _ws_ is a workspace package directory path or package name from a
  `package.json`) run the npm command. This may be specified multiple
  times. This may also be given to `npm init` to create a new workspace and
  update the top-level `workspaces` stanza.
- `--workspaces`: Run the npm command in all workspaces, but not the
  top-level package. This will abort on the first failure.
- `--include-workspace-root`: Add the top-level package to the list of
  packages on which to operate.
- `--if-present`: For `npm run`, ignore any workspaces that do not
  implement that command.

Other notes:
- For huge monorepos with long build times where developers often want to
  work on just a single package, Yarn's [focused workspaces] allows working
  without doing a full build of all workspaces.


Lifecycle Scripts
-----------------

The following scripts, if present, are run by various npm commands.

* install, ci, rebuild:
  - `preinstall`
  - `install`
  - `postinstall`
  - `prepare`: Commonly used for for TS compilation, ensuring `dist/`
    folder is up to date, etc.

* publish, pack:
  - `prepublishOnly` (for `publish` only)
  - `prepack`
  - `prepare`
  - `postpack`


npm Options
-----------

#### --prefix

Changes the global installation prefix (partially), including where
`install -g` installs things, ___and___ sets the directory from which
`package.json` etc. will be read.

Generally, don't use this; see §""Prefix" and Package Definitions vs.
NPM Configuration" above for details.

The `--prefix DIR` option determines where the following files are found:
- `package.json`: Configuration, dependencies, scripts.
- `package-lock.json`: Exact (locked) depdendency definitions. (Or
  `npm-shrinkwrap.json` if that's being used instead.
- `node_modules`: Package install dir; imports resolved from here.
- `.npmrc`: Project-level NPM configuration.
- `.npm/`: Local cache directory, if being used instead of global cache.

It does _not_ itself change the CWD, but `npm run` (and `test`, `start`
etc.) commands _do_ change the CWD to the prefix (explicit or implicit)
before running scripts defined in `package.json`. Note that many tools,
e.g., `jest` rely on this behaviour and search for their configuration in
CWD, not in the NPM prefix.


npm Command Overview
--------------------

Links to all command doc pages are in the 'CLI commands' section of the
[docs]. All commands use a search upward from the current working directory
to find the package directory (see §"Files and Directories" above),
defaulting to the CWD if no package directory is found. Some commands
change the CWD to that directory before continuing.

* `init`: Interactively create `package.json`. Add `-y` to be
  non-interactive. Customize with [`~/.npm-init.js`]. This command is
  supplied by the [init-package-json] module.
* `pack`: Create a tarball of the CWD package. Given package
  names/versions, downloads to cache and creates tarballs.
* `run`: Change the current working directory to the package directory and
  execute the given command defined in the `scripts` section of
  `package.json`.
* `exec` (also `npx` command): Without changing the current working
  directory (unlike `npm run`), run a command in the environment NPM creates
  for the current package. (This includes commands linked into
  `node_modules/.bin/`.) Note that `exec` can accept NPM arguments, but
  also requires a `--` before any arguments for the command being run.

#### install

With no arguments [`install`], installs everything in `package.json`,
using exact versions from `package-lock.json` if they are within the
`package.json` ranges. `package-lock.json` will be updated with exact
installed versions.

With arguments it installs the given packages (at the given versions
if `@verspec` is added and, if `package.json` is present, updates its
dependency lists.

XXX `npm-shrinkwrap.json` takes priority over `package-lock.json`;
figure out difference between these two and document here.
(`npm-shrinkwrap.json` can be published in packages?)

Options:
* `-g`, `--global`
* `--production`, `NODE_ENV=production`: Do not install `devDependencies`.
* `-P`, `--save-prod`: (default) Save installed name/ver in `dependencies`
  * `--no-save`: Do not save dependency in `package.json`
  * `-D`, `--save-dev`: Save name/ver in `devDependencies`
  * `-O`, `--save-optional`: Save name/ver in `optionalDependencies`
* `-E`, `--save-exact`: Save exact instead of minimum vesion in deps
* `-B`, `--save-bundle`: Add also to `bundledDependencies`

#### Packaging

- `publish`: Uploads package to an NPM registry (the public registry by
  default).
- `pack`: Creates tarball for publishing.



<!-------------------------------------------------------------------->
[NPM Packages]: ./npm-package.md
[docs-pm]: https://docs.npmjs.com/about-packages-and-modules
[docs]: https://docs.npmjs.com/

<!-- Files and Directories -->
[folders]: https://docs.npmjs.com/cli/configuring-npm/folders

<!-- Workspaces -->
[LernaJS]: https://lerna.js.org/
[Yarn]: https://classic.yarnpkg.com/lang/en/docs/workspaces/
[focused workspaces]: https://classic.yarnpkg.com/blog/2018/05/18/focused-workspaces/
[roche25]: https://medium.com/@rochejul/npm-workspaces-e349da921d29
[workspaces]: https://docs.npmjs.com/cli/v7/using-npm/workspaces?v=true

[SPDX License List]: https://spdx.org/licenses/
[`install`]: https://docs.npmjs.com/cli/install
[`package.json`]: https://docs.npmjs.com/files/package.json
[`~/.npm-init.js`]: https://docs.npmjs.com/getting-started/using-a-package.json#how-to-customize-the-packagejson-questionnaire
[dependency fields]: https://docs.npmjs.com/files/package.json#dependencies
[init-package-json]: https://github.com/npm/init-package-json/
[registry]: https://docs.npmjs.com/misc/registry
