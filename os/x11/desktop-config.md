X11 Desktop Configuration
=========================

There are a number of different configuration systems; the XDG (X11 Desktop
Group) ones seem to be a sort of common standard.

### Directories

The [XDG Base Directory Specification][xdg-basedir] is better summarised on
the Arch Wiki [XDG Base Directory][arch-xdg-basedir] page. Brief overview:

    XDG NAME          Default               Analagous to
    ───────────────────────────────────────────────────────────────────
    XDG_CONFIG_HOME   $HOME/.config         /etc
    XDG_DATA_HOME     $HOME/.local/share    /usr/share
    XDG_STATE_HOME    $HOME/.local/state    /var/lib, /var/log
    XDG_CACHE_HOME    $HOME/.cache          /var/cache
    XDG_RUNTIME_DIR   (none; always set)    /var/run
    ───────────────────────────────────────────────────────────────────
    XDG_DATA_DIRS     /usr/local/share:/usr/share
    XDG_CONFIG_DIRS   /etc/xdg
    ───────────────────────────────────────────────────────────────────

A few non-obvious notes:
- `XDG_STATE_HOME` should persist between application restarts, but may be
  deleted.
- Log files go in $XDG_STATE_HOME, despite this being under `.local/state/`
  rather than something with `var` or `log` in the name.
- `XDG_RUNTIME_DIR`, _must_ be created when the user logs in (`pam_systemd`
  sets this to `/run/user/$UID`), accessible only to the user (mode 0700),
  and on a local FS not shared with any other system. Any file without the
  sticky bit set and >6h old may be automatically removed.
  - If not set, apps should print a warning and fall back to whatever is
    appropriate for them.

Most of the spec above dates from around 2003, but `XDG_STATE_HOME` is
quite new: it was released in 0.8 in 2022. [[list-XDG_STATE_HOME]],
[[systemd#25739]], [[tinydm#8]]. Applications previously dumped state and
log files into `XDG_DATA_HOME` or `XDG_CACHE_HOME` and it's unclear how
many have updated.


XDG MIME Settings and gnome-open (xdg-open too?)
------------------------------------------------

For the issue with `gnome-open` and Telegram using the wrong browser, the
issue appears be with some XDG MIME settings. `xdg-mime query default TYPE`
with the following _TYPE_ arguments gave these results:

    text/html                       google-chrome.desktop
    x-scheme-handler/http           chromium.desktop
    x-scheme-handler/https          chromium.desktop

This was fixed with

    xdg-mime default google-chrome.desktop \
      text/html x-scheme-handler/https x-scheme-handler/http


<!-------------------------------------------------------------------->
[arch-xdg-basedir]: https://wiki.archlinux.org/title/XDG_Base_Directory
[xdg-basedir]: https://specifications.freedesktop.org/basedir-spec/latest/

[list-XDG_STATE_HOME]: https://lists.freedesktop.org/archives/xdg/2016-December/013803.html
[systemd#25739]: https://github.com/systemd/systemd/issues/25739
[tinydm#8]: https://gitlab.com/postmarketOS/tinydm/-/merge_requests/8
