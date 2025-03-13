X11 Login and Session Startup
=============================

Display Manager
---------------

* The Display Manager provides the login screen.
* Its Debian apt package will provide `x-display-manager`.
* `xdm` is the original old-school one.
* [`lightdm`], from freedesktop.org, is the usual default.

#### LightDM

LightdDM uses "greeters" to determine how to display the login screen.
They're found in `/usr/share/xgreeters/*.desktop`. Debian+Xfce uses
the GTK greeter. Ubuntu uses the Unity greeter. The [Ubuntu wiki
page][uw-lightdm] provides lots of good info on LightDM.

###### Greeter Configuration

`lightdm --show-config` will show lightdm's configuration, including
the source file for each non-default setting. Local configuration is
added to Ubuntu 18 (and maybe Debian, but maybe not) under
`/etc/lightdm/lightdm.conf.d/`.

The `greeter-hide-users` option determines whether you need to type in
your login name (`true`) or select your full name from a dropdown
(`false`). Debian 9 sets this to `true`; Ubuntu 18 leaves it at the
default `false`. Override this by adding
`/etc/lightdm/lightdm.conf.d/50-hide-users.conf` with:

    [Seat:*]
    greeter-hide-users=true

### Choosing a Session

LightDM with the GTK greeter gives me a drop-down to choose the
session. With Xfce and Fvwm installed you will typically see:

    Debian 9                XUbuntu 18.04
    -------------------     -------------------
    • Default Xsession     • Fvwm
    • Fvwm                 • Xfce Session
    • Xfce Session         • Xubuntu Session

The session descriptions above are stored in `/usr/share/xsessions/`.
(Files in this directory must be world-readable to be picked up when
`lightdm` is restarted.) The Debian 9 'Default Xsession' above is
`lightdm-xsession.desktop`:

    [Desktop Entry]
    Version=1.0
    Name=Default Xsession
    Exec=default
    Icon=
    Type=Application

The the 'LightDM configuration' section of [CustomXSession] on the
Ubuntu Wiki describes how to add a new one, suggesting
`custom.desktop` containing:

    [Desktop Entry]
    Name=Xsession
    Exec=/etc/X11/Xsession

Both of the above should execute your `.xsession` file on login.

`lightdm --show-config` on Debian 9 shows `session-wrapper=/etc/X11/Xsession`;
I'm not clear on what this means.


Session Startup
---------------

See also [CustomXSession] on the Ubuntu Wiki.

The default session manager can be seen with
`update-alternatives --display x-session-manager`.

#### Startup Files

(Many of these have a `/etc` version as well.)

* `~/.xinitrc`: Used by [`xinit`]
* `~/.xsession`: Used by "bare" sessions (i.e., not Gnome, Xfce, etc.)
* [`~/.xprofile`]: Sourced by GDM, KDM, LightDM, LXDM, SDDM. (But not
  by XDM or SLIM.)

#### Session Options in the Display Manager

The "Xfce Session" option in the Display Manager section above
presumably does whatever Xfce normally does.

The "Fvwm" option seems to run a "pure" Fvwm 2 configuration that does
not appear to run `.xsession` or `.xinitrc`, presumably relying on
`.fvwm/config` to do all the setup. The environment for this includes

    DESKTOP_SESSION=fvwm
    XGD_SESSION_DESKTOP=fvwm
    GTK_IM_MODULE=xim
    GDM_SESSION=fvwm

I use `Default Xsession` which does run `~/.xsession` (mine sources
`~/.profile` and then execs `~/.xinitrc`) and give me an environment with:

    DESKTOP_SESSION=lightdm-xsession
    XGD_SESSION_DESKTOP=fvwmlightdm-xsession
    XDG_CURRENT_DESKTOP=XFCE
    GTK_IM_MODULE=ibus
    GDM_SESSION=fvwmlightdm-xsession

Though I'm using `xfce4-panel` I don't use the Xfce session manager
or desktop; I just run `fvwm` at the end of my `.xinitrc`.

#### Gnome Keyring

See Arch Wiki [GNOME/Keyring]. This works outside of GNOME as well.
The usual name (hardcoded for some programs) of the password keyring
is `Login`, and if the password is the same as your Unix password, PAM
may unlock it at login.

This also may run SSH and GnuPG agents. As of GNOME 3.28 the SSH agent
is just a wrapper around OpenSSH's `ssh-agent`.

Applications:
- `gnome-keyring-daemon` starts, manages and gives environment
  information.
- `libsecret` is the API.
- `seahorse` is a visual tool for browsing keyrings and other info.
- `secret-tool` (apt `libsecret-tools`) looks up attrs/values from the
  command line. Not useful for browsing.
- Google Chrome ≥70 uses it to store web site passwords.

Further information:
- [so-376112]

#### Other Information

* The `startx(1)` manpage.
* The [Ubuntu Wiki Session Startup][uw-ses-start] page has little
  useful information and seems to be GDM-specific.
* Debian Reference, [Starting the X Window System][debref-startx]
* [X Window System Administrator's Guide][x11-admin-guide]



[CustomXSession]: https://wiki.ubuntu.com/CustomXSession
[GNOME/Keyring]: https://wiki.archlinux.org/index.php/GNOME/Keyring
[`lightdm`]: https://freedesktop.org/wiki/Software/LightDM/
[`xinit`]: https://wiki.archlinux.org/index.php/Xinit
[`~/.xprofile`]: https://wiki.archlinux.org/index.php/Xprofile
[debref-startx]: https://www.debian.org/doc/manuals/debian-reference/ch07.en.html#_starting_the_x_window_system
[so-376112]: https://unix.stackexchange.com/q/376112/10489
[uw-lightdm]: https://wiki.ubuntu.com/LightDM
[uw-ses-start]: https://wiki.ubuntu.com/X/Config/SessionStartup
[x11-admin-guide]: https://archive.org/details/xwindowsystemadm08muimiss
