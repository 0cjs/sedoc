Alpine Releases
===============

Independent, non-commercial distro focused on small size, resource
efficiency and security, but also with over 20,000 packages available.
- Small: uses musl libc and BusyBox; Docker image is only 5 MB.
- Security: All userland binaries are PIE with stack smashing protection.
- Simple: `apk` package manager, OpenRC init, script-driven setups.

[Releases][rel] page. [Docker images][docker] images are tagged with
e.g. `3`, `3.19`, `3.19.0`, `edge`, `20231219`.

Releases are supported with security fixes for two years (or longer, on
request when patches are available). Bug fixes for only the most recent
release.

| BranchDate | Ver     | EOL        | Kernel | Notes
| -----------|---------|------------|--------|---------------
|            | edge    |            |        |
| 2023-12-07 | 3.19.0  | 2025-11-01 |        |
| 2023-05-09 | 3.18.5  | 2025-05-09 |        |
| 2022-11-22 | 3.17.6  | 2024-11-22 |        |

`Ver` has latest point release. The Git branch is always `N.NN-stable`.


Package Management
------------------

Package manager is [`apk`][] (Alpine Package Keeper). Fetches from
_mirrors_ that host _repositories_ (category of packages) for _releases_
(`edge`, `stable`, `3.19`, etc.). The three public repositories are:
- _main:_ Officially supported packages, those expected for a basic system.
- _community:_ Packages from testing that have been tested.
- _testing:_ New, broken or outdated packages that need testing. Only
  available on `edge`.

Downgrading packages is not currently supported, though it can be done
if you figure out how.

### Commands

Give `-h` to any subcommand for help.

- `apk update`
- `apk upgrade [--available]`: Upgrades all installed packages. Does not
  overwrite files you've changed. (Will first do an `update` if more than 4
  hours has elapsed since the last update.0
- `apk search [-e] PAT`: Search for packages matching _pat_; `-e` to
  exclude partial matches. _Pat_ uses `*` globs?
- `apk info PKGNAME`
- `apk add PKGNAME ...`: Exact package name(s) must be specified.
- `apk cache clean`: Clean cache, if it was enabled.

### Database

- `/etc/apk/world` Lists packages you want explicitly installed. Can be
  edited by hand. `apk add` brings host to this state. This file is
  updated when `apk add` is run manually.
- `/etc/apk/repositories`: Edit this to switch to a new release.



<!-------------------------------------------------------------------->
[rel]: https://alpinelinux.org/releases/
[docker]: https://hub.docker.com/_/alpine/

[`apk`]: https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html
