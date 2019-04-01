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

#### Abstract Namespace

Linux supports an [abstract namespace] for Unix domain sockets
separate from the filesystem. This has no security; like IP all names
are accessible/usable by all processes and users, including
containerized processes that were not started with `CLONE_NEWNET`
separate network namespace. One way of mitigating this is to
[authenticate clients with `SO_PEERCRED`][cks-150720].

The sockets API distinguishes names in this namespace by a leading
`\0` byte. Many tools (such as `lsof` and the Go net package)
use a leading `@`.



<!-------------------------------------------------------------------->
[abstract namespace]: https://utcc.utoronto.ca/~cks/space/blog/linux/SocketAbstractNamespace?showcomments
[cks-070228]: https://utcc.utoronto.ca/~cks/space/blog/python/UnixDomainSockets
[cks-150720]: https://utcc.utoronto.ca/~cks/space/blog/python/AbstractUnixSocketsAndPeercred
