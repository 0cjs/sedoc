NPM - Node Package Manager
==========================

[Master docs page][docs].

Most `npm` subcommands assume that the current working directory (CWD)
is the project directory; this is where it will  manipulate the
`node_modules/` subdirectory and read the optional `package.json`
file, if present.

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


package.json
------------

[`package.json`] is not a required file; you can `npm install`
specific packages into `node_modules/` under the CWD even if it
doesn't exist.

#### [Dependency Fields]

The following fields specify dependencies:
- `dependencies`: Required for use of the package (as library or script)
- `devDependencies`: For building and testing;
  installed by default by `npm link` or `install`
- `peerDependencies`: Minimum versions of plugins; not installed by default
- `bundledDependencies`: Bundled when publishing the package by `npm pack`
- `optionalDependencies`: Proceed with warning if not available
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
- `^` prefix for "compatible with":
  Changes must not modify left-most non-zero digit.
- `v1 - v2`: range
- `range1 || range2`: either range must be satisfied

Other specifiers are:
- `https://.../package.tar.gz`: URL to tarball
- `git+https://...`: URL to Git repo (also `git`, `git+ssh`, `git+file`, etc.).
  Add `#commit-ish` or `#semver:SEMVER` for a specific version.
  The commit-ish may need slashes escaped with `\`.
- `user/project`: GitHub repo. Optional version as with `git`.
- `./foo/bar`: Local path, starting with `../`, `./`, `~/`, `/` or `file:`.

#### Other Common Fields

- `name`: (required)
  - Cannot start with `.` or `_`; no uppercase; URL-safe.
  - Do not put `js` or `node` in the name. (Use `engines` if not for node.)
  - Don't use names already in <https://www.npmjs.com>.
- `version`: (required) A semver.
- `private`: (default `false`) If `true`, npm will not publish and will
  disable some lint checks for license etc. See also `publishConfig`.
- `license` (default `ISC`) Use a license from the [SPDX License List],
  `SEE LICENSE IN <filename>` or `UNLICENSED`.





[SPDX License List]: https://spdx.org/licenses/
[`install`]: https://docs.npmjs.com/cli/install
[`package.json`]: https://docs.npmjs.com/files/package.json
[`~/.npm-init.js`]: https://docs.npmjs.com/getting-started/using-a-package.json#how-to-customize-the-packagejson-questionnaire
[dependency fields]: https://docs.npmjs.com/files/package.json#dependencies
[docs]: https://docs.npmjs.com/
[init-package-json]: https://github.com/npm/init-package-json/
[registry]: https://docs.npmjs.com/misc/registry
[semver]: https://docs.npmjs.com/misc/semver
