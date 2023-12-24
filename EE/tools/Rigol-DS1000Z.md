Rigol DS1000Z Series (1054Z) Oscilloscope Notes
===============================================

### Generic Oscilloscope Hints

- Determine probe effect on waveform by measuring it with one probe
  and storing that, then measuring with two probes at the same point
  and comparing with stored waveform.


General
-------

References:
- [User Guide, DS1000Z Series Digital Oscilloscope][manual] (PDF)
- Videos in the [Basics of Oscilloscopes][rv bas] series.

Specs:
- 7.0" WVGA (800×480) screen
- Sample rate 1 Gsa/s, 500 Msa/s, 256 Msa/s w/1, 2, 4 channels enabled.
- 24 Mpoints memory (split between all enabled channels)
- 64 levels of intensity grading for display persistence.
- Hardware frequency counter (works when only part cycle on screen)
- Decoding is on-screen only, but you can have two decoders running at once
  and can trigger from the decode.

### Settings Reset/Save/Load

`Utility → System → Power Set` determines whether at power-up the
'scope starts with `Last` settings from before power-off (default) or
factory `Default` settings. The factory default settings (described in
detail on page 14-12 of the manual) can also be restored at any time
with `Storage → Default`.

Current settings can be saved and reloaded as "Setup" (`.stp`) files
in internal or USB storage via `Storage → Storage → Setups`. Note that
"Parameters"/"Param" (`.txt`) format also records setup and other
'scope information but cannot be reloaded.

### Preferences/Settings

`Utility → System → Vertical Ref` determines whether vertical scale
zooms around `Ground` of signal (default) or `Center` of screen.

`Display` menu offers vector/dot display, persistence time
(longer/infinite good for checking for noise/jitter/glitches),
waveform intensity for persistence, grid display/brightness.

`Measure → Font Size` sets size of measurements display at screen
bottom. May need `Sel Item` to switch between displayed stats.


UI Hints
--------

- The `Clear` button only clears the waveform on the screen; it does not
  change any of the measurement parameters. (But the `Auto` button beside
  it does!) Use to clear persistent and averaged data from screen,
  including with stats.
- For single-shot captures, generally capture the full waveform you want to
  see and view details with zoom (see ["Horizontal"](#horizontal) below).
- Use `Measure → Clear → ItemX → Delete` to gray out bottom-line
  measurements to be the first to be removed when new ones are added. See
  ["Measurement"](#measurement) below for more details on handling this.
- `Measurement » Statistics` will display a diagram of how a stat at the
  bottom of the screen is calculated. `Help` followed by a stat button will
  give more details on any stat.
- To use vertical scale controls for the Math channel, you need to press
  `MATH` _twice_, to be not in the top level math menu but the "Math" menu
  below that.
- Reference waveforms always display in original time base, not scaled as
  you change the current time base on screen.
- `ASCII List` function may help with decoding longer chunks of data not
  readable on the screen.


Printing, Capture, Remote Control
---------------------------------

The print button will create a `DS1Z_QuickPrint#.png` file where `#` is the
lowest number starting from `1` that is not already on the USB disk. The
file will always dated 2014-11-01 21:00:00.

### Network Access

The 'scope has a built-in web server with some minimal status and
configuration information. It supports [SCPI][] (Standard Commands for
Programmable Instruments and [LXI][] (LAN eXtensions for Instrumentation);
not sure of the relationship between the two, but SCPI seems lower level.
Some computers use [VISA][] ( Virtual instrument software architecture)
APIs to communicate with instruments via LAN/USB/etc.; The VISA address for
the 'scope will look like `TCPIP::192.168.xx.xx::INSTR`.

Windows Software:
- (Win) Rigol Ultrascope for DS1000Z Series software.
- (Win) marmad software; EEVblog forums ["Software & tips for Rigol
  DS2072"][marmad]. Record/playback control/setting, screen
  grab/save/preview and animated GIF compilation, and markers when zooming
  in large memory depths. Requires Rigol's software to be installed first
  for VISA drivers etc.

Python:
- cibomahto.com, [Controlling a Rigol oscilloscope using Linux and
  Python][cibo]. Simple code for using the `usbtmc` driver.
- [PyVISA][] library. Uses IVI-VISA library if installed, otherwise uses
  `pyvista-py` (pure Python implementation) backend.
- orborneee.com, [Control Your New Rigol-DS1054Z With An Old-School Text
  User Interface][oee-blog].
  - [PiPy `rigol-ds1000z` package][oee-pipy]. [GitHub][oee-gh]. Uses
    [PyVISA][] to communicate with the 'scope. On Debian, requires
    `python-tk` package.
  - Text user interface to the 'scope, giving a wide range of settings
    directly available and visible in a terminal, including one-key screen
    capture.
  - [Issue #3][rd1kz-i3] describes the failure in `find_visas()`. That can
    be hacked around with the following, at which point the next issue
    is that commands are very slow (106 seconds or so to respond).

        #   XXX hack from https://github.com/amosborne/rigol-ds1000z/issues/2#issuecomment-1558026543
        return [("TCPIP0::192.168.xx.xx::INSTR", "@py")]

- [`rdpoor/rigol-grab`]: Seems to work well; the `rigol_grab.py` can be run
  in a virtualenv where `rigol-ds1000z` was installed as it uses the same
  depenedencies. `python ./rigol-grab/rigol_grab.py -p 192.168.xx.xx` dumps
  the screen to `rigol.png` (overwriting any existing file).

### VISA Interface

__Utility » IO Setting » LAN Conf.__ will pop up a settings window that
includes network information and a VISA address such as
`TCPIP0::192.168.1.40::INSTR`. Connectivity can be confirmed with PyVISA:

    import pyvisa
    rm = pyvisa.ResourceManager()
    inst = rm.open_resource('TCPIP0::192.168.xx.xx::INSTR')
    inst.query('*IDN?')
      # ⇒ 'RIGOL TECHNOLOGIES,DS1104Z,DS1ZA191003179,00.04.04.SP1\n'


Acquisition and Memory Depth (Ch. 4)
------------------------------------

All under `Acquire` menu.

Acquisition modes (`Acquire » Mode`):
- `Normal` (default): Sampled at equal time intervals.
- `Peak Detect`: Acquires min/max signal value during the sample period.
  Ensures small pulses are not missed at cost of increased noise. All
  pulses with width ≥ sample period will be captured.
- `Average` (2-1024 in powers of 2): Multi-sample average. For repeating
  waveforms, lowers noise and increases vert. resolution, but slows
  response to waveform changes.
- `High Resolution`: Single-sample average. Reduces noise/smooths waveform;
  use when converter rate is higher than acquisition storage rate.

`Sin(x)/x` disabled when less than 3 channels enabled. XXX Why?

`Sa Rate` menu shows sample rate; max 1 GSa/s. Distortion and lost pulses
when too low; "waveform confusion" when below Nyquist.

The centre top of the screen displays a bar representing the waveform in
memory, greying out the part of the buffer not displayed on the screen, if
any. To the left is displayed the current sample rate (samples/sec) and
memory depth (points).

`Acquire » Mem Depth`
- Maximum total depth (sample buffer size) is 24 Mpt across all enabled
  channels. Depth options are `Auto, 3k, 30k, 3M, 6M` with 3-4 channels
  enabled; all figures switch to ×2 or ×4 with 2 or 1 channels enabled.
- The full time period of the display (horizontal scale) is always
  buffered; sample rate is reduced as necessary to fit within 6M/12M/24M
  points depth.
- `Auto` mode sets depth to just enough memory to hold the display time
  period of samples at the highest available rate, or uses max depth.
- Manual depth uses a fixed depth that may leave undisplayed buffer on
  either side (viewable by changing horiz offset or scale).
- XXX Why would you ever use `Auto` mode or less than max depth? Speed?
- Horizontal zoom mode uses only displayed part of buffer, not entire
  capture buffer.
- When `Storage » Storage` is set to `CSV`, the `DataSrc` parameter
  determines whether it dumps `Screen` or `Memory`.

`Acquire » Anti-aliasing` (default disabled): When not enabled, "waveform
aliasing is more possible." ???


Horizontal
----------

Horizontal scale knob sets time base _H_ in time/division, displayed on top
line of display. (Press for zoom.) Position knob sets trigger position on
display, displayed on top line as _D_; press knob to reset to 0, Scale
changes around centre, not trigger position (i.e., narrowing H can put
trigger off screen).

Horizontal section `MENU` button:
- `Delayed`: __Zoom__, which Rigol calls "delayed sweep." Also available by
  pushing horizontal time base button. See below.
- `Time Base` (H) mode:
  - `YT`: X is time, Y is voltage. At H ≥ 200 ms. enters "slow sweep" mode,
    which adds a moving bar to show what part of the screen is being
    updated. (This is not "similar to roll mode," as claimed by the
    manual.)
  - `XY`: Voltage vs. voltage on two selected channels.
  - `Roll`: (H ≥ 200 ms. only.) No trigger, waveform does not restart at
    left of screen. Instead new samples appear on right side of screen,
    scrolling left.

#### Zoom

Widen horizontal scale to capture on the screen the entire waveform across
which you wish to scroll/zoom (zoom will not view buffered data off of
screen). Press the horizontal scale (large) knob to enter zoom mode; screen
splits with full waveform on top and zoomed section on bottom. Press again
to leave zoom mode; this resets the zoom value but not the horizontal
position if you go back into zoom.

Rigol calls this mode "delayed sweep" in the menu, but it's not; it's just
zooming into the buffer rather than sampling twice. Analogue oscilloscopes
could have a second time base generator synchronized with the main one but
running faster, optionally with its trigger delayed; this was called the
"delayed sweep," and painted a second waveform on the screen which was
effectively a "zoomed in" section of the main waveform. Digital 'scopes
simply zoom in on the measurement buffer.


Triggering
----------

Triggering and trigger status display (at upper left):
- _Single_ waits for trigger condition, triggers once, and stops. (`STOP`)
- _Normal_ retriggers every time it sees the trigger condition, stopping
  when it doesn't see it. (`WAIT` and `T'D`)
- _Auto_ forces a trigger if it doesn't see a trigger condition. (`AUTO`
  and `T'D`). Handy to get a trace on screen for adjustment when you've not
  yet worked out the trigger. (Before trigger either the previously
  captured waveform or nothing is displayed.) XXX How long does it scan
  before forcing?
- _Force_ button forces a single capture (except when stopped) continuing
  in that mode after.

`RUN/STOP` in stop mode will freeze the display on the current sample, but
also continue to display previous waveforms shown via the persistence
setting (`Display » Persis.Time`). To get just the current waveform, use
`SINGLE` instead.

Most trigger types have a `Setting » Holdoff` setting (min 16 ns), the
amount of time after a trigger during which subsequent trigger events are
ignored. On analogue scopes this is used when your waveform period is
longer than your horizontal time base so you can see just the start of the
waveform; with digital using zoom might be a better way of handling this if
you stil have enough resolution with the wider capture time.

Analogue channel triggers also have a `NoiseReject` setting that "reject[s]
high frequency noise int he signal." There's no indication of what "high
frequency" is, but various triggers on CVBS signals often seem to work
better with this off.

Trigger coupling (Menu/Setting/Coupling), valid only with edge triggers,
can be set to DC/AC/LFR/HFR independently of the input coupling:
- `DC`
- `AC`: blocks all DC components, attenuates signals < 75 Hz.
- `LFR` (LF reject): blocks DC components, rejects LF < 75 kHz.
- `HFR` (HF reject): rejects high frequency components > 75 kHz.

### Trigger Types

- `Edge`: cross voltage level on rising, falling or both
- `Pulse`: minimumn pulse width to trigger; `+`/`-` for
  positive/negative-going pulse. `When` sets width comparison to
  `>`/`<`/between.
- `Slope`: time difference between two voltage levels.
- `Video`: parameters:
  - `Polarity` ???. for sync?. Maybe just changes sign of trigger level.
  - `Sync`: "all"=any line, specific line

#### Video Triggering

Notes from Rigol Video [Using Video Triggering][rv uvt]:
- Explicitly set memory depth to max. (Not clear why; sync seems to work
  even when vsync is off the left-hand side of the screen.)

Trigger parameters:
- `Sync`
  - `All Line` triggers on the first line found.
  - `Line`: a given line number (in odd or even field) from 0 to 525 (NTSC,
    480p) or 625 (PAL/SECAM, 525p). But see below re 240p.
  - `Odd`, `Even`: rising edge of first ramp pulse in odd or even field.
- `Standard`:
  - `NTSC`: 60 fields, 30 frames/sec; 525 lines. Even field first.
    Counts equalization pulses.
  - `PAL/SECAM`: 50 fields, 25 frames/sec; 625 lines. Odd field first for PAL.
  - `480P`, `576P`. These do not count equalization pulses.

Notes on 240p signals:
- The NTSC line trigger will not sync if the line number is less than 5.
  Setting the line between 5 and 10 will actually sync at earlier lines and
  skip some lines, and the line numbers will be wrong throughout. This is
  presumably because of the missing equalization pulses around/during
  vsync.
- 480p sync can be used starting at line 8, which is the second line in vsync.
  To convert screen line to 'scope line use 7+_vsync-lines+bplines+line_.
- Start of frame may also be caught with a pulse trigger set for a negative
  pulse width >50 μs. (Possibly a trigger holdoff may be necessary to avoid
  retrigger on the next two lines.)


Measurement
-----------

Hardware frequency counter at upper right; source channel set via `Measure
» Counter`. This is both more accurate than the channel measurements menu
at the left, and will also measure frequency even when only part of a cycle
is on the screen. (The software measurement may need several cycles on
screen, especially at lower frequencies, and possibly the trigger point,
too.)

Left-hand buttons for quick measurements; `Measure` menu for more
sophisticated stuff including:
- `Measure All`: Toggle display of all 29 measurements for channels
  selected via `All Measure Source` below it. Uses 1/3 to full screen.
- `Statistic` to enable measurement diagrams and stats for individual
  measurements at the bottom of the screen. `Extremum` for cur/avg/min/max;
  `Difference` for cur/avg/deviation/count; `Reset` to clear stat history.
  `CLEAR` button also resets stats.
- `Range → Region` to measure full screen or within cursors only. The
  cursors used for this measurement are completely independent of the
  cursors below. They also vanish a short time after you move them.
- `Delay` and `Phase` for cross-channel measurements.
- `Threshold` (min/mid/max def. 10%/50%/90%) for all time/delay/phase
  params.

Real-time graph and table history of measurement values is available
from `Measure → History`.

#### Cursors

The cursors used for measurement ranges are _not_ these cursors; they're a
separate set. See "Measurement" above.

Cursors always must be on screen (though they make take some time to appear
after a scroll); they will move if you change the time base, including
changing the time base in the zoom window.

When the cursor menu is not up, pressing or holding the `Cursor` button
brings it up. When it is already up pressing `Cursor` switches to the next
cursor mode and holding (4 seconds) will toggle between `OFF`/`Track` or
`Manual`/`Auto`.

There are always four cursors; the mode determines how they are set.
- `OFF`
- `Manual`: Use `Select` menu option to select current pair: AX/BX (measure
  horizontally) or AY/BY (measure vertically). Further options below select
  A, B or both for control by the knob. Pressing the knob rotates between
  these three. In zoom mode, manual cursors appear in the overview window
  only.
- `Track`: As with manual but only AX/BX adjustable; 'scope will
  automatically set AY/BY to current value at X. In zoom mode, track
  cursorsappear in zoom window only. _WARNING:_ This also seems to do some
  sort of horizontal tracking; when moving both cursors together the width
  between them will change slightly depending on where you move them.
- `Auto`: Merely displays cursors matching the currently selected
  measurement setting (left-hand buttons). The `Auto Item` setting will let
  you choose any of the five current measurements displayed at the bottom
  of the screen (or `NONE` to turn off the cursors). Adding a new
  measurement will switch the auto cursors to that measurement.

Cursor mode Auto can set cursor lines for any one of the current quick
measure items at the bottom of the screen to give you a better sense
of where the thresholds are. New measurements will become the auto item.

#### Clearing Measurements

To delete measurements created from the left-hand buttons, use
`Measure → Clear → ItemX → Delete` to grey out the measurement; the
greyed-out measurements will be pushed off the screen as you
add new measurements. The `Recover` item in that deepest menu will
restore a measurement, allowing you to bring back ones used previously
in the current session if you've cleared the screen of the bottom
measurements for a while.

Pressing and holding `Measure` or using `Measure → Clear → All Items` will
turn off bottom measurement display completely. The latter will also
recover all items, or they can be recovered individually as above. A
clear-all plus one or two individual recoveries can be faster than
individual deletions.

#### Other Notes

`Measurements » Font size` is basically useless; `Large` and `Extra large`
will display only three or two of the measurements, though all five are
still there. You cannot see one of the hidden ones with the left-hand
buttons (it says it's already displayed); you need to use the following
select menu item to disable one of the displayed ones and enable a
different one.


Memory Segmentation
-------------------

`Utility » Record` lets you capture a sequence of screen-size buffers (YT
timebase only), ignoring data except around the trigger. Good for capturing
a sequence of data at triggers with a lot of unwanted signal between them.

Upper-right control buttons:
- `RUN/STOP` starts a new recording, as `Record » Record`.
- `SINGLE` button (no menu option) single-steps a frame in the direction
  set by `Record » Step Dir`; the step direction reverses at the end of the
  recording when not in `Record » Play Opt » Mode » Loop`.
- Play/pause only available in menu.

If you're looking to find frames with out-of-bounds data, `Utility »
Pass/Fail` might be a better option.



<!-------------------------------------------------------------------->
[manual]: https://int.rigol.com/Public/Uploads/uploadfile/files/ftp/DS/手册/DS1000Z/EN/DS1000Z_UserGuide_EN.pdf

[LXI]: https://en.wikipedia.org/wiki/LAN_eXtensions_for_Instrumentation
[SCPI]: https://en.wikipedia.org/wiki/Standard_Commands_for_Programmable_Instruments
[VISA]: https://en.wikipedia.org/wiki/Virtual_instrument_software_architecture

[PyVISA]: https://pyvisa.readthedocs.io/en/latest/
[`rdpoor/rigol-grab`]: https://github.com/rdpoor/rigol-grab
[cibo]: https://www.cibomahto.com/2010/04/controlling-a-rigol-oscilloscope-using-linux-and-python/
[marmad]: https://www.eevblog.com/forum/projects/software-tips-and-tricks-for-rigol-ds200040006000-ultravision-dsos/
[oee-blog]: https://www.osborneee.com/rigol-ds1000z/
[oee-gh]: https://github.com/amosborne/rigol-ds1000z
[oee-pipy]: https://pypi.org/project/rigol-ds1000z/
[rd1kz-i3]: https://github.com/amosborne/rigol-ds1000z/issues/3

[rv bas]: https://www.rigolna.com/scopebasics/
[rv uvt]: https://www.youtube.com/watch?v=uAVDTghrqYc&pbjreload=101
