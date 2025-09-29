JavaScript Notes
================

* [JavaScript Scoping and Hoisting][jshoist] (Adequately Good)
* [ES6 In Depth: Modules][es6modules] (Mozilla Hacks)


Testing Frameworks
------------------

* [Jest], [docs][jest-doc], [cheatsheet][jest-cheat]  
  Typically you'll need to install both `jest` and `babel-jest`.


Syntax
------

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

<!-- Testing Frameworks -->
[jest]: ./jest.md
[jest-doc]: https://facebook.github.io/jest/docs/en/getting-started.html
[jest-cheat]: https://devhints.io/jest
[es6modules]: https://hacks.mozilla.org/2015/08/es6-in-depth-modules/
[jshoist]: http://www.adequatelygood.com/JavaScript-Scoping-and-Hoisting.html

<!-- Syntax -->
[`Error`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error

<!-- Global APIs -->
[Styling console output]: https://developer.mozilla.org/en-US/docs/Web/API/console#styling_console_output
[`console`]: https://developer.mozilla.org/en-US/docs/Web/API/console
[substitution arguments]: https://developer.mozilla.org/en-US/docs/Web/API/console#using_string_substitutions
