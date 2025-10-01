| [Overview](README.md) | [Async](async.md)
| [NPM](npm.md) | [NPM Files](npm-files.md) | [Jest](jest.md)
|

JavaScript Notes
================

Misc Reading:
* [JavaScript Scoping and Hoisting][jshoist] (Adequately Good)
* [ES6 In Depth: Modules][es6modules] (Mozilla Hacks)

Syntax
------

### Syntax

- Objects are maps; the [property access] operators are:
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

### Immutable Primitives

- The primitives string, number, boolean, undefined, null, symbol and
  bigint are all immutable; "changing" them with e.g. `s += '.exe'`
  creates a new object and changes the reference to point to it.
- Re-assigning parameters to a function changes the bindings within the
  function, and does not affect bindings outside the function. (Mutating
  the objects will change them globally, however.)
- `Symbol(…)` produces a globally unique [symbol] with every call. Certain
  well-known symbols that are properties on Symbol (e.g.,
  `Symbol.hasInstance` serve as markers for protocols.

### Global Variables

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

### Exceptions

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


<!-------------------------------------------------------------------->

[es6modules]: https://hacks.mozilla.org/2015/08/es6-in-depth-modules/
[jshoist]: http://www.adequatelygood.com/JavaScript-Scoping-and-Hoisting.html

<!-- Syntax -->
[nullish coalescing operator]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing
[property access]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Property_accessors
[symbol]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol

<!-- Global Variables -->
[`globalThis`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/globalThis
[`global`]: https://nodejs.org/api/globals.html#globals_global
[global object]: https://developer.mozilla.org/en-US/docs/Glossary/Global_object

<!-- Global APIs -->
[Styling console output]: https://developer.mozilla.org/en-US/docs/Web/API/console#styling_console_output
[`Error`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error
[`console`]: https://developer.mozilla.org/en-US/docs/Web/API/console
[substitution arguments]: https://developer.mozilla.org/en-US/docs/Web/API/console#using_string_substitutions
