Multi-DBMS Tools
================

### DBeaver

[DBeaver] is a multi-DB graphical tool written in Java, supporting MySQL,
Postgres, SQLite, anything with a JDBC driver, and many things without.

Debian package `dbeaver-ce` available from the [downloads page][dbeaver-dl]
or by adding their repository (info on the downloads page—scroll down).
Note that it's fairly large (121 MB download; 212 MB installed). It
includes its own OpenJDK 21 bundle, so does not require a system JVM. You
may remove `/usr/share/dbeaver-ce/jre/` (101 MB) to make it use a system
JVM.

Connection information is provided on the command line using `-con`, e.g.

    dbeaver -con 'driver=mysql|host=H|port=P|database=D|user=U|password=P|name=N'

Parameters include:
- `name=`: Display name for the connection.
- `openConsole=true`: Opens SQL console automatically (default=false).
- `create=true`: Use existing connection by name (default=true).
- `url=jdbc:mysql://…`: Use JDBC URL to connect.



<!-------------------------------------------------------------------->
[DBeaver]: https://dbeaver.io/about/
[dbeaver-dl]: https://dbeaver.io/download/
[dbeaver-repo]: https://github.com/dbeaver/dbeaver/wiki/Installation

