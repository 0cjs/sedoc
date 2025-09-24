Asynchronous Code in JavaScript
===============================o

References:
- javascript.info tutorial, ["Promises, async/await"][jinf-async]

#### Misc Notes

- JS lambda syntax is `() => { … }` or `function(…) { … }`.
  (Braces not necessary for a single statement.)

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


<!-------------------------------------------------------------------->
[jinf-async]: https://javascript.info/async
