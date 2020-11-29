X11 Desktop Configuration
=========================

There are a number of different configuration systems; the XDG (X11 Desktop
Group) ones seem to be a sort of common standard.

For the issue with `gnome-open` and Telegram using the wrong browser, the
issue appears be with some XDG MIME settings. `xdg-mime query default` with
the following arguments gave these results:

    text/html                       google-chrome.desktop
    x-scheme-handler/http           chromium.desktop
    x-scheme-handler/https          chromium.desktop

This was fixed with

    xdg-mime default google-chrome.desktop \
      x-scheme-handler/https x-scheme-handler/http
