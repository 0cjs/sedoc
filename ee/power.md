Power Supplies and AC Power
===========================

- _Inlets_ (or _receptacles_) are always male.
- _Outlets_ are always female.

AC Polarity
-----------

References:
- EE SE [Difference between Line and Neutral in AC][se ee 38666]
- EEVblog forum post [IEC plug/socket...live vs neutral?][eevb lvn]

In home AC circuits, the hot line swings positive and negative relative to
neutral, and neutral should stay close to ground potential. Measuring the
potential between each of the conductors and ground can tell you which one
is neutral.

Neutral/hot polarization is usually not available outside of North America,
even on grounded outlets. Many European [CEE7][wp cee7] outlets are not
polarized and and for e.g. German Schuko socket the polarization depends on
which way you plug it in.


NEMA Connectors
---------------

Suffixes: outlets `R` (receptacle), inlets `P` (plug).

[NEMA 1-15][wp nema1] (2 vertical blades, 125 V 15 A max). May be polarized
with large blade neutral and small blade hot (usually in NA, never in
Japan), otherwise both blades small. Outlets may have additional ground
screw; common in Japan.

NEMA 1-20 (125 V 20 A max) has T-shaped neutral.

[NEMA 5-15][wp nema5] (NA standard 3-prong, 125 V 15 A max) outlet
(female) is as follows.

    looking into        Neutral: taller blade
         N H                Hot: shorter blade
          G              Ground: U-shaped
    female outlet

NEMA 5-20 (125 V 20 A max) is the same except that the neutral slot is
T-shaped.


IEC Connectors
--------------

#### C1 Outlet (feamale / C2 Inlet (male)

2 pins, not polarized, rectangular shape (no indents).
Do not confuse with C7/C8. Used for shavers.

#### C5 Outlet (female) / C6 Inlet (male)

3 pins, polarized, "Cloverleaf" or "micky mouse" shape.
Small devices, North American laptop PSUs, my SFF PCs.
2.5 A, 70°C. [Wikipedia][wp c5/c6].

#### C7 Plug (female) / C8 Inlet (male)

2 pins, not polarized, "Infinity" shape.
Many laptop PSUs, including my Thinkpads.
2.5 A, 70°C. [Wikipedia][wp c7/c8].

#### C13 Plug (female) / C14 Inlet (male)

[Wikipedia][wp c13/c14]. 3 pins, polarized, 10 A, 70°C. "IEC cords."
Computers, monitors, etc. Neutral/hot polarity taken from [[e2Kuk]]; an
Amazon.co.jp C14-C13 cable matches this. But this cannot be relied upon as
the wall end may not be polarized or the cable may be wired wrong.


       inlet       plug     viewed from front (user) side
       _____       _____
      /  G  \     /  G  \    G  ground   green+yelow
     | H   N |   | N   H |   N  neutral  white, blue, grey
     +-------+   +-------+   H  hot      black, brown
       male        female


Voltage Regulators
------------------

Generally voltage regulators (linear and switching) will be damaged if
biased in reverse (output voltage significantly higher than input voltage,
or sometimes even not enough lower). As noted at [[f6 p86851]], the Recom
R-78xx-1.0 datasheet offers two solutions, one keeping in ≥ out - 0.7 V via
a diode from output to input and the other keeping in ≥ out but with 0.3 V
output drop via a zener diode on the output:

<img src='sch/recom-protection.jpg' width='80%'>

Another option, if using an external PSU that produces the required
regulated voltage, is to connect it to both the output _and input_ of the
regulator, as described in [[eese 552710]]. This should still be confirmed
with the data sheet, however; it is usually safe for linear regulators, but
not for buck-boost regulators that may also pull down the output.

### Constant Current Supply

The LM317 maintains a constant 1.25 V between the reference pin and the
output pin; this can set the output to any arbitrary voltage by putting the
reference in the middle of a voltage divider between output and ground.

However, if you connect the output to the reference via a resistor R (with
no connection to ground) you'll produce a constant current power supply
supplying A = 1.25 V / R.

<img src='sch/lm317-cc.jpg' width='300px' />

This will work with higher voltage regulators such as the 7805, but they
will have to drop more voltage across R and thus be more wasteful (and you
the resistor will generate more heat).


<!-------------------------------------------------------------------->

[eevb lvn]: https://www.eevblog.com/forum/beginners/iec-plugsocket-live-vs-neutral/
[se ee 38666]: https://electronics.stackexchange.com/q/38666/15390
[wp cee7]: https://en.wikipedia.org/wiki/AC_power_plugs_and_sockets#CEE_7_standard

[wp nema5]: https://en.wikipedia.org/wiki/NEMA_connector#NEMA_5
[wp nema1]: https://en.wikipedia.org/wiki/NEMA_connector#NEMA_1

[e2Kuk]: https://www.electronics2000.co.uk/pin-out/iec.phprecep
[wp c13/c14]: https://en.wikipedia.org/wiki/IEC_60320#C13/C14_coupler
[wp c5/c6]: https://en.wikipedia.org/wiki/IEC_60320#C5/C6_coupler
[wp c7/c8]: https://en.wikipedia.org/wiki/IEC_60320#C7/C8_coupler

[f6 p86851]: http://forum.6502.org/viewtopic.php?f=12&t=6760#p86851
[eese 552710]: https://electronics.stackexchange.com/a/552710/15390
