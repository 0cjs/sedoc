Python Names, Binding and Namespaces
====================================

> _Namespaces are one honking great idea -- let's do more of those!_  
> _--The Zen of Python ("`import this`")_

The primary documentation for this is the [Execution model] section of
the Python 3 reference and the [Scopes and Namespaces] section of the
[Classes] tutorial. [Wikipedia] also has a useful summary.

Python programs are constructed from _code blocks_: modules, function
bodies, and [class definitions]. Blocks are executed as a unit and
each block has its own _namespace_, a map of name → value bindings
accessible as attributes on the object where one exists (modules,
classes and class instances, but not stand-alone functions). In
CPython the namespace is stored as the [`__dict__`] attribute on the
object but this is probably implementation-dependent.

There are four categories of namespace that are searched in 'LEGB'
order to find the nearest in-scope binding:

1. (__L__) The local namespace of currently executing function or
   class definition.
2. (__E__) The namespaces of lexically enclosing functions or class
   definitions. `locals()` returns the current function or class's
   namespace dictionary.
3. (__G__) The namespace of the current module, refered to (perhaps
   misleadingly) as a 'Global' namespace. (It is not shared in any
   way with other modules.) `globals()` returns the current module
   object's namespace dictionary. (Use `sys.modules[__name__]` to
   get the module itself.)
4. (__B__) The namespace of the [`builtins`] module. This is the
   outermost scope and is accessible from everywhere. The CPython
   implementation also makes this available via the `__builtins__`
   global set in every module namespace.

Two namespaces are created when the interpreter starts: the _builtin_
namespace on the `builtin` module and a 'global' namespace on the
`__main__` module in which the top-level code runs. (Well, typically
more will be created for other modules that are loaded at startup
time.)


Binding
-------

Bindings are created with any of the following statements:

1. Assignment: `x = ...`.
2. `global x` and `nonlocal x`, which bind _x_ to an enclosing block's
   _x_ and the current module's _x_, respectively. In both cases you
   may change the binding and that will be reflected in the encloser's
   binding.
3. Various forms of the `import` statement.
4. `def x():`
5. `class x:`

These all create a binding that applies to the entire block, both
before and after the statement creating the binding, though the
variable will be unbound before the statement that creates the
binding. Thus,

    x = 1
    def f():
        print('x=%s' % x)
        x = 3    
    f()

    ⇒ UnboundLocalError: local variable 'x' referenced before assignment


Classes
-------

Class definitions are executed to build the class; they have their own
namespace (for class variables, including functions) while executing
and the bindings become available as attributes on the class object.
Instance variables are referenced explicitly as attributes the first
(`self`) parameter passed to instance functions.

    class C:
        c = 1
        @staticmethod
        def s(cls): pass
        def f(self):
            self.i = 2

    o = C()
    C.c                 # class variable        ==> 1
    C.s                 # class method          ==> <function __main__.C.s>
    C.f                 # instance method       ==> <function __main__.C.f>
    o.f(); o.i          # instance variable     ==> 2


Exception Hierarchy
-------------------

    +-object
      +-Exception
        +-BaseException
          +-NameError
            +-UnboundLocalError



[`__dict__`]: https://docs.python.org/3/library/stdtypes.html#object.__dict__
[`builtins`]: https://docs.python.org/3/library/builtins.html
[class definitions]: https://docs.python.org/3/reference/compound_stmts.html#class
[classes]: https://docs.python.org/3/tutorial/classes.html
[execution model]: https://docs.python.org/3/reference/executionmodel.html
[scopes and namespaces]: https://docs.python.org/3/tutorial/classes.html#python-scopes-and-namespaces
[wikipedia]: https://en.wikipedia.org/wiki/Scope_(computer_science)#Python
