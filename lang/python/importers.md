Python Importers and Hooks
==========================

The primary description of the import system is the [reference
documentation][isys]. This more accurately describes the current
system than either of the PEPs below, and should probably be read
first.

[PEP 302 "New Import Hooks"][PEP 302] describes the import system
introduced in Python 2.3. This was heavily modified (with backward
compatability retained) by [PEP 451 "A ModuleSpec Type for the Import
System"][PEP 451] (Python 3.4), but much documentation still
references only the (now not entirely accurate) PEP 302.

The [`importlib`] library implements the above and documents some
further details.

[Hacking Python without hacking Python][hpwhp] gives an example of the
use of import hooks to do transformation on code (e.g., on the AST) as
you load it.


Importer Protocol
-----------------

An importer builds modules, usually including loading Python code from
some location. It consists of two logically distinct objects: the
_[finder]_ which identifies the loader to use (and sometimes other
information) and the _[loader]_ which actually does the loading. In
PEP 451 loading the finder creates a _[spec]_ which includes the
loader along with additional information.

### Finders

Finder objects are normally added to `sys.meta_path` and/or
`sys.path_hooks` (see below).

#### PEP 302

The [finder interface][PEP 302 finder] of [PEP 302]  (deprecated since
3.3) has a `find_module(fullname, path=None)` method taking the fully
qualified (dotted) name of the module and a _path_ argument of `None`
for a top-level module or the parent module's `package.__path__` for
submodules. It returns the loader. If no loader is found, it returns
`None` or, before Python 3.4, raises [`NotImplementedError`].

It appears that [PEP 302 finders may also return `(None,
portions)`][PEP 302 namespace] to indicate part of a possible
namespace package. XXX Find further docs on this.

#### PEP 451

The [finder interface][PEP 451 finder]  of [PEP 451] \(often
`importlib.abc`'s [`MetaPathFinder`] or [`PathEntryFinder`]) has a
`find_spec(fullname, path, target=None)` method taking the name and
path as above and an optional _[target]_ module object used if
reloading. It returns the [`ModuleSpec`] for the module (which
includes the loader) or `None` if no loader was found (or no loader
that could reload into _target_).

PEP 451 finders may cache data related to module searches; if so they
can be invalidated with their `invalidate_caches()` method. If the
finder has no caches this returns `None` or, before Python 3.4,
`NotImplemented`.

For backwards compatibility, `importlib.abc.MetaPathFinder` and
`PathEntryFinder` implement a `find_module` method that returns the
loader in the spec returned by `find_spec`. (Having specs implement
the loader interface was considered an unnecessary complication.)

Python 3.4 and above offer some [factory
functions][`spec_from_loader()`], `spec_from_file_location` and
`spec_from_loader`, to help build specs.


### Loaders

Loaders (unlike finders) can depend on parents having been imported
and existing in `sys.modules`, e.g., when `load_module('foo.bar.baz')`
is called `foo` and `foo.bar` are already imported.

#### PEP 302

The [loader interface][PEP 302 loader]  of [PEP 302] has a
`load_module(fullname)` method that returns the loaded module or
raises an exception, usually `ImportError` if no other exception is
being propagated. `load_module` is responsible for some significant
work (see the link above and the [PEP 451 loader] description)
including various kinds of validation and setup. Methods in the
[Python 2 import libraries][py2imp] and Python 3 [`importlib.util`]
\(particularly [`importlib.util.module_for_loader()`] are designed to
help with this.

#### PEP 451

A [PEP 451] loader has an `exec_module(module)` method that, given a
module object, executes the module code within it to finish building
(or reloading) the module. It must handle being called more than once
on the same module object, though may do this by throwing
`ImportError` on calls after the first.

These loaders also have a `create_module(spec)` method that can create
and return the new module object to be passed to `exec_module`. If it
it returns `None` the import system will create the module object
itself in the default way.

Neither of these should set any import-related attributes on the
module.

The [PEP 420] `module_repr()` method is deprecated but if it exists
on a loader it will be used exclusively.


Module Search and Load Process
------------------------------

Modules are loaded only after their parent package modules are loaded.
The following [search process] will be followed first for the
highest-level unloaded module in the full module name and then for
each immediate child module.

Modules are first looked up in the module cache, `sys.modules`, which
contains all explicitly and automatically loaded modules. (Thus,
`import a.b.c` will insert `a`, `a.b` and `a.b.c` into the cache if
`a` had not been previously loaded.) The cache is writable so deleting
a key or setting its value to `None` will force module creation anew
on next import, though other modules will still have references to the
old module object. (Use [`importlib.reload()`] to have the existing
module object reloaded.)

If a module must be loaded, the interpreter searches:
1. The finders in [`sys.meta_path`]
2. The path of the parent package via its loader.
3. `sys.path` if there is no parent package.

Since Python 3.3, steps 2 and 3 are taken care of by finders
pre-installed on `sys.meta_path`. (Before that `sys.meta_path` was
empty by default and the steps were built in to the interpreter.)

### Meta-path Searches

During a [meta-path search][metapath], the interpreter walks through
the list of meta-path finder objects in [`sys.meta_path`], calling the
`find_spec()` method on each or, if not present, `find_module()`.

The interface is documented in the [importlib.abc.MetaPathFinder]
abstract base class. These are queried before any other importers
(including frozen and built-in) are checked and so can override any
other import processing.

If all meta-path finders fail to return a spec (or loader), the load
fails (since Python 3.4, where the path search is done by explicit
meta-path finders) or (below 3.4) the interpreter moves on to an
internal implementation of the path search. The path search is the
same either way.

### Path Searches

The search path is `sys.path` for top-level modules or the parent
module's `__path__` for child modules. In either case it consists of
an iterable of strings representing _locations_.

For each location in turn, a finder for that location (if any) is
queried by calling its `find_spec()` method or, if not present,
`find_module()`. If that finder returns a spec (or loader), it is
used, otherwise the search moves on to the next location in the path.

To get the finder, the location is first looked up in the
[`sys.path_importer_cache`] dictionary. If the key is present the
value is either a finder that is used or `None` in which case the
import fails because previous searches for a finder for this location
failed.
   
If the key is not found, the location is passed in turn to each hook
(a callable object) in [`sys.path_hooks`]. The first hook that returns
a finder rather than throwing `ImportError` is stored in the cache. If
no hook returns a finder, `None` is stored in the cache.


Import-related Libraries
------------------------

Various import-related libraries are listed in [Importing
Modules][implibs] in the standard library documentation.

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


XXX To-do
---------

XXX Bring into this doc a glossary? E.g.,
<https://www.python.org/dev/peps/pep-0451/#terms-and-concepts>

XXX \[from PEP 302]: The built-in [`__import__`] function (known as
PyImport_ImportModuleEx() in import.c) will then check to see whether
the module doing the import is a package or a submodule of a package.
If it is indeed a (submodule of a) package, it first tries to do the
import relative to the package (the parent package for a submodule).
For example, if a package named "spam" does "import eggs", it will
first look for a module named "spam.eggs". If that fails, the import
continues as an absolute import

XXX `import` searches `sys.path` for directories and files from which
to build modules. Symlinks are dereferenced before calculating names
and paths. The default `sys.path` includes the directory containing
the input script (or current directory if no file specified), the
`$PYTHONPATH` environment variable paths and installation-dependent
defaults.

XXX Writable paths may have `__pycache__` directories created with the
["compiled"] code (`cpython-34.pyc`, machine-portable) underneath, if
the "source" was not already compiled code. Compiled files will be
read from directories that contain no source.

XXX As well as directories, ZIP files containing source code or
compiled source code (not binary shared libs) may be specified in the
path.



<!-------------------------------------------------------------------->
["compiled"]: https://docs.python.org/3/tutorial/modules.html#compiled-python-files
[PEP 302 finder]: https://docs.python.org/3/library/importlib.html#importlib.abc.Finder
[PEP 302 loader]: https://www.python.org/dev/peps/pep-0302/#specification-part-1-the-importer-protocol
[PEP 302 namespace]: https://www.python.org/dev/peps/pep-0451/#namespace-packages
[PEP 302]: https://www.python.org/dev/peps/pep-0302/
[PEP 420]: https://www.python.org/dev/peps/pep-0420
[PEP 451 finder]: https://www.python.org/dev/peps/pep-0451/#finders
[PEP 451 loader]: https://www.python.org/dev/peps/pep-0451/#loader
[PEP 451]: https://www.python.org/dev/peps/pep-0451/
[`MetaPathFinder`]: https://docs.python.org/3/library/importlib.html#importlib.abc.MetaPathFinder
[`ModuleSpec`]: https://docs.python.org/3/library/importlib.html#importlib.machinery.ModuleSpec
[`NotImplementedError`]: https://docs.python.org/3/library/exceptions.html#NotImplementedError
[`PathEntryFinder`]: https://docs.python.org/3/library/importlib.html#importlib.abc.PathEntryFinder
[`__import__`]: https://docs.python.org/3/library/functions.html#__import__
[`imp`]: https://docs.python.org/3/library/imp.html
[`importlib.reload()`]: https://docs.python.org/3/library/importlib.html#importlib.reload
[`importlib.util.module_for_loader()`]: https://docs.python.org/3/library/importlib.html#importlib.util.module_for_loader
[`importlib.util`]: https://docs.python.org/3/library/importlib.html?highlight=importlib#module-importlib.util
[`importlib`]: https://docs.python.org/3/library/importlib.html
[`spec_from_loader()`]: https://docs.python.org/3/library/importlib.html#importlib.util.spec_from_loader
[`sys.meta_path`]: https://docs.python.org/3/library/sys.html#sys.meta_path
[`sys.path_hooks`]: https://docs.python.org/3/library/sys.html#sys.path_hooks
[`sys.path_importer_cache`]: https://docs.python.org/3/library/sys.html#sys.path_importer_cache
[callable]: functions.md
[finder]: https://docs.python.org/3/glossary.html#term-finder
[hpwhp]: https://stupidpythonideas.blogspot.jp/2015/06/hacking-python-without-hacking-python.html
[implibs]: https://docs.python.org/3/library/modules.html
[importlib.abc.MetaPathFinder]: https://docs.python.org/3/library/importlib.html#importlib.abc.MetaPathFinder
[isys]: https://docs.python.org/3/reference/import.html
[loader]: https://docs.python.org/3/glossary.html#term-loader
[metapath]: https://docs.python.org/3/reference/import.html#the-meta-path
[py2imp]: https://docs.python.org/2/library/modules.html
[search process]: https://docs.python.org/3/reference/import.html#searching
[so-34import]: https://stackoverflow.com/a/43602645/107294
[spec]: https://docs.python.org/3/glossary.html#term-module-spec
[target]: https://www.python.org/dev/peps/pep-0451/#the-target-parameter-of-find-spec
