Python Tips and Tricks
======================

#### jsontool

Install the [`jsontool`] package to get a program that can pretty
print JSON (color it and add optional indented multi-line formatting).
It comes with a command line tool or you can call it directly with the
Python interpreter:

    jsontool --indent=2 < foo.json
    python3 -m jsontool --indent=4 < foo.json

This isn't as good as [`jq`](../jq.md) but can be useful when that's
not available. In particular, on any system that already has `python`
(2 or 3) in the path it can be installed with:

    curl > ~/.local/bin/jsontool \
        https://raw.github.com/mysz/jsontool/master/jsontool.py



[`jsontool`]: https://pypi.python.org/pypi/jsontool/
