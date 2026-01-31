| [Overview](README.md) | [Node](node.md) | [TypeScript](ts.md)
| [NVM](nvm.md) | [NPM Packages](npm-package.md)
| [Async](async.md) | [Jest](jest.md)
|

TypeScript
==========

The standard [TypeScript] compiler is `tsc` from the [`typescript`] package.
`tsc` does type checking; note that many other transpilers do not.

References:
- [Documentation][doc]

### Node Support for TS

Node has limited TS support; see the [TypeScript][node-ts] module:
- Regardless of what's below, `node` will never run `.ts` files under a
  `node_modules/` path. (This is to discourage packages written in
  TypeScript; they should instead be compiled to JavaScript.)
- `--experimental-strip-types` (automatic on `.ts` files after v22.18.0 )
  strips all [erasable syntax], hopefully leaving behind straight JS. ( TS
  using enums, namespaces/modules with runtime code, parameter properties
  in classes, import aliases, etc. will not work.) Disable with
  `--no-experimental-strip-types`.
- `tsc --erasableSyntaxOnly` can confirm the above will work.
- 22.7.0 added `--experimental-transform-types` strips and beyond that can
  also transform some TS features to JS.

### Related Packages

* [`tsx`]: TypeScript Execute: provides a `tsx` binary you use just like
  `node`. Has sensible defaults for no-config situations. Seamless CJS ↔ ESM
  imports. Improvement over [`ts-node`]. (For command-line programs, use as
  `#!/usr/bin/env tsx`.)
* [`get-tsconfig`]: Pure JS code to find, parse and validate
  `tsconfig.json` files. No dependencies (not even TypeScript).
* [`esbuild`]: Fast JS bundler/minifier. Compiles TS w/o type checking.
  Written in Go.


Build/Test System
-----------------

[`tsconfig.json`] configured with appropriate [options][tscref], e.g.:

    {
        "compilerOptions": {
            "target": "ES2020",
            "module": "commonjs",
            "outDir": "./dist",
            "rootDir": "./src",
            "strict": true,
            "esModuleInterop": true,
            "skipLibCheck": true
        },
        "include": ["src/**/*"],
        "exclude": ["**/*.test.ts", "node_modules"]
    }

The exclude above prevents files from being compiled to `dist/`.

Build targets (in `package.json`):

    "scripts": {
        "dev": "tsx watch src/server.ts",
        "build": "tsc",
        "start": "node dist/server.js",
        "test": "tsx --test 'src/**/*.test.ts'",
        "test:watch": "tsx --test --watch 'src/**/*.test.ts'"
    }

In this example the test targets use [Node.js's test runner][njs-test].


Compiler Options
----------------

These are set in [`tsconfig.json`]; see the [full options reference][tscref].

### Output Directory

The [`outDir`] option sets the output directory in which the `.js` object
files, `.d.ts`, `.js.map`, `*.buildinfo`, etc. files will be placed. The
subdirectory structure of the source will be preserved. The default is the
source directory. Many systems will set this to `dist/`.

### Incremental Compilation

Incremental compilation by `tsc` is enabled by any of:
- `tsc -b` at the command line.
- [`incremental: true`] in the config.
- [`composite: true`] in the config, which sets `incremental: true`.

Incremental compilation generates and uses a [build info
file][tsbuildinfo]. This is named `tsconfig.tsbuildinfo` by default, but
`tsconfig` may be changed to a project name in some circumstances. An
arbitrary path and filename can be set with the
[`tsBuildInfoFile`][tsbuildinfo] configuration option. (XXX Does this
option apply only to composite projects?)


<!-------------------------------------------------------------------->

[TypeScript]: https://www.typescriptlang.org/
[`tsconfig.json`]: https://www.typescriptlang.org/docs/handbook/tsconfig-json.html
[doc]: https://www.typescriptlang.org/docs/
[erasable syntax]: https://devblogs.microsoft.com/typescript/announcing-typescript-5-8-beta/#the---erasablesyntaxonly-option
[node-ts]: https://nodejs.org/docs/latest-v22.x/api/typescript.html#typescript-features
[tscref]: https://www.typescriptlang.org/tsconfig/#composite

<!-- Packages -->
[`esbuild`]: https://www.npmjs.com/package/esbuild
[`get-tsconfig`]: https://www.npmjs.com/package/get-tsconfig
[`ts-node`]: https://www.npmjs.com/package/ts-node
[`tsx`]: https://tsx.is/
[`typescript`]: https://www.npmjs.com/package/typescript

<!-- Build/Test System -->
[njs-test]: https://nodejs.org/en/learn/test-runner/using-test-runner

<!-- Compiler Options -->
[`composite: true`]: https://www.typescriptlang.org/tsconfig/#Projects_6255
[`incremental: true`]: https://www.typescriptlang.org/tsconfig/#incremental
[`outDir`]: https://www.typescriptlang.org/tsconfig/#outDir
[tsbuildinfo]: https://www.typescriptlang.org/tsconfig/#tsBuildInfoFile
