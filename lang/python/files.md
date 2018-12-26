Python Filesystem and Path Libraries
====================================

Things related to this include:
* [File objects]
* [`os.PathLike`], [PEP 519] \(≥3.6)
* The built-in function [`open()`]
* [File and Directory Access][stdlib-filedir] libraries,
  especially [`pathlib`] and [`os.path`]
* [Generic Operating System Services][stdlib-genos] (`os` and `io`)

Also see [File and Network I/O](io.md).


os.PathLike
-----------

(≥3.6) From [PEP 519], [`os.PathLike`] is an abstract base class for
objects representing a file system path. The abstract method
`__fspath__()` must return a `str` (preferably) or `bytes` object in
the format appropriate for the OS.

Most path-using `os` functions accept a `PathLike` and the
`pathlib.Path` classes implement this interface.

`os.fspath()` returns any `str` or `bytes` parameter and calls
`__fspath__()` on anything else.

On earlier versions of Python, generally you wrap `Path` objects
(below) in a `str()` call.


pathlib and Path classes
------------------------

The [`pathlib`] standard library (≥3.4) offers classes `PurePosixPath`,
`PureWindowsPath`, `PosixPath` and `WindowsPath`. The Pure versions do
not include I/O functionality and can be instantiated on any platform.
The `Path()` and `PurePath()` constructors will instantiate an
appropriate class for the OS on which they're running.

All `Path()` constructors take a list of segments; `.` is the default
if the list is empty. Each segmeent may be a single path component or
multiple components separated by `/`. Windows versions additionally
may have components separated by `\`. Display format always uses `/`.

    >>> PureWindowsPath('c:\\foo\\bar', 'baz/quux')
    PureWindowsPath('c:/foo/bar/baz/quux')

The last segment starting with `/` will be the root of the path;
previous segments are ignored. Extra slashes and `.` components are
removed, but `..` is preserved (because symlinks).

### General Properties and Operators

Paths are immutable and hashable. Same-flavour paths are comparable
and orderable, respecting the OS's case-folding semantics. Different-flavour
(Windows vs. Posix) paths are always unequal and unorderable.

`str(path)` and `bytes(path)` return the OS-native form.

### Attributes and Methods

#### PurePath

Attributes:
* `parts`: Tuple of components
* `root`: Local or global root, if any, in OS format (e.g., `/`, `\\`)
* `drive`: Drive letter or name, if any (e.g., `c:`)
* `anchor`: Concatenation of drive and root, in OS format
* `parent`: A `Path` representing the immediate parent
* `parents`: A sequence of `Path`s representing ancestor paths (purely
   lexical; parent of `foo/..` is `foo`)
* `name`: Final path component
* `suffix`: Final suffix, e.g., `foo.tar.gz` ⇒ `.gz`
* `suffixes`: Suffixes, e.g., `foo.tar.gz` ⇒ [`.tar`, `.gz`]
* `stem`: name without final suffix

Methods:
* `as_posix()`: String representation with `/` separating components
* `as_uri()`: String repr. as `file:///` URI;
  raises `ValueError` if path not absolute
* `is_absolute()`
* `is_reserved()`: True if reserved under Windows; always False under Posix
* `joinpath(*paths)`: Concatenates Paths and strings
* `match(pat)`: Does this Path match the given glob pattern; `*` can match
  across multiple components
* `relative_to(*paths)`: Return Path relative to given path; argument
   must be a prefix (it won't generate `..` components)
* `with_name(name)`: Return new path with substituted name
* `with_suffix(suffix)`: Return new path with substituted suffix

#### Concrete Path

Class methods:
* `Path.cwd()`
* `Path.home()`: (≥3.5)

Testing and information:
* `exists()`
* `is_dir()`
* `is_file()`
* `is_symlink()`
* `is_socket()`
* `is_fifo()`
* `is_block_device()`
* `is_char_device()`
* `stat()`
* `lstat()`
* `owner()`, `group()`: Returns name of owner/group;
   raises `KeyError` if no name for UID/GID
* `resolve(strict=False)`:
  Returns absolute path with all symlinks resolved and `..` eliminated.
  - Infinite loop raises `RuntimeError`.
  - (≥3.6) `strict=True` raises `FileNotFoundError` if path doesn't exist.
  - (≤3.5) Always operates as if `strict=True`.
* `samefile(otherpath)`

Usage:
* `expanduser()`: (≥3.5) Returns new path with `~` and `~user` expanded
* `glob(pat)`: Returns Paths from glob match in directory.
  - `*` matches only within a component; `**` matches multiple components
* `rglob(pat)` Recursive glob: `glob('**'+pat)`
* `iterdir()`: Yield Path objects of directory contents
* `open()`: Same as built-in [`open()`]
* `read_bytes()`: (≥3.5) Returns `bytes` of file content
* `read_text(encoding=None, errors=None)`: (≥3.5) Returns `str` of file content

File/directory modification:
* `chmod()`
* `lchmod()`
* `mkdir(mnode=0o777, parents=False, exist_ok=False)`
* `rename(target)`: Existing target replaced silently only on Unix
* `replace(target)`: Existing target always replaced silently
* `symlink_to(target)`
* `touch(mode=0o666, exist_ok=True)`
* `unlink()`, `rmdir()`: Unlink file/empty directory
* `write_bytes(data)`: (≥3.5)
* `write_text(data, encoding=None, errors=None)`: (≥3.5)



[PEP 519]: https://www.python.org/dev/peps/pep-0519
[`open()`]: https://docs.python.org/3/library/functions.html#open
[`os.PathLike`]: https://docs.python.org/3/library/os.html#os.PathLike
[`os.path`]: https://docs.python.org/3/library/os.path.html
[`pathlib`]: https://docs.python.org/3/library/pathlib.html
[file objects]: https://docs.python.org/3/glossary.html#term-file-object
[stdlib-filedir]: https://docs.python.org/3/library/filesys.html
[stdlib-genos]: https://docs.python.org/3/library/allos.html
