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
     7   +5V†     btn 2       GND ● +5V      +5V     7
     8   GND      COM/STR     GND   GND      GND     8
     9   padl A   GND       Start   Start    B2(R)   9

     † Ground on Commodore TED (C16, C116, Plus/4) machines

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

__"Keyboard" controllers__ have a 12 button telephone-style keypad in four
rows: `123`, `456`, `789`, `*0#`.
- Pins 1-4 are connected to the switch rows
- Pin 6 (button) is connected to column 3.
- Pin 7 (+5V) pulls columns 1 and 2 high via 4k7 pull-ups in the
  controller.
- Pins 5 and 9 (padl B and A) are connected after the pull-ups above and
  used to pull columns 1 and/or 2 low .

The much later Atari 7800 (1986) had a two-button joystick with resistors
and didodes that fed +5V to both paddle inputs. Pressing either button
would ground pin 6, and each button separately would ground one of the
paddle inputs. This made either button work on 2600 and 7800 single-button
games, but properly programmed games could distinguish the two buttons.

References: [[herc-atari]], [[rcse 24536]]

### Commodore

The VIC-20 and Comodore 64 are the same as above.

Some Commodore 64 games (such as [Robocop 2]) could make use of a second
joystick button wired to pin 9. The Cheetah Annihilator was one example of
such a joystick. [[rcse 2499]], [[lemon64]]

The TED machines (C16, C116 and Plus/4) use a MiniDIN-8 connector and:
- have no pin 9
- provide +5V on pin 5 with no current limiting resistor
- tie pin 7 to ground instead of +5V;
- use diode-isolated pull-ups instead of relying on the VIA/CIA's pull-ups.

### Taito

Taito built their own custom paddle controller, called the [Vaus
Paddle][taito] for Arkanoid and Arkanoid II; versions of it were packaged
with the NES and MSX ports. The MSX version probably used the NES style
"clocked input" comunications mechanism (which was very different from the
standard MSX paddles) so that they could reduce manufacturing costs by
having mostly common components for the two versions. (They may have
differed only in the external connector.)

The controller basically used a couple of 555 timers and a 4040 counter to
generate a value for the paddle position that, along with the button
status, is latched by a '166 parallel load shift register; the computer
then clocks the values of this out in the usual NES way.

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


Converters
----------

Answers to RCSE [Joystick adapter from 9-pin to USB][rcse 16066] list
several different converters to USB, including:
- [Stelladaptor] schematics etc. are under a Creative Commons licence.
- [2600-daptor.com][26dap]: various adapters for many Atari-style
  controllers and various gamepads.
- [Bliss Box] has a range of adapters with very wide support.


Controller Detection
--------------------

The MSX Wiki page [MSX-HID] gives an algorithm for detecting a large
variety of different controllers.



<!-------------------------------------------------------------------->
[wp atjoy other]: https://en.wikipedia.org/wiki/Atari_joystick_port#Other_platforms
[rcse 24536]: https://retrocomputing.stackexchange.com/a/24536/7208

[herc-atari]: http://herculesworkshop.com/cgi-bin/p/awtp-custom.cgi?d=hercules-workshop&page=28360

[Robocop 2]: https://www.lemon64.com/forum/viewtopic.php?t=35034
[lemon64]: https://www.lemon64.com/forum/viewtopic.php?t=48672
[rcse 2499]: https://retrocomputing.stackexchange.com/a/2640/7208

[taito]: https://www.msx.org/wiki/Taito_Arkanoid_Vaus_Paddle

[jr200]: https://www.manualslib.com/manual/1238042/Panasonic-Jr-200u.html?page=61#manual

[letoine]: https://github.com/letoine/MegadriveControllerToUSB
[nfg]: https://nfggames.com/forum2/index.php?topic=2266.0

[amiga]: https://allpinouts.org/pinouts/connectors/input_device/mouse-joystick-amiga-9-pin/

[26dap]: http://2600-daptor.com/
[Bliss Box]: https://bliss-box.net/
[Stelladaptor]: http://www.grandideastudio.com/stelladaptor-2600/
[rcse 16066]: https://retrocomputing.stackexchange.com/q/16066/7208

<!-- Controller Detection -->
[MSX-HID]: https://www.msx.org/wiki/MSX-HID
