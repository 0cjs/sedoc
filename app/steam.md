Steam / store.steampoewred.com
==============================

### Linux Client

Installation:
- Some browser plugins will suppress the "Install" button that otherwise
  appears at the top right of every store page. (It's not AdBlock+.)
- The [About] page gives a big link to download the package file for the
  current OS, and small icons below for other OSes. These all link to a
  `cdn.fastly.steamstatic.com/client/installer/` path; `steam.deb` in the
  case of Linux.
- [Repo] gives an alternate method for installing via apt. It's not clear
  what the use of this is, since once you've done an `apt install
  ./steam.db` it auto-updates itself anyway.
- GitHub [`ValveSoftware/steam-for-linux`] has just a README (the project
  is for issue tracking) and has a link to `steam.deb` at a different
  location: `media.steampowered.com/client/installer/steam.deb`.



<!-------------------------------------------------------------------->
[About]: https://store.steampowered.com/about/
[repo]: https://repo.steampowered.com/steam/
[`ValveSoftware/steam-for-linux`]: https://github.com/ValveSoftware/steam-for-linux
