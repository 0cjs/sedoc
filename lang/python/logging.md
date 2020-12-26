Python Logging
==============

Three modules: [`logging`], [`logging.config`], [`logging.handlers`].
Configuration can be done with function calls, a dictionary or a
config file.

Overview
--------

Logging is done by calling methods on [`Logger`] objects obtained from
`logging.getLogger(name)`. These are arranged in a hirarchy based on
dot-separated components _name_: logger `foo.bar` has parent `foo`, which in
turn has the root logger as its parent. `getLogger(__name__)` is the canonical
way to get a logger object for the current module. (The Logger object will be
created if it does not already exist.) [`getChild(suffix)`][getChild] will
get/create a child of a given logger.

Calling `log(lvl, msg, ...)` on a `Logger` does the following.
(`debug(msg, ...)` etc. are equivalent with preset `lvl`.)

1. Determines if `lvl` is below this logger's threshold by calling
   [`isEnabledFor(lvl)`][isEnabledFor]. The message is ignored if it's below:
  - the global disable level set by [`logging.disable(lvl)`][disable]
  - this logger's level, if it's not `NOTSET` (0)
  - the first level above `NOTSET` for each parent logger up the tree.

2. Creates a [`LogRecord`] object using [`makeRecord(...)`].

3. Calls [`handle(record)`], which:
   1. Checks the Logger's `disable` property. If True, the record is ignored.
   2. Calls [`filter(record)`] to check with each filter on this Logger. If any
      filter returns False, the record is ignored.
   3. Passes the record to all of this Logger's [handlers].
   4. If [`propagate`] is True, passes the record to the handlers of each
      parent logger up the tree until it finds one with `propagate` False or
      reaches the root. (Note that this does not check threshold levels or
      filters of parent Loggers.)


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

Messages are logged only if their level exceeds a threshold that ranges
from 0 upward. Each level may have a name assigned to it; the default names
are:

    logging.NOTSET   =  0
    logging.DEBUG    = 10
    logging.INFO     = 20
    logging.WARNING  = 30
    logging.ERROR    = 40
    logging.CRITICAL = 50

- [`getLevelName(lvl)`][getLevelName]: returns the name of a level, or
  "Level _n_" if no other name has been assigned.
- [`addLevelName(lvl, name)`][addLevelName] sets the name of a level,
  overwriting any previously assigned name (including the default names).


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



<!-------------------------------------------------------------------->
[`Filter`]: https://docs.python.org/3/library/logging.html#filter-objects
[`Formatter`]: https://docs.python.org/3/library/logging.html#formatter-objects
[`Handler`]: https://docs.python.org/3/library/logging.html#handler-objects
[`LogRecord` attributes]: https://docs.python.org/3/library/logging.html#logrecord-attributes
[`LogRecord`]: https://docs.python.org/3/library/logging.html#logrecord-objects
[`LogRecord`]: https://docs.python.org/3/library/logging.html#logrecord-objects
[`Logger`]: https://docs.python.org/3/library/logging.html#logger-objects
[`filter(record)`]: https://docs.python.org/3.5/library/logging.html#logging.Logger.filter
[`handle(record)`]: https://docs.python.org/3/library/logging.html#logging.Logger.handle
[`logging.basicConfig()`]: https://docs.python.org/3/library/logging.html?highlight=basicconfig#logging.basicConfig
[`logging.config`]: https://docs.python.org/3/library/logging.config.html
[`logging.handlers`]: https://docs.python.org/3/library/logging.handlers.html
[`logging`]: https://docs.python.org/3/library/logging.html
[`makeRecord(...)`]: https://docs.python.org/3/library/logging.html#logging.Logger.makeRecord
[`propagate`]: https://docs.python.org/3.5/library/logging.html#logging.Logger.propagate
[`str.format()`]: https://docs.python.org/3/library/stdtypes.html#str.format
[`string.Template`]: https://docs.python.org/3/library/string.html#string.Template
[`time.strftime()`]: https://docs.python.org/3/library/time.html#time.strftime
[addLevelName]: https://docs.python.org/3/library/logging.html#logging.addLevelName
[disable]:  https://docs.python.org/3/library/logging.html#logging.disable
[getChild]: https://docs.python.org/3/library/logging.html#logging.Logger.getChild
[getLevelName]: https://docs.python.org/3/library/logging.html#logging.getLevelName
[handlers]: https://docs.python.org/3/library/logging.html#handler-objects
[isEnabledFor]: https://docs.python.org/3/library/logging.html#logging.Logger.isEnabledFor
[printf]: https://docs.python.org/3/library/stdtypes.html#old-string-formatting
