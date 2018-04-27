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



[so-dpi]: https://askubuntu.com/a/272172/354600
