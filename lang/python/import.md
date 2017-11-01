The Python Import/Module System
===============================

Handy commands:

    # Show import path python is using
    python -c "import sys, pprint; pprint.pprint(sys.path)"

    # Show import path for a particular module
    python -c 'import foo; print(foo.__file__)'



Overview
--------

[Modules][modules] are objects of type `builtins.module`) that
encapsulate a namespace containing arbitrary Python objects (typically
classes and functions). They're usually created by loading a `.py`
file with the `import` statement (see below). A module's symbol table
is global to functions defined within it, but must be qualified for
code outside it.

    import a.b.c    # Create module a.b.c
                    # from a/b/c/ or a/b/c.py somewhere in sys.path
    a.b.c           # => <module 'm.a' from '.../a/b/c.py'>
    a.b.c.f         # => <function a.b.c.f>
    a.b.c.f()       # calls f() from that module
    f = a.b.c.f     # Assign f to a local name

The name of a module is defined by the path used to import it, and is
available as `__name__`.

Modules are loaded once per interpreter instance unless you use:

    import importlib; importlib.reload(modulename)

### Packages

A (regular) [package] is a module that may contain submodules or
subpackages, technically a module with a `__path__` attribute. These
are usually created via `import` from a directory containing an
`__init__.py` file or any `*.{py,pyc,so,pyd}` files. Importing a
directory without any of these creates a [namespace package] (unless
other same-named dirs later in the path contain such files).

### Module Attributes

    __name__        # module name; '__main__' if top module (`python foo.py`)
    __file__        # full path to .py file, if created from a file
    __path__        # _NamespacePath with full path to dir, if namespace module


The [Import Statement][istmt]
-----------------------------

`import` is a runtime directive that creates a module. (Thus, if in a
function, `if` statement, etc., it will not be executed until the code
is run.)

    import a.b              # Import all definitions into namespace a.b
    from a.b import f, g    # import definitions into current namespace
    from a.b import *       # imports all not starting with `_`
                            # (may hide existing definitions)

`import` searches `sys.path` for directories and files from which to
build modules. Symlinks are dereferenced before calculating names and
paths.

Writable paths may have `__pycache__` directories created with the
compiled code (`cpython-34.pyc`, machine-portable) underneath, if the
"source" was not already compiled code.


Further Documentation
---------------------

* The Python Language Reference section [The import system][isys] goes
  into the gory details of how imports work and how to replace the
  import system with your own.
* [PEP 451] (included in Python 3.4) has more gory details.



[istmt]: https://docs.python.org/3/reference/simple_stmts.html#import
[isys]: https://docs.python.org/3/reference/import.html
[modules]: https://docs.python.org/3/tutorial/modules.html
[package]: https://docs.python.org/3/glossary.html#term-package
[namespace package]: https://www.python.org/dev/peps/pep-0420/
[PEP 451]: https://www.python.org/dev/peps/pep-0451/
