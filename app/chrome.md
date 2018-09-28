Google Chrome
=============

Markdown parsers generally won't turn `chrome://` URLs into links, so
they are quoted as code here and must be manually copied/pasted.

Command-line Options
--------------------

Documentation:
- [All switches], regularly updated from Chromium source.
- [Run Chromium With Flags] provides general documentation, including how
  to set flags on various OSes.
- `chrome://version` will show the command line used to start Chrome.

Common Options:
- `--proxy-server=socks5://localhost:1080`: Overrides environment vars.
- `--proxy-bypass-list=localhost,*example.com`: Only used if
  `--proxy-server` is used.
- `--proxy-pac-url=file:///home/user/proxy.pac`


Internal URLs
-------------

- `chrome://flags`


UI Layout
---------

The top tabs top tabs can be changed using `chrome://flags/#top-chrome-md`.



[Run Chromium With Flags]: https://www.chromium.org/developers/how-tos/run-chromium-with-flags
[all switches]: https://peter.sh/experiments/chromium-command-line-switches/
