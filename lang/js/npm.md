NPM - Node Package Manager
==========================

[Master docs page][docs].

Most `npm` subcommands assume that the current working directory (CWD)
is the project directory; this is where it will  manipulate the
`node_modules/` subdirectory and read the (optional) `package.json`
file, if present.

For details on the files used by NPM see [NPM Package Configuration
Files](npm-files.md).


NPM Packages
------------

An NPM package is one of:
- A Git URL pointing to a repo containing a `package.json` in the root
- A directory with a `package.json`
- A tarball of the above directory
- A URL resolving to the above tarball
- `name@version` published on the [registry], giving the above URL
- `name@tag` published on the registry pointing to a version above
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

##### install

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






[SPDX License List]: https://spdx.org/licenses/
[`install`]: https://docs.npmjs.com/cli/install
[`package.json`]: https://docs.npmjs.com/files/package.json
[`~/.npm-init.js`]: https://docs.npmjs.com/getting-started/using-a-package.json#how-to-customize-the-packagejson-questionnaire
[dependency fields]: https://docs.npmjs.com/files/package.json#dependencies
[docs]: https://docs.npmjs.com/
[init-package-json]: https://github.com/npm/init-package-json/
[registry]: https://docs.npmjs.com/misc/registry
[semver]: https://docs.npmjs.com/misc/semver
