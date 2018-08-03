Python Summary/Quickref
=======================

#### Documentation

* [Official Documentation] ([Language Reference], [Library Reference]).
* Wikipedia, [Python syntax and semantics][wp].
* O'Reilly [Python Pocket Reference, 5th ed.][ppr] (Safari)

You can also get interactive documentation using the [`help()`]
function:
- `help()`: Start interactive help system.
- `help(object)`: Display docstring(s) for given object.
- `help('topics')`: Display help topics. Individual topics listed must
  be given as strings in the same (upper) case.
- `help('keywords')`, `help('symbols')`
- `help('modules')`: List all modules; can take a very long time.
  Use `help('modules foo')` to search for modules containing `foo` in
  the name or description, or display information about module `foo`.
- `help(s)`: Where `s` is `'modules'`, `'keywords'`, `'symbols'`.

#### Quick Hints

* Use the [ipython](ipython.md) REPL to experiment.
* Use [virtual environments](test/virtualenv.md) to experiment with packages.


Langauge Summary
----------------

Python variables are untyped, holding references to typed values which
are always _objects_. Each object has a _[namespace](name-binding.md)_,
a dictionary of name-value bindings called _attributes_, usually
accessed as `obj.attr`. Attribute access can be modified 'under the
hood' with _[descriptors](functions.md#Descriptors)_.

There is limited implicit conversation, mainly between numeric types
and any type to boolean.

[Functions](functions.md) are first-class objects like any other.
_f(x)_ syntax invokes the [`__call__`] attribute on the object (which
must be a function itself), passing the parameters `x` to it.

Scripts are executed statement by statement, updating the interpreter
state as they go. Thus, bindings must come before use.

All statments (which includes expressions) run in the context of a
_module_ (`__main__` by default); that module's namespace is referred
to as the "global" namespace for that statement.

* Loading a module creates a new namespace that will be the global one
  for the code in that module.

* Defining a class creates a new namespace that will be the _local
  namespace_ for the code defining the class. The code in the [class
  definition](name-binding.md#classes) is executed immediately in
  ithat local namespace (which shadows the module namespace): this is
  implemented by storing new bindings in the class object's attribute
  dictionary.

* Function definitions are executable statements that compile and
  store the function's code in a (callable) function object, binding
  it to a variable that is the function name. (Expressions in the
  function declaration, i.e. arguments, are executed at the time of
  definition, not at the time of the call.) Calling a function creates
  a new local namespace used by the code run during that function
  call.

* Blocks (see below) do not introduce new namespaces.

### Immutability

(Also see [Hashes and Equality][hashandeq].)

Some objects in Python, such as `int` and `str` are immutable. The
`hash()` function works only on immutable objects, throwing
`TypeError` if the object is mutable, and thus only immutable objects
may be used as keys in `dict`s.

"Immutable" collections, such as `tuple` are only "shallow immutable";
they are truly immutable (and `hash()` works on them) only when they
contain only immutable values. Thus:

    hash((1,2))                 ⇒ 3713081631934410656
    t = (1,[]); t               ⇒ (1,[])
    t[1].append(2); t           ⇒ (1,[2])
    hash(t)                     ⇒ TypeError: unhashable type: 'list'

GvR [explains][GvRimmut], "Immutability is a property of types, while
hashability is a property of values"; @nedbat's corollary:
"Immutablity is shallow, hashability is deep." But "this stops being
true with a sufficiently good notion of type (or even just the one
provided by the typing module)" (@DRMaclver).

For expanded discussion see [Python Tuples are Immutable, Except When
They're Mutable][inventwith] and [There's Immutable And Then There's
Immutable][jenkins].


Syntax
------

### Lexical

* Also see Python reference documentation [Lexical Analysis][lexical].

Statements are separated by semicolons or newlines. Indenting
introduces a new block that closes at the next dedent. Statements that
introduce blocks (`def`, `if`, `else`, etc.) are followed by a colon
and may not be on the same line as another block-introducing
statement. Following the colon may be a list of semicolon-separated
statements on the same line or an indented block on subsequent lines.
E.g.:

    if x == 0:   pass           # Statement must be present; pass does nothing
    elif x > 0:  foo; bar; baz()
    else:
        baz(0, 1, 2)
        quux('............................................')

In place of the `pass` statement you can also use an expression,
usually `None` or `...` (Ellipsis literal).

If `return` is not used in a function it always returns `None`.
`lambda: expr` however returns `expr` and may not use `return`.

### Futher Details

* See [Expressions and Statements](expressions.md).

### Types

* See [Types](types.md).

### Literals

Numbers: the usual: `0`, `-1`, `3.4`, `3.5e-8`.

String (`str`) Literals:

    'foo'           # C-style backslash sequences interpolated
    '''foo'''       # newlines are literal
    r'foo'          # no `\x` interpolation; useful for regexes

    'a' "b"         # adjacent literals are concatenated
    len('a'  # 1    # Good for commenting parts of strings.
        'b') # 2    # len('ab') => 2

Tuples, Lists, Dictionaries, Sets:

    1, 2                    # tuple
    (1, 2)                  # tuple
    ()                      # empty tuple

    [0, 'a', (), []]        # list
    list({4,2,3})           # list: [2,3,4] (from set; see below)

    { 1:'one', 'two':2 }    # dict
    {}                      # empty dict

    { 0, 'a', (), [] }      # set
    set()                   # empty set
    frozenset(['a',2,'a'])  # frozen set: frozenset({2, 'a'})


Objects
-------

`dir()` returns a list of names in local scope; `dir(obj)` returns the
list of `obj`'s attributes.

`str(o)` returns an informal, nicely printable string representation
of an object by calling `o.__str__()`. If that's not present, it
returns [`repr(o)`], which returns the formal string representation,
which either can be passed to `eval()` to recreate the object or is of
the form `<...description...>`. (It should always unambiguously
describe that particular object.) `repr()` returns `o.__repr__()` if
present or does its own thing if not.



[CPython]: https://en.wikipedia.org/wiki/CPython
[GvRimmut]: https://twitter.com/nedbat/status/960849071157268480
[`__call__`]: https://docs.python.org/3/reference/datamodel.html#object.__call__
[`help()`]: https://docs.python.org/3/library/functions.html#help
[`repr(o)`]: https://docs.python.org/3/reference/datamodel.html#object.__repr__
[hashandeq]: https://hynek.me/articles/hashes-and-equality/
[inventwith]: https://inventwithpython.com/blog/2018/02/05/python-tuples-are-immutable-except-when-theyre-mutable/
[jenkins]: http://blog.jenkster.com/2017/01/theres-immutable-and-then-theres-immutable.html
[lambda]: https://docs.python.org/3/reference/expressions.html#lambda
[language reference]: https://docs.python.org/3/reference/
[legacy]: https://wiki.python.org/moin/Python2orPython3
[lexical]: https://docs.python.org/3/reference/lexical_analysis.html
[library reference]: https://docs.python.org/3/library/index.html
[official documentation]: <https://docs.python.org/3/>
[ppr]: https://www.safaribooksonline.com/library/view/python-pocket-reference/9781449357009/ch01.html
[wp]: https://en.wikipedia.org/wiki/Python_syntax_and_semantics
