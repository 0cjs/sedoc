MongoDB
=======


Installation
------------

Server:
- [Community edition downloads page][mdb-dl-server].
  - Download pages have `.deb` files etc.
  - Ubuntu PPA, Debian keys/sources.list entries, `.rpm`, .tgz available.
    (See e.g. instructions at [[mdb-shell]] §Install.)
- Docker image [`mongo`][dr-mongo].
  - [Tags list][dr-mongo-tags] is separate.
  - `latest` tag is `8.0.13`, `8.0` and `8`, which in turn are
    `8.0.13-noble` (Ubuntu 24.04) and Windows ltsc2022 and ltsc2025.
  - `8.0.13-noble` (kernel 6.8) seems to run fine on Debian 12 (kernel 6.1)
    as well.

The tools (MongoDB Shell, MongoDB Command Line Database Tools, etc.)
are separate packages from the server on independent release cycles.
See the [MongoDB tools download page][mdb-dl-tools].


Tools
-----

Common options:
- `-h HOST`, `-p PORT`: Connection target.

MongoDB Shell `mongosh`:
- mongodb.com, [Welcome to MongoDB Shell (`mongosh`)][mdb-shell]
- mongodbtutorial.org, [MongoDB Shell][mtut-shell]
- slingacademy.com, [MongoDB Shell Commands: The Complete Cheat
  Sheet][sling-mongosh]

MongoDB Database Tools:
- `mongodump`, `mongorestore`, `bsondump`, `mongoimport`, `mongoexport`,
  `mongostat`, `mongotop`, `mongofiles`.
- mongodb.com, [The MongoDB Database Tools Documentation][mdb-tools]



<!-------------------------------------------------------------------->
[dr-mongo-tags]: https://github.com/docker-library/docs/blob/master/mongo/README.md
[dr-mongo]: https://hub.docker.com/_/mongo/
[mdb-dl-server]: https://www.mongodb.com/try/download/community-edition/releases
[mdb-dl-tools]: https://www.mongodb.com/try/download/shell
[mdb-shell]: https://www.mongodb.com/docs/mongodb-shell/
[mdb-tools]: https://www.mongodb.com/docs/database-tools/
[mtut-shell]: https://www.mongodbtutorial.org/getting-started/mongodb-shell/
[sling-mongosh]: https://www.slingacademy.com/article/mongodb-shell-commands-the-complete-cheat-sheet/
