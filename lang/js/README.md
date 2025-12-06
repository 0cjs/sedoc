| [Overview](README.md) | [Node](node.js) | [TypeScript](ts.js)
| [NPM](npm.md) | [NPM Configuration](npm-config.md)
| [Async](async.md) | [Jest](jest.md)
|

JavaScript Notes
================

Misc Reading:
* [JavaScript Scoping and Hoisting][jshoist] (Adequately Good)
* [ES6 In Depth: Modules][es6modules] (Mozilla Hacks)

Objects
-------

[Object]s are maps of _properties_ (named _k_ below) to values. They
typically inherit from `Object.prototype`, though they may also be [null
prototype] objects created with `Object.create(null)`. Properties are
[classified][propclass] as:
- _Enumerable_ or _non-enumerable_ based on their `enumerable` flag; most
  iterators (`for … in`, `Object.keys()`) visit only enumerable keys. Query
  with `o.propertyIsEnumerable(k)`. ([`Object.defineProperty()`] creates
  non-enumerable properties by default.)
- Ownership ("own" properties): whether the property is defined directly on
  this object or inherited from the prototype chain. Query with
  `Object.hasOwn(o, k)` or legacy `o.hasOwnProperty(k)`
- The name _k_ is a string or a [symbol].

The [property access] operators are:
  - `.`: _obj_`.`.
  - `[…]`: _obj_`[expr]` where _expr_ evaulates to a string or [symbol]. A
    space is allowed before the opening bracket.
  - `.#`: _obj_`.#name` where _name_ is a private element in a class.
  - `?.` short-circuit property access operator; when any application in a
    chain produces `undefined` or `null`, that is immediately returned,
    avoiding the error that would be thrown by the next access. E.g.:
    - `a.b?.c`: null/undef if _a_ has no _b_ property
    - `a?.[p].c`: null/undef is _a_ has no property named by expression _p_
    - `a.b?.()`: null/undef if _a_ has no function `b()` (a `TypeError`
      will be thrown if `.b` exists but is not a function)
- `??` is the [nullish coalescing operator]; it evaluates to the LHS if
  it's not `null` or `undefined`, otherwise the RHS. (It has precedence
  directly between `||` and `? :`.) The `||` operator is similar, but tests
  whether the LHS is falsy.


Syntax
------

### Destructuring

JS supports [destructuring] anywhere new identifier bindings are created,
including the index of `for`, function parameters and `catch` bindings.
Destructuring need not be complete: as with function parameters values
without bindings are ignored. New names and default values may be specified.
- `const { b, c:x } = { a:10, b:20, c:30 }`: binds b=20, x=30.
- `function f({y}); f({x:3, y:6})`: binds y=6 in the function
- `[a, b] = [10, 20, 30]`: binds a=10, b=20.
- `[a, b=99] = []`: binds a=undefined, b=99.
- `[a, , c] = [10, 20, 30]`: binds a=10, c=30. (
- `[a, ...xs] = [10, 20, 30]`: binds a=10, xs=[20, 30]
- `const [, p, h] = /^(\w+):\/\/([^/]+)\/(.*)$/.exec(url)`: binds _p_ and
  _h_ to the protocol and host from the regexp match.

Array destructuring calls the iterable protocol on the RHS, so the RHS need
not be an array. The RHS is iterated only until all bindings are assigned.
This covers most of it, but there are more details in [destructuring].

### Rest Parameters and Spread Syntax

_[Rest parameters]_ in a function declaration `function f(...xs) { … }`
constructs an array _xs_ from multiple parameters `f(x₀, x₁, x₂)` .
_[Spread syntax]_ `g(...ys)` deconstructs an array _ys_ to multiple
parameters, as if it were called as `g(y₀, y₁, y₂)`.

### Lambdas

Lambdas use `=>`.
- LHS is a single parameter or no/multiple parameters (destructuring
  supported) in parens: `() => …`; `x => …`; `(x,y) => …`; `([x,y]) => …`.
- RHS is a single expression not requiring a return or a block requiring a
  return: `x => x+1`, `x => { return x+1 }`.


Immutable Primitives
--------------------

- The primitives string, number, boolean, undefined, null, symbol and
  bigint are all immutable; "changing" them with e.g. `s += '.exe'`
  creates a new object and changes the reference to point to it.
- Re-assigning parameters to a function changes the bindings within the
  function, and does not affect bindings outside the function. (Mutating
  the objects will change them globally, however.)
- `Symbol(…)` produces a globally unique [symbol] with every call. Certain
  well-known symbols that are properties on Symbol (e.g.,
  `Symbol.hasInstance` serve as markers for protocols.


Global Variables
----------------

Every JS environment has one [global object]; what it is varies depending
on the environment. (In a browser it's usually an instance of `Window`;
Node.js creates one that it used to call [`global`].)

The global object can always be accessed as [`globalThis`]; in the global
context (i.e., for code not in a module: at the Node REPL or in `<script>`
without `type="module"`) it is also available as `this`.

All "global" references are actually references to properties on the global
object, e.g., `Error == globalThis.Error`.

There is a global environment, but the only code that runs in it is code in
`<script>` tags without `type="module"` and typed at the Node REPL.
(Running `node x.js` actually wraps the file in, approximately,
`(function(exports, require, module, __filename, __dirname) { … })` and so
this is run in that function's environment. But in the global environment
(and non-strict mode?) we have the following effects:

    var one = 1             // global scope; sets globalThis.one
    function two() { }      // global scope; sets globalThis.two
    globalThis.three = 3    // global scope; sets globalThis.three
    let four = 4            // effectively local; NOT on globalThis
    const five = 5          // effectively local; NOT on globalThis


Exceptions
----------

Exceptions are raised with `throw`, typically `throw new Error('message')`.
[`Error`] indicates a runtime error; subclasses include:
- `EvalError`: error from global function `eval()`.
- `RangeError`: numeric param out of range.
- `ReferenceError`: de-referencing an invalid reference.
- `SyntaxError`.
- `TypeError`: param has invalid type.
- `URIError`: bad parameter(s) to `encodeURI()` or `decodeURI()`.
- `AggregateError`: wrapper for several errors when they need to be
  reported together, e.g. by `Promise.any()`.
- `InternalError`: JS engine error.


Global APIs
-----------

### console

Below _m_ is a "message," which may be a one or more objects (given as
additional arguments) or a string followed optionally by additional
[substitution arguments]. These are substituted positionally replacing the
following in the string:
- `%o`: object in "optimally useful formatting style"
- `%O`: object in "generic object formatting style" (similar to `.dir()`)
- `%s`: string
- `%d`, `%i`: integer
- `%f`: floating point value
- `%c`: apply CSS rules to following text; see [Styling console output]
- Additional browser/interpreter-specific ones.

Certain formatting options are not available on the terminal but only in
browser console panes, such as being able to show things in collapsed form
(with triangles to expand sections).

__Basic [`console`] API:__
- `.error(m)`: Print at error level, to stderr if on terminal.
- `.warn(m)`: Print at warn level, to stderr if on terminal.
- `.log(m)`: Print at the default level, to stdout if on terminal.
- `.info(m)`: Print at the info level.
- `.debug(m)`: Print at the debug level.
- `.assert(p, m)`: If _p_ is truthy, print _m_ at error level.
- `.trace(m)`: Print a stack trace at the current point in the program.
  First line is `Trace:` followed by optional _m_; then indented locations.

__Additional formatting:__
- `.dir(o, options)`: Hierchical display with color.
  Default options: `{ colors: true, depth: 2, showHidden: false, }`
- `.table(o, columns)`: Show array/object in tabular form. _columns_ is an
  array of indices (integers for arrays, names for an object) of columns to
  display; defaults to all columns.
- `.group(m)`, `.groupCollapsed(m)`, `.groupEnd()`. Adds/removes a level of
  indent on the console. Optional param(s) _m_ is printed before indenting.
- `.clear()`: Clear the panel or terminal screen.


Modules
-------

There are two module systems:
* Common JS (CJS, `.js`): legacy Node.js import system using [`require()`].
  (These are not called "modules"; that refers only to ESM.)
* ECMAScript Modules (ESM, `.mjs`): new module system using `import` and
  [`import()`] introduced in ECMAScript 2015 (ES6), but not recommended in
  Node until 12+ (2019).

Node will try to detect from the contents of a file if it's CJS or ESM, but
you can force all `.js` files to be ESM with `"type": "module"` in
`packge.json`. Regardless, it's [recommended by V8][v8ext] that explicit
`.mjs` extensions be used for ESM files both to make it more clear to
developers and to maximise cross-platform compatibility.

ESM imports must use an explicit extension on filenames. Node CJS
(`require()`) is able to do [extension searches] (e.g. `foo/bar` to find
`foo/bar.js`). This is not allowed in ESM: file extensions are mandatory
with two exceptions:
- Node's `package.json` [`exports`][node.md] field can map bare names to
  files.
- Some systems added experimental extension search to ESM. This should
  never be used. (Node may turn on this capability automatically.)

There are three widely used specifiers for the import name:
- Relative (to the importer), starting with one of `/`, `./`, `../`.
- Absolute, which are URLs (typically `http:`, `file:`, data). The
  [`node:`] URL always resolves to internal Node.js modules.
- Bare specifiers. Complex and probably should be avoided (see above and
  [import maps]).

### ESM

#### Imports

Modules are automatically run in strict mode. [`import`] syntax follows.
All identifiers introduced by imports are "hoisted," meaning that the
identifier is available everywhere in the importing module, even before the
import statement, and the importee's global code is always run before any
code in the importing module.

* `import 'module-name'`: Import for side effects only. (Runs the module's
  global code if it's not already been run.)

* `import * as NSOBJ from 'module-name'`: Namespace import. _nsobj_ is
  a _namespace object_ that contains all exports as properties on it.
  the default export is available under key `.default`. _nosobj_ is
  [sealed][] (immutable) and has a [null prototype].

* `import D from 'module-name'`: Default import, binding the default export
  to _d._ May be used in combination: `D, *`, `D, { f, g }`. Importing name
  `default` has the same effect, but needs to be rebound as it's a reserved
  word: `import { default as D }`.

* `import { B } from 'module-name'`: Named import. _b_ is comma-separated
  list of bindings, with optional renamings `{ foo as f }`. Modules may
  export string-literal identifiers (`export { a as 'a-b' }`) in which case
  they must be quoted in the import: `import { 'a-b' as b }`.

#### Exports

XXX write me



<!-------------------------------------------------------------------->

[es6modules]: https://hacks.mozilla.org/2015/08/es6-in-depth-modules/
[jshoist]: http://www.adequatelygood.com/JavaScript-Scoping-and-Hoisting.html

<!-- Objects -->
[`Object.defineProperty()`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol
[null prototype]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object#null-prototype_objects
[nullish coalescing operator]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing
[object]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object
[propclass]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Enumerability_and_ownership_of_properties
[property access]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Property_accessors
[symbol]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol

<!-- Syntax -->
[destructuring]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring
[rest parameters]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters
[spread syntax]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax

<!-- Global Variables -->
[`globalThis`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/globalThis
[`global`]: https://nodejs.org/api/globals.html#globals_global
[global object]: https://developer.mozilla.org/en-US/docs/Glossary/Global_object

<!-- Global APIs -->
[Styling console output]: https://developer.mozilla.org/en-US/docs/Web/API/console#styling_console_output
[`Error`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error
[`console`]: https://developer.mozilla.org/en-US/docs/Web/API/console
[substitution arguments]: https://developer.mozilla.org/en-US/docs/Web/API/console#using_string_substitutions

<!-- Modules -->
[`import()`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/import
[`import`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import
[`node:`]: https://nodejs.org/api/esm.html#node-imports
[`require()`]: https://nodejs.org/api/modules.html#requireid
[extension searches]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import#module_specifier_resolution
[import maps]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules#importing_modules_using_import_maps
[node.md](./node.md#package.json)
[sealed]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/seal
[v8ext]: https://v8.dev/features/modules#mjs
