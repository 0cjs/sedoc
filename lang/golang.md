Go Language Notes
=================

Running and Testing
-------------------

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
