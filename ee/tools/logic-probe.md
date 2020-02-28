Logic Probes
============

Octal TTL Logic Probe
---------------------

The probe can be run at any voltage from 3.0 to 12 V. Reference
voltages are relative to the power supply voltage; voltages below
assume Vcc is 5.0 V. Power input is a pair of 0.1" headers at the
upper right; both male and female header pins are supplied and either
may be used. Ground is on the left and Vcc on the right.

At the upper left are eight test inputs (on both male and female 0.1"
headers) for the levels to be tested; the status of these is displayed
on the LEDs at the lower left. Two reference voltages are generated:
RefHigh (usually 2.0 or 2.7 V) and RefLow (usually 0.5 or 0.8 V). For
each test input a red "low" LED lights when the voltage is below
RefLow, and the green "high" LED lights when the voltage is above
RefHigh.

The right-hand side is the reference voltage generation section. The
pins at the right are used for checking the reference voltages; they
are, from top to bottom, GND, RefHigh, GND and RefLow. To the left of
these, the top potentiometer trims the RefHigh voltage and the lower
potentiometer trims the RefLow voltage. These are 5 kΩ pots in series
with 26 kΩ and 10 kΩ resistances respectively, acting as the GND side
of the voltage divider.

Below that are eight switches to switch in and out resistors for the
Vcc side of the RefLow (1-4) and RefHigh (5-8) voltage dividers:

    No    Ω  Voltage Divider Output
     1  91k  0.5 V  TTL maximum output for "low"
     2  56k  0.8 V  TTL maximum input for "low"
    3-4             User-supplied resistors for arbitrary RefLow voltages
    5-6             User-supplied resistors for arbitrary RefHigh voltages
     7  39k  2.0 V  TTL minimum input for "high"
     8  22k  2.7 V  TTL minimum output for "high"

### Design Notes

I originally made this to check that the eight outputs of an MC6821
PIA were not only the correct values, but to ensure that it was
properly pulling up/down the output lines. (I was getting weird
results that I thought might have been due to some sort of bus
conflicts, or it not driving the bus hard enough.) The parts are what
I had around, not necessarily optimal for the task.

The reference voltages are generated via a standard resistor voltage
divider. The low half of each divider is a resistor in series with a
5 kΩ trim pot and the upper half is a switch-selectable resistor. Each
of the 8 channels has a pair of LM324 op-amps. The LED anodes are on
the +5 rail, so the op-amp outputs are inverted (high = out of range;
low = in range).
- RefLow to `-`, test line to `+`, output to green LED cathode.
- RefHigh to `+`, test line to `-`, output to red LED cathode.

Voltage divider calculations:

    RefLow:
      TTL output max 0.5 V / 5.0 V = 0.10
       TTL input max 0.8 V / 5.0 V = 0.16
                             RATIO = 1.60
    Approximate with:
               (91k+10k)/(56k+10k) = 1.53           XXX could have done better
    Voltage Dividers around R2=10k: 7.5k + ½5k pot
       91k ⊥ 10111 = 0.5 V
       56k ⊥ 10667 = 0.8 V

    RefHigh:
      TTL output min 2.7 V / 5.0 V = 0.54
       TTL input min 2.0 V / 5.0 V = 0.40
                             RATIO = 1.35
    Approximate with:
               (39k+26k)/(22k+26k) = 1.35
    Voltage dividers around R2=26k: 22k + 1.5k + ½5k pot
        22k ⊥ 25826 = 2.7 V      (also 20k, 23478)
        39k ⊥ 26000 = 2.0 V      (also 33k, 22000)

#### Board Design

It just barely fits on a 7×5 cm 24×18 hole protoboard. My next option
was a 7×9 cm 26×31 board, almost half of which would have been unused.

For ease of use I use both male and female headers in parallel for all
inputs, with the male on the outside so that they can be easily
clipped with standard test clips. The test points for RefHigh and
RefLow are male pins only; it didn't seem worth adding female ones.


References
----------

- Dr Jefyll's [Throw-Together-Computer][ttc] (TTC) 6502 board



<!-------------------------------------------------------------------->
[ttc]: http://forum.6502.org/viewtopic.php?p=62120#p62120
