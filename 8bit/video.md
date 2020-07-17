Video on 8-bit Systems
======================

For connector information, see [conn/video](conn/video.md).

Video output is generally vertical sync for ~50-60 Hz frames or fields (two
interlaced fields per frame), horizontal synchronization signals for 260 or
more lines per frame/field, and image information encoded as a single (Y)
or three (RGB) luminance signals and, for non-RGB colour systems,
additional encoded color information as either one or more separate signals
(chroma for S-video; Cb and Cr for component video) or combined with the
luma signal (composite color video).

Separate sync signals are typically TTL; RGB signals may or may not be TTL
as well in digital RGB systems (8 colors, or 16 with an additional
intensity signal). Standard luminance signals are generally about a volt
into 75Ω; sync signals usually are reduced to similar levels when combined
with a luminance.

Systems are, roughly:
- RGBHV: Three luminance signals and separate H and V sync signals
- RGBS: Composite sync signal
- RGB: Sync on green
- Component video: Y+sync Cb Cr
- S-video: Y+sync, chroma
- Composite video+sync

#### Vertical Sync

When identifying a video format, both [ITU BT.601] and [SMPTE 259M] append
the field rate directly to the format or the frame rate with a slash,
making "480i60" and "480i/30" the same thing.

Standard vertical rates are almost invariably around 50-60 Hz (frame rate
half that for interlaced output). The SD vsync signal goes low (-300 mV
from black level) with the line 4 hsync pulse and returns to high (black
level) with the line 7 hsync pulse (falling edge). [[hdr csync1]]

However, standard SD systems are interlaced, and indicate odd-line (1,3,…)
fields by starting vsync on a line boundary, and even-line (2,4,…) fields
by starting vsync in the middle of a line boundary. (Thus, 262.5 lines per
field in NTSC video.) In this case vsync returns to high between hsync
pulses. See the [LMH1981] datasheet and [[hdr csync1]] for sample
waveforms.

Many systems do a (non-standard as far as TV goes) progressive 262 or 263
line 60 FPS display by always starting vsync on a line boundary. (This may
leave "blank" scan lines between the rendered scan lines on the monitor.)
This also affects csync; see below. It seems that most CRT monitors/TVs
handle this, but many non-CRT monitors and digital capture devices may not.
Additionally, some devices may handle it correctly through composite but
not component inputs, and vice versa. [[hdr 240]]

#### Horizontal Sync

Horizontal sync rates start around 15.7 kHz for ~200 displayed lines (see
progressive note below), and are increased when displaying more lines in
progressive signals. Common horizontal sync rates (kHz) are:

     480i   15.750    NTSC B/W: 262.5 lines × 2 × 60 Hz fields
     480i   15.734    NTSC color: as B/W at 59.940 Hz
     576i   15.625    PAL: 312.5 lines × 2 × 50 Hz fields
            21.8      EGA (350 line)
           ~24        400-line modes
            31.469    VGA

SD uses bi-level sync, with the leading edge of the horizontal sync pulse
(-300 mV from black level) indicating the start of the line. The pulse is
typically around 4.7 μs, but the trailing edge should be ignored. HD uses
tri-level sync going to -300 mV then +300 mV before returning to black
level; the sync reference point is the zero-crossing between the two. Some
cheaper HD systems will use the rising edge of SD sync too, causing
problems. Others always use the first falling edge. [[hdr jit]]

#### Composite Sync (csync)

Combining the sync signals produces composite sync (csync). Suppressing the
hsync during the vsync pulse would cause loss of horizontal sync during the
vertical sync interval; the solution is to return to black level for a
short period _before_ the falling edge of the hsync signal so that a
falling edge is still present at the right point, called _serrated pulses_
within the _broad pulses_ of the vsync. This is _not_ the same as doing an
XOR of the signals; that would delay the falling edge of hsync by the hsync
signal width; properly constructed csync retains exactly the hsync's
falling edges. [[hdr csync1]]

But because the signals are interlaced, it's even trickier because it
introduces a falling edge half-way between the two horizontal sync signals.
This is fixed in the NTSC standards by introducing double-rate and narrower
"equalization pulses" for the three lines before, three lines during and
three lines after the vsync interval; effectively it looks like the hsync
runs at double rate with a narrower pulse during this time. This is
typically decoded with a one-shot (monostable multivibrator) to recover the
hsync and an integrator (low-pass filter) to recover the vsync. [[hdr
csync1]].

Nonstandard progressive SD video (240p) often drops the equalization pulses
and may also use standard-width hsync pulses during vsync. Being
non-standard, there are many variations of what exactly goes on here. [[hdr
csync2]] describes various methods of combining sync and what kind of
variations they produce:
- AND gate: suppresses hsync during vsync. CRTs usually recover sync within
  the first few lines (often the non-displayed lines). More modern systems
  using a digital PLL may lose the signal completely unless it has good
  "coast" functionality.
- XNOR: delays hsync per first paragraph above. Digital PLLs may or may not
  have a range wide enough to capture the shifted falling edges. XNOR may
  generate glitches when both inputs change at the same time (sometimes
  fixed with an RC filter).

[[TB476]] discusss how to try to recover from poor csync implementations.

#### Input AC Coupling

The [LMH1981] datasheet discusses input coupling considerations for video
(p. 14) and suggests 1 μF for DC-coupled inputs and 0.01 μF for AC-coupled
inputs.


References
----------

Data Sheets and Application Notes:
- TI [LMH1981] Multi-Format Video Sync Separator. Includes waveforms for
  various SD and HD video and sync signals.
- Analog Devices [ADV7170] Digital PAL/NTSC Video Encoder. Provides lots of
  insight into how to generate video signals.
- Renesas, Technical Brief \[TB476] [Regenerating HSYNC from Corrupted SOG
  or CSYNC during VSYNC][TB476]. (SOG = Sync On Green.) Includes schematic
  and board layout for sync regeneration device that "cleans up" the sync
  for cheap digital monitors.
- Renesas [ISL4089] DC-Restored Video Amplifier. Used in [[TB476]] to
  remove sync from green signal.

HD Retrovision articles and posts:
- \[hdr csync1] [Engineering CSYNC - Part 1: Setting the Stage][hdr csync1]
- \[hdr csync2] [Engineering CSYNC - Part 2: “Falling” Short][hdr csync2]
- \[hdr jit] [Sync Jitter][hdr jit]
- \[hdr 240] [More information than you need about “240p” video][hdr 240].



<!-------------------------------------------------------------------->
[ITU BT.601]: https://en.wikipedia.org/wiki/Rec._601
[SMPTE 259M]: https://en.wikipedia.org/wiki/SMPTE_259M
[TB476]: https://www.renesas.com/us/en/www/doc/tech-brief/tb476.pdf
[adv7170]: https://www.analog.com/media/en/technical-documentation/data-sheets/ADV7170_7171.pdf
[hdr 240]: https://www.hdretrovision.com/240p
[hdr csync1]: https://www.hdretrovision.com/blog/2018/10/22/engineering-csync-part-1-setting-the-stage
[hdr csync2]: https://www.hdretrovision.com/blog/2019/10/10/engineering-csync-part-2-falling-short
[hdr jit]: https://www.hdretrovision.com/jitter
[isl4089]: https://www.renesas.com/jp/ja/www/doc/datasheet/isl4089.pdf
[lmh1981]: https://www.ti.com/lit/ds/symlink/lmh1981.pdf
