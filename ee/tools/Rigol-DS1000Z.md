Rigol DS1000Z Series (1054Z) Oscilloscope Notes
===============================================

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