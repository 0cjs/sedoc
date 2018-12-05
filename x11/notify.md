X11 Notifications
=================

There is a [Desktop Notifications Specification][spec] used by Gnome
and other desktop systems. All notifications are handled by a single
session-scoped service that provides a D-BUS interface.

Servers:
* `xfce4-notifyd`

Clients:
* Gnome's [libnotify].
* `notify-send`: A command-line client from the `libnotify-bin` package.

Other:
* `xfce4-notifyd-config`: Graphical configuration tool for `xfce4-notifyd`.
  This allows configuring logging, do-not-disturb, blocked applications, etc.



[spec]: https://developer.gnome.org/notification-spec/
[libnotify]: https://developer.gnome.org/platform-overview/stable/tech-notify.html.en
