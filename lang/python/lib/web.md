Python Web Frameworks
=====================


The HFT Guy gives his experience in [My Experience In Production with:
Flask, Bottle, Tornado and Twisted]. This includes short code and test
examples. His analysis is, briefly:
- __Flask:__ nice for really small stuff, but not simple and rapidly
  becames unmaintainable as your app grows, particularly due to global
  variables. Lots of dependencies.
- __Bottle:__ still missing lots of features (async, compression, etc.),
  but not going to collapse as it grows like Flask will. It's a single
  `.py` file. "Flask done right."
- __Django:__ No experience, but praised for its great ORM.
- __Tornado:__ Quick to start with, no dependencies, a bit boilerplatey.
  Async is tricky; don't use this if you don't need it. Routing is a list
  of tuples.
- __Twisted:__ Not a web framework; don't try it. Big, complex, hacky, hard
  to use. (Python's built-in async features are much better.)



<!-------------------------------------------------------------------->
[]: https://thehftguy.com/2020/10/27/my-experience-in-production-with-flask-bottle-tornado-and-twisted/
