Twisted Transports and Protocols
================================

Transports are usually provided by Twisted. They use callbacks into
Protocols when data is read and may be called to write data.

Protocols are Twisted- or user-supplied. Their functions are invoked
with read data which they convert to higher level messages, and they
will generally in invoke Transport writes and application-supplied
callbacks

Many commonly used interfaces are documented in
[`twisted.internet.interfaces`].

[`twisted.internet.interfaces`]: https://twistedmatrix.com/documents/current/api/twisted.internet.interfaces.html


Transports
----------

Transport interfaces offer non-blocking write and other
transport-related functions.
- [`ITransport`] is used for byte streams; subinterfaces include
  `ITCPTransport`, `IUnixTransport` and `IProcessTransport`.
- `IUDPTransport`, `IUNIXDatagramTransport`, `IMulticastTransport`, etc.
  provide packet-oriented interfaces.

`ITransport` Methods:
- `write(bytes)`: Non-blocking write; will attempt to make sure that
  all data is eventually written.
- `writeSequence(seq)`: Call `write()` on each `bytes` in the sequence.
- `loseConnection()`: Close connection after writing all pending data.
- `getPeer()`, `getHost()`: Get remote and local addresses. Returns an
  [`IAddress` provider]


[`IAddress` provider]: https://twistedmatrix.com/documents/current/api/twisted.internet.address.html
[`ITransport`]: https://twistedmatrix.com/documents/current/api/twisted.internet.interfaces.ITransport.html


Protocols and Their Factories
-----------------------------

The [`twisted.internet.protocol`] module contains the abstractions
for _protocols_, which read/write data and convert it to/from
higher-level messages, and _factories_ that create protocol objects.

Connection error handling is split between the factories and the
protocols depending on the type of error. E.g., `clientConnectionFailed()`
is called on the `ClientFactory` because a `Protocol` isn't created
for failed connections.

### Factories

When a factory object isn't wanted for a simple client connection, a
[`ClientCreator`] can be instantiated with the reactor and protocol
class. Calling `connectTCP()` or a similar method will return a
`Deferred` that will be called with an instance of that protocol upon
successful connect.

Trivial factory classes can be created with the [`Factory.forProtocol`]
constructor which takes a `Protocol` subclass and its `__init__()`
arguments.

Explicit factory classes usually inherit from `ClientFactory` or
`ServerFactory`. (There is also a `ReconnectingClientFactory` with
exponential backoff.) Setting the `protocol` class attribute to a
protocol class will allow the inherited `buildProtocol()` method to
automatically create an appropriate protocol instance upon connection.

### Protocols

[`Protocol`] is the base class for all streaming protocols.

Instance attributes:
* `connected`: (BaseProtocol)
* `transport`: an [`ITransport`] \(I think) (BaseProtocol)
* `connectionMade()`: Called when the connection (server or client)
  setup is complete. Use this to send an initial mesage. (BaseProtocol)
* `dataReceived(data)`: (Protocol)
* `connectionLost(reason=connectionDone)`: Connection has been shut down.
  Clear any circular and external references to this protocol. (Protocol)
* `factory`: The factory that created this protocol. (Set by
  `Factory.buildProtocol()`.)

The [`ProcessProtocol`] subclass offers special facilities for dealing
with I/O for processes (child, remote, etc.). But functions from
[`twisted.internet.utils`] such as `getProcessOutputAndValue()` may be
more convenient.

### Example

    from twisted.internet import defer
    from twisted.internet.protocol import Protocol, ClientFactory

    class MyProtocol(Protocol):
        data = b''
        def dataReceived(self, data):       self.data += data
        def connectionMade(self):           self.transport.write(b'Hello\r\n')
        def connectionLost(self, reason):   self.factory.finish(data)

    class MyClientFactory(ClientFactory):
        protocol = MyProtocol

        def __init__(self, deferred):
            self.deferred = deferred

        def finished(self, data):
            d, self.deferred = self.deferred, None
            d.callback(data)

        def clientConnectionFailed(self, connector, reason):
            if self.deferred is not None:
                d, self.deferred = self.deferred, None
                d.errback(reason)

[`ClientCreator`]: https://twistedmatrix.com/documents/current/api/twisted.internet.protocol.ClientCreator.html
[`Factory.forProtocol`]: https://twistedmatrix.com/documents/current/api/twisted.internet.protocol.Factory.html#forProtocol
[`ProcessProtocol`]: https://twistedmatrix.com/documents/current/api/twisted.internet.protocol.ProcessProtocol.html
[`Protocol`]: https://twistedmatrix.com/documents/current/api/twisted.internet.protocol.Protocol.html
[`twisted.internet.protocol`]: https://twistedmatrix.com/documents/current/api/twisted.internet.protocol.html
[`twisted.internet.utils`]: https://twistedmatrix.com/documents/current/api/twisted.internet.utils.html
