National/Panasonic Personal Computer Jr.200
===========================================

6800-based machine (actually 6802 clone). 32 KB RAM; 16 KB ROM.

References:
- \[Reunanen] Markku Reunanen, [Discovering the Panasonic JR-200U][Reunanen]
  Excellent resource for both info and projects, including device to
  DMA into memory from expansion bus..


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
- MN1544CJR 4-bit sub-CPU (HD-DIP-40)

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
  - Measured output on motherboard connector: 22.5 VAC
label, measured 22.5 VAC.

I/O Interfaces
--------------

DIP switches on bottom: CH2/CH1, ｶﾗｰ/ﾓﾉｸﾛ, 2400ﾎﾞｰ/600ﾎﾞｰ (for CMT).

### Video

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

### Joysticks

__ジョイスティック__, 2× DE-9 male jacks on left side, __1__ towards
front, __2__ towards back. MSX-compatible (not Atari). Pins 1-4 and
6-7 are switch inputs, 8 is an output, 5 is +5V and 9 is GND.

### Parallel Printer

__プリンタ__, 8-pin × 2 row .1" male header in IDC surround.

### Serial

Serial interface is an option, but that appears to be just the DB-25
connector to connect to pins on the board, with the actual serial I/O
being bit-banged via PD0-PD4 on the MN1271 PIA. But receive is done
with SD1 on the PIA.

Possibly CN10 (see above) is the internal connector for this.

### Expansion Bus

__外部バス__, 25 pin × 2 row 0.1" male header in IDC surround.


ROM
---

The boot screen is as follows, and may come up in two different colours.

    JR BASIC 5.0
    (C) 1982 by
    Matsushita System Engineering
    Free Bytes 30716
    Ready

- Dark blue text, cyan background, green border.
- White text, black background, black border.

\[Reunanen] has disassemblies of his [BASIC ($A000)][r-dis-bas] and
[system ($E000)][r-dis-sys] ROMs, but they are completely raw, no
comments, data/code separation, or labels for vectors.

### Machine-language Monitor

The system ROM has simple machine-language monitor built-in (at least
on my white/black/black version); it comes up with a `> ` prompt by
using the `MON` command from BASIC or when the machine is started
without a BASIC ROM installed. Some experimentation discovered the
following (case-sensitive) commands. When an address `aaaa` (upper or
lower case) is not given, the default is just after the last address
displayed.

- `Daaaa`: Dump $80 bytes of memory starting at location _aaaa_.
- `Maaaa`: Modify memory a byte at a time; old value displayed first.
  Enter new value, RETURN to leave the same, or `.` to terminate entry.
- `Gaaaa`: Call _aaaa_ (address required); RTS returns to monitor.

A simple little program to test the monitor is:

    7000 86 EE      LDAA #$EE
    7002 B7 70 10   STAA $7010
    7005 39         RTS

`GA000` will display the start-up messages and give the BASIC prompt,
without clearing the screen, though this doesn't seem to leave BASIC
entirely initialized properly (e.g., control-letters no longer enter
BASIC keywords but instead produce symbols; sending a screen code may
fix this).



<!-------------------------------------------------------------------->
[r-dis-bas]: http://www.kameli.net/~marq/jr200/basic.lst
[r-dis-sys]: http://www.kameli.net/~marq/jr200/sysrom.lst
[Reunanen]: http://www.kameli.net/marq/?page_id=1270
[oh-c]: https://www14.big.or.jp/~nijiyume/hard/jyoho/connect.htm