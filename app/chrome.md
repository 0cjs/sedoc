Google Chrome
=============

Markdown parsers generally won't turn `chrome://` URLs into links, so
they are quoted as code here and must be manually copied/pasted.

Contents:
- Configuration
- Command-line Options
- Internal URLs
- Proxies
- Cookies


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


Cookies
-------

### Site Allow and Block Lists

The site-specific allow and block lists are at `chrome://settings/cookies`.

I normally use "Block all cookies (not recommended)" in the global settings
at the top of this page and rely on the allow list ("Sites that can always
use cookies") to make trusted sites work. Temporarily switching to "Block
third-party cookies" can help with sites that mysteriously stop working; if
that fixes the problem, enabling third party cookies for just that site may
fix it in "Block all" mode.

When adding a new allow entry in this page the dialogue will contain an
"Including third-party cookies on this site" checkbox; if you check this
the entry will become a special entry:
- Search will not find it in the allow list.
- It appears at the _end_ of the allow list.
- It can only be deleted, not edited.

The third-party checkbox does not appear when editing; to change the
third-party setting delete the entry and add a fresh one.

As of Chrome 105 an "eye" icon is displayed in the URL bar on sites when
cookies (for that site or third parties) are blocked by default. (And by
block list entries?)
- Clicking "eye" » "Site not working?" will bring up a dialogue with an
  "Allow" button. __WARNING:__ using that button will add an entry to allow
  all third-party cookies when accessing the site in the URL bar.
- Clicking "Show cookies and other site data..." in the above dialogue will
  bring up the "Cookies in use" dialogue with "Allowed" and "Blocked"
  panes; here you can individually enable sites.
- (Previously there was a "cookie" icon in the URL bar that did this also
  for sites where you accept cookies; this earlier [disappeared for some
  profiles][su 1689521] and as of Chrome 105 seems to be completely gone.)

### Sites Requiring Third-party Cookies

    trello.com

With some sites requiring third-party cookies you can enable them bit by bit:
after reloading with `foo.com` enabled, the eye icon will appear and you can
see more cookies that were blocked for this page load.

With other sites, such as `trello.com`, you won't see an indication that
further cookies were blocked but you still need to enable additional
domains for it to work. I tried adding the butlerfortrello.com I saw in
DevTools»Applicaton»Storage»Cookies with third-party cookies enabled, but
not even that did it. Looking through the network logs didn't produce
anything obvious, but it's a huge amount of unsearchable data.

### References

- superuser.com: [How can I show all allowed and blocked cookies for a page
  in Chrome?][su 1743322]
- superuser.com: [Why is my Chrome URL bar cookie dialogue different
  between two profiles?][su 1689521]



<!-------------------------------------------------------------------->
[Run Chromium With Flags]: https://www.chromium.org/developers/how-tos/run-chromium-with-flags
[all switches]: https://peter.sh/experiments/chromium-command-line-switches/
[proxdebug]: https://www.chromium.org/developers/design-documents/network-stack/debugging-net-proxy
[su 1743322]: https://superuser.com/q/1743322/26274
[su 1689521]: https://superuser.com/q/1689521/26274
