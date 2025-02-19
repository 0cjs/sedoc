Keyring, Agent and Similar Programs
===================================

Gnome-Keyring
-------------

For more information see [nurdletech].

`gnome-keyring-daemon` can do secret storage and serve as an agent for
various protocols, depending on how it's started. Typical startup to cover
all of this in your `.{xsession,xinirc}` would be:

    export $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)

You can query this daemon with the `seahorse` program.

Clients include:
- NetworkManager, for storing WiFi and VPN passwords. (But not if
  they're marked to be made available for all users; those go in `/etc`.
- VSCode, for storage of information relating to your GitHub or other
  login used for Live share.



[nurdletech]: https://nurdletech.com/linux-notes/agents/keyring.html
