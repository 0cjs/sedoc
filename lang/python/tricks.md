Python Tips and Tricks
======================

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
to your situation.0

[`collections.namedtuple`]: https://docs.python.org/3/library/collections.html#collections.namedtuple
[`types.SimpleNamespace`]: https://docs.python.org/3/library/types.html#types.SimpleNamespace


#### json.tool

The [`json.tool`] package, which is part of the standard library in
Python 2 and 3, can be used from the command line to pretty-print JSON
from a file for (if no file is specified) stdin:

    python  -m jsontool data.js

    python3 -m jsontool data.js pretty.js   # writes output file
    python3 -m jsontool -h

This isn't as good as [`jq`](../jq.md) but can be useful when that's
not available and can't easily be installed.

[`json.tool`]: https://docs.python.org/3/library/json.html#module-json.tool
