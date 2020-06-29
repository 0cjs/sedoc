National/Panasonic Personal Computer Jr.200
===========================================

6800-based machine (actually 6802 clone). 32 KB RAM; 16 KB ROM.

It was also sold in Finland as the Panasonic JR-200UP (PAL output). The
North American edition, the JR-200U, got a good [_Creative Computing_
review in May 1983][ccreview] (2nd/3rd pages are swapped), but had bad
timing; rather than race to the bottom in pricing it was discontinued in
the North American market in Feb. 1984.

References:
- \[servman] Panasonic, [Personal Computer JR-200U Service Manual][servman],
  EDCD 83-001.
- \[Reunanen] Markku Reunanen, [Discovering the Panasonic JR-200U][Reunanen]
  Excellent resource for both info and projects, including device to
  DMA into memory from expansion bus. Also links to various bits of
  code for the machine.
- \[Heikkinen] Tero Heikkinen, [Old Machinery][Heikkinen] blog `jr200up` tag.
- \[FIND] find_jr200, [Hardware][FIND].


Internal Hardware
-----------------

All ICs soldered. Board has signal markings near pins.
MN = Matsushita (Panasonic). HD,HM = Hitachi.

- MN1800A CPU. MC6802 clone. (DIP-40)
  - `○ ← 6800 → ○ ← 1800A → ○` mobo pads; can use alternate CPU?
- MN1271 PIA. 4× 8-bit parallel, half-duplex serial, 6× timer/counter.
  (HD-DIP-64).
- HD61K201F. (QFP-64)
- MN4864CA2, MN4864CB2. "2764" 8K×8 EPROM. (DIP-28)
  - IC4 (centre of board). Seen labels: "B1".
  - IC5 (twoards front). Seen labels: "A1".
- 4× HM4864P-3 64K×1 DRAM. (DIP-16)
- 2× HM6116P-3 6116 2K×8 static RAM (DIP-28)
- MN1544CJR 4-bit sub-CPU (HD-DIP-40); 4K ROM, 128 bytes RAM

DRAM is only 4-bits wide; presumably a memory controller handles doing
two-cycle reads/writes. This slows down the system; [[Reunanen]]
documents some of the slower timing, and that VRAM (2×2K×8 static) is
"twice as fast" as normal memory.

CN10 is a male 12-pin header/JP-type connector of some sort near the
real panel cut-out for a DB-25 or similar sized connector. Possibly
this is the internal serial port connector.


Power Supply
------------

- Internal PSU; input 100 VAC 50/60 Hz 8 W.
- AC goes through switch to step-down transformer:
  - Label: TI-219; IKD-2H; 100 V; 27 V 12 VA
  - Measured output on mobo connector: 22.5 VAC label, measured 22.5 VAC.

I/O Interfaces
--------------

DIP switches on bottom: CH2/CH1, ｶﾗｰ/ﾓﾉｸﾛ, 2400ﾎﾞｰ/600ﾎﾞｰ (for CMT).

### Video

See also [video](video.md) for addressing/software details.

__RF出力__ RCA jack. Internal coax cable terminating with RCA plug
plugged into the RCA jack on the internal RF modulator case. Easy
composite output conversion: solder RCA jack to pins 1/3 on back of
DIN-8.

RF output is just a hole in the back of my computer. Digital RGB and
composite are on a DIN-8 270°. Mapping between DIN-8 and P1308 pins
below was confirmed using the video cable that came with the machine.
Composite output looks significantly more clear with switch in ﾓﾉｸﾛ
position.

    DIN-8 1308    Description
      1           vert sync + vert blank
      2   1,5,6   GND
      3           Composite video
      4     7     HSync (but broken on mine?)
      5     8     VSync
      6     2     Red
      7     3     Green
      8     4     Blue

### Keyboard

The western editions use the exact same layout (even underbar between `/?`
and right shift and a yen symbol next to RUB OUT), but the カナ key is
removed, as are all katakana markings (leaving blank space), and the 英数
and GRAPH keys have been relabeled GRAPH OFF and GRAPH ON.

The keyboard is a standard [rubber chiclet keyboard][wp-chiclet] with
rubber dome caps pressing a (carbon?) conductive (~80Ω) pad against
traces on the keyboard PCB. The shift and RETURN keys have two pads;
the space bar has five.

[wp-chiclet]: https://en.wikipedia.org/wiki/Chiclet_keyboard#Simplified_design

The motherboard flat cable and speaker and power LED wires are
soldered to the board; the speaker should be unscrewed from the case
and the power LED unclipped from the case before the PCB is unscrewed
from the frame (16 very small flathead screws with a short cross
cut—not Phillips).

Pins on the keyboard connector:

    22      speaker brown wire
    21      shorted to 22 at keyboard cable entry
    20      speaker red wire
    19      power LED orange wire
    18      power LED yellow wire
    17      outer contact: space bar, left shift, others
    3-16    various key contacts
    1-2     shorted together at keyboard cable entry

It's not unusual for some keys to be intermittent. I've tried cleaning
the PCB with 99% isopropyl alcohol and the conductive pads with water.
This improved things, though the result wasn't perfect: light
keytouches on a few pads were still intermittent (though less so), but
slightly harder presses always worked.

### Sound

- Volume control pot (VR1) on back; often very dirty/crackly.
- __外部スピーカ (8Ω)__ RCA jack.
- Internal 8Ω speaker connected to keyboard PCB.

One machine had an audio output mod with a 3.5mm mono phone jack on
coaxial cable. Not sure how this was different from the 8Ω speaker
output on the back.
- Tip: pad front of pin 14 of keyboard assembly connector cable
- Sleeve: pad back of pin 4 of keyboard assembly connector cable

### CMT

CMT interface pinout is standard, as mentioned in the [OLD Hard
Connector Information][oh-c] table. Supplied cable is:

    2-RWsleeve, 4-RedTip, 5-WhiteTip, 6-Bsleeve, 7-Btip

Output recorded at 44.1 kHz unsigned 8-bit reads back fine if the volume is
sufficient; generally, normalize the recording to -0 dB.

### Joysticks

__ジョイスティック__, 2× DE-9 male jacks on left side, __1__ towards
front, __2__ towards back. MSX-compatible (not Atari). Pins 1-4 and
6-7 are switch inputs, 8 is an output ("strobe"), 5 is +5V and 9 is GND.

### Parallel Printer

__プリンタ__, 8-pin × 2 row .1" male header in IDC surround.

### Serial

Serial interface is an option, but that appears to be just the DB-25
connector to connect to pins on the board, with the actual serial I/O
being bit-banged via PD0-PD4 on the MN1271 PIA. But receive is done
with SD1 on the PIA.

Possibly CN10 (see above) is the internal connector for this.

### Expansion Bus

__外部バス__, 25 pin × 2 row 0.1" male header in IDC surround. May have
serial port lines as well.

Pins A19 and B19 supply +5 V but not much current; consider using an
external PSU for devices connected to it.

BIOS has code for autobooting ROM supplied on the expansion port.

Pinout from Ardunio loader board diagram on [[Reunanen]]; not clear what
the orientation is.

            ○ ○
     /reset ○ ○ /phi2s
            ○ ○
      /!vma ○ ○
            ○ ○ R/W̅ or R̅/W

        gnd ○ ○ gnd
         5V ○ ○
            ○ ○
            ○ ○
            ○ ○

            ○ ○
            ○ ○
        A15 ○ ○ A14
        A13 ○ ○ A12
        A11 ○ ○ A10

         A9 ○ ○ A8
         A7 ○ ○ A6
         A5 ○ ○ A4
         A3 ○ ○ A2
         A1 ○ ○ A0

         D7 ○ ○ D6
         D5 ○ ○ D4
         D3 ○ ○ D2
         D1 ○ ○ D0
            ○ ○


Peripherals
-----------

Supposedly a 5.25" floppy drive was made.



<!-------------------------------------------------------------------->
[FIND]: http://www17.plala.or.jp/find_jr200/hard.html
[Heikkinen]: https://oldmachinery.blogspot.com/search/label/jr200up
[Reunanen]: http://www.kameli.net/marq/?page_id=1270
[ccreview]: https://archive.org/stream/creativecomputing-1983-05./Creative_Computing_v09_n05_1983_05#page/n19/mode/1up
[oh-c]: https://www14.big.or.jp/~nijiyume/hard/jyoho/connect.htm
[servman]: http://vintagevolts.com/wp-content/uploads/Panasonic-JR-200U-Service-Manual.pdf
