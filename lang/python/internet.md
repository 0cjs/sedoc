Python Internet Protocols and Support
=====================================

* [Internet Protocols and Support][internet] in the standard library


HTTP Servers
------------

The [`http.server`] library can be used from the command line to serve
a local directory. To serve the current working directory on
[`http://localhost:8000`]:

    python3 -m http.server                  # 3.x
    python  -m SimpleHttpServer 8000        # 2.x



[`http.server`]: https://docs.python.org/3/library/http.server.html
[`http://localhost:8000`]: http://localhost:8000
[internet]: https://docs.python.org/3/library/internet.html
