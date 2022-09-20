Google Chrome
=============

Markdown parsers generally won't turn `chrome://` URLs into links, so
they are quoted as code here and must be manually copied/pasted.

Contents:
- Configuration
- Command-line Options
- Internal URLs
- Proxies


Configuration
-------------

The display of the Reading list in the bookmarks bar can be turned on and
off from the bookmarks bar context menu, but that still leaves the star in
the URL bar dropping down a menu to select bookmark or reading list. To get
rid of that, kill the feature entirely by going to `chrome://flags/#read-later`
(or search for "Reading") and changing the "Reading List" flag to
"Disabled."


Command-line Options
--------------------

Documentation:
- [All switches], regularly updated from Chromium source.
- [Run Chromium With Flags] provides general documentation, including how
  to set flags on various OSes.
- `chrome://version` will show the command line used to start Chrome.

Common Options:
- `--proxy-pac-url=file:///home/user/proxy.pac`
-- `--window-position=x,y`, `--window-size=x,y`


Internal URLs
-------------

- `chrome://flags`
- `chrome://flags/#top-chrome-md`: UI layout for tabs etc.


Proxies
-------

The [Debugging problems with the network proxy][proxdebug] page may be
helpful. However, as of version 71 the `chrome://net-internals/#proxy`
URL given by this page no longer appears to work.

Command-line options:
- `--proxy-server=socks5://localhost:1080`: Overrides environment vars.
- `--proxy-bypass-list=localhost,*example.com`:
  Used _only_ if `--proxy-server` option used, even if `$HTTP_PROXY` set.



<!-------------------------------------------------------------------->
[Run Chromium With Flags]: https://www.chromium.org/developers/how-tos/run-chromium-with-flags
[all switches]: https://peter.sh/experiments/chromium-command-line-switches/
[proxdebug]: https://www.chromium.org/developers/design-documents/network-stack/debugging-net-proxy
