Python File and Network I/O
===========================

Also see [Python Filesystem and Path Libraries](files.md).

File I/O
--------

Files are opened with the built-in function [`open()`].

* `open(file)`: _file_ may be a [path-like object] or a file descriptor.
  Returns a [file object]: [`TextIOWrapper`], [`BufferedIOBase`] subclass
  or unbuffered [`FileIO`].
  - `mode='r'`: `r` read (default), `w` write, `a` append, `+` 'rw', `w+b`
    truncates (but not `r+b`), `b` binary, `t` text (default),
    `x` exclusive.
  - `buffering=-1`: `0`=none, 1=line, ≥2=block.
    Default -1 is lines for text, system-chosen blocksize for binary.
  - `encoding=None`: Text mode only, default is platform-dependent.
    See [`codecs`].
  - `errors=None`: Handles codec errors.
  - `newline=None`: Used only for deprecated `mode='u'` universal newlines.
  - `closefd=True`: Close _file_ arg if a file descriptor.
  - `opener=None`: A callable, default `os.open`.

Network I/O
-----------

The [`socket`] module is the standard BSD API. A buffered [file
object] wrapping a socket can be obtained with `socket.makefile()`.

* [`socket.makefile()`]: Args similar to `open()`.
  - `mode`: Only `r`, `w`, `b` allowed.
  - Socket must be blocking.
  - `close()` does not close underlying socket.
  - Windows cannot mix the returned object with file-like objects.

Warnings:
- `sock.shutdown(socket.SHUT_WR)` on a Unix domain stream socket will
  shut down both directions (Ubuntu 18.04).





[`BufferedIOBase`]: https://docs.python.org/3/library/io.html#io.BufferedIOBase
[`FileIO`]: https://docs.python.org/3/library/io.html#io.FileIO
[`TextIOWrapper`]: https://docs.python.org/3/library/io.html#io.TextIOWrapper
[`codecs`]: https://docs.python.org/3/library/codecs.html#standard-encodings
[`open()`]: https://docs.python.org/3/library/functions.html#open
[file object]: https://docs.python.org/3/glossary.html#term-file-object
[path-like object]: https://docs.python.org/3/glossary.html#term-path-like-object

[`socket.makefile()`]: https://docs.python.org/3/library/socket.html#socket.socket.makefile
[`socket`]: https://docs.python.org/3/library/socket.html
