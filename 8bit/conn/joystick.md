Joystick Connectors
===================

The Atari-ish DE-9 standard ([more platforms here][wp atjoy other]).
Directions and buttons are N.O., shorting to ground when activated.

From experimentation it seems it may be possible to use Atari joysticks on
MSX, but check strobe behaviour.

    Pin  Atari    MSX       ────Sega────   Pin
    ──────────────────────────────────────────
     1   up       up           Up           1
     2   down     down       Down           2
     3   left     left       Left           3
     4   right    right     Right           4
     5   padl B   +5V Vcc     +5V   +5V     5
     6   button   btn 1     Btn A   Btn B   6
     7   +5V      btn 2       GND ● +5V     7
     8   GND      COM/STR     GND   GND     8
     9   padl A   GND       Start   Start   9

### MSX

- Joystick direction switches and buttons short to pin 8 ("COMmon"). This
  is actually a PIO output pin (IOB5) that is set low when reading the
  joystick switches; pins 1-4,6-7 are PIO inputs (IOA0-5) with external 10k
  pullups that are overridden when shorted to IOB5.
- Paddles should hold pins 1-4,6-7 (up to 6 paddles) low. When paddle poll
  is requested (BIOS `PDL` function), a TTL high pulse is triggered on pin
  8 ("STRobe out"); on this rising edge each paddle should return a TTL
  high pulse of 10-3000 μs on its pin indicating the position of the
  paddle. This can be done with a 74LS123 by putting a .04 μF cap across
  `Cext` and `Rext` and a 150 kΩ pot between Vcc and `Rext`.
- See §1.4.6 (p. 27) and §1.4.7 (p. 28) of the Sony MSX Technical Handbook.

### Sega

- †Sega: `Select` line (pin 7, `●`) starts at GND. On older controllers,
  switching to +5V enables additional buttons (using an 74HC157?).
- On later controllers, `Select` is a "clock" that toggles through multiple
  selections? Low for 1.8 ms resets the clock to start of sequence? See
  [nfg], [letoine].



<!-------------------------------------------------------------------->
[wp atjoy other]: https://en.wikipedia.org/wiki/Atari_joystick_port#Other_platforms
[nfg]: https://nfggames.com/forum2/index.php?topic=2266.0
[letoine]: https://github.com/letoine/MegadriveControllerToUSB
