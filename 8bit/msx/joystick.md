MSX Joystick Ports
==================

References:
- \[td1] [_MSX Technical Data Book_][td1] (en), Sony, 1984. pp.25-28, 44

Two types defined:
- __Type A:__ One button or indistinguishable buttons.
  All joysticks must be marked; software need not be.
- __Type B:__ Two independent trigger buttons.
  All joysticks must be marked; software requiring Type B must be marked.

Two DE-9F connectors, J3 (port 1) and optional J4 (port 2):
- TTL levels. Pinout [[td1] p.25] and [`conn/joystick`](../conn/joystick.md).
- Schematics: [[td1] p.26] switches only, [[td1] p.28] paddle circuit.
- All pins have pullups to Vcc (typically 10 kΩ) except +5 (5) and GND (9).
  This is in addition to the (unspecified) on-chip pull-ups.
- AY-3-8910 PSG IOA 0-5 and IOB 0-6 used for interface.
  - Ports are either all pins input or all pins output; they cannot be split.
    - IOA is set to input and has nothing connected usable for ouput.
    - IOB is set to output and must be to avoid floating select input on
      the '157s. (Thus, pins 1/8 and 2/8, though wired to be input capable,
      can not be used for input without making IOA0-5 unusable.)
  - IOB6 switches 1.5× 74LS157 routing pins 1-4,6,7 to IOA0-5 from ports 1/2
  - IOB4/5 independent to pin 8 ports 1/2 w/pullup. (Spec says output-only,
    but from schematic could also be used as input.)
  - IOB0,1,2,3 → P1/6,7,P2/6,7 through 7407 non-inverting open-collector buffer
- Note pin 9=GND is different from Atari Joystick 8=GND, but outputs to pin
  8 (B4,B5) are normally low (except when querying paddles) so an Atari
  joystick can work.

Ports and pinout key:
- `Reg`=PSG register address to write to $A0. Write output at $A1;
  read input or output at A2. See also [`sound`](sound.md).
- `IO`=PSG I/O port and bit [[td1 p.44]].
- `pin`=connector pin; `s/#`=input switched by '157 (`B6`).
- `P`=pullup via resistor. `dir`=`i`:input,`o`:output.

Ports and pinout table:

    Reg IO pin P dir Description
    ──────────────────────────────────────────────────────────────────────────
             5        +5 VDC max 50 mA (per port)
             9        GND; short inputs to this to assert them
    ──────────────────────────────────────────────────────────────────────────
    R14 A0 s/1 *  i   fwd
        A1 s/2 *  i   back
        A2 s/3 *  i   left
        A3 s/4 *  i   right
        A4 s/6 *  i   TRG 1: only button on Type A joystick
        A5 s/7 *  i   TRG 2: 2nd button Type B joystick
        A6        i   Key layout select: 1=JIS 0=syllable
        A7        i   CSAR (CMT read)
    ──────────────────────────────────────────────────────────────────────────
    R15 B0 1/6 *   o  ouput drive for port 1 TRG 1 (set high when using input)
        B1 1/7 *   o    "     "    "  port 1 TRG 2   "   "    "     "     "
        B2 2/6 *   o    "     "    "  port 2 TRG 1   "   "    "     "     "
        B3 1/7 *   o    "     "    "  port 2 TRG 2   "   "    "     "     "
        B4 1/8     o  paddle query port 1 (hold low to use Atari joystick)
        B5 2/8 *   o  paddle query port 2 (hold low to use Atari joystick)
        B6         o  To S (A̅/B) on '157s. 0/1=port 1/2 select for pins 1-4,6,7
        B7         o  KLAMP (kana lamp) 0=on 1=off
    ──────────────────────────────────────────────────────────────────────────

Joystick schematic [[td1] p.27] is NO switches on pins 1-4,6,7 common to 8.

Paddles [[td1] p.28]:
- Calling `PDL` function sends query trigger pulse to pin 8 of a port
  (IOB4=port 1, IOB5=port 2). Not explictly stated, but pulse must be
  negative since there's a pull-up on the line and the paddle schematic
  shows an inverter on pulse input.
- Paddle responds with 10 μs to 3000 μs pulse (from start of trigger pulse)
  indicating position.
- Each paddle uses a [LS123][SN74LS122] or eqiv. monostable multivibrator:
  - Pin 8 → inverting buffer → `1A`: pulse input to query position
  - GND → `1B`, `1C̅L̅R̅`.
  - `1Q`: to pin 1 for paddle 1 (or 2-4,6,7 for other paddles).
  - 0.04 μF cap between `Cext` and `Rext/Cext`.
  - 150 KΩ potentiometer from Vcc to `Rext`.
- Also see [`8bit/conn/joystick`](../conn/joystick.md).


Applications
------------

### Light Pen, Touchpad, SPI, NES/SNES Controllers

MSX1 defined from the start a spec for input devices sending absolute
co-ordinates; these can be received via a light pen (Sanyo or V9938
internal) or an SPI-like serial protocol over the controller ports. The
usual controller port device was a resistive touchpad (such as the one
built in to the Hitachi MB-H3).

The BIOS automatically detects if a touchpad is connected to a controller
port. All interfaces are read via MSX-BIOS `GTPAD` ($0DB) or the BASIC
`PAD()` function. (Setup may be required before using the light pen from
BASIC.)

References:
- MSX Wiki: [Touchpad][mw-tp]; [Light Pen][mw-lp].
- Hackaday.io, [(S)NES gamepad adapter for MSX computers][had-27494]
- Hotbit, [Um estudo sobre o MSX Touchpad][hotbit]

### JoyNet

[JoyNet] is a standard for ring networks via joystick ports. The MSX end is
a DE-9M plug and the other end is a "send" DIN-5M and "recv" DIN-5F to
insert into the ring.
- Receive from up-ring: Read pins 1,2 as D0,D1, write acks on pin 8.
- Send to down-ring:    Write pins 6,7 as D0,D1, read acks on pin 3.
- Connecting just two gives you Konami's F1-Spirit 3D Special cable.



<!-------------------------------------------------------------------->
[SN74LS122]: http://www.ti.com/lit/gpn/sn74ls122
[td1 p.44]: https://archive.org/stream/MSXTechnicalHandbookBySony#page/n46/mode/1up
[td1]: https://archive.org/stream/MSXTechnicalHandbookBySony#page/n27/mode/1up

[had-27494]: https://hackaday.io/project/27494-snes-gamepad-adapter-for-msx-computers
[hotbit]: http://hotbit.blogspot.com/2014/10/recentemente-alguem-publicou-no-msx.html
[mw-lp]: https://www.msx.org/wiki/Light_pen
[mw-tp]: https://www.msx.org/wiki/Touchpad

[joynet]: https://map.grauw.nl/resources/joynet/
