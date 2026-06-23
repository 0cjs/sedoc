SyncThing
=========

[SyncThing][] ([docs], [GitHub]) synchronises directories and files between clusters of computers,
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

[SyncThing Tray] is third-party code that provides a tray icon and the
`syncthingctl` program, which complements the standard `syncthing cli`
interface. (The latest version is not regularly tested with v1.x, but
should mostly work.) `syncthingctl` will also let you manipulate the config
with JS code; this may be useful for handling dot-home configuration.

### Installation

    #   `syncthingtray` provides `syncthingctl` as well as
    sudo apt install syncthing syncthingtray    # latter if using a desktop
    systemctl --user enable --now syncthing.service

    #   If you want it running at boot, even if you don't log in.
    sudo loginctl enable-linger cjs
    #   On headless boxen:
    sudo systemctl enable --now syncthing@cjs.service

The web GUI binds to `127.0.0.1:8384`. It can be configured with
username/passphrase authentication.


Overview
--------

SyncThing synchronises _folders_ between _devices._
* A _device_ is a particular instance of SyncThing running on a host.
  It is identified by a public-key-like _device ID_ often expressed as an
  8×7 char string or the first six chars of that string.
* A _folder_ is a directory tree identified with a global _folder ID_; it
  has a local (to each device) _path_ and _label._ It will contain an
  `.stfolder/` subdir for metadata, though some metdata is held in the
  program config.

Two devices will sync only if they mutually have each other's device IDs
configured. (Actions » Show ID, use string or QR code.)

### Paths

The demon has _config_ and _data_ (metadata) dirs; these both default to
`${XDG_STATE_HOME:-~/.local/state}/syncthing` and can be overrridden with
various options: `--home, -H, --config, -C, --data, -D`. (Pre-1.27 this was
in `${XDG_CONFIG_HOME:-~/.config}/syncthing`.)

The config dir contains TLS keys and certs and `config.xml`, which is a
combination config and status file that's heavily modified by syncthing as
it runs. To manage it from dot-home, you'd want to write programs that
manipulate this via web API, probably most easily driven by `synthing cli`.


<!-------------------------------------------------------------------->
[GitHub]: https://github.com/syncthing/
[SyncThing Tray]: https://github.com/Martchus/syncthingtray
[SyncThing]: https://syncthing.net/
[docs]: https://docs.syncthing.net/
