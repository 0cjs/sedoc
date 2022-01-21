Joystick Connectors
===================

The Atari-ish DE-9 standard ([more platforms here][wp atjoy other]).
Directions and buttons are N.O., shorting to ground when activated.

From experimentation it seems it may be possible to use Atari joysticks on
MSX, but check strobe behaviour.

    Pin  Atari    MSX       ────Sega────     Amiga  Pin
    ───────────────────────────────────────────────────
     1   up       up           Up            up      1
     2   down     down       Down            down    2
     3   left     left       Left            left    3
     4   right    right     Right            right   4
     5   padl B   +5V Vcc     +5V   +5V      B3(M)   5
     6   button   btn 1     Btn A   Btn B    B1(L)   6
     7   +5V      btn 2       GND ● +5V      +5V     7
     8   GND      COM/STR     GND   GND      GND     8
     9   padl A   GND       Start   Start    B2(R)   9

### Atari

__Paddle controllers__ are a pair of pots on a single cable. The buttons for
controls 1 and 2 (A and B) short pins 3 and 4 (normally left and right
joystick switches) respectively to pin 8. The pots are 1 MΩ with one end
on pin 7 (+5V) and the wiper on pin 9 / 5. Thus, __Atari paddle controllers
may short pins 7--9, 7--5, or 7--9--5__. The 7--9--5 combination (both
paddles at far left) may damage MSX machines.

__Driving controllers__ are a single infinite-turn knob that with each
quarter turn generates a 2-bit gray code sequence (00, 01, 11, 10) on pins
1 and 2. The "accelerator" button shorts pin 6 to pin 8.

__"Keyboard" controllers__ have 12 button telephone-style keypad (`1`-`9`, `*`,
`0`, `#`) Pins 1-4 are connected to the switch rows, pins 5, 9, 6 to the
columns, and pin 7 (+5V) to the first two columns via individual 4k7
resistors (pull-ups?).

References: [[herc-atari]]

### MSX

__WARNNG!__ When an MSX joystick is used on an Atari-compatible system
(Atari, C64, Amiga, etc.), button 2 will _short +5V to GND_. This may
damage the system through both the short and the subsequent voltage spike
when the button is released.

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
- This design is probably the same as the PC-6001, with the MSX designers
  choosing controller backward compatibility with that rather than Atari.

__MSX-Compatible Systems:__
- National/Panasonic JR-200: 1-4,6,7:input 5:+5V 8:output 9:GND. ([_JR-200U
  Service Manual_ p.62 PDF 61][jr200].)

### Sega

- †Sega: `Select` line (pin 7, `●`) starts at GND. On older controllers,
  switching to +5V enables additional buttons (using an 74HC157?).
- On later controllers, `Select` is a "clock" that toggles through multiple
  selections? Low for 1.8 ms resets the clock to start of sequence? See
  [[nfg]], [[letoine]].

### Amiga

[Controllers][amiga]:
- Digital joystick: same as Atari except button 2 added.
- Paddles: same as Atari except button 3 on pin 1 (up) added.
- Mouse/trackball: pins 1-4 are V, H, VQ and HQ pulses. B1/2/3 are L/R/M.
- Lightpen: B1 = beamtrigger; B2 = B2; B3 = penpress.

+5V is 50 mA max.



<!-------------------------------------------------------------------->
[amiga]: https://allpinouts.org/pinouts/connectors/input_device/mouse-joystick-amiga-9-pin/
[herc-atari]: http://herculesworkshop.com/cgi-bin/p/awtp-custom.cgi?d=hercules-workshop&page=28360
[jr200] https://www.manualslib.com/manual/1238042/Panasonic-Jr-200u.html?page=61#manual
[letoine]: https://github.com/letoine/MegadriveControllerToUSB
[nfg]: https://nfggames.com/forum2/index.php?topic=2266.0
[wp atjoy other]: https://en.wikipedia.org/wiki/Atari_joystick_port#Other_platforms
