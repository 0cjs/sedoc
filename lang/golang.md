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

### [Blank Identifier]

You can assign to `_` to discard a value; this is used for ignored
values:

    if _, err := os.Stat(path); os.IsNotExist(err) {
        fmt.Printf("%s does not exist\n", path)
    }

and for suppressing unused import/var warnings during development:

    import ("fmt"; "log"; "os")
    var _ = fmt.Printf          // We compile without debugging printfs
    func main() {
        fd, err := os.Open("test.go")
        if err != nil { log.Fatal(err) }
        _ = fd  // TODO: use fd.
    }

Also for importing a package just for its side effects:

    import _ "net/http/pprof"

Also for forcing static checks of an interface when there are no
static conversions in the code that would already do that:

    // Compiler asserts that *RawMessage implments json.Marshaller
    var _ json.Marshaller = (*RawMessage)(nil)

### [Interfaces]

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
    x, ok := i.(float64)      // ⇒ "zero value", false
    _, ok := i.(float64)      // Check only; not a float64.
    x     := i.(float64)      // panic

    switch t := t.(type) {
    default:    fmt.Printf("unexpcted type %T\n", t)
    case bool:  fmt.Printf("boolean %t\n", t)
    case *bool: fmt.Printf("pointer to boolean %t\n", *t)
    }

Sandbox at [tour/methods12](https://tour.golang.org/methods/12).


### [Struct Embedding]


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


### [Struct Composition]

To replace specific functions within a structure but inherit the rest,
use struct embedding as above. E.g., to replace just the `io.Writer`
in a `net.Conn`:

    type recordingConn struct { net.Conn; io.Writer }
    func (c *recordingConn) Write(buf []byte) (int, error) {
        return c.Writer.Write(buf)
    }

    func main() {
        client, server := net.Pipe()
        var buf bytes.Buffer
        client = &recordingConn { client, io.MultiWriter(client, &buf), }
    }

A detailed tutorial available at Dave Cheney's [Struct Composition]
blog post.


### First-class Functions

[Codewalk: First-Class Functions in Go](
https://golang.org/doc/codewalk/functions/)



-----

[Blank Identifier]: https://golang.org/doc/effective_go.html#blank
[Struct Embedding]: https://golang.org/doc/effective_go.html#embedding
[Struct Composition]: https://dave.cheney.net/2015/05/22/struct-composition-with-go
[Interfaces]: https://golang.org/doc/effective_go.html#interfaces_and_types
