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

### Installation

`homeinst telegram` will do it. Or download the .tar.gz from the downloads
page and place the two files `Telegram/{Telegram,Update}` into your
`~/.local/bin/`. Snap and Flatpak are also available.

### Usage

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

- `Ctrl-/`: list of keyboard shortcuts
- `Ctrl-K`: quick switcher (toggle)
- `Ctrl-I`: inbox (toggle)
- `Shift-PgUp`: jump to oldest unread message

Press `Tab` to enter keyboard mode; circles through items.

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

UI:
- Links can be added most easily by copying the link, selecting the
  hyperlink text when editing the message, and pasting (Ctr-V).
- Code text cannot be linked.


Signal
------

You must have the phone app installed before you can use Signal on desktop.
The following instructions are from the pop-up shown by the "Download for
Linux] button on the [Signal download] page (with added `chmod` commands).

    # NOTE: These instructions only work for 64 bit Debian-based
    # Linux distributions such as Ubuntu, Mint etc.

    # 1. Install our official public software signing key
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
    cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
    sudo chmod go+r /usr/share/keyrings/signal-desktop-keyring.gpg

    # 2. Add our repository to your list of repositories
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
      sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
    sudo chmod go+r /etc/apt/sources.list.d/signal-xenial.list

    # 3. Update your package database and install signal
    sudo apt update && sudo apt install signal-desktop


Google Meet
-----------

            Space   Push-to-talk (when enabled)
                C   Captions show/hide
          Shift-M   Picture-in-picture mode
    ────────────────────────────────────────────────────────
           Ctrl-D   Microphone mute/unmute
               -E   Camera off/on
    ────────────────────────────────────────────────────────
       Ctrl-Alt-C   Meeting chat window show/hide
               -P   Participants show/hide
               -H   Hand raise/lower
               -K   Increase number of participant tiles
               -J   Decrease   "    "      "        "
               -M   Your video minimise/expand
    ────────────────────────────────────────────────────────
       Ctrl-Alt-S   Announce who is currently speaking
               -I      "     current information about room
               -X      "     recently received reactions
    ────────────────────────────────────────────────────────

References: [[gm-shortcuts]]


<!-------------------------------------------------------------------->
[Gitter]: https://gitter.im/apps
[g zoom]: https://gist.github.com/MadLittleMods/fd8cebe7e370a471b073

[t md]: http://telegra.ph/markdown-07-07

[d qs]: https://support.discord.com/hc/en-us/articles/115000070311

[Signal download]: https://signal.org/download/

[gm-shortcuts]: https://support.google.com/a/users/answer/9896256?hl=en
