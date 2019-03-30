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



<!-------------------------------------------------------------------->
[electron apps]: https://electronjs.org/apps
[so-dpi]: https://askubuntu.com/a/272172/354600
[su 1116767]: https://superuser.com/q/1116767/26274
[su 1222862]: https://superuser.com/a/1222862/26274
