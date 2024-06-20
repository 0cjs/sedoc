X11 libinput Notes
==================

[libinput] is a library from Wayland that also provides a generic X.Org
input driver that can replace the old evdev and Synaptics drivers.
Version 1.16 of the X.Org server added support for this via the
`xf86-input-libinput` wrapper. (This required some changes to Gnome/GTK and
KDE as well; all was released in Fedora 22.)

The `libinput` command is in (Debian) `libinput-tools` package.

Documentation:
- [libinput][li-top] (documentation home)
- [Trackpoints and Pointing Sticks][li-tp]
- [Trackpoint configuration][li-tpconf]

### Trackpoints

(They seem to have genericised the name to "trackpoint" in the docs, rather
than using TrackPoint™.)

Trackpoints support [on-button scrolling][li-tpobs] where holding down the
middle button converts stick movements to scroll events.
- On by default, which prevents middle-button mouse drags. Change with
  `libinput_device_config_scroll_set_button()`.
- With `libinput_device_config_scroll_set_button_lock()` the button need
  not be held down; press/release once enables lock and again disables it.

The stick responds only to pressure; the trackpoint system returns events
that contain a delta from 1 to 30 or more. Light pressure sends delta 1
events at a slow rate; the rate increases with pressure until it reaches a
maximum, at which point further pressure doesn't change the rate but
increases the delta in the events. [[li-tp]]

#### Magic Trackpoint Multiplier

[Trackpoint configuration][li-tpconf] describes how to set up the "magic
trackpoint multiplier," the `AttrTrackpointMultiplier` [device
quirk][li-quirk]. Normally one should use only the quirks distributed with
libinput as they're an interal API that can change at any time. But it's
possible to override them locally; see below.

The multiplier is zero or greater, and defaults to 1.0. (For the 2016
ThinkPad X1, it's 0.5, as can be seen with `libinput quirks list
/dev/input/event5` or similar; use `libinput list-devices` to find the
device path.)

The [Device quirks][li-quirk] page gives details on installing temporary
local device quirks and debugging them.

    #   Find TPPS/2 IBM TrackPoint device.
    libinput list-devices

    #   List its quirks to get the name and current value of quirk.
    libinput quirks list --verbose /dev/input/event5
    #   Look for lines saying "full match"; these will tell you what
    #   file to look in for all details of how to match the quirk
    #   on your machine and set it.
    #   E.g., /usr/share/libinput/50-system-lenovo.quirks

    #   Add local changed version
    cat >> /etc/libinput/local-overrides.quirks
    [Lenovo X1 Carbon 4th Trackpoint]
    MatchUdevType=pointingstick
    MatchName=*TPPS/2 IBM TrackPoint*
    MatchDMIModalias=dmi:*svnLENOVO:*:pvrThinkPadX1Carbon4th*
    AttrTrackpointMultiplier=0.9

    #   Confirm it reads your new value correctly.
    libinput quirks list /dev/input/event5

(You can test files without bringing them into the environment using the
`--data-dir` option the above command; it tests _any_ files ending in
`.ini` in that dir.)

Then "restart the graphical environment" [[arch-libinput]] to use the
new quirk. Logging out and back in does this.



<!-------------------------------------------------------------------->
[arch-libinput]: https://wiki.archlinux.org/title/Libinput
[li-quirk]: https://wayland.freedesktop.org/libinput/doc/latest/device-quirks.html
[li-top]: https://wayland.freedesktop.org/libinput/doc/latest/
[li-tp]: https://wayland.freedesktop.org/libinput/doc/latest/trackpoints.html
[li-tpconf]: https://wayland.freedesktop.org/libinput/doc/latest/trackpoint-configuration.html#trackpoint-multiplier
[li-tpobs]: https://wayland.freedesktop.org/libinput/doc/latest/scrolling.html#button-scrolling
[libinput]: https://en.wikipedia.org/wiki/Wayland_(protocol)#libinput
