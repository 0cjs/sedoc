Operational Amplifiers
======================

__Rule:__ No current flows in to or out of the inputs.

As a comparator:
output indicates V+ > V-: i.e., near Vcc if true, near GND if false.

### Comparators vs. Op-Amps

Comparators are:[[ig1086]]
- at least 10x faster
- won't get stuck on a rail (op-amps don't like to go full swing)
- usually open-collector output

Comparator hysteresis:  
![Comparator hysteresis](sch/comparator-hysteresis.jpg)

### References

- [[ig1086]] IMSAI Guy #1086 Comparator Hysteresis


Build Notes
-----------

- Use a bypass cap near supply pin?


Parts Guide
-----------

### LM324

- [LM324N][TI LM324-N-MIL] (14): Low-power quad operational amplifier
  - Pins: `O1 I1- I1+ V+ I2+ I2- O2 ‥ O3 I3- I3+ GND I4+ I4- O4`
- [TL074] (14): Quad, 30-V, 3-MHz, high slew rate (13-V/µs), In to V+,
  JFET-input op amp
  - Pins: `1OUT 1IN- 1IN+ VCC+ 2IN+ 2IN- 2OUT`
        `‥ 3OUT 3IN- 3IN+ VCC- 4IN+ 4IN- 4OUT`
  - Recommended by Eurorackguy below.


Example Circuits
----------------

The following audio amplifier and mixer are from a [Eurorack
oscillator][thea]. (That page also has a useful op-amp-based
voltage scaler dropping 0-6V or 0-5V to 3.3-0V.)

<img src='sch/output-amp-1.svg' width=400>

> The raw waveform signal enters on the left, passes through a high-pass
> filter to remove the DC offset, and then gets amplified using a
> straightforward inverting amplifier configuration. Finally, there's a
> current-limiting 1kΩ resistor between the amplifier output and the jack
> so that temporary shorts when connecting and disconnecting patch cables
> don't cause any trouble."

<img src='sch/mixer.svg' width=400>

> "The mixer is a implemented using a summing inverting amplifier, also
> known as an "active mixer" or "virtual earth mixer". It's a very common
> circuit to see in audio applications.

(The [summing inverting amplifier][sumamp] can be used for audio mixing, as
above, and also as a D/A by using a resistor ladder to sum the inputs,
e.g., 1k/2k/4k/8k.)


<!-------------------------------------------------------------------->
[ig1086]: https://www.youtube.com/watch?v=mnRO1OK6bqY

<!-- Parts Guide -->
[TL074]: https://www.ti.com/product/TL074
[TI LM324-N-MIL]: https://www.ti.com/lit/ds/symlink/lm324-n-mil.pdf

<!-- Example Circuits -->
[thea]: https://blog.thea.codes/designing-castor-and-pollux/
[sumamp]: https://www.electronics-tutorials.ws/opamp/opamp_4.html
