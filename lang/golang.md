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
        if t == nil { fmt.Println("<nil>"); return }
        fmt.Println(t.S)
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
