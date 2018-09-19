Proxy Auto-config
=================

Most browsers (and perhaps other user-agents) can use a [proxy
auto-config (PAC)][PAC] file to choose a proxy server on a per-request
basis. The file is JavaScript supplying a `FindProxyForURL(url, host)`
function run in a sandbox supplying a few helper functions.
`FindProxyForURL` returns a character string of semicolon-separated
proxy configurations to be tried in order; the configurations are
`DIRECT`, `PROXY host:port` or `SOCKS host:port`, e.g..

    PROXY proxy.example.com:8080; SOCKS 10.1.2.3:1080; DIRECT

Unresponsive proxies will usually be ignored for some time (e.g. 30
minutes) after first detected unresponsive.

UTF-8 might not be supported in PAC files.


PAC File Location
-----------------

PAC files location be specified with the `--proxy-pac-url=` option to
Google Chrome; use the `file:///` scheme for local files.

Many other browsers have an 'Automatic proxy configuration URL' or
'Automatic configuration script' setting.

Browsers may use the [Web Proxy Autodiscovery Protocol][WPAP] to find
the location whence a PAC file can be downloaded.


PAC Sandbox API
---------------

From [Navigator] and [Firefox]:

- `isPlainHostName(host)`: No dots in hostname.
- `dnsDomainIs(host, domain)`: Right-hand portion of _host_ matches
  _domain_.
- `localHostOrDomainIs(host, hostdom)`: _host_ is equal to _hostdom_
  of the leftmost dot-separated component of _hostdom_.
- `isResolvable(host)`: Name can be resolved to an address.
- `isInNet(host, netaddr, mask)`: Resolved _host_ address matches
  _netaddr_ as masked by _mask_. 'Same as in SOCKS specification.'
- `dnsResolve(host)`: Resolves IP address of _host_.
- `myIpAddress()`: Returns address of current host. May return
  'useless' answers such as `127.0.0.1`.
- `dnsDomainLevels(host)`: Number of dot-separated components in `host`.
- `shExpMatch(str, pat)`: Match _str_ against shell glob pattern _pat_.

Date-related functions include `weekdayRange`, `dateRange`, `timeRange`.

Standard JavaScript functions on strings can also be used:
- `host.substring(0,5) == "http:"`


Testing PAC Code
----------------

[pacparser] is a C library to parse PAC files. (Despite the README,
the Python wrapper builds under both Python 2 and 3.) It uses
SpiderMonkey to interpret the JavaScript.

`pacparser` is available from PyPI. However, it doesn't seem to
install on Linux even if one has `libpacparser-dev` (Debian)
installed. Debian does have a `python3-pacparser` package available.



[Firefox]: https://calomel.org/proxy_auto_config.html
[PAC]: https://en.wikipedia.org/wiki/Proxy_auto-config
[WPAP]: https://en.wikipedia.org/wiki/Web_Proxy_Autodiscovery_Protocol
[navigator]: https://web.archive.org/web/20070602031929/http://wp.netscape.com/eng/mozilla/2.0/relnotes/demo/proxy-live.html
[pacparser]: https://github.com/manugarg/pacparser
