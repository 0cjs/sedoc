jq - Command-line JSON Processor
================================

The [manual] is a web version of the manpage.

The jq language is basically filter combinators (even literals are
filters with constant output) whose inputs and outputs are wired
together to make the overall filter executed by the command-line tool.
A filter that produces multiple results on its output will run filter
to which it's wired multiple times.

The language is rich, including conditionals, comparisons, variables
(rarely needed), functions, recursion with tail-call optimization,
math, I/O, and a module system.

[jqplay] offers a web REPL, including a cheat-sheet with examples.


Filters
-------

Basic filters:
- `.`: identity
- `.name`: Dictionary index.
  - For non-identifier keys, use `.["name"]`.
  - `.name?` for no output instead of error when field not present.
  - `.abc.def` == `.abc|.def`.
- `.[0]`: Array index.
  - `.[-1]` is the last element.
  - `.[7:10]` slices, giving indices 7-9.
  - `.[]` gives all elements of the array.
- `,`: Parallel filters duplicating input; output in order listed.
  Entire set of filters will be run once for each input object when
  predecessor produces multiple objects as output: `.[] | .id, .name`
  will produce alternating lines of _id_ and _name_.
- `|`: Output of left filter to input of right. E.g., `.[] | .name`.
  As above, `.a.b` == `.a | . | .b`.
- `()`: Grouping.


Sample Queries
--------------

In the terminology here, an 'Array' is specifically a JSON array
object:

    [ { "Name": "foo", "Value": "bar" }, { "Name": "baz", "Value": "quux" } ]

and a 'List' is a sequence of one or more JSON objects not in an array
(usually one per line):

    { "Name": "foo", "Value": "bar" }
    { "Name": "baz", "Value": "quux" }

`jq` generally works on the latter, and uses the `.[]` operator to
deconstruct the former to the latter.


### Field Selection and Extraction

Input JSON (basic structure; many fields removed):

    {
      "Reservations": [
        {
          "ReservationId": "r-00000000",
          "Instances": [
            {
              "VpcId": "vpc-00000000",
              "InstanceId": "i-00000000",
              "Tags": [
                {
                  "Key": "foo"
                  "Value": "bar"
                }
                {
                  "Key": "Name"
                  "Value": "Elizabeth"
                }
                {
                  "Key": "baz"
                  "Value": "qux"
                }
              ]
            }
          ]
        }
      ]
    }

Query:

    aws ec2 describe-instances | jq -c '
      .Reservations[].Instances[]
          | { InstanceId, Name:.Tags[] | select(.Key == "Name").Value }
      '

1.  `.`: For each root object:

        { "Reservations": [ ... ] }     // Just one root in this query

2.  `Reservations`: Value(s) of key 'Reservations' (in this case, an
    array):

        [{"ReservationId": ...}, {"ReservationId": ...}, ...]

3.  `[]`: List of array elements

        {"ReservationId": ..., "Instances": [ { VpcId": "vpc-0", ... } ], ...}
        {"ReservationId": ..., "Instances": [ { VpcId": "vpc-1", ... } ], ...}
        ...

4.  `.Instances[]`: As steps 2/3 above:

        { "VpcId": "vpc-0", "Tags": [...], ... }
        { "VpcId": "vpc-1", "Tags": [...], ... }
        ...

5.  `| { ... }`: Output of prev stage goes into an object constructor.

        { ... }
        { ... }
        ...

6.  `InstanceId`: Short for `InstanceId: .InstanceId`; add object field.

        { "InstanceId": "i-0", ... }

7.  `Name:`: Add second object field under key 'Name'.

        { "InstanceId": "i-0", "Name": ... }

8.  `.Tags[]`: List of all elements in array value of key `Tags`,

            { "Key": "foo", "Value": "var" }
            { "Key": "Name", "Value": "Elizabeth" }
            { "Key": "baz", "Value": "qux" }

9.  `| select(.Key == "Name")`: Select only objects where value of key
    '.Key' is "Name":

            { "Key": "Name", "Value": "Elizabeth" }

10. `.Value`: Produce value of key 'Value' on above object:

            "Elizabeth"

11. Value from 8-10 is value of 'Name':

        { "InstanceId": "i-0", "Name": "Elizabeth" }



<!-------------------------------------------------------------------->
[jqplay]: https://jqplay.org/
[manual]: https://stedolan.github.io/jq/manual/
