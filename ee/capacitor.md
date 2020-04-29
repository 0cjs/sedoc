Capacitor Notes
===============

Bypass Caps
-----------

[Wikipedia][wp-decoup-cap] mentions ~100 nF ceramic per IC with
up to a few hundred μF electrolytic/tantalum per board section.
Cypress note [Using Decoupling Capacitors][cypress-decoup] goes
into much more detail.


General Notes
-------------

#### Ceramic

- Derating voltage changes life from order of a hundred to a thousand
  years.
- Capacitance may fall of dramatically as applied voltage (DC bias)
  approaches the rated voltage, especially for smaller caps. E.g., 10
  nF 6.3 V in [1210] is pretty flat out to 6 V, but the same as 0805
  is 5% down at 2 V and 40% down at 6 V. ([[ksim]] can give these
  graphs.)
- "Age" reduces capacitance; this is actually time post-heat, and will
  be reset if you run it through the reflow oven again. (Don't
  calibrate for a few days after reflow!) But this is under 10% loss
  over 100,000 hours.
- X7R/X5R bad w/AC because the dipoles heat just due to the changing
  electric field, even if current is very low.

#### Aluminum Electrolytic

- Anode and cathode plates are both Al; dielectric is actually a layer
  of oxide grown on the anode plate. Electrolyte fluid connects
  dielectric to cathode plate.
- Much more capacitance/size because dielectric layer is etched with
  many "valleys" giving much more surface area.
- Over time dielectric gets eaten away by electrolyte (even when on
  shelf), reducing capacitance.
- Applying voltage (slowly ramp up) can reform dielectric (on other
  side), but that pulls oxygen from the electrolyte, drying out the
  cap and increasing ESR.
- Wearout not on aluminum polymers, only "wet" electrolytics.
- Derate to increase life, if you want.

#### Tantalum Electrolytic

- Band is often positive, not negative!
- Most volumetrically efficient.
- Polarized. (Non-polarized are two in series w/anodes in opposite
  directions.)
- Stable, reliable, exceeds expected life of all hardware.
- Solid (MnO₂) electrolyte:
  - Long-term stable; failure generally on power application.
  - Cracks/impurities in Ta₂O₅ cathode can cause exothermic
    electrolyte reaction 2 MnO₂ → Mn₂O₃ + O; self-healing unless
    happens too fast (Mn₂O₃ is _very_ low conductance).
  - Catastrophic failure can result in high currents (unless limited)
    and burnup. Protect with derating, 3 Ω series resistor, slow powerup.
- Polymer electrolyte:
  - Over time ESR increases
  - Failure is less catestrophic (down to 10-100 Ω) because polymer
    electrolyte reaction similar to above absorbs oxygen.
- Voltage derating guidelines:
  - Tantalum MnO₂: 50%
  - Tantalum polymer: 20% (>10 V); 10% (≤10 V)
  - Aluminum polymer: 0%

#### "Supercapacitors"

- Electrostatic double-layer capacitors (EDLCs)
- Dip solid anode into an electrolyte w/ions that are attracted to the
  anode/cathode surafce and become the dielectric. Very thin, so very
  low breakdown voltage.
- Generally 1-3 V, and 3 V would be series caps.
- Hybrids add an Li-ion battery to the cathode for more capacity, but
  supposedly giving power delivery of a cap.

### Sources and References

- [[lewis]] [James Lewis - They're JUST Capacitors][lewis] (YouTube, 50 min.)
- [[ksim]] Kemet K-Sim capacitor simulator




<!-------------------------------------------------------------------->
[cypress-decoup]: http://www.cypress.com/file/135716/download
[lewis]: https://www.youtube.com/watch?v=ZAbOHFYRFGg
[wp-decoup-cap]: https://en.wikipedia.org/wiki/Decoupling_capacitor
[1210]: https://en.wikipedia.org/wiki/Surface-mount_technology#Packages
[ksim]: http://ksim.kemet.com/
