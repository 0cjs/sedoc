Twisted: Deferred Callback Handling
-----------------------------------

- [`twisted.internet.defer.Deferred`][`Deferred`] API reference
- [Introduction to Deferreds][ht-deferintro]
- [Deferred Reference][ht-deferred] documentation/howto
- [`src/twisted/internet/defer.py`][gh-deferred] source code

A [`Deferred`] is an object encapsulating how to handle an event at a
future time and, after handling, its result. After construction its
processing chain `.callbacks` is set up via the functions described
below. Later one of `callback(result)`, `errback(fail=None)` or
`cancel()` is called on it to do the chain processing; only one of
these may be called and that only once.


Constructors
------------

- `Deferred(canceller=None)`: Unexecuted `Deferred` with empty chain.
  If _canceller_ is not supplied, `.errback(CancelledError)` is called
  on cancellation.

To construct an already-executed `Deferred`, when you do not need to
do any asynchronous operations:

- `succeed(result)`: Executed with `.callback(result)`
- `fail(result=None)`: Executed with with `.errback(result)`
- `execute(f, *args, **kwargs)`:
  Invoke _f_ with args; wrap return value in `.callback(retval)` or
  exception in or `errback(Failure(exception))`.
- `maybeDeferred(f, *args, *kwargs)`:
  Invoke _f_ with args. Based on return value's type:
  - `Deferred`: return it
  - `Failure`: return `fail(result)`
  - Exception thrown: return `fail(result)`
  - Otherwise: return `succeed(result)`


Callback Chain
--------------

The `.callbacks` attribute is a list of _(callback, errback)_ pairs of
functions. If for any stage a _callback_ is supplied without an
_errback_ or vice versa, the missing one will be set to `passthru`
(the identity function). Append pairs to the sequence with:
- [`addCallbacks(callback)`]: Optional args:
  - `errback`: No errback at this stage if `None`.
  - `callbackArgs`: Positional args passed to _callback_ after
    _result_.
  - `errbackArgs`: Positional args passed to errback after _fail_.
  - `callbackKeywords`, `errbackKeywords`: Additional keyword args.
- `addCallback(callback, *args, *kw)`: Errback will be `passthu`.
- `addErrback(errback, *args, *kw)`: Callback will be `passthru`.
- `addBoth(callback, *args, *kw)`: `callback` also used for `errback`.
- `chainDeferred(d)`: Same as `addCallbacks(d.callback, d.errback)`.


Chain Processing
----------------

A `Deferred` is called no more than once with:
- [`callback(result)`]: _result_ is passed to first callback.
- [`errback(fail=None)`]: _fail_ is passed to first errback.
  _fail_ must be a [`Failure`] or an object (usually an `Exception`)
  to be wrapped in a `Failure`. Default is the current exception,
  raising `NoCurrentExceptionError` if none.

A second attempt to call the `Deferred` will raise `AlreadyCalledError`.

After the _callback_ or _errback_ for a pair is executed, processing
continues with the next pair based on return value:
- Exception thrown: Wrap in `Failure`; pass to _errback_ from next pair.
- `Failure`: Pass to _errback_ of next pair.
- `Deferred`: XXX
- Other: Pass to _callback_ of next pair.

Be careful in an _errback_ that you return a `Failure` unless you have
handled the error and wish to continue with the next _callback_.

The final result is left in the `.result` property. Exceptions will
never be propagated outside of a _callback_ or _errback_; anything not
properly handled will end up as a `Failure` in `.result`. (A message
`Unhandled error in Deferred:` will be printed to stderr when the
`Deferred` is finalized.)


Pausing and Cancellation
------------------------

[`Deferred.pause()`] will stop processing until `unpause()` has been
called once for each call to `pause()`. (When paused,
`_runCallbacks()` will return without doing anything.)

[`Deferred.cancel()`] will cancel the pending operation if neither
`callback` nor `errback` have been called. If the `Deferred` was
instantiated with a callable `canceller` parameter, that will be
called, otherwise `errback` will be called with [`CancelledError`].

[`Deferred.addTimeout()`] can also schedule a cancellation; this has
some complex options.


Inline Callbacks
----------------

The [`@inlineCallbacks`] decorator lets you write a sequential-looking
function. So instead of:

    def printThing(thing):
        print(thing)
    deferred = requestThing()
    deferred.addCallback(printThing)

you can simply `yield` the Deferred in a generator and it function
will be suspended until the `Deferred` is complete:

    @inlineCallbacks
    def printThing():
        deferred = requestThing()   # returns a Deferred
        thing = yield deferred      # will resume after deferred is processed
        print(thing)

If the yielded object is not a `Deferred` it will be immediately
returned, à la [`maybeDeferred()`].


asyncio Interoperation
-----------------------

Interoperate with [`asyncio.Future`] objects with:
- `Deferred.asFuture(loop)`: Adapt a `Deferred` to an `asyncio.Future`.
- `Deferred.fromFuture(future)`: (class method)
  Construct a `Deferred` from an `asyncio,Future`.


Lower-level APIs
----------------

[`Deferred`] is the usual way to handle callbacks because it
makes it easy to separate error handling and compose callback and
error handling functions. However, lower-level APIs offer explicit
callback interfaces for various network and other actions.

* [`reactor.addReader()`] will register an `IReadDescptor` with the
  reactor. Its `fileno` is a file descriptor to monitor, `doRead()`
  will be called when data is available for reading, and
  `connectionLost()` will be called if the connection is lost.

* [`reactor.connectTCP()`] will register a `ClientFactory` to be
  called after a successful connection to a given host and port.
  Various callbacks on the factory will be invoked during the
  connection process, with a successful connection eventually calling
  `buildProtocol(addr)` to return a [`Protocol`] to handle reading
  data and building messages. (`reactor.listenTCP()` is similar for
  servers.)

Most [`Protocol`] objects will handle callbacks to the application
level using `Deferred` objects, but this can also be done directly.



[`@inlineCallbacks`]: https://twistedmatrix.com/documents/current/api/twisted.internet.defer.html#inlineCallbacks
[`CancelledError`]: https://twistedmatrix.com/documents/current/api/twisted.internet.defer.CancelledError.html
[`Deferred.addTimeout()`]: https://twistedmatrix.com/documents/current/api/twisted.internet.defer.Deferred.html#addTimeout
[`Deferred.cancel()`]: https://twistedmatrix.com/documents/current/api/twisted.internet.defer.Deferred.html#cancel
[`Deferred.pause()`]: https://twistedmatrix.com/documents/current/api/twisted.internet.defer.Deferred.html#pause
[`Deferred`]: https://twistedmatrix.com/documents/current/api/twisted.internet.defer.Deferred.html
[`Failure`]: https://twistedmatrix.com/documents/current/api/twisted.python.failure.Failure.html
[`Protocol`]: https://twistedmatrix.com/documents/current/api/twisted.internet.protocol.html
[`addCallbacks(callback)`]: https://twistedmatrix.com/documents/current/api/twisted.internet.defer.Deferred.html#addCallbacks
[`asyncio.Future`]: https://docs.python.org/3/library/asyncio-future.html#asyncio.Future
[`callback(result)`]: https://twistedmatrix.com/documents/current/api/twisted.internet.defer.Deferred.html#callback
[`errback(fail=None)`]: https://twistedmatrix.com/documents/current/api/twisted.internet.defer.Deferred.html#errback
[`maybeDeferred()`]: https://twistedmatrix.com/documents/current/api/twisted.internet.defer.html#maybeDeferred
[`reactor.addReader()`]: https://twistedmatrix.com/documents/current/api/twisted.internet.interfaces.IReactorFDSet.html#addReader
[`reactor.connectTCP()`]: https://twistedmatrix.com/documents/current/api/twisted.internet.interfaces.IReactorTCP.html#connectTCP
[gh-deferred]: https://github.com/twisted/twisted/blob/trunk/src/twisted/internet/defer.py
[ht-deferintro]: https://twistedmatrix.com/documents/current/core/howto/defer-intro.html
[ht-deferred]: https://twistedmatrix.com/documents/current/core/howto/defer.html
