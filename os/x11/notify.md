X11 Notifications
=================

There is a [Desktop Notifications Specification][spec] used by Gnome
and other desktop systems. All notifications are handled by a single
session-scoped service that provides a D-BUS interface.

Servers:
* [GNOME Notification Daemon]
  \(`/usr/lib/notification-daemon/notification-daemon`):
  Quite barebones.
* XFCE4 notifyd
  \(`/usr/lib/x86_64-linux-gnu/xfce4/notifyd/xfce4-notifyd`):
  Features include muting and logging. Configure with `xfce4-notifyd-config`.

Clients:
* Gnome's [libnotify].
* `notify-send`: A command-line client from the `libnotify-bin` package.

Other:
* `xfce4-notifyd-config`: Graphical configuration tool for `xfce4-notifyd`.
  This allows configuring logging, do-not-disturb, blocked applications, etc.


Web App Notifications
---------------------

Web browsers offer a [Notifications API] for displaying notifications
outside the page at the system level; on Linux this typically uses the
Desktop Notifications Specification above.



<!-------------------------------------------------------------------->
[GNOME Notification Daemon]: https://github.com/GNOME/notification-daemon
[Notifications API]: https://developer.mozilla.org/en-US/docs/Web/API/Notifications_API/Using_the_Notifications_API
[libnotify]: https://developer.gnome.org/platform-overview/stable/tech-notify.html.en
[spec]: https://developer.gnome.org/notification-spec/
