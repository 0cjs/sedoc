X11 Keyboard Notes
==================

Automation and Sending Keys
---------------------------


`xdotool` and `xte` (Debian package `xautomation`) can send keystrokes and
change modifiers, e.g.:

    xdotool key F3
    xdotool key Caps_Lock               # toggles caps lock
    xte "key Caps_Lock"

Python can also interact with X11 (warning, 2011 code). Modifiers are
1=Shift, 2=Lock (Caps Lock), 4=Control, 8=Mod1, 16=Mod2, 32=Mod3, 64=Mod4,
128=Mod5. Run `xmodmap -pm` to see what Mod1 through Mod5 correspond to.
[[ubse 80301]].

    #!/usr/bin/env python
    from ctypes import *
    X11 = cdll.LoadLibrary("libX11.so.6")
    display = X11.XOpenDisplay(None)
    X11.XkbLockModifiers(display, c_uint(0x0100), c_uint(2), c_uint(0))
    X11.XCloseDisplay(display)


Keybaord Remapping
------------------

As well as (or after) as remapping with `xmodmap`, the keyboard can be
reset to the standard configuration with `setxkbmap`:

    setxkbmap -option                   # stdandard configuration
    setxkbmap -option ctrl:nocaps       # std cfg except caps→ctrl
    setxkbmap -option caps:none         # caps sent, but no longer toggles lock

    xkbset nullify lock
    xkbset nullify -lock

The `caps:none` setting can be useful for programs that check for and
require the presence of the key even if you don't want to use it. [This
answer][use 75492] explains this and other answers there have lots of
interesting information.



<!-------------------------------------------------------------------->
[ubse 80301]: https://askubuntu.com/a/80301/354600
[use 75492]: https://unix.stackexchange.com/a/75492/10489
