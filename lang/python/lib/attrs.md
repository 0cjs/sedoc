attrs: Classes without Boilerplate
==================================

[`attrs`] decorates a class with initializers, accessors, validation
code, comparison operators, str/repr, etc. This is done immediately
after the definition: the resulting classes are regular classes in all
ways. It (optionally) uses a slightly cutesy syntax of words starting
with `attr` with a dot in the middle to give them an explicit
namespace.

    import attr
    @attr.s                                     # Required for setup to work
    class C:
        x  = attr.ib(default=2)
        xs = attr.ib(factory=list)
        ys = attr.ib()
        @ys.default                             # Factory for default value
        def init_ys(self):
            return list(reversed(self.xs))
        def __attrs_post_init__(self):          # Called at end of __init__()
            pass

    from attr import attrs, attrib, Factory
    @attrs
    class D:
        x  = attrib(default=2)
        xs = attrib(default=Factory(list))

    E = attr.make_class('E', ['x', 'xs'])

    @attr.s
    class F:
        _p1 = attr.ib()                         # Init with F(p1=1)
        _p2 = attr.ib(init=False, default=3)    # p2 cannot be passed to F()

    #   Existing classes may have the methods added as well.
    class G:
        def __init__(self, x): self.x = x
    G = attr.s(these={ 'x': attr.ib() }, init=False)(G)

Subclassing works as usual, with attribute order defined by the [MRO].

Nested classes are automatically [detected] in Python 3; in 2 you need
need to mark them manually:

    @attr.s
    class H(object):
        @attr.s(repr_ns='H')
        class I(object): pass


API
---

##### Class definition dectorator and runtime class constructor:

* `@attr.s()`, `@attrs()`: Generate boilerplate for the following
  class definition. Parameters:
  - `kw_only=False`: If true, init arguments are not positional by
    default.
  - `frozen=False`: If true, constructed objects are immutable(ish).
* `attr.make_class(name, attrnames)`: Parameters:
  - `bases=(,)`: Sequence of class objects to be superclasses.
  - `cmp=True`: If false, do not generate comparison function.

##### Attribute definitions:

* `attr.ib()`, `attrib()`: Return a marker (`attr.ib` instance) for an
  attribute for which boilerplate should be generated after the class
  definition is complete. Parameters:
  - `kw_only=False`: If true, make it a keyword-only init param.
  - `init=True`: If false, do not initialize the property on
    construction.
* `@x.default`, where _x_ is a previously defined attribute, makes the
  following function definition a function that is called with the
  partially initialized instance; the returned value is used as the
  attribute initial value.

##### Object queries:

* `attr.asdict(o)`, `attr.astuple(o)`: Given an instance `o`, return a
  dictionary of its current attribute-value mappings or a tuple of its
  attribute values. Parameters:
  - `filter`: Function or lambda taking `name, value` parameters and
    returning `False` for any attributes that should not be included
    in the dictionary. Helpers include:
    `attr.filters.{include,exclude}`.
* `attr.evolve(o, **resets)`: Produce a copy with substituted
  parameters. Usually used with frozen instances.


Not Yet Covered Here
--------------------

- Validators.
- Conversion (e.g., to force param to an `int`)
- Metadata
- Types
- [Slots]
- Full API. (What's below is incomplete.)



[MRO]: https://www.python.org/download/releases/2.3/mro/
[`attrs`]: https://www.attrs.org/
[detected]: https://www.python.org/dev/peps/pep-3155/
[slots]: https://www.attrs.org/en/stable/glossary.html#term-slotted-classes
