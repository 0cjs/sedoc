| [Overview](README.md) | [TypeScript](ts.js) | [Async](async.md)
| [NPM](npm.md) | [NPM Files](npm-files.md) | [Jest](jest.md)
|

TypeScript
==========

The standard [TypeScript] compiler is `tsc` from the [`typescript`] package.

Since v22.18.0, Node.js has `--experimental-strip-types` for type
stripping; this works only with [erasable syntax] only. (No enums,
namespaces/modules with runtime code, parameter properties in classes,
import aliases.) `tsc --erasableSyntaxOnly` will issue errors if you're
using any non-erasable syntax.

References:
- [Documentation][doc]

### Related Packages

* [`tsx`]: TypeScript Execute: provides a `tsx` binary you use just like
  `node`. Has sensible defaults for no-config situations. Seamless CJS ↔
  ESM imports. Improvement over `ts-node`. (For command-line programs, use
  as `#!/usr/bin/env tsx`.)
* [`get-tsconfig`]: Pure JS code to find, parse and validate
  `tsconfig.json` files. No dependencies (not even TypeScript).
* [`esbuild`]: Fast JS bundler/minifier. Compiles TS w/o type checking.
  Written in Go.


Build/Test System
-----------------

[`tsconfig.json`] configured with appropriate options, e.g.:

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



<!-------------------------------------------------------------------->

[TypeScript]: https://www.typescriptlang.org/
[doc]: https://www.typescriptlang.org/docs/
[erasable syntax]: https://devblogs.microsoft.com/typescript/announcing-typescript-5-8-beta/#the---erasablesyntaxonly-option

<!-- Packages -->
[`esbuild`]: https://www.npmjs.com/package/esbuild
[`get-tsconfig`]: https://www.npmjs.com/package/get-tsconfig
[`typescript`]: https://www.npmjs.com/package/typescript
[`tsx`]: https://tsx.is/

<!-- Build/Test System -->
[`tsconfig.json`]: https://www.typescriptlang.org/docs/handbook/tsconfig-json.html
[njs-test]: https://nodejs.org/en/learn/test-runner/using-test-runner
