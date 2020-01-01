The Bel Language
================

Initially published by Paul Graham 2019-10-12: [announcement], [guide],
[source] and [examples].

Four fundamental data types of objects:
- Symbols: case-sensitive words
- Pairs: `(a . b)`, `(c . (d . (e . nil)))`.
- Characters: `\A` (ASCII $65), `\bel` (ASCII $07)
- Streams (no printable representation of stream objects)
- Numbers not mentioned, but heavily used in examples.

Lists:
- Symbol `nil` represents empty list `()`.
- Nested pairs; a "proper" list is `nil` or has `nil` as cdr of innermost
  pair. Non-proper lists are "dotted" lists.
- `(c d e)` is syntactic sugar for `(c . (d . (e . nil)))`.
- A proper list is also called a string: `"abc"` is syntactic sugar for
  `(\a \b \c)`.

`nil`/empty list is the false value. `t` is true, as is any other non-`nil`
value.

    (lit clo nil (x) (+ x 1)) (fn (x) (+ x 1))

The two function definitions above are equivalent. 1. `lit` indicates a
literal object not be evaluated; 2. object type, `clo` for closure;
3. environment (list of bindings); 4. list of formal parameters; 5. form
(maybe not?) to be evaluated.

Bel has only expressions that, when evaluated, may return a value
`(+ 1 2)`; cause an error `(/ 1 0)`, `(err "oops")`;  or fail to terminate
`(while t)`. Side effects are common. All character and stream literals and
`nil`, `t`, `o` and `apply` always evaluate to themselves; other atoms
evaluate to the value to which they've been bound or cause an error.

Both _special forms_ and _functions_ are _operators_. If the first element
of a proper list is not a special form and evaluates to function, all
elements of the list are evaluated and the function applied to them.

Bindings may be _dyamic_, _lexical_ and _global_, in order of precedence.
The set of global bindings is the _global environment_. Lexical bindings
are created by function calls. Dynamic bindings are visible everywhere,
like globals, but persist only during the evaluation of the expression that
created them. Assignments change whatever binding is currently visible.

Variables and Constants:
- `t`, `nil`, `o`, `apply`
- `chars`: A list of all chars; each elm is a `(c . b)` where _c_ is the
  char and _b_ the binary representation as a string of `\0` and `\1`
  chars.
- `globe`, `scope`: the current global and lexical environments; lists of
  `(var . val)` pairs.
- `ins`, `outs`: Default input and output streams, initially `nil`
  indicating default streams.

Primitives (treat as functions):
- `(id x y)`: True iff _x_ and _y_ are identical.
- `(join x y)`, `(join x)`: Creates a new pair `(x . y)`, `(x)`. The new
  pair will not be `id` to any existing pair.
- `(car x)`, `(cdr xs)`: The usual. On `nil` returns `nil`; on any other
  atom throws error.
- `(type x)`: Returns `symbol`, `pair`, `char`, `stream`.
- `(xar xs y)`, `(xdr xs y)`: Replace car/cdr of _xs_ with _y_.
- `(sym xs)`: Returns symbol whose name is the elements of _xs_. Error if
  _xs_ not a string.
- `(nom x)`: Returns fresh list of chars representing name of symbol _x_.
  `(nom 'foo)` ⇒ `"foo"`. Error if _x_ not symbol.
- `(rdb s)`, `(wrb x s)`: Read/write bit _x_ (either `\0` or `\1`) from/to
  stream _s_ or initial output stream if _s_ is `nil`. Error on bad args or
  I/O error.
- `(ops name dir)`: Open a stream named _nam_; _dir_ is `in` or `out`.
- `(cls s)`: Close stream _s_.
- `(stat s)`: Returns state of stream _s_, `closed`, `in`, `out`. Error if
  invalid arg.
- `(coin)`: Randomly returns `t` or `nil`.
- `(sys x)`: Send _x_ as command to operating system.

Special forms:
- `(quote x)`: Returns _x_ without it being evaluated. `'foo` is syntactic
  sugar for `(quote foo)`.
- `(lit ...)`: Returns `(lit ...)` w/o evaluation, thus return value is
  still `(lit ...)` when evaluated again. The value of any primitive `p` is
  `(lit prim p)`.
- `(if ...)`: Last argument is else case, pairs preceding it are predicates
  and cases to evaluate if true. Shortcut evaluation. If an even number of
  args, final case defaults to `nil`.
- `(apply f ...)`: elements up to last are consed onto final list. `(apply
  f 'a '(b))` == `(apply f '(a b))`.
- `(where x)`: `(where (cdr '(a b c)))` ⇒ `((a b c) d)`. ???
- `(dyn v x y)`: Evals _x_, dynamic binds result to _v_, evals _y_ in that
  environment.
- `(after x y)`: Evals _x_ and then _y_, even if _x_ throws error.
- `(ccc f)`: "Evals _f_ and calls its value on the current continuation.
  The continuation, if called with one argument, will return it as the
  value of the `ccc` expression (even if you are no longer in the ccc
  expression or in code called by it)."
- `(thread x)`: Starts a new thread evaluating _x_. Global bindings are
  shared between threads but not dynamic ones.

Reading the Source
------------------

The section "Reading the Source" in the [guide] walks through the [source]
defining more functions and the interpreter based on the primitives (summarized
from guide above).

Intuitively (to help with defines after uses):
- `(set v₁ e₁ v₂ e₂ …)`: Binds _v₁_ to value of expression _e₁_ etc.
- `(def n p e)`: abbreviation for `(set n (lit clo nil p e))`.
- `(mac n p e)`: abbrev. `(set n (lit mac (lit clo nil p e)))`.
- `[f _ x]`: abbrev. `(fn (_) (f _ x))` (`_` is ordinary variable)

Backtick quotes list except substitution is turned back on for items with a
leading comma. `,@` splices into surrounding list.

    (set x 'a)
    `(x ,x y)               ⇒ (x a y)
    `(x ,x y ,(+ 1 2))      ⇒ (x a y 3)
    (set y '(c d))
    `(a b ,@y e f)          ⇒ (a b c d e f)

From "Now let's look at the source" goes through every definition, and
along the way builds up the real nature of the language (e.g., `~atom` is
`(compose no atom)`.



<!-------------------------------------------------------------------->
[announcement]: http://paulgraham.com/bel.html
[guide]: https://sep.yimg.com/ty/cdn/paulgraham/bellanguage.txt?t=1570993483&
[source]: https://sep.yimg.com/ty/cdn/paulgraham/bel.bel?t=1570993483&
[examples]: https://sep.yimg.com/ty/cdn/paulgraham/belexamples.txt?t=1570993483&
