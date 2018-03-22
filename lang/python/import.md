The Python Import/Module System
===============================

Handy commands:

    # Show import path python is using
    python -c 'import sys, pprint; pprint.pprint(sys.path)'

    # Show source used to create a particular module
    python -c 'import foo; print(foo.__file__)'


`import` Statement Syntax
-------------------------

[`import`][istmt] is a runtime directive that creates a module. (Any parent
modules/packages in the hierarchy will also be created.) Thus, if in a
function, `if` statement, etc., `import` will not be executed until
the code is run. Also see [PEP 328] for the multi-line and relative
import design.

    import a.b              # bind module to `a.b` in current namespace
    import a.b.c as c

    #   `from` can import definitions or submodules
    from a.b import f, g    # import definitions into current namespace
    from a.b import (h, j)  # can use parens for multilines without backslash

    #   At the module level only (not in classes or functions, this
    #   imports `__all__` if present in that module's globals, otherwise
    #   all defs not starting with `_`. It may hide defs in the importer.
    from a.b import *

    #   Relative imports can only be done with non-* form of `from`
    #   Intra-package references are based on name of current module.
    from . import foo
    from .. import bar
    from ..bar import baz

Intra-package references can be used from `__main__` only under
certain circumstances; see [PEP 366].

Import statements result in bytecode that calls [`__import__`]. For
programmatic importing You should use [`importlib.import_module()`]
instead.


Modules
--------

[Modules][modules] are objects of type `builtins.module`) that
encapsulate a namespace containing arbitrary Python objects (typically
classes and functions). They're usually created by loading a `.py`
file with the `import` statement (see below). A module's symbol table,
accessed with the [`globals()`] function, is global to functions
defined within the module, but must be qualified for code outside it.

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
    b.c                 ⇒ <module 'b.c' from './a/b/c.py'>
    import a.b.c
    a.b.c               ⇒ <module 'a.b.c' from './a/b/c.py'>
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

Importers
---------

[PEP 302] describes the 2.3 import system. That's described below but
isn't entirely correct for 3.3.

XXX Now see [`finder`] and work from there (esp. [PEP 420] and [PEP 451]).

#### Importer Protocol

Importers consist of two objects, a _finder_ and a _loader_.

The finder has a `find_module(self, fullname, path=None)` method
called with the fully qualified name of the module and, if on
`sys.meta_path`, a `path` of `None` for top-level modules or
`package.__path__` for submodules. It returns a loader or `None` if
the module was not found. The loader may be `self`.

The loader has a `load_module(fullname)` method that returns the
loaded module or throws `ImportError`. It (unlike the finder) can
depend on parents having been imported and existing in `sys.modules`,
e.g., when `load_module('foo.bar.baz')` is called `foo` and `foo.bar`
are already imported.

The loader must:
1. Check for `sys.modules[fullname]` and use that if it exists so that
   `reload()` works correctly.
2. Before doing any importing, create `sys.modules[fullname]` if it
   doesn't exist, 
3. Remove `sys.modules[fullname]` if it did the insertion and the
   import failed, otherwise leave it alone.
4. Set the following attributes: `__loader__` (to itself), `__name__`,
   `__file__`, `__package__` (see [PEP 366]).
5. Set `__path__` if the module is a package. This must be a list,
   but may be empty if the importer won't use it later.
6. Execute the module's code (if a Python module) in its global
   namespace (`module.__dict__`).

[`importlib.util.module_for_loader()`] will handle many of these
details.

#### Importer Hooks

Python has two lists of hooks queried in order to find an importer.

1. `sys.meta_path` is a list of objects with `find_module()` methods.
   These are queried before any other importers (including frozen and
   built-in) are checked and so can override any other import
   processing.

2. `sys.path_hooks` is a list of [callable]s accepting a single path
   item and returning either an importer object (with a
   `load_module()` attribute) or raising `ImportError`. Once an
   importer has been returned for a path that importer will always be
   used for that entry.

The paths that will be checked with the `sys.path_hooks` functions
include not only `sys.path` but also paths for individual packages.
(XXX fill in more about this here or throughout document.)

#### XXX todo

XXX \[from PEP 302]: The built-in `__import__` function (known as
PyImport_ImportModuleEx() in import.c) will then check to see whether
the module doing the import is a package or a submodule of a package.
If it is indeed a (submodule of a) package, it first tries to do the
import relative to the package (the parent package for a submodule).
For example, if a package named "spam" does "import eggs", it will
first look for a module named "spam.eggs". If that fails, the import
continues as an absolute import

#### XXX more todo

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
[PEP 302]: https://www.python.org/dev/peps/pep-0302/
[PEP 328]: https://www.python.org/dev/peps/pep-0328/
[PEP 366]: https://www.python.org/dev/peps/pep-0366/
[PEP 420]: https://www.python.org/dev/peps/pep-0420/
[PEP 451]: https://www.python.org/dev/peps/pep-0451/
[`__import__`]: https://docs.python.org/3/library/functions.html#__import__
[`finder`]: https://docs.python.org/3/glossary.html#term-finder
[`globals()`]: https://docs.python.org/3/library/functions.html#globals
[`imp`]: https://docs.python.org/3/library/imp.html
[`importlib.import_module()`]: https://docs.python.org/3/library/importlib.html#importlib.import_module
[`importlib.util.module_for_loader()`]: https://docs.python.org/3/library/importlib.html#importlib.util.module_for_loader
[`importlib`]: https://docs.python.org/3/library/importlib.html
[callable]: functions.md
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
