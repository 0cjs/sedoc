MySQL
=====

### Multi-DBMS Tools

See [`tools`](./tools.md) for DBeaver, etc.

### MySQL Workbench

[MySQL Workbench][wb] is a graphical tool for interactive operations on
MySQL databases. There are separate open source and Enterprise versions.
Latest version as of this writing is 8.0.45.

The [open source download page][wb-os] has source and pre-built packages
for Win, Mac, Ubuntu and RHEL. You will be prompted to log in, but there's
a link at the bottom to download without login.

Ubuntu is x86 64 bit only, for 22.04 and 24.04, with and without debug
symbols. Neither will install on Debian 12 due to missing dependencies:
- 24.04 Many unknown libs missing, e.g. `libatk1.0-0t64`,
  `libglibmm-2.4-1t64` This is due to 22.04 being post `t64` transition
  and thus having the renamed libs, but Debian 12 being before that.
  (Try Debian 13?)
- 22.04: 4 missing, apparently just old versions of libs: `libjpeg8`,
  `libmysqlclient21`, `libproj22`, `libpython3.10`.



<!-------------------------------------------------------------------->
[wb]: https://www.mysql.com/products/workbench/
[wb-os]: https://dev.mysql.com/downloads/workbench/
