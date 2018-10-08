Twisted Event-driven Concurrency Framework
==========================================

- [Overview](overview.md)
- [Deferred](deferred.md)
- [Transports and Protocols](protocol.md)


Introduction
------------

[Twisted] is a framework for event-driven (mainly network) programming
using an event loop which deals with I/O and calls user-written callbacks.
It includes sub-packages to handle various protocols including:
- Conch: SSH, Telnet
- Mail: SMTP, POP, IMAP
- Names: DNS
- Pair: Tunnels, network taps, raw sockets (Linux only)
- Web: Many protocols at various levels (also see [Nevow])
- Words/IM: IRC, XMPP

The current version as of 2018-10-08 is 18.7.


External Documentation
----------------------

- [GitHub](https://github.com/twisted/twisted)
- [API Reference]
- [Documentation overview][tm-docs]
- [Developer Guides], both overviews and howtos for specific tasks. If
  you know what you want to do but don't know how to do it, this is a
  good place to start.
- [Example code]
- Dave Peticolas' [Twisted Introduction][peticolas] (good for people
  not familiar with event-driven programming)



[API reference]: https://twistedmatrix.com/documents/current/api/
[Developer Guides]: https://twistedmatrix.com/documents/current/core/howto/
[Nevow]: https://github.com/twisted/nevow
[Twisted]: http://twistedmatrix.com/
[example code]: https://twistedmatrix.com/documents/current/core/examples/index.html
[peticolas]: http://krondo.com/an-introduction-to-asynchronous-programming-and-twisted/
[tm-docs]: https://twistedmatrix.com/trac/wiki/Documentation
