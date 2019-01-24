Twisted Overview
================

Important classes and objects include:

- `zope.interface.Interface`: See ["Interfaces"](#interfaces) below.
- [`twisted.internet.defer.Deferred`](deferred.md): Encapsulates the
  data-handling and error-handling callbacks that will be invoked by
  the event loop or sometimes immediately.
- ["Event Loop"](#event-loop), below.
- [Transports and Protocols](protocol.md), which handle reading,
  writing and parsing of protocol data.

Many commonly used interfaces are documented in
[`twisted.internet.interfaces`].

[`twisted.internet.interfaces`]: https://twistedmatrix.com/documents/current/api/twisted.internet.interfaces.html


Interfaces
----------

Zope [Interfaces][zope-if] are used within Twisted for reasons
explained at [Why Interfaces]. ([Zope] is a family of Python web
application [frameworks][zope-fw], along with an app server, database,
and other tools.)

Roughly, instances of `Interface` describe the attributes (including
functions) to be available on objects _providing_ that interface.
These objects may be instantiated from classes or other factories
_implementing_ the interface, but in some cases (such as a module
providing an interface) there may be no factory implementing it.

_Adapters_ are used to produce new providers of interfaces from
providers other interfaces. these can be registered via
`twisted.python.components.registerAdapter`.

[Why Interfaces]: http://glyph.twistedmatrix.com/2009/02/explaining-why-interfaces-are-great.html
[Zope]: https://en.wikipedia.org/wiki/Zope
[zope-fw]: http://www.zope.org/en/latest/world.html#frameworks
[zope-if]: https://zopeinterface.readthedocs.io/


Event Loop
----------

The event loop may be 'foreign' (such as from a graphical toolkit) or
supplied by Twisted (see [Choosing a Reactor][ht-choosing-reactor]),
and may or may not involve parallelism (threads).

Instead of the manual setup below, the event loop can be set up and
started automatically by the [Twisted Application Framework
][ht-application] running [`twisted.application.service`] modules.

The most basic application just gets the default reactor and starts it:

    from twisted.internet import reactor
    reactor.callWhenRunning(myfunc)
    reactor.callLater(4, reactor.stop)
    reactor.run()

The [Reactor Overview][ht-reactor] provides links to detailed
documentation. Some common attributes and methods are:

- `run()`: Start reactor in this thread. (IReactorCore)
- `stop()`, `crash()`: Stop reactor with and without firing system events.
  The latter may lose data and leave inconsistent state. (IReactorCore)
- `callWhenRunning(f)`: Schedule _f_ to be called as soon as possible
  when reactor is running. (IReactorCore)
- `reactor.callLater(secs, callback, *args)`
- `reactor.listenTCP(port, factory, iface=None)`: Start a server. (IReactorTCP)
- `reactor.connectTCP(port, factory, iface=None)`: Start a client. (IReactorTCP)

#### Test Reactors

Reactors are not restartable, and in testing situations you probably
don't want to re-use reactors anyway. Instead, create a new one every
time, e.g.:

    @pytest.fixture
    def reactor():
        #   We want a reactor that works on all platforms.
        from twisted.internet.selectreactor import SelectReactor
        timeout_secs = 2
        r, forced = SelectReactor(), False
        def force_stop(): nonlocal forced; forced = True; r.stop()
        r.callLater(timeout_secs, force_stop)
        yield r
        if forced: pytest.fail(
            'Test did not stop reactor within {} secs'.format(timeout_secs))

If you don't mind using a test framework based on `unittest` that does
everything with a single reactor, you can also have a look at
[Test-driven development with Twisted][ht-trial] which shows how to
use the `twisted.trial` package. It also offers some generally useful
ideas on unit testing in Twisted.

[`twisted.application.service`]: https://twistedmatrix.com/documents/18.7.0/api/twisted.application.service.html
[ht-application]: https://twistedmatrix.com/documents/current/core/howto/application.html
[ht-choosing-reactor]: https://twistedmatrix.com/documents/current/core/howto/choosing-reactor.html
[ht-reactor]: https://twistedmatrix.com/documents/current/core/howto/reactor-basics.html
[ht-trial]: https://twistedmatrix.com/documents/current/core/howto/trial.html
