Python Date and Time Handling
=============================

- [`datetime`] is the Python standard library
- [`dateutil`] has useful extensions
  - [`dateutil.tz`] has `tzinfo` objects for the [IANA timezone database][IANA]



datetime
--------

[`datetime`] is the standard Python library for handling dates and times.

All objects are immutable.

Constants:

    MINYEAR     # ⇒ 1
    MAXYEAR     # ⇒ 9999

Class hierarchy:

    object
        timedelta       # duration in microseconds
        time            # idealized time in 86,400 second day (no leap secs)
        date            # year/month/day in proleptic Gregorian calendar
            datetime    # Adds `time` to `date`
        tzinfo          # Abstract base class for time zone info objects
            timezone    # Fixed offset from UTC (no DST etc. adjustments)

An 'aware' object has some sort of TZ, DST etc. information allowing
it to mark a specific moment in time that's not open to interpretation
(e.g., '13:15 UTC'). A 'naive' object may vary depending on external
interpretation (e.g., '2013-08-25'). `date` is always naive; `datetime`
and `time` may be naive or aware.

### timedelta

A [`timedelta`] is a duration in microseconds between two
`date/time/datetime`. It is neither naive nor aware.

- Constructed representations are normalized to a unique value.
- Only days can be negative; `timedelta(seconds-1)` produces
  `timedelta(-1, 86399)`.
- The absolute value of _days_ <= 999,999,999.
- Due to this normalization:
  - `timedelta.max > -timedelta.min`
  - `-timedelta.max` is not representable as a timedelta object.

Class attributes:

    min         # most negative, `timedelta(-999999999)`.
    max         # most positive, `timedelta(999999999)`.
    resolution  # minimum difference, `timedelta(microseconds=1)`.

Constructors:

    timedelta(days=0, seconds=0, microseconds=0, milliseconds=0,
              minutes=0, hours=0, weeks=0)

Operations:
* Hashable, efficient pickling.
* Boolean context: `False` if 0, `True` otherwise.
* Comparisons:
  * With non-`timedelta`: `==` False, `!=` True, `<` etc. raise `ValueError`
  * Smaller durations are smaller timedeltas
* `+/-/*/÷/mod/abs` with ints and floats. Results will be rounded to
  microseconds.
* `str`: String of form `D day[s], ][H]H:MM:SS[.UUUUUU]`.
* `repr`: String of form `datetime.timedelta(D[, S[, U]])`
  where only `D` may be negative.
* `.total_seconds()`: (Py>=3.2) `td / timedelta(seconds=1)`
  (Loses microsecond accuracy on >270 year durations on most platforms.)
* `+/-` with `date` and `datetime`.

### time

[`time`] is an idealized time in a 24\*60\*60 second day (there are no
leap seconds). It's naive if either `.tzinfo` or `.tzinfo.utcoffset(None)`
is `None`.

Class attributes:

    min         # ⇒ time(0, 0, 0, 0)            # earliest representable time
    max         # ⇒ time(23, 59, 59, 999999)    # latest representable time
    resolution  # ⇒ timedelta(microseconds=1)

Constructors:

    time(hour=0, minute=0, second=0, microsecond=0,
         tzinfo=None, *, fold=0)
    time.fromisoformat(s)           # (≥3.7) Inverse of .isoformat()
                                    # HH[:MM[:SS[.mmm[mmm]]]]
                                    # [+HH:MM[:SS[.ffffff]]]

    #   `ValueError` raised if any parameter outside allowable ranges:
    0 ≤ hour < 24
    0 ≤ minute < 60
    0 ≤ second < 2460
    0 ≤ microsecond < 1,000,000
    fold in [0, 1]                  # (≥3.6)

Instance attributes:

    hour            # in range(60)
    minute          # in range(60)
    second          # in range(60)
    microsecond     # in range(1000000)
    tzinfo
    fold            #  (≥3.6) 0=earlier, 1=later of two moments with same repr.

An interval may repeat during a day when clocks are rolled back at the
end of DST or when the UTC offset of a zone is changed. In this case,
`fold` becomes `1` for the later of the two moments that have the same
wall clock time representation.

Comparisons:
- Hashable, efficient pickling
- Boolean context: always `True`. (≤3.5, midnight UTC was `False`)
- `time` vs. non-`time` or aware vs. naive:
  `==` False, `!=` True, `<` etc. raise `<` etc.) raise `TypeError`.
- Otherwise preceeding in time is smaller.

Instance methods:
- `replace(...)`: Return a time with the same value except fields
  specified to be replaced in the args, whcih are asame as the
  constructor except `fold`, which defaults to 0.
- `isoformat(timespace='auto')`: Return time in ISO format; 6-char UTC
  offset is appended unless `.utcoffset() is None`. Timespecs:
  - `auto`: `seconds` if `.microsecond == 0`, otherwise `microseconds`
  - `microseconds`: Format `HH:MM:SS.mmmmmm`
  - `milliseconds`: Truncate (not round) microseconds
  - `seconds`, `minutes`, `hours`: Drop microseconds and further fields
  - Invalid: raise `ValueError`
- `__str__()`: ⇒ `.isoformat()`
- `strftime(format)`
- `__format__(format)`: As `strftime()`; used for f-strings
- `tzname()`, `utcoffset()`, `dst()`:
  - `tzinfo is None`: returns `None`
  - Otherwise: calls same method on `.tzinfo` object and returns
    that value or raises an exception if that value is `None`
  - (≥3.7) UTC offset is not restricted to a whole number of minutes.

### date

A [`date`] is a year, month and day in proleptic Gregorian calendar,
extended infintely in both directions from current date. It's always
naive.

It functions as per Reingold and Dershowitz _Calendrical
Calculations_, where it’s the base calendar for all computations. See
the book for algorithms for converting between proleptic Gregorian
ordinals and many other calendar systems. Also see [The Mathematics of
the ISO 8601 Calendar][isocalendar].

Class attributes:

    min             # ⇒ date(MINYEAR, 1, 1)
    max             # ⇒ date(MAXYEAR, 12, 31)
    resolution      # ⇒ timedelta(days=1)

Constructors:

    date(year, month, day)
    date.today()
    date.fromtimestamp(posix_timestamp)     # e.g., time.time()
    date.fromordinal(ordinal)               # proleptic Gregorian ordinal

Instance attributes:

    year, month, day

Instance methods:

    replace(year=self.year, month=self.month, day=self.day)    # ⇒ date
    timetuple()         # ⇒ time.struct_time as returned by time.localtime()
    toordinal()         # ⇒ proleptic Gregorian ordinal
    weekday()           # ⇒ mon = 0 ... sun = 6
    isoweekday()        # ⇒ mon = 1 ... sun = 7
    isocalendar()       # ⇒ (ISO year, ISO week number, ISO weekday)
    isoformat()         # ⇒ YYYY-MM-DD
    __str__()           #   isoformat()
    ctime()             # ⇒ e.g., "Wed Dec 4 00:00:00 2002"
    strftime(fmt)       #   see below
    __format__(fmt)     #   strftime(fmt)

Comparisons:
- Boolean context: always `True`

### datetime

A [`datetime`][datetime-obj] is a sublclass of `date` with `time`
added to it, using the same assumptions as both (Gregorian calendar
infinitely extended in both directions, 86,400 seconds in a day). It's
naive if either `.tzinfo` or `.tzinfo.utcoffset(self)` is `None`.

Class Attributes:

    min, max, resolution

Constructors:

    datetime(year, month, day,              # MINYEAR ≤ year ≤ MAXYEAR
             hour=0, minute=0, second=0,
             microsecond=0,
             tzinfo=None, *, fold=0)
    datetime.today()                        # Local datetime with tzinfo
    datetime.now(tz=None)                   # Local datetime with tzinfo, e.g.
                                            #   datetime.now(timezone.utc)
    datetime.utcnow()                       # tzinfo=None
    datetime.utcfromtimestamp(ts)           # as fromtimestamp w/ tz=None
    datetime.fromtimestamp(ts, tz=None)     # from POSIX timestamp, time.time()
    datetime.fromOrdinal(ord)               # ord=1 ⇒ 0001-01-01
    datetime.combine(date, time, tz=None)   # Default tz is from time obj
    datetime.fromisoformat(str)             # Only .isoformat() output parsed
    datetime.strptime(str, format)          # See str[fp]time below

The `fromtimestamp` constructors may raise `OverflowError` if the
value is outside the range supported by C `localtime()`/`gmtime()`
functions, often 1970-2038. Also `OSError` if gmtime() etc. fails. On
non-POSIX systems including leap seconds they are ignored.

Instance attributes:

    year, month, day                            # see `date`
    hour, minute, second, microsecond, fold     # see `time`

Instance methods:
- XXX All from date, time?
- XXX Plus some extras.

Comparisons:
- XXX

### tzinfo, timezone

[`tzinfo`], [`timezone`]

XXX write me

### strftime/strptime

`date`, `datetime` and `time` have a [`strftime(fmt)`][strftime]
method, broadly the same as `time.strftime(fmt, d.timetuple())`.

`datetime.strptime(date_string, fmt)` constructs a `datetime` object,
equivalant to `datetime(*(time.strptime(date_string, format)[0:6]))`.

Format specifies are as per the 1989 C standard and work on all platfoms
with a standard C implementation:
* `%%`: literal `%`
* `%Y`, `%y`: year (4-digit, 2-digit); 0-pad
* `%U`, `%W`: week of year: 0 up to first Sunday, Monday; 0-pad
* `%j`: day of year; 3-digit 0-pad
* `%m`, `%b`, `%B`: month (1=Jan 0-pad, abbrev., full)
* `%d`: day of month; 0-pad
* `%a`, `%A`, `%w`: weekday (abbreviated, full, decimal 0=Sunday)
* `%H`, `%M`, `%S`: hour, minute, second; 0-pad
* `%f`: microseconds (<=999999); 0-pad
* `%p`: AM or PM for current locale
* `%z`, `%Z`: UTC offset (+/-0000), time zone name (empty if object is naive)
* `%c`, `%x`, `%X`: locale-appropriate datetime, date, time representation

Python ≥ 3.6 adds the following (non-C standard):
* `%G`: ISO 8601 year containing greater part of date's ISO week
* `%u`: ISO 8601 weekday (1=Monday)
* `%V`: ISO 8601 week starting Mon; week 01 contains Jan 4 (see [isocalendar])


dateutil
--------

[`dateutil`], [`dateutil.tz`]
XXX



[IANA]: https://www.iana.org/time-zones
[`date`]: https://docs.python.org/3/library/datetime.html#date-objects
[`datetime`]: https://docs.python.org/3/library/datetime.html
[`dateutil.tz`]: https://dateutil.readthedocs.io/en/stable/tz.html
[`dateutil`]: https://dateutil.readthedocs.io/en/stable/index.html
[`time`]: https://docs.python.org/3/library/datetime.html#time-objects
[`timedelta`]: https://docs.python.org/3/library/datetime.html#timedelta-objects
[`timezone`]: https://docs.python.org/3/library/datetime.html#timezone-objects
[`tzinfo`]: https://docs.python.org/3/library/datetime.html#tzinfo-objects
[datetime-obj]: https://docs.python.org/3/library/datetime.html#datetime-objects
[isocalendar]: https://www.staff.science.uu.nl/~gent0113/calendar/isocalendar.htm
[strftime]: https://docs.python.org/3/library/datetime.html#strftime-strptime-behavior
