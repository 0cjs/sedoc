TOML: An INI-like Configuration Language
========================================

"Tom's Obvious, Minimal Language" by Tom Preston-Warner. There's a
brief description at [Wikipedia], and the readme on [GitHub] gives
full details.

Configs map unambiguously to hash tables.

Example
-------

    #   Hashes mark the rest of the line as a comment

    Top = "A top-level value; case-sensitive."

    [group1]
        desc = "Accessible as `group1.desc` in your hash"
        [subgroup]
            indentation = "Is allowed, but not required"

    ["keys and types"]
    ''              = "Empty keys are strongly discoruaged."
    string          = 'The "usual" string.'
    number.int      = 1234                  # same as subgroup [number]
    number.float    = 6.62607015e-34
    bool = true
    date = 1979-05-27T07:32:00-08:00
    'list ("array")' = [
        [true, false],     # Line breaks ok in lists only
        [-1, 0, 1],
        ["a", "b", "c"]
    ]
    #   XXX inline table?

    # Defining a key multiple times is invalid.
    # Defining subkeys on a key that's not a hash is disallowed.



<!-------------------------------------------------------------------->
[GitHub]: https://github.com/toml-lang/toml
[Wikipedia]: https://en.wikipedia.org/wiki/TOML
