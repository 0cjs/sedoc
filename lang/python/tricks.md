Python Tips and Tricks
======================

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
