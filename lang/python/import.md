The Python Import/Module System
===============================

This and [importers] summarize [the import system reference
documentation][isys] among other sources.

#### Handy commands

    # Show import path python is using
    python -c 'import sys, pprint; pprint.pprint(sys.path)'

    # Show source used to create a particular module
    python -c 'import foo; print(foo.__file__)'


import Statement Syntax
-----------------------

[import][istmt] is a runtime directive that creates a module and
binds it to a name. (Any parent modules/packages in the hierarchy will
also be created.) Thus, in a function, if statement, etc.,
import will not be executed until the code is run.

See [PEP 328] for more on multi-line import syntax and relative import
design.

    #   Loads below are done only if not already loaded.
    #   Bindings are in current namespace.
    import a.b              # Load a; bind a; load b; bind b.
    import a.b.c as c       # Load a, b, c; bind only c.

    a = __import__('a.b.c')                 # Programatic imports
    c = importlib.import_module('a.b.c')    # need explicit binding.

    #   from can import definitions or submodules
    from a.b import f, g    # bind f, g into current namespace
    from a.b import (h, j)  # can use parens for multilines without backslash

    #   At the module level only (not in classes or functions), binds
    #   definitions listed in `a.b.__all__` or, if not present, all defs
    #   not starting with `_`. May shadow existing bindings in the importer.
    from a.b import *

    #   Relative imports can only be done with non-* form of from
    #   Intra-package references are based on name of current module.
    from . import foo
    from .. import bar
    from ..bar import baz

Intra-package references can be used from `__main__` only under
certain circumstances; see [PEP 366].

Import statements result in bytecode that calls
[`builtins.__import__`][] (which returns the top-level module
imported) to perform module creation/load followed by code to do the
name binding. This should generally not be used directly:
1. For programmatic importing use the techniques below.
2. `builtins.__import__` may be bound to a user-defined function to
   change the behaviour of the syntactic `import` statement, but this
   is strongly discouraged; instead use import hooks (see ["Module
   Loading and Importers"](#module-loading-and-importers) below and
   the [importers] document).

#### Programmatic Importing

* [importlib.import_module(name, package=None)][import_module()]
  imports the named module (loading it if necessary) and returns it.
  (The return value is different from `__import__()`.)
* [importlib.util.find_spec(name, package=None)][find_spec()]
  returns a spec or None if the module _name_ is not found. The spec
  ([importlib.machinery.ModuleSpec]) includes the name, loader,
  etc.; for more see below.

To load the a module from a spec:

    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    sys.modules[name] = module

To directly import a source file (≥3.5):

    spec = importlib.util.spec_from_file_location(module_name, file_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    sys.modules[module_name] = module   # Optional

[so-import-as-main] discusses how to load a module from a given path
with a different module name assigned (e.g., `__main__`) but uses a
deprecated API. It's not clear how to do this with the current API,
but as of 3.7 the old imp interface still works.

#### Deprecated Interfaces

The imp module (access to import internals) has been deprecated
since Python 3.4; use importlib instead. import imp generates a
DeprecationWarning in CPython ≥ 3.6.


Modules
-------

Terminology note: the module system uses search paths that are lists
of filesystem paths or other locations. Below we call search paths
just 'paths' and filesystem paths 'locations'.

[Modules][modules] are objects of type [types.ModuleType] that
encapsulate a namespace containing arbitrary Python objects (typically
classes and functions). They're usually created by loading a .py
file with the import statement (see below). A module's symbol table,
accessed with the [globals()] function, is global to functions
defined within the module, but must be qualified for code outside it.

    import a.b.c    # Create module a.b.c
                    # from a/b/c/ or a/b/c.py somewhere in sys.path
    a.b.c           # => <module 'a.b.c' from '.../a/b/c.py'>
    a.b.c.f         # => <function a.b.c.f>
    a.b.c.f()       # calls f() from that module
    f = a.b.c.f     # Assign f to a local name

The name of a module is defined by the location used to import it, and
is available as `__name__` (and maybe`__spec__.name`).

A module with a given name is loaded/created once per interpreter
instance (barring manipulation of sys.modules; see below) unless you
use:

    import importlib; importlib.reload(modulename)

The files containing the code that is executed to build the module
object are usually referred to as "modules" (even in the [modules]
tutorial) even though, if the same file is loaded via two different
locations in $PYTHONPATH, you can end up with two different modules:

    PYTHONPATH=a:. ipython
    import b.c
    b.c                 ⇒ <module 'b.c' from './a/b/c.py'>
    import a.b.c
    a.b.c               ⇒ <module 'a.b.c' from './a/b/c.py'>
    a.b.c is b.c        ⇒ False

### Packages

A [package] is a module that can contain submodules and/or
subpackages. (Non-package modules cannot do this.) Packages always
have a [`__path__`] attribute which a list of locations (usually of
filesystem paths); this, rather than sys.path is used to search for
submodules.

Packages come in two types.

#### Regular Packages

[Regular packages] are usually created from a directory containing an
`__init__.py` file. This can be empty (which simply identifies the
directory as a package), or it can contain initialisation code.

If the initialization code sets `__all__,` this is the list of
submodules that will be imported by `from pkg import *`. If`__all__`
is not set, `import *` will not search for subpackages but merely load
the main package (and, consequently, anything it loads explicitly).

Once a regular package has been found on the search path, only that
package's `__path__` list (default: a single location that is the
directory containing `__init__.py`) will be used to search for
submodules. Thus, submodules not in the original but in same-named
package dirs further down sys.path will not be found unless the
first package's `__path__` is explicitly modified. (This is the reason
for having namespace packages, below.)

#### Namespace Packages

[Namespace packages], described in [PEP 420], serve only as a
container for subpackages or submodules. A namespace package may have
no representation on disk at all, or, if it does, it may be just one
or more directories (without `__init__.py` files) or other objects,
known as _[portions]_, each of which contributes subpackages.

The `__path__` attribute of a namespace package is not a regular list
but instead a custom iterable that can perform a new search for
portions if sys.path or a parent path changes.

Also see [so-27586272](https://stackoverflow.com/a/27586272/107294).

#### Example

Given a/b/c.py in sys.path (and no other files under a/):

    import a
    a                ⇒ <module 'a' (namespace)>
    a.b              ⇒ AttributeError: module 'a' has no attribute 'b'
    import a.b.c
    a.b              ⇒ <module 'a.b' (namespace)>
    a.b.c            ⇒ <module 'a.b.c' from '/home/cjs/a/b/c.py'>

However, if you add the file a/b.py to the above, or under any other
directory in sys.path:

    import a.b.c
    ⇒ ImportError: No module named 'a.b.c'; 'a.b' is not a package

The default loader for namespace packages doesn't support [PEP 302]'s
[ResourceLoader.get_data()] function, and so [pkgutil.get_data()]
will always return None. A workaround for this is to add an empty
`__init__.py` file to the package directory to convert it to a regular
package.

### Module Attributes

Modules have the [following attributes][modattr]:

    __name__        # Module name; '__main__' if top module (python foo.py)
    __loader__      # Loader used to load this package, e.g.,
                    #    _frozen_importlib_external._NamespaceLoader
                    #    _frozen_importlib_external.SourceFileLoader
    __package__     # Empty str for top-level  modules.
                    #    Same as __name__ for package modules (PEP 366).
                    #    Otherwise parent module (== __spec__.parent).
    __spec__        # (>=3.4) PEP 451 module load/import information. Older
                    #    individual attributes below are generally the same.
    __path__        # An iterable of strs representing locations. For regular
                    #    For regular packages, initialized to a list containing
                    #    the location of the module dir.
                    #    For namespace packages, a _NamespacePath with
                    #    locations of all portions.
    __file__        # Optional; usually full path to .py file.
    __cached__      # Optional; path to compiled version of code
                    #    (which need not be actually present).

There's nothing in particular synchronizing `__spec__` and the related
individual module attributes. A notable exception to them being the
same is when a non-package module is run with `-m`; `module.__name__`
will be `__main__` but `module.__spec__.name` will be the actual
module name.

For more details, see [importers].


The `__main__` Module
---------------------

The "top-level" module in which the interpreter starts is always named
[`__main__`]. More precisely, the `__name__` attribute will always be
`__main__`, although `__spec__`.name may be different (see above).
This is what allows the standard "start when run but not when
imported" boilerplate:

    if __name__ == '__main__':
        main()

The possible ways to start the interpreter are as follows.`__name__`
in that starting module will always `__main__`.

1. __python …/foo.py__:
   - Loads file `…/foo.py` from whatever path was specified.
   - The directory in which `foo.py` lives will be added to`sys.path`.
   - `sys.path` will _not_ include the current working directory.
   - `__spec__` will be None.
2. __python -m bar__ where bar is not a package:
   - Loads file `bar.py` from the Python path.
   - sys.path will include the current working directory.
   - `__spec__`.name will be bar.
3. __python -m baz__ where baz is a package:
   - Loads file `baz/__main__.py` from the Python path or prints  
     `python: No module named baz.__main__; 'baz' is a package and
     cannot be directly executed.`
   - `sys.path` will include the current working directory.
   - `__spec__.name` will be `baz`.

A `baz.__main__` module should normally still use the standard if
`__name__ == '__main__'` technique to avoid running main program code
when it's imported with `import baz.__main__` (in which case its
`__name__` attribute will be the fully qualified name,
`baz.__main__`). This allows unit testing of code in that module.


Module Loading and Importers
-----------------------------

Modules are loaded only after their parent package modules are loaded.
The following [search] process will be followed first for the
highest-level not-yet-loaded module in the full module name and then
for child modules.

Modules are first looked up in the module cache, sys.modules, which
contains all explicitly and automatically loaded modules. (Thus,
import a.b.c will insert a, a.b and a.b.c into the cache if
a had not been previously loaded.) The cache is writable so deleting
a key or setting its value to None will force module creation anew
on next import, though other modules will still have references to the
old module object. (Use [importlib.reload()] to have the existing
module object reloaded.)

If a module isn't in the cache, the [import protocol][importers] is
invoked. See that document for the details. (And also for how to add
your own importers.)


Importing from "Unusual" Filenames
----------------------------------

import needs an identifier to which to bind the module it creates
and also generates the name of the file to read from this. Thus, files
to be imported with import must end with .py and not otherwise
have any characters not valid in a Python identifier. This makes
loading files designed for use as scripts (e.g., git-mything)
unloadable as modules with this mechanism.

There are several solutions ([so 8350853], [so 24659400]) other than
renaming the file:

1. Instead of creating a module, just execute it in the local
   namespace (adding its definitions) with exec(open(PATH).read()).

2. Create a symlink to the file with a better name.

3. Create the module separately from binding a variable to it,
   possibly in an import proxy module:

   gitmything.py:

       #   XXX not clear how this handles paths
       #   XXX These must use importlib.import_module if . in name.

       #   Solution 1:
       tmp = __import__('git-mything')
       globals().update(vars(tmp))

       #   Solution 2:
       sys.modules['gitmything'] = __import__('git-mything')

   main.py:

       #   Solution 1/2:
       from gitmything import *

       #   Solution 3:
       import importlib
       mod = importlib.import_module("path.to.my-module")


Other Resources from Packages
-----------------------------

Packages may provide arbitrary resources (which are like—and may even
be—files) from a resource container (like a directory). These are loaded
via [`importlib.resources`] since 3.6, but due to changes to that API over
time it's better to use the [`importlib_resources`] compatibility package.
For more information on this and examples of use see the [`py-resource-test`]
repo.


Further Documentation
---------------------

* [The Hitchhikers's Guide to Packaging][hhgtp] provides guidelines on
  how to lay out Python projects with packaging metadata and create
  distributable packages for them. This may not be up to date with
  modern versions of Python and libraries.



<!-------------------------------------------------------------------->
[PEP 302]: https://www.python.org/dev/peps/pep-0302/
[PEP 328]: https://www.python.org/dev/peps/pep-0328/
[PEP 366]: https://www.python.org/dev/peps/pep-0366/
[PEP 420]: https://www.python.org/dev/peps/pep-0420/
[ResourceLoader.get_data()]: https://docs.python.org/3/library/importlib.html#importlib.abc.ResourceLoader.get_data
[`__import__`]: https://docs.python.org/3/library/functions.html#__import__
[`__main__`]: https://docs.python.org/3/library/__main__.html
[`__path__`]: https://docs.python.org/3/reference/import.html#__path__
[`importlib.resources`]: https://docs.python.org/3.11/library/importlib.resources.html
[`importlib_resources`]: https://pypi.org/project/importlib-resources/
[`py-resource-test`]: https://github.com/cynic-net/py-resource-test
[factory functions]: https://www.python.org/dev/peps/pep-0451/#factory-functions
[find_spec()]: https://docs.python.org/3/library/importlib.html?highlight=import_module#importlib.util.find_spec
[globals()]: https://docs.python.org/3/library/functions.html#globals
[hhgtp]: https://the-hitchhikers-guide-to-packaging.readthedocs.io/en/latest/
[import_module()]: https://docs.python.org/3/library/importlib.html#importlib.import_module
[importers]: importers.md
[importlib.machinery.ModuleSpec]: https://docs.python.org/3/library/importlib.html#importlib.machinery.ModuleSpec
[importlib.reload()]: https://docs.python.org/3/library/importlib.html#importlib.reload
[istmt]: https://docs.python.org/3/reference/simple_stmts.html#import
[isys]: https://docs.python.org/3/reference/import.html
[modattr]: https://docs.python.org/3/reference/import.html#import-related-module-attributes
[modules]: https://docs.python.org/3/tutorial/modules.html
[namespace packages]: https://docs.python.org/3/glossary.html#term-namespace-package
[package]: https://docs.python.org/3/glossary.html#term-package
[pkgutil.get_data()]: https://docs.python.org/3/library/pkgutil.html?highlight=get_data
[portions]: https://docs.python.org/3/glossary.html#term-portion
[regular packages]: https://docs.python.org/3/glossary.html#term-regular-package
[search]: https://docs.python.org/3/reference/import.html#searching
[so 24659400]: https://stackoverflow.com/a/24659400/107294
[so 8350853]: https://stackoverflow.com/q/8350853/107294
[so-import-as-main]: https://stackoverflow.com/a/6114411/107294
[types.ModuleType]: https://docs.python.org/3/library/types.html#types.ModuleType
