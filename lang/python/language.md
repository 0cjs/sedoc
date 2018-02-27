Python Summary/Quickref
=======================

#### Documentation

* [Official Documentation] ([Language Reference], [Library Reference]).
* Wikipedia, [Python syntax and semantics][wp].
* O'Reilly [Python Pocket Reference, 5th ed.][ppr] (Safari)

#### Quick Hints

* Use the [ipython](ipython.md) REPL to experiment.
* Use [virtual environments](test/virtualenv.md) to experiment with packages.


Langauge Summary
----------------

Python variables are untyped, holding references to typed values which
are always _objects_. Each object has a _[namespace](name-binding.md)_,
a dictionary of name-value bindings called _attributes_, usually
accessed as `obj.attr`.

There is limited implicit conversation, mainly between numeric types
and any type to boolean.

[Functions](functions.md) are first-class objects like any other.
_f(x)_ syntax invokes the [`__call__`] attribute on the object (which
must be a function itself), passing the parameters `x` to it.

Scripts are executed statement by statement, updating the interpreter
state as they go. Thus, bindings must come before use.

All statments (which includes expressions) run in the context of a
_module_ (`__main__` by default); that module's namespace is referred
to as the "global" namespace for that statement. Calling functions,
defining classes and loading new modules all create new namespaces.

Function definitions are executable statements that compile and store
the function's code, binding it to a variable that is the function
name. (Expressions in the function declaration, i.e. arguments, are
executed at the time of definition, not at the time of the call.) The
compiled code will use a new _local_ namespace created at call time.

Code in [class definitions](name-binding.md#classes) is executed
immediately but in the class's _local_ namespace which shadows the
module namespace; new bindings are stored in the class object's
attribute dictionary.


Syntax
------

### [Lexical]

Statements are separated by semicolons or newlines. Indenting
introduces a new block that closes at the next dedent. Statements that
introduce blocks (`def`, `if`, `else`, etc.) are followed by a colon
and may not be on the same line as another block-introducing
statement. Following the colon may be a list of semicolon-separated
statements on the same line or an indented block on subsequent lines.
E.g.:

    if x == 0:  pass  # statement must be present so do nothing
    elif x > 0: foo; bar; baz()
    else:
        baz(0, 1, 2)
        quux('............................................')

In place of the `pass` statement you can also use an expression,
usually `None` or `...` (Ellipsis literal).

If `return` is not used in a function it always returns `None`.
`lambda: expr` however returns `expr` and may not use `return`.

### Futher Details

Further details can be found in the [expressions](expressions.md)
documentation here and in the following from the Python reference
manual:
* [Lexical Analysis][lexical]
* [Expressions]
* [Compound statements]

### Types

See [types.md] for more information on the types below.

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



[CPython]: https://en.wikipedia.org/wiki/CPython
[`__call__`]: https://docs.python.org/3/reference/datamodel.html#object.__call__
[compound statements]: https://docs.python.org/3/reference/compound_stmts.html
[expressions]: https://docs.python.org/3/reference/expressions.html
[lambda]: https://docs.python.org/3/reference/expressions.html#lambda
[language reference]: https://docs.python.org/3/reference/
[legacy]: https://wiki.python.org/moin/Python2orPython3
[lexical]: https://docs.python.org/3/reference/lexical_analysis.html
[library reference]: https://docs.python.org/3/library/index.html
[official documentation]: <https://docs.python.org/3/>
[ppr]: https://www.safaribooksonline.com/library/view/python-pocket-reference/9781449357009/ch01.html
[wp]: https://en.wikipedia.org/wiki/Python_syntax_and_semantics
