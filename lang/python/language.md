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

Python variables are untyped; their values are typed. All variables
are references to objects or builtin types. [Functions](functions.md)
define variables in the same namespace and these reference function
objects.

There is limited implicit conversation, mainly between numeric types
and any type to boolean.


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
