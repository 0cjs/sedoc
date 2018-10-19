Python Tips and Tricks
======================

#### Space-delimited List Definitions

Ruby has `%w(apple banana pear)`. Python can do similar with
[`str.split()`], [`re.split()`], etc:

    'apple banana pear'.split()
    'one thing, another thing, etc. etc. etc.'.split(', ')
    re.split(r'\W+',   'No spaces, or punctuation, in result.')
    re.split(r'(\W+)', 'Extra items: with punctuation, and spaces.')

[`str.split()`]: https://docs.python.org/3/library/stdtypes.html#str.split
[`re.split()`]: https://docs.python.org/3/library/re.html#re.split

#### Dynamically Adding Attributes to Objects

Sometimes it's handy to add new attributes to existing objects on the
fly. This can be done with [`types.SimpleNamespace`] class:

    from types import SimpleNamespace
    o = SimpleNamespace()
    o.attr                      # ⇒ AttributeError: 'types.SimpleNamespace'
                                #   object has no attribute 'attr'
    o.attr = 42
    o.attr                      # ⇒ 42

(But also consider whether [`collections.namedtuple`] is better suited
to your situation.)

[`collections.namedtuple`]: https://docs.python.org/3/library/collections.html#collections.namedtuple
[`types.SimpleNamespace`]: https://docs.python.org/3/library/types.html#types.SimpleNamespace

#### json.tool

The [`json.tool`] package, which is part of the standard library in
Python 2 and 3, can be used from the command line to pretty-print JSON
from a file for (if no file is specified) stdin:

    python  -m json.tool data.js
    python3 -m json.tool data.js pretty.js   # writes output file
    python3 -m json.tool -h

This isn't as good as [`jq`](../jq.md) but can be useful when that's
not available and can't easily be installed.

[`json.tool`]: https://docs.python.org/3/library/json.html#module-json.tool


Not So Great Ideas
------------------

#### Assignments in Lambdas

You can't do assignments in `lambda ...: ...` (because they're not
expressions), but you can store your data in (mutable) sequences and
use [`operator.setitem()`]. (Assignment expressions are coming in
Python 3.8; see [PEP 572].)

[PEP 572]: https://www.python.org/dev/peps/pep-0572/
[`operator.setitem()`]: https://docs.python.org/3/library/operator.html#operator.setitem

#### Defeating Grep

    globals()['__buil' + 'tins__'].__dict__['__imp' + 'ort__']('os').listdir('.')
    (lambda c:(lambda b:(lambda a:getattr(a,b("flfgrz")[0])(b("yf")[0]))(__import__(b("bf")[0])))(c.getencoder("rot13")))(__import__("codecs"))
