Syncthing
=========

[Syncthing][] ([docs], [GitHub]) synchronises directories and files between clusters of computers,
encrypting all data in transit and optionally encrypting data at rest.

### Versions

    2.1.0   Latest, distributed via upstream apt repo
    1.30.0  Last 1.x release
    1.29.5  Debian 13 `syncthing` package
    1.19.2  Debian 12 `syncthing` package

Downloads/repos can be found at <https://syncthing.net/downloads/>,
<https://apt.syncthing.net>.

2.x and 1.x are wire-compatible, so will interoperate. 2.x just brings in a
new DB format etc.; on first start it will migrate any 1.x local data and
then you can't go back.

[Syncthing Tray] is third-party code that provides a tray icon and the
`syncthingctl` program, which complements the standard `syncthing cli`
interface. (The latest version is not regularly tested with v1.x, but
should mostly work.) `syncthingctl` will also let you manipulate the config
with JS code; this may be useful for handling dot-home configuration.

### Installation

    #   `syncthingtray` provides `syncthingctl` as well as
    sudo apt install syncthing syncthingtray    # latter if using a desktop

    systemctl --user enable --now syncthing.service
    #   Or on headless boxen:
    sudo systemctl enable --now syncthing@cjs.service

    #   If you want it running at boot, even if you don't log in.
    sudo loginctl enable-linger cjs

The web GUI binds to `127.0.0.1:8384`. It requires cookies to be enabled.
It can be configured with username/passphrase authentication.


Overview
--------

Syncthing synchronises _folders_ between _devices._
* A _device_ is a particular instance of Syncthing running on a host. It is
  identified by a public-key-like _device ID_ often expressed as an 8×7
  char string or the first six chars of that string.
* A _folder_ is a directory tree identified with a global _folder ID_; it
  has a local (to each device) _path_ and _label._ It will contain an
  `.stfolder/` subdir as a marker (contains nothing—metadata is held in the
  program config).

Two devices will sync only if they mutually have each other's device IDs
configured. Your ID can be found via Actions » Show ID, but devices
announce themselves on the local network and +Add Remote Device will
display the list of unknown announcers so you can auto-add. This will
trigger a pop-up on the other host asking if you want to reciprocate.

They also can receive sync only for folders the peer has been configured to
offer. Adding a share on one side will offer it to the other host,
triggering a pop-up asking if you want to reciprocate, and (if not
immediately accepted) leaving it in the list of pending shares.

XXX write up _introducers_.

XXX write up notes on untrusted devices.

### Paths

The demon has _config_ and _data_ (metadata) dirs; these both default to
`${XDG_STATE_HOME:-~/.local/state}/syncthing` and can be overridden with
various options: `--home, -H, --config, -C, --data, -D`. (Pre-1.27 this was
in `${XDG_CONFIG_HOME:-~/.config}/syncthing`.)

The config dir contains TLS keys and certs and `config.xml`, which is a
combination config and status file that's heavily modified by Syncthing as
it runs. To manage it from dot-home, you'd want to write programs that
manipulate this via web API, probably most easily driven by `synthing cli`.

### Networking

Each device may have multiple addresses; these are advertised using:
- Local broadcast: to other peers on local networks. This allows easier
  adding of peers (see above).
- Discovery servers: directory servers that look up addresses from a device
  ID; a device normally registers with `discovery.syncthing.net`.
- Static config: in config file.

Devices behind NAT or similar may acquire addresses on a _relay server_
(default the pool at `relays.syncthing.net`, but you could add your own)
that they advertise just as they do other addresses.


FAQ and Tips
------------

### Web Interface Stops Working w/Partial Information Shown

The typical symptom is that the panel renders without info: device is
"unknown device" with blank/default fields and no folders are listed. This
is typically CSRF errors, with a common cause being that browser cookies
are blocked for the origin (CSRF token is cookie-delivered): you've used
both HTTP and HTTPS, and cookies are not enabled for both. You must enable
_both_ <http://127.0.0.1:8384> _and_ <httpS://127.0.0.1:8384> origins.

In this case, `syncthing cli show system` will work fine because it's a
browser, not an API, issue. (And in the browser developer tools, `/rest/…`
requests will return 403 with 'CSRF Error' in the body.)


<!-------------------------------------------------------------------->
[GitHub]: https://github.com/syncthing/
[Syncthing Tray]: https://github.com/Martchus/syncthingtray
[Syncthing]: https://syncthing.net/
[docs]: https://docs.syncthing.net/
