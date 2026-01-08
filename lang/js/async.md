| [Overview](README.md) | [Node](node.md) | [TypeScript](ts.md)
| [NPM](npm.md) | [NPM Packages](npm-package.md)
| [Async](async.md) | [Jest](jest.md)
|

Asynchronous Code in JavaScript
===============================

References:
- javascript.info tutorial, ["Promises, async/await"][jinf-async]

Remember that JS lambda syntax is `() => …` (evals to the result of …; do
not use `return`) and `() => { … }` or `function(…) { … }` evals to the
result of `return …` inside the block.


Event Loop
----------

This is [the Node.js Event Loop][njs-loop]; not clear how close other
systems are to it.

On startup Node.js executes the code from the given file. If anything has
been scheduled via async calls, it then starts the event loop, which has
six _phases_ per iteration. (Maybe more—OS dependent.)

1. Timers: callbacks scheduled by `setTimeout()` and `setInterval()`.
2. Pending callbacks: I/O callbacks deferred to the next loop iteration.
   (E.g., ECONNREFUSED on some systems due to reporting waits.)
3. Idle, prepare: used internally.
4. Poll:
   - Retrieve new I/O events.
   - Execute I/O-related callbacks (with some exceptions).
   - There's a hard limit on the number of callbacks executed in this phase
     to avoid starving the timers etc.
   - If no I/O callbacks scheduled and no `setImmediate()` queued, Node
     blocks here with a timeout at the next timer. I/O becoming ready here
     will return from the blocking call and execute immediately.
5. Check: `setImmediate()` callbacks.
6. Close callbacks: not all but some, e.g. `socket.on('close', …)`.

If  are no timers or async I/O scheduled at the end of an iteration NodeJS
shuts down.

#### NextTick and MicroTask Queues

`process.nextTick()` (as of v22 legacy; use `queueMicroTask()` instead.) is
technically separate from the event loop; `nextTickQueue` is always
processed immediately after the current operation (transition from
underlying C/C++ to JS). Or when the JS stack runs to completion, and
before the event loop is allowed to continue. (This can starve the whole
event loop!)

The microtask queue (`queueMicroTask()`) is manged by V8; the `nextTickQueue`
managed by Node.js is always run first.

See docs for complex details, but one purpose for these is to allow APIs to
assign event handlers after an object has been constructed, but before any
I/O can occur. The main issue is that functions must be _entirely_ sync or
async; you can't sometimes be sync and sometimes emit events. See the
example in [`queueMicroTask()`]. (And [The Node.js Event Loop][njs-loop]
goes into a lot more detail.)


Functions
---------

#### Callbacks

Some JS libraries provide callback functionality. E.g. DOM elements:

    let script = document.createElement('script');
    script.src = '…'
    script.onload = () =>  { … }    // executed if/when script load complete
    script.onerror = () =>  { … }   // executed if/when script load fails
                                    //   (e.g., parse error?)
#### Promises

Promise objects are constructed with a single parameter, the _executor_
which is a function taking two arguments, `resolve` and `reject`.
- When created, the Promise state is set to `pending`, the result to
  `undefined` and the executor is run immediately and asynchronously.
- On successful execution, the executor calls `resolve(value)`, the result
  is set to `value`, and the Promise state changes to `fulfilled`.
- On failure, the executor calls `reject(value)`, the result is set to
  `value` and the Promise state changes to `rejected`.

You can await a promise directly:

    p = Promise(…)
    q = await p         // exception if promise was rejected

XXX more here


Stack Traces and the Call Stack
-------------------------------

Stack traces stop at async boundaries, e.g.:

    try {
        //  f() will create a new continuation to fulfil the promise; this
        //  continuation will have its own call stack. It then immediately
        //  returns, unwinding the user call stack and executing the `await`.
        await f()
    } catch (err) {
        //  This will contain the stack trace of only the continuation in
        //  which the error occurred, ignoring all code (including
        //  intermediate continuations) that set up the last continuation.
        //  Often this will be just a single line of trace deep in the Node
        //  internals.
        console.log(err.stack)
    }

This can to some degree be worked around by having the user's async
function preserve the user stack:

    async function f() {
        //  Get our call site here, before any async stuff as done, as
        //  this will be lost in the continuations created for async.
        const callSite = {}
        Error.captureStackTrace(callSite)

        try { … } catch (err) {
            //  Now the stack trace we return will go down as far as
            //  `callSite` above. (But note we lose the stack in `err`;
            //  we really should combine the two.)
            err.userStack = callSite.stack
            throw err
        }
    }


<!-------------------------------------------------------------------->
[jinf-async]: https://javascript.info/async

<!-- Event Loop -->
[njs-loop]: https://nodejs.org/en/learn/asynchronous-work/event-loop-timers-and-nexttick
[`queueMicroTask()`]: https://nodejs.org/api/globals.html#queuemicrotaskcallback
