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
    a.b.c           # => <module 'a.b.c' from '.../a/b/c.py'>
    a.b.c.f         # => <function a.b.c.f>
    a.b.c.f()       # calls f() from that module
    f = a.b.c.f     # Assign f to a local name

The name of a module is defined by the path used to import it, and is
available as `__name__`.

Modules are loaded once per interpreter instance unless you use:

    import importlib; importlib.reload(modulename)

The files containing the code that is executed to build the module
object are usually referred to as "modules" (even in the [modules]
tutorial) even though, if the same file is loaded via two different
paths in `$PYTHONPATH`, you can end up with two different modules:

    PYTHONPATH=a:. ipython
    import b.c
    b.c                 ⇒ <module 'b.c' from '/home/cjs/play/pyimp/a/b/c.py'>
    import a.b.c
    a.b.c               ⇒ <module 'a.b.c' from '/home/cjs/play/pyimp/a/b/c.py'>
    a.b.c is b.c        ⇒ False

### Packages

A [package] is a [module] that can contain submodules and/or
subpackages. (Non-package modules cannot do this.) Packages always
have a `__path__` attribute. Packages come in two types.

##### [Regular Package]s

[Regular package]s are usually created from a directory containing an
`__init__.py` file. This can be empty (which simply identifies the
directory as a package), or it can contain initialiation code or set
`__all__`, which can be a list of submodule names to be imported with
`from pkg import *`; without this submodules will not be loaded.

##### [Namespace Package]s

Described in [PEP 420], these serve only as a container for subpackages
or submodules and have no physical representation beyond a directory
on the disk. (In particular, they have no `__init__.py` file.)

Given `a/b/c.py` in `sys.path` (and no other files under `a/`):

    import a
    a                ⇒ <module 'a' (namespace)>
    a.b              ⇒ AttributeError: module 'a' has no attribute 'b'
    import a.b.c
    a.b              ⇒ <module 'a.b' (namespace)>
    a.b.c            ⇒ <module 'a.b.c' from '/home/cjs/a/b/c.py'>

However, if you add the file `a/b.py` to the above, or under any other
directory in `sys.path`:

    import a.b.c
    ⇒ ImportError: No module named 'a.b.c'; 'a.b' is not a package

### Module Attributes

    __name__        # module name; '__main__' if top module (`python foo.py`)
    __file__        # full path to .py file, if created from a file
    __path__        # Dir containing `__init.py__` (set before execing it) or
                    # _NamespacePath with full path to dir, if namespace package
    __loader__      # Loader used to load this package, e.g.,
                    #    _frozen_importlib_external._NamespaceLoader
                    #    _frozen_importlib_external.SourceFileLoader


The [Import Statement][istmt]
-----------------------------

`import` is a runtime directive that creates a module. (Thus, if in a
function, `if` statement, etc., it will not be executed until the code
is run.)

    import a.b              # Import all definitions into namespace a.b
    from a.b import f, g    # import definitions into current namespace
    from a.b import *       # imports `__all__` if present, otherwise all defs
                            # not starting with `_` (may hide existing defs)
    from . import foo       # Intra-package references are based on name
    from .. import bar      # of current module and thus cannot be used
    from ..bar import baz   # in `__main__`.

`import` searches `sys.path` for directories and files from which to
build modules. Symlinks are dereferenced before calculating names and
paths. The default `sys.path` includes the directory containing the
input script (or current directory if no file specified), the
`$PYTHONPATH` environment variable paths and installation-dependent
defaults.

Writable paths may have `__pycache__` directories created with the
["compiled"] code (`cpython-34.pyc`, machine-portable) underneath, if
the "source" was not already compiled code. Compiled files will be
read from directories that contain no source.

As well as directories, ZIP files containing source code or compiled
source code (not binary shared libs) may be specified in the path.


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
* [PEP 451] (included in Python 3.4) has more gory details. [The
* Hitchhikers's Guide to Packaging][hhgtp] provides guidelines on
  how to lay out Python projects with packaging metadata and create
  distributable packages for them. This may not be up to date with
  modern versions of Python and libraries.



["compiled"]: https://docs.python.org/3/tutorial/modules.html#compiled-python-files
[PEP 420]: https://www.python.org/dev/peps/pep-0420/
[PEP 451]: https://www.python.org/dev/peps/pep-0451/
[`imp`]: https://docs.python.org/3/library/imp.html
[`importlib`]: https://docs.python.org/3/library/importlib.html
[hhgtp]: https://the-hitchhikers-guide-to-packaging.readthedocs.io/en/latest/
[implibs]: https://docs.python.org/3/library/modules.html
[istmt]: https://docs.python.org/3/reference/simple_stmts.html#import
[isys]: https://docs.python.org/3/reference/import.html
[modules]: https://docs.python.org/3/tutorial/modules.html
[namespace package]: https://docs.python.org/3/glossary.html#term-namespace-package
[package]: https://docs.python.org/3/glossary.html#term-package
[regular package]: https://docs.python.org/3/glossary.html#term-regular-package
[so-34import]: https://stackoverflow.com/a/43602645/107294
[so-impname1]: https://stackoverflow.com/q/8350853/107294
[so-impname2]: https://stackoverflow.com/a/24659400/107294
