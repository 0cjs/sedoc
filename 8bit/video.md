Video on 8-bit Systems
======================

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

#### Horizontal Sync Rates

Standard vertical rates are almost invariably around 50-60 Hz (frame rate
half that for interlaced output). Horizontal sync rates start around 15.7
kHz for ~200 displayed lines (see progressive note below), and are
increased when displaying more lines in progressive signals. Common
horizontal sync rates (kHz) are:

     480i   15.750    NTSC B/W: 262.5 lines × 2 × 60 Hz fields
     480i   15.734    NTSC color: as B/W at 59.940 Hz
     576i   15.625    PAL: 312.5 lines × 2 × 50 Hz fields
            21.8      EGA (350 line)
           ~24        400-line modes
            31.469    VGA

Interlaced systems indicate odd-line (1,3,…) fields by starting vsync on a
line boundary, and even-line (2,4,…) fields by starting vsync in the middle
of a line boundary. (Thus, 262.5 lines per field in NTSC video.) See the
[LMH1981] datasheet for sample waveforms.

Many systems do a progressive 262 (?) line 60 FPS version of this by always
starting vsync on a line boundary. (This may leave "blank" scan lines
between the rendered scan lines on the monitor.) It seems that most CRT
monitors/TVs handle this but many digital capture devices may not.

#### Input AC Coupling

The [LMH1981] datasheet discusses input coupling considerations for video
(p. 14) and suggests 1 μF for DC-coupled inputs and 0.01 μF for AC-coupled
inputs.


References
----------

- TI [LMH1981] Multi-Format Video Sync Separator. Includes waveforms for
  various SD and HD video and sync signals.
- Analog Devices [ADV7170] Digital PAL/NTSC Video Encoder. Provides lots of
  insight into how to generate video signals.



<!-------------------------------------------------------------------->
[adv7170]: https://www.analog.com/media/en/technical-documentation/data-sheets/ADV7170_7171.pdf
[lmh1981]: https://www.ti.com/lit/ds/symlink/lmh1981.pdf
