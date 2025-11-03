| [Overview](README.md) | [TypeScript](ts.js) | [Async](async.md)
| [NPM](npm.md) | [NPM Files](npm-files.md) | [Jest](jest.md)
|

NPM - Node Package Manager
==========================

References:
- [Top-level documentation page][docs].
- [About packages and modules][docs-pm]

NPM is a tool to handle building and installation of _packages_

Most `npm` subcommands search upwards from the CWD for `package.json`
and/or `node_modules/`, and take where that's found as the project
directory. Otherwise the `node_modules/` (and `package.json`, if updating
it is necessary) will be created in the CWD.

While packages must have a `package.json` to be identified as such (see
below) and `npm install` by default installs dependencies listed in
`package.json`, you do not need to have a `package.json` just to install a
package in `node_modules` under the current directory. (But a
`package.json` listing the dependency will be created  unless you use
`--no-save`.)

For details on `package.json` and other files used by NPM see [NPM Package
Configuration Files](npm-files.md).

#### Identifying NPM Packages

An NPM package is one of:
- A directory with a `package.json`
- A gzipped tarball of such a directory.
- A URL pointing to such a tarball.
- A Git URL pointing to a repo containing a `package.json` in the root.
- `name@version` published on the [registry], giving a tarball URL.
- `name@tag` published on the registry pointing to a version above.
- `name` that has a "latest" tag


npm Command Overview
--------------------

Links to all command doc pages are in the 'CLI commands' section of
the [docs].

* `init`: Interactively create `package.json`. Add `-y` to be
  non-interactive. Customize with [`~/.npm-init.js`]. This command is
  supplied by the [init-package-json] module.
* `pack`: Create a tarball of the CWD package. Given package
  names/versions, downloads to cache and creates tarballs.
* `exec` (also `npx` command): Run a command in the environment NPM creates
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



<!-------------------------------------------------------------------->
[docs-pm]: https://docs.npmjs.com/about-packages-and-modules
[docs]: https://docs.npmjs.com/

[SPDX License List]: https://spdx.org/licenses/
[`install`]: https://docs.npmjs.com/cli/install
[`package.json`]: https://docs.npmjs.com/files/package.json
[`~/.npm-init.js`]: https://docs.npmjs.com/getting-started/using-a-package.json#how-to-customize-the-packagejson-questionnaire
[dependency fields]: https://docs.npmjs.com/files/package.json#dependencies
[init-package-json]: https://github.com/npm/init-package-json/
[registry]: https://docs.npmjs.com/misc/registry
[semver]: https://docs.npmjs.com/misc/semver
