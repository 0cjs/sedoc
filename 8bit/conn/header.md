.1" Pin Headers
===============

<!-- Digraphs: ▼=Dt ▄=LB ▂=U+2582 lower one quarter block -->

Pin headers are used both for ribbon cable with BT224 IDC connectors (as
used for PC internal drives) and individually crimped; my numbering tries
to keep these compatible. IDC connectors on ribbon cables are almost
invariably female, so boards generally use male connectors.

The guide protrusion in the middle of the connector faces up; looking into
the female IDC connector on a ribbon cable pin 1 will be at top left, with
pin 2 immediately below it. The male connector on a device is thus reversed.

            Looking Into
      Female Cable   Male Device
        ▼  ▂              ▂  ▼
        1 3 5 7        7 5 3 1      alternative numbering A1, A2, ...
        2 4 6 8        8 6 4 2      alternative numbering B1, B2....

Dupont crimp kit shrouds have markings for male connectors; pin 1 will
be at the opposite end from that marked when female inserts are used.

#### Grounds

When using alternate grounding (i.e., every signal line is pared with an
adjacent ground line), pins 1, 3, 5, ... are ground. (This follows the
standard used for floppy drive cables.)


Standards and Suggestions
-------------------------

### DC Power Supply

8-pin 2×4 "dupont" header for multi-voltage DC to small systems. With the
KEY blocked on the PSU side and the middle GND pin always present on the
equipment side, the connector cannot be inserted the wrong way around so
long as all the pins are aligned. (This could be improved with a better
connector; dupont is a bit of a hack for this.)

    female PSU side     male equipment side
    GND GND +12 -12      -12 +12 GND GND        GND pins required
    +5V +5V KEY -5V      -5V KEY +5V +5V        KEY slot must have no pin

    GND black   +12V yellow   -12V blue         Colors are ATX standard.
    +5V red                    -5V white

Using [calculator.net][calcnet vd], expected voltage drops for a 1.5 m PSU
cable are:

    GND, +5V   2× 18 AWG (0.82 mm²)   3.0 A   1.9%    4.91 V
                                      5.0 A   3.2%    4.84 V
        ±12V   1× 20 AWG (0.50 mm²)   1.0 A   0.9%  ٍ±11.9  V
         -5V   1× 20 AWG (0.50 mm²)   0.5 A   1.0%    4.95 V

(Testing so far over 2×18AWG has seen drops: 5.00→4.87 V @3.0 A;
5.00→4.82 V @4.0A; 4.99→4.76 0.00→0.10 V @5.0 A.)

The equipment side will typically be a short cable with the male power
connector on one end and a system-specific connector on the other (barrel
of either polarity, DIN, etc.) or a pigtail connected directly to the
motherboard.

Heat shrink is placed on a) individual spade lugs, b) along wire bundle,
and c) on dupont header. Chokes should be added to reduce noise.

[calcnet vd]: https://www.calculator.net/voltage-drop-calculator.html

### Motorola PIA (6820, 6821, 6522, 6526, etc.)

Darrel Rictor, creator of several SBCs and active on forum.6502.org, has a
[pinout for the parallel ports of a 6522][rictor via] and several
periperhals. It uses two 2×7 headers separated by 0.5" so that a single
2×18 header can be used to connect both at once.

    GND PA1 PA3 PA5 PA7 CA2 +5V  .   .   .   .  GND PB1 PB3 PB5 PB7 CB2 +5V
    GND PA0 PA2 PA4 PA6 CA1 +5V  .   .   .   .  GND PB0 PB2 PB4 PB6 CB1 +5V

The [Ancientcomputing RC2014 6522 board][ancomp 6522] is the reverse of
this, counting up port bits in pin numbering direction:

    +5V CA1 PA6 PA4 PA2 PA0 GND
    +5V CA2 PA7 PA5 PA3 PA1 GND


[rictor via]: https://sbc.rictor.org/via.html
[ancomp 6522]: https://github.com/ancientcomputing/rc2014/tree/master/eagle/6522_board
