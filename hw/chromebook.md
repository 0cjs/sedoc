Google Chromebook
=================

Command Prompts
---------------

Ctrl-Alt-T opens a terminal running a [Crosh shell]. Commands include
the following; _(dev)_ indicates that it works only in developer mode.

* `help`
* `help_advanced`: (dev)
* `shell`: (dev) Starts a Bash shell.
* `tpcontrol`, `xset m|r`: Touchpad and mouse tweaking.
* `ssh`: Includes options for SOCKS proxy for tunnelling.
* `ssh_forget_host`: SSH known_hosts management.
* `top`
* `ping`
* `tracepath`
* `network_diag`
* `packet_capture`: (dev)

By default the window is in a browser tab. Use [croshwindow]
([source]) to get separate, undecorated windows.



[Recovery] and Developer Modes
------------------------------

To force entry into [recovery] mode, hold Esc and Refresh (F3) and then
press the power button. (On the Chromebook Flip, this is on the left
side of the unit.) It will say the OS is missing or damaged, but it's
not if it wasn't before.

In recovery mode, pressing Ctrl-D will enable [developer
mode][generic], disabling OS verification. This will take 10-15
minutes. After a reboot you'll get a chance to enable [debugging
features]; this is usually not desirable nor necessary just to use
Crouton.

Once developer mode is enabled, at every boot you'll need to press
Ctrl-D or wait 30 seconds and listen to a very loud beep. (This
notifies the user that the host is not secure.) If instead you press
space twice to re-enable OS verification, this will power-wash the
system.

There is further [developer info]; that page links to instructions for
particular devices. The Asus C300 uses the [generic developer
instructions][generic].

#### Debugging Features

The [debugging features] can be enabled only during the initial setup
after wiping and enabling developer mode. This is very insecure; among
other things it enables an SSH server that uses password login and
standard test keys. If you do enable it, you can get a text console
with Ctrl-Alt-F2 and log in as root with default password 'test0000'.


[Crouton]
---------

* Installer download: <https://goo.gl/fd3zc>.
* Run installer in shell: `sh ~/Downloads/crouton`
* Chrome extension: <https://goo.gl/OVQOEt>



[crosh shell]: https://www.howtogeek.com/170648/10-commands-included-in-chrome-oss-hidden-crosh-shell/
[croshwindow]: https://chrome.google.com/webstore/detail/crosh-window/nhbmpbdladcchdhkemlojfjdknjadhmh
[crouton]: https://github.com/dnschneid/crouton
[debugging features]: http://www.chromium.org/chromium-os/how-tos-and-troubleshooting/debugging-features
[developer info]: http://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices
[generic]: http://www.chromium.org/a/chromium.org/dev/chromium-os/developer-information-for-chrome-os-devices/generic
[recovery]: https://support.google.com/chromebook/answer/1080595
[source]: https://github.com/adlr/croshwindow
