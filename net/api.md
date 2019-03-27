Unix Network API Notes
======================

This has notes not only on the BSD `socket` API in all languages, but
also userland interfaces such as socket files and tools such as `curl`.


Unix Domain Sockets
-------------------

Notes from [cks-070228]:
- Create with family `AF_UNIX` and `SOCK_STREAM` or `SOCK_DGRAM`.
- Address is a path with much lower length limit than regular paths.
- `bind()` address path must not exist (even if nothing listening on it).
- Address path not removed when server stops listening.
- Linux requires `w` perms on socket for clients; other systems may not.
  (Properly restrict access by putting in `0700` directory.)
- Unix domain sockets have no peername.



<!-------------------------------------------------------------------->
[cks-070228]: https://utcc.utoronto.ca/~cks/space/blog/python/UnixDomainSockets
