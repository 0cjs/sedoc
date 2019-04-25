Chat System Tips and Tricks
===========================

Multi-system Chat Clients
-------------------------

* *[Franz](http://meetfranz.com/)* (Win/Mac/Linux): Basically a wrapper around
  the web interfaces of the chat systems (this makes Hangouts kinda terrible).
  Best feature may be getting all notifications from one place.
  UI is not great. Doesn't do [Line](https://line.me).

[Gitter]
--------

In the old (now unsuable) version of the Gitter desktop client, the
zoom [could be changed][gitter-zoom]. Bring up the console from menu
`Gitter / Developer Tools` and enter:

    gui.Window.get().zoomLevel = -1.1;   // 0 is default zoom

Unfortunately this no longer works as of Gitter 4.x, and I don't know
of a replacement. (Help wanted on this!)


Telegram
--------

[Telgram markdown formatting][tel-md] varies by client. For Android,
Web and Win/Unix desktop:

    Markup:     __italic__   **bold**   `monspace`  ```multiline monospace```
    Shortcut:   Ctrl-I       Ctrl-B     Ctrl-Shift-M

Also `Ctrl-K` for links and `Ctrl-Shift-N` to clear formatting.

`Ctrl-Z` or `Backspace` will roll back emoji replacement.


Slack
-----

Tips:
* Copying a message link in Slack produces a URL like
  `https://something.slack.com/archive/CE7MF912Q/p1555997770049100`.
  In a browser this will attempt to open the Slack app. To jump
  directly to the message, replace `archive` with `message`.



<!-------------------------------------------------------------------->
[Gitter]: https://gitter.im/apps
[gitter-zoom]: https://gist.github.com/MadLittleMods/fd8cebe7e370a471b073
[tel-md]: http://telegra.ph/markdown-07-07
