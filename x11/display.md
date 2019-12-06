X11 Display Information
=======================

* `xrandr`: output and monitor information (RandR extension)
* `xdpyinfo`: X11 display information
* `xrdb`: X server resource database utility


DPI
---

See [so-dpi] for a detailed analysis of DPI calculation in Ubuntu.

    grep DPI /var/log/Xorg.0.log
    xdpyinfo | grep dots
    xrdb  -query | grep dpi
    xwininfo -root -metric      # Shows screen size in mm according to DPI?

But for dealing with Xft fonts (e.g., `urxvt`), you want to set the
`Xft.dpi` property:

    echo 'Xft.dpi: 96' | xrdb -merge

But see also [fonts](fonts.md) if the issue seems to be the width of
terminals and the line height looks ok.

#### Other Applications

* `google-chrome` and [Electron apps] such as VS Code and Gitter  use
  one scaling for all non-retina DPI settings. To scale it at any low
  DPI setting:
  - Scale the entire application with `--force-device-scale-factor=0.75`.
  - Change the `chrome://settings` to set page zoom to 125%.
  - From [su 1222862]. See also [su 1116767] for much more.


xrandr Usage Summary
--------------------

xrandr lets you manage X11 _screens_ (or framebuffers) and how they
are displayed (potentially with transformations) on video _outputs_.
Remember that you may need to restart your window manager after a
screen (but not output) geometry change.

Sample usage:

    xrandr --output LVDS-1 --panning 1920x1080      # pan w/larger ext. monitor
    xrandr --output VGA1 --mode 1440x900 --same-as LVDS1

Output to terminal:
- `-v`: Print xrandr and X11 RandR extension versions
- `--prop`: Display properties for each output
- `--verbose`: Print _much_ more detailed information.
- no argument, `--query`, `--current`: print screen and output
  information. `*` indicates current mode, `+` preferred mode.

Changing screens:
- `--screen SNUM`: Select X11 (abstract) screen to change.
- `--fb WxH`: Set framebuffer size. All configured outputs must fit within
  this size.
- `--fbmm WxH`: Set reported physical screen size. Overrides DPI.
- `--dpi DPI`: Set reported screen DPI (also sets `--fbmm`).
- `--newmode NAME MODE`: Add a new modeline to the server; it must still be
  added to outputs as well. Remove with `--rmmode NAME`.

Screen to output mapping:
- `--left-of`, `--right-of`, `--above`, `--below`, `--same-as`: All take
  an output name.

Changing outputs:
- `--dryrun`
- `-d`, `--display NAME`: X11 display instead of `$DISPLAY`.

Common per-output options:
- `--output OUT`: Select output by name or XID.
- `--off`: Disable output.
- `--primary`: Set output as primary (sorted first in geometry requests).
- `--auto`: Set preferred output mode on connected output (~96 DPI if no
  preferred mode) and enable output. `--preferred` will avoid enabling.
- `--mode MODE`: Select mode by name or XID.

Output transformation from screen:
- `--panning WxH`: Enable panning for display on total panning area _WxH_
  (many more params available). (Use `--fb` to make screen size larger than
  largest output.)
- `--reflect`: Add `x`, `y` or `xy`.
- `--rotate`: Add `normal`, `left`, `right` or inverted.
- `--transform`,
- `--scale`, `--scale-from`: Shortcuts for `--transform`
- `--pos XxY`: Position output within the screen (pixels).

Rare per-ouput options:
- `--rate RATE`: Set preference for refresh rate.
- `--gamma R:G:B`, `--brightness`
- `--set PROP VAL`
- `--addmode OUTPUT NAME`: Add a mode to an ouput (see `--newmode`).
  Remove with `--delmode OUTPUT NAME`.

<!-------------------------------------------------------------------->
[electron apps]: https://electronjs.org/apps
[so-dpi]: https://askubuntu.com/a/272172/354600
[su 1116767]: https://superuser.com/q/1116767/26274
[su 1222862]: https://superuser.com/a/1222862/26274
