Sample [`jq`] Queries
=====================

In the terminology here, an 'Array' is specifically a JSON array
object:

    [ { "Name": "foo", "Value": "bar" }, { "Name": "baz", "Value": "quux" } ]

and a 'List' is a sequence of one or more JSON objects not in an array
(usually one per line):

    { "Name": "foo", "Value": "bar" }
    { "Name": "baz", "Value": "quux" }

`jq` generally works on the latter, and uses the `.[]` operator to
deconstruct the former to the latter.


Field Selection and Extraction
------------------------------

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



[`jq`]: https://stedolan.github.io/jq/manual/
