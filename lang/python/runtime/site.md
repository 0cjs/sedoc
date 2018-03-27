Python Interpreter Site Setup
=============================

At startup the Python interpreter has a minimal system path from which
it automatically imports `site.py` before doing anything else. This
can be skipped with the `-S` option. Running the module directly
(`python3 -m site`) gives information about what it's configured; this
will give correct results with `-S` because it checks itself to see if
`sys.flags.no_site` is set.

Full details of the initialization are given in both the [source] and
[documentation] \([v2 docs]). See also Stack Overflow [What sets up
sys.path with Python, and when?][so-4271494].



[documentation]: https://docs.python.org/3/library/site.html
[so-4271494]: https://stackoverflow.com/q/4271494/107294
[source]: https://github.com/python/cpython/blob/master/Lib/site.py
[v2 docs]: https://docs.python.org/2/library/site.html
