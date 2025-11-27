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

When package B imports from package A, it may use only what package A has
explicitly exported via an [`exports`] in A's `package.json`.
- If A has `"exports": { "./foo.js": "./foo.js" }`, package B cannot
  `require('A/bar.js')`.
- If A has `"exports": { "./*": "./*" }`, package B can import anything.

The [`imports`] field creates private import mappings for a package that
apply only to imports done from within the package itself. These are,
however, still restricted to what package A exports. This is typically
used for path re-mappings. Given:

    "imports": {
        "#foo/*":   "./src/foo/*",
        "#afoo/*"   "A/foo/*",
        "#dep/*":   { "node": "dep-native/*",
                      "default": "./polyfill/*" }
    }

This package can:
- `require('#foo/bar.js')`: internal file mapping.
- `require('#afoo/bar.js')`: external package path mapping.
- `require('#dep/bar.js')`: conditional package selection.

The `import` mappings use similar resolution rules to `exports`, except
that the LHS of the mapping does not start with `./` but instead must start
with a `#` followed by at least one non-`/` character before the `/`.
Punctuation as the second character is acceptable: as well as `#x` you can
use `##` or `#@`.

When using patterns, `*` is _not_ a filepath glob pattern but matches
anything (including slashes). All `*`s on the RHS are replaced with
whatever the single `*` on the LHS matched.

Patterns are matched in order; the first match wins.

Even when using CJS `require(…)` these mappings do not do automatic search
like relative imports do: `foo/bar` will not find `foo/bar.js`.

You can attempt to add additional patterns to match the traditional Node.js
search patterns, e.g. to make `#P/foo` give `src/foo.js` and `#P/bar/` give
`bar/index.js`:

    "imports": {
        "#P/*": "./src/*.js",
        "#P/*/": "./src/*/index.js"
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
