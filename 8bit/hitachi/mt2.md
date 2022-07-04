MT-2 OS V1.1
============

Not clear what this is, but it's something in the MB-6885 printer ROM;
`CALL $E42B` to start it. After it times out with `NOT READY`, the
following commands are available at the `:` prompt:

    E   Exit: go to monitor
    I   asks SURE?
    K   asks FILE NAME:
    L   asks FILE NAME:
    P   asks FILE NAME:, FROM (def. 0142), TO (def. 014C)
    V   asks FILE NAME:
    W   does nothing?
