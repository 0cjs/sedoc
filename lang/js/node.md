| [Overview](README.md) | [Node](node.js) | [TypeScript](ts.js)
| [NPM](npm.md) | [NPM Configuration](npm-config.md)
| [Async](async.md) | [Jest](jest.md)
|

Node.js Runtime Environment
===========================

This describes Node-specific features and Node's implementation of standard
features.

References:
- [Documentation]
- [Modules: Packages]


package.json
------------

Node will read the following fields in `package.json`.

#### __imports__

The [`imports`] field creates private mappings, always starting with `#`,
that apply only to imports done from within the package itself. These use
similar resolution rules to [`exports`][], but imports may also map to
external packages outside the current package.

When using patterns, `*` is _not_ a filepath glob pattern but matches
anything (including slashes). All `*`s on the RHS are replaced with
whatever the single `*` on the LHS matched.

Even when using CJS `require(…)` these mappings do not do automatic search
like relative imports do: `foo/bar` will not find `foo/bar.js`.

You can attempt to add additional information to match the traditional
Node.js search patterns, e.g. to make `foo` give `src/foo.js` and `bar/`
give `bar/index.js`:

    "imports": {
        "#/*": "./src/*.js",
        "#/*/": "./src/*/index.js"
    }

but this is not recommended as it's complex and fragile; instead just give
the full name at the import location: `foo.js` and `bar/index.js`. (This is
the normal and required way of doing things in ESM anyway because there
imports may be importing via URLs rather than filesystems.)



<!-------------------------------------------------------------------->
[Documentation]: https://nodejs.org/docs/latest/api/
[Modules: Packages]: https://nodejs.org/api/packages.html

[`imports`]: https://nodejs.org/api/packages.html#subpath-imports
[`exports`]: https://nodejs.org/api/packages.html#package-entry-points
