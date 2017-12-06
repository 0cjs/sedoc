The Python Import/Module System
===============================

Handy commands:

    # Show import path python is using
    python -c 'import sys, pprint; pprint.pprint(sys.path)'

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


[Import-related Libraries][implibs]
-----------------------------------

[`importlib`] replaced the deprecated [`imp`] library in 3.4.

#### [Replacing `imp.load_source`][so-34import]

    from importlib.util import spec_from_loader
    from importlib.machinery import SourceFileLoader

    spec = spec_from_loader("foobar",
        SourceFileLoader("foobar", "/path/to/foobar"))
    foobar = module_from_spec(spec)
    spec.loader.exec_module(foobar)

    # To keep importing by name after first load:
    sys.modules['foobar'] = foobar


Importing from "Unusual" Filenames
----------------------------------

`import` needs an identifier to which to bind the module it creates
and also generates the name of the file to read from this. Thus, files
to be imported with `import` must end with `.py` and not otherwise
have any characters not valid in a Python identifier. This makes
loading files designed for use as scripts (e.g., `git-mything`)
unloadable as modules with this mechanism.

There are several solutions ([so-impname1], [so-impname2]) other than
renaming the file:

1. Instead of creating a module, just execute it in the local
   namespace (adding its definitions) with `exec(open(PATH).read())`.

2. Create a symlink to the file with a better name.

3. Create the module separately from binding a variable to it,
   possibly in an import proxy module:

      gitmything.py:
          #   XXX not clear how this handles paths

          #   Solution 1:
          tmp = __import__('git-mything')
          globals().update(vars(tmp))

          #   Solution 2:
          sys.modules['gitmything'] = __import__('git-mything')

          #   Solution 3:

      main.py:
          #   Solution 1/2:
          from gitmything import *

          #   Solution 3:
          import importlib
          mod = importlib.import_module("path.to.my-module")


Further Documentation
---------------------

* The Python Language Reference section [The import system][isys] goes
  into the gory details of how imports work and how to replace the
  import system with your own.
* [PEP 451] (included in Python 3.4) has more gory details.



[PEP 451]: https://www.python.org/dev/peps/pep-0451/
[`imp`]: https://docs.python.org/3/library/imp.html
[`importlib`]: https://docs.python.org/3/library/importlib.html
[implibs]: https://docs.python.org/3/library/modules.html
[istmt]: https://docs.python.org/3/reference/simple_stmts.html#import
[isys]: https://docs.python.org/3/reference/import.html
[modules]: https://docs.python.org/3/tutorial/modules.html
[namespace package]: https://www.python.org/dev/peps/pep-0420/
[package]: https://docs.python.org/3/glossary.html#term-package
[so-34import]: https://stackoverflow.com/a/43602645/107294
[so-impname1]: https://stackoverflow.com/q/8350853/107294
[so-impname2]: https://stackoverflow.com/a/24659400/107294
