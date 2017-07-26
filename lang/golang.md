Go Language Notes
=================

Running and Testing
-------------------

[How to Write Go Code](https://golang.org/doc/code.html) is a brief
overview of the development environment and its customary use.
[Effective Go](https://golang.org/doc/effective_go.html) covers
conventions in much more detail and is also a high-density
introduction to what makes the language different from other
languages.

A quick place to run small language experiments is in the [Go Tour](
https://tour.golang.org/). Use `import "fmt"` and `fmt.Println(x)` to
print-debug.

Language Features
-----------------

### Interfaces

    type I interface { M() }
    type T struct { S string }
    func (t *T) M() {
        if t == nil { fmt.Println("<nil>")
             } else { fmt.Println(t.S) }
    }
    func main() {
        var i I
        i = &T{"hello"}; i.M()
        var t *T = nil; i = t; i.M()    // Just `i = nil` gives SEGV
    }

Think of `i` above as a runtime tuple of a `(*T, type-tag)` (as
printed by format string `"(%v, %T)"`). Note this difference:

    t = nil; i = t  // (nil, *T):  i.M() reciever var `t` is nil
    i = nil         // (nil, nil): i.M() call crashes with SEGV

Empty interface holds any value/type:

    func describe(i interface{}) {
        fmt.Printf("(%v, %T)\n", i, i)
    }

Type checks:

    var i interface{} = "hello"
    x, ok := i.(float)      // ⇒ "zero value", false
    x     := i.(float)      // panic
    t := i.(type)           // t == `bool`, `int`, `string`, etc.

Sandbox at [tour/methods12](https://tour.golang.org/methods/12).


### Struct Embedding

(This also applies, more simply because no data, to interfaces.)

Structs containing unnamed references to other structs "embed" a copy
of that struct in themselves, allowing access to the "sub-struct"
fields directly:

    type Alice struct { a int }
    type Bob   struct { b bool }
    type Sub   struct { aa Alice; bb Bob }
    type Embed struct { Alice; Bob }

    var s Sub   = Sub{Alice{13}, Bob{true}}
    var e Embed = Embed{Alice{13}, Bob{true}}

    func main() {
        fmt.Println(s, s.aa, s.bb, s.aa.a, s.bb.b)
        // fmt.Println(s.a)
        //      => "s.a undefined (type Sub has no field or method a)"
        fmt.Println(e, e.a, e.b, e.Bob.b)
    }

Note the type name can be used for disambiguation, `e.Bob.b`; you may
not embed the same type twice.

The embedded structs are still separate types and data as far as
method calls are concerned:

    func (b Bob) printBob() { fmt.Println(unsafe.Sizeof(b) }

`unsafe.Sizeof(e)` is 8, but `e.printBob()` will print 1.


### First-class Functions

[Codewalk: First-Class Functions in Go](
https://golang.org/doc/codewalk/functions/)
