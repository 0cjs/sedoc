Argument Parsing
================

The most commonly used library for argument parsing is `argparse`,
though there is also a [`getopt`] which is slightly less Python and
more Gnu-flavoured. The old `optparse` is deprecated.

[argparse] Summary
------------------

#### Example

    #   Setup
    from argparse import ArgumentParser
    p = ArgumentParser(description='''
        Summary of what this program does.
        And details on further lines.''',
        epilog='Text after options are listed')

    #   Flags
    p.add_argument('-q', '--quiet', action='store_true')
    p.add_argument('-n', '--count', type=int, default=10) # Option takes a param
    p.add_argument('-i', '--invert', default=1, action='store_const', const=-1)
    p.add_argument('--required', help='Must be specified as `--required VALUE`')
    p.add_argument('--str', dest='types', action='append_const', const=str)
    p.add_argument('--int', dest='types', action='append_const', const=int)

    #   Positional args
    p.add_argument('input', help='input file (required)')
    p.add_argument('second', nargs='?', default=None, # e.g., sys.stdout
                   help='output file(optional)')
    p.add_argument('remainder', nargs='*')

    #   parsing
    args = p.parse_args('-qi -n 5 sourcefile'.split())  # default is `sys.argv`
    print(vars(args))   # argparse.Namespace object

#### Setup

There's signficantly more flexability than shown here, including
disabling abbrevations and reading args from files. See
[ArgumentParser] for more options.

Arguments can be broken down into groups by putting them into separate
`ArgumentParser`s (init with `add_help=False` to avoid conflicting
`-h` args) and then using the `parents=[...]` option to add them to a
top-level parser. This can also be used for [subcommands].

#### Flags

See [`add_argument()`] for the full set of options. Briefly:
* `action`
  * `store`: Stores value (default)
  * `store_const`: Stores value set by `const` argument (defaults to None)
  * `store_true`, `store_false`: Stores boolean and sets default to negation
  * `append`: Stores a list (`None` if no args) and appends each arg to it
  * `append_const`: As append but stores `const`, useful with `dest`:
  * `count`: Stores count of times specified, e.g., for verbosity
  * `help`: Prints help message (added as `-h` and `--help` by default)
  * `version`: Prints `version=` argument given to `ArgumentParser`
  * Pass an [`Action`] (extending `__call__` and `__init__`) to customize
* `nargs`: args to consume following flag (default determined by `action`).
  * `None`: Stores a scalar
  * `1`: Stores a list of one item.
  * `'?'`: Consumes if it can, otherwise stores `default`
  * `'*'`, `+`: Stores list of all remaining args, `+` requires at least one
  * `argparse.REMAINDER`: Gathers unparsed options into a list somehow
* `const`: Used with `store_const`, `append_const`, `nargs='?'`.
* `default`: If string, parsed as if it were specified on command line.
  `argparse.SUPPRESS` leaves attribute off result if not on command line.
  Also see [`set_defaults()`] to set defaults separately and to add
  attributes not specified with `add_argument()`.
* `type`: Can be `int`, `float`, `open`, etc.; any callable that takes a
  `string` and returns a value. (`raise argparse.ArgumentTypeError(msg)`
  on parse error.) For default `open()` params use
  `argparse.FileType('w', mode=..., encoding=...)`
* `choices`: Container of valid values; checked after type conversion.
  Can be any object that support `in` operator (`dict`, `set`, etc.).
* `required`
* `metavar`: Value placeholder printed in help message.
* `dest`: Name of attribute on returned parsed args object.
  Can be the same for multiple options.

Arguments can be grouped in the help with [`add_argument_group()`].
There's also `add_mutually_exclusive_group()`.

#### Parsing

The parser will accept `-n 3`, `--count 3` or `--count=3`. It will
accept abbreviations unless disabled with `allow_abbrev=False`. See
[Arguments containing -][arg-] for a note on ambiguity.

The parser returns an `argparse.Namespace` object; you can specify an
existing object to have it add attributes to that.

The parser does not modify its input. 



[ArgumentParser]: https://docs.python.org/3/library/argparse.html#argumentparser-objects
[`Action`]: https://docs.python.org/3/library/argparse.html#argparse.Action
[`add_argument()`]: https://docs.python.org/3/library/argparse.html#the-add-argument-method
[`getopt`]: https://docs.python.org/3/library/getopt.html
[`sys.argv`]: https://docs.python.org/3/library/sys.html#sys.argv
[arg-]: https://docs.python.org/3/library/argparse.html#arguments-containing
[argparse]: https://docs.python.org/3/library/argparse.html
[subcommands]: https://docs.python.org/3/library/argparse.html#sub-commands
[`add_argument_group()`]: https://docs.python.org/3/library/argparse.html#argument-groups
[`set_defaults()`]: https://docs.python.org/3/library/argparse.html#argparse.ArgumentParser.set_defaults
