Rigol DS1000Z Series (1054Z) Oscilloscope Notes
===============================================

References:
- [User Guide, DS1000Z Series Digital Oscilloscope][manual] (PDF)
- Videos in the [Basics of Oscilloscopes][rv bas] series.

Specs:
- 7.0" WVGA (800×480) screen
- Sample rate 1 Gsa/s, 500 Msa/s, 256 Msa/s w/1, 2, 4 channels enabled.
- 24 Mpoints memory (split between all enabled channels)

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

- For single-shot captures, generally capture the full waveform you
  want to see and view details by pressing the horizontal scale
  (large) knob to get into zoom mode to see specific sections. (Press
  again to leave zoom mode; this resets the zoom value but not the
  horizontal position if you go back into zoom.)
- Use `Measure → Clear → ItemX → Delete` to gray out bottom-line
  measurements to be the first to be removed when new ones are added.
  See "Measurement" below for more details on handling this.
- To use vertical scale controls for the Math channel, you need to
  press `MATH` _twice_, to be not in the top level math menu but the
  "Math" menu below that..


Printing
--------

The print button will create a `DS1Z_QuickPrint#.png` file where `#` is the
lowest number starting from `1` that is not already on the USB disk. The
file will always dated 2014-11-01 21:00:00.


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

Horizontal section MENU button.

Time Base:
- YT mode: X is voltage, Y is time.
- XY mode: Voltage vs. voltage on two selected channels.
- Roll mode: waveform scrolls across full display, new measurements
  appearing at the right and scrolling left. No horizontal position
  or trigger available.

Delayed sweep: only in YT mode. Slow sweep when time base ≥ 200 ms.
XXX figure this out.


Triggering
----------

Triggering and trigger status display (at upper left):
- _Single_ waits for trigger condition, triggers once, and stops. (`STOP`)
- _Normal_ retriggers every time it sees the trigger condition, stopping
  when it doesn't see it. (`WAIT` and `T'D`)
- _Auto_ forces a trigger if it doesn't see a trigger condition. (`AUTO`
  and `T'D`) XXX How long does it scan before forcing?
- _Force_ button forces a single capture (except when stopped) continuing
  in that mode after.

Trigger coupling (Menu/Setting/Coupling), valid only with edge triggers,
can be set to DC/AC/LFR/HFR independently of the input coupling:
- `DC`
- `AC`: blocks all DC components, attenuates signals < 75 Hz.
- `LFR` (LF reject): blocks DC components, rejects LF < 75 kHz.
- `HFR` (HF reject): rejects high frequency components > 75 kHz.

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
  - `PAL/SECAM`: 50 fields, 25 frames/sec; 625 lines. Odd field first for PAL.
  - `480P`, `576P`.

Notes on 240p signals:
- The NTSC line trigger will not sync if the line number is less than 5
  (less than 8 for 480p). Setting the line between 5 and 10 will actually
  sync at earlier lines and skip some lines, and the line numbers will be
  wrong throughout. This is presumably because of the missing equalization
  pulses around/during vsync.
- Start of frame may also be caught with a pulse trigger set for a negative
  pulse width >50 μs. (Possibly a trigger holdoff may be necessary to avoid
  retrigger on the next two lines.)


Measurement
-----------

Hardware frequency counter at upper right; source channel set via
`Measure → Source`.

Left-hand buttons for quick measuresments; `Measure` menu for more
sophisticated stuff including:
- `Range → Region` to measure full screen or within cursors only.
- `Delay` and `Phase` for cross-channel measurements.
- `Threshold` (min/mid/max def. 10%/50%/90%) for all time/delay/phase params.
- `Statistic` to enable stats (`Extremum` for cur/avg/min/max;
  `Difference` for cur/avg/deviation/count; `Reset` to clear stat history).

Real-time graph and table history of measurement values is available
from `Measure → History`.

Cursor mode Auto can set cursor lines for any one of the current quick
measure items at the bottom of the screen to give you a better sense
of where the thresholds are. New measurements will become the auto item.

#### Clearing Measurements

To delete measurements created from the left-hand buttons, use
`Measure → Clear → ItemX → Delete` to grey out the measurement; the
greyed-out measurements will slowly be pushed off the screen as you
add new measurements. The `Recover` item in that deepest menu will
restore a measurement, allowing you to bring back ones used previously
in the current session if you've cleared the screen of the bottom
measurements for a while.

Pressing and holding `Measure` or `Measure → Clear → All Items` will
turn off bottom measurement display completely. Doing that again will
recover all items, or you can recover them individually as above. A
clear all plus one or two recoveries can be faster than individual
deletions.



<!-------------------------------------------------------------------->
[manual]: https://int.rigol.com/Public/Uploads/uploadfile/files/ftp/DS/手册/DS1000Z/EN/DS1000Z_UserGuide_EN.pdf
[rv uvt]: https://www.youtube.com/watch?v=uAVDTghrqYc&pbjreload=101
[rv bas]: https://www.rigolna.com/scopebasics/
