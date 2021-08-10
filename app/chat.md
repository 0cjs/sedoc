Chat System Tips and Tricks
===========================

Multi-system Chat Clients
-------------------------

* *[Franz](http://meetfranz.com/)* (Win/Mac/Linux): Basically a wrapper around
  the web interfaces of the chat systems (this makes Hangouts kinda terrible).
  Best feature may be getting all notifications from one place.
  UI is not great. Doesn't do [Line](https://line.me).

Gitter
------

In the old (now unsuable) version of the [Gitter] desktop client, the zoom
[could be changed][g zoom]. Bring up the console from menu `Gitter /
Developer Tools` and enter:

    gui.Window.get().zoomLevel = -1.1;   // 0 is default zoom

Unfortunately this no longer works as of Gitter 4.x, and I don't know
of a replacement. (Help wanted on this!)


Telegram
--------

Settings » Advanced contains useful stuff:
- Manage local storage: reduce max disk usage from 3 GB
- Export Telegram data: account info, contacts, messages, media.
  (Notifies all devices; approve on mobile or wait 24h.)
- System Integration: if icons, window frames are incorrect.

[Telgram markdown formatting][t md] varies by client. For Android,
Web and Win/Unix desktop:

    Markup:     __italic__   **bold**   `monspace`  ```multiline monospace```
    Shortcut:   Ctrl-I       Ctrl-B     Ctrl-Shift-M

Also `Ctrl-K` for links and `Ctrl-Shift-N` to clear formatting.

`Ctrl-Z` or `Backspace` will roll back emoji replacement.


Discord
-------

[Quick Swicher][d qs] summary and prefixes:

    Enter   (alone) switch to previous channel
    *       server name search; goes to last-used channel on that server
    @       user name search; goes to DM with user
    #       text channel name
    !       voice channel name


Slack
-----

Tips:
* Copying a message link in Slack produces a URL like
  `https://something.slack.com/archive/CE7MF912Q/p1555997770049100`.
  In a browser this will attempt to open the Slack app. To jump
  directly to the message, replace `archive` with `message`.



<!-------------------------------------------------------------------->
[Gitter]: https://gitter.im/apps
[g zoom]: https://gist.github.com/MadLittleMods/fd8cebe7e370a471b073

[t md]: http://telegra.ph/markdown-07-07

[d qs]: https://support.discord.com/hc/en-us/articles/115000070311
