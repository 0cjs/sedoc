Python Logging
==============

Three modules: [`logging`], [`logging.config`], [`logging.handlers`].
Configuration can be done with function calls, a dictionary or a
config file.

Simple Start
------------

    import logging
    logging.warning('...')          # debug, info, warning, error, critical
    logging.info('x²=%s', x*x)
    logging.error('Caught!', exec_info=true)    # Same as logging.exception()

    # `root` is the default name of the root logger, so output is like
    # WARNING:root:...

You can call [`logging.basicConfig()`] before any of the above to
configure the root logger; it will have no effect after. This cannot
be used to configure other `Logger` objects.
- `level`: Minimum level to print, default `WARNING`. See below.
- `datefmt`: Format for dates as with [`time.strftime()`].
- `format`: Format string for handler; see [`LogRecord` attributes].
- `style`: Style for `format`, one of `'%'` ([printf], default), `'{'`
  ([`str.format()`]), `'$'` ([`string.Template`]).
- `filename`: Create a `FileHandler` with the given filename instead
  of a `StreamHandler` to stderr.
- `filemode`: Default `'a'`.
- `stream`: Use a given stream; incompatible with `filename`.


Logging Levels
--------------

    logging.NOTSET   =  0
    logging.DEBUG    = 10
    logging.INFO     = 20
    logging.WARNING  = 30
    logging.ERROR    = 40
    logging.CRITICAL = 50


API Reference
-------------

Call only `logging.getLogger(name)` to instantiate a `Logger`. _name_
is usually `__name__`. Multiple calls with the same _name_ return the
same object. Names may be hierarchical separated by `.` for a
parent/child relationship.

Classes:
- [`LogRecord`]: Single log entry created by a `Logger`.
- [`Logger`]: Instantiate only via `logging.getLogger()`.
  - `addHandler(handler)`: Adds a `Handler`; one `Logger` may have
    multiple `Handler`s.
- [`Handler`]: Send `LogRecord`s ≥  configured level to an output.
  Base class of `StreamHandler`, `FileHandler`, `HTTPHandler`,
  `SMTPHandler`, etc.
  - `setLevel(level)`
  - `setFormatter(formatter)`: Takes a `Formatter` object.
- [`Formatter`]
- [`Filter`]

Functions:
- `logging.exception()`
- `logging.config.fileConfig(fname, disable_existing_loggers)`,
- `logging.config.dictConfig()`



[`Filter`]: https://docs.python.org/3/library/logging.html#filter-objects
[`Formatter`]: https://docs.python.org/3/library/logging.html#formatter-objects
[`Handler`]: https://docs.python.org/3/library/logging.html#handler-objects
[`LogRecord` attributes]: https://docs.python.org/3/library/logging.html#logrecord-attributes
[`LogRecord`]: https://docs.python.org/3/library/logging.html#logrecord-objects
[`Logger`]: https://docs.python.org/3/library/logging.html#logger-objects
[`logging.basicConfig()`]: https://docs.python.org/3/library/logging.html?highlight=basicconfig#logging.basicConfig
[`logging.config`]: https://docs.python.org/3/library/logging.config.html
[`logging.handlers`]: https://docs.python.org/3/library/logging.handlers.html
[`logging`]: https://docs.python.org/3/library/logging.html
[`str.format()`]: https://docs.python.org/3/library/stdtypes.html#str.format
[`string.Template`]: https://docs.python.org/3/library/string.html#string.Template
[`time.strftime()`]: https://docs.python.org/3/library/time.html#time.strftime
[printf]: https://docs.python.org/3/library/stdtypes.html#old-string-formatting
