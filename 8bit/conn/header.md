.1" Pin Headers
===============

<!-- Digraphs: ▼=Dt ▄=LB -->

Pin headers are used both for ribbon cable with BT224 IDC connectors (as
used for PC internal drives) and individually crimped; my numbering tries
to keep these compatible. IDC connectors on ribbon cables are almost
invariably female, so boards generally use male connectors.

The guide protrusion in the middle of the connector faces up; looking into
the female IDC connector on a ribbon cable pin 1 will be at top left, with
pin 2 immediately below it. The male connector on a device is thus reversed.

            Looking Into
      Female Cable   Male Device
        ▼  ▄              ▄  ▼
        1 3 5 7        7 5 3 1      alternative numbering A1, A2, ...
        2 4 6 8        8 6 4 2      alternative numbering B1, B2....

Dupont crimp kit shrouds have markings for male connectors; pin 1 will
be at the opposite end from that marked when female inserts are used.

#### Grounds

When using alternate grounding (i.e., every signal line is pared with an
adjacent ground line), pins 1, 3, 5, ... are ground. (This follows the
standard used for floppy drive cables.)
