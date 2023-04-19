X11 Resolution Settings and Monitor Configuration
=================================================

### E-EDID

Sources query displays for their capabilities via [E-EDID]; this can
usually be read even when the monitor is off.

Detailed Timing Descriptors (DTDs) have been used a long time now. Standard
timing descriptors have max Hres of 2288 pixels and must have Hres and Vres
divisible by 8. This doesn't work for many 16:9 displays. (E.g., 1366×768
where H/8 = 170.75 is usually given as 1360×765.) Many wide panels do not
advertise their resolutions in the standard timing descriptors, giving only
generic 1280×768 or similar.

* `xrandr` displays basic info for all cards/outputs. `--props` will
  include EDID hexdump and a few other things. `--verbose` includes
  `--props` info and will add modeline details.

* `/sys/class/drm/card%d-%s` (typically only `card0-*` in most systems,
  where `*` is each output) is a symlink to `/sys/devices/*/*/drm/*/*/` dir
  (PCI IDs, then card/output IDs). Contains:
  - `status`: `disconnected` or `connected`
  - `edid`: Raw EDID data; no DTDs?
  - `modes`: modeline names only, one per line
  - `dpms`: `On` or `Off`

* `edid-decode`: Reads raw EDID info (e.g., `/sys/devices/**/edid`).
  Shows DTDs.

* Debian `read-edid` package provides:
  - `get-edid`: reads EDID info and sends raw to stdout. Does not work on
    Thinkpad T510 (all 0xFF, not what's in `/sys/devices/**/edid`).
  - `parse-edid`: parses EDID from stdin; ignores DTDs.

Other:

    monitor-edid
    ddccontrol
    xrandr --props


### Modelines

It's not clear exactly how `xrandr` gets its modelines. Sometimes it seems
not to add DTDs the monitor makes available. If `--addmode` is used to
add a new mode for that output, it seems to copy the same mode from another
output, if available, otherwise it says, "cannot find mode …".

Not clear if some display adapters/converters may not return all mode lines,
particularly for higher resolutions, or if this is just `xrandr` missing
them.

`xrandr` displays the modelines returned from the display, but some
displays, and especially display adapters/converters, don't return all
usable modelines. New ones can be added to a display by using `--newmode
NAME ...` to create a named mode (adds to `VIRTUAL1` output until added to
another output?) and `--addmode OUTPUT NAME` to add that mode to a given
output.


### Device Specs

Chinese no-name VGI → HDMI Adapter:
- Range limits: 60-85 Hz V, 30-81 kHz H, max dotclock 150 MHz
- DTD 1: 1920x1080   60 Hz 67.5 kHz
  - 148.5  1920 2008 2052 2200  1080 1084 1089 1125 +HSync +VSync

QNX QHD2410R DP 23" QHD monitor:
- Range limits: 23-76 Hz V, 15-99 kHz H, max dotclock 250 MHz
- DTD 1: 2560x1440   59.951 Hz  88.787 kHz
  - 241.5  2560 2608 2640 2720 1440 1443 1448 1481  +HSync +VSync



<!-------------------------------------------------------------------->
[E-EDID]: https://en.wikipedia.org/wiki/Extended_Display_Identification_Data
