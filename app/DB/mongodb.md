MongoDB
=======

MongoDB stores _[documents]_ which are essentially JSON objects (though
actually [BSON], which is slightly more type-rich). Each document has an
_[id]_ field serving as the primary key which is either supplied by the
client or is an automatically generated _[ObjectID]_ (except for
time-series collections). Additonal _secondary indexes_ (single-field or
_[compound]_) may be created for faster lookups.

Document fields are ordered, with `_id` always first and the remainder in
the order supplied in the write request. (Renaming fields may change the
order.)

Documents are grouped together in _collections_ (each assigned an immutable
UUID) which in turn are grouped into _databases_ served by a MongoDB
server. Each database has a separate set of files for storage. System
databases include `admin`, `local` and `config`.



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


Tools and Clients
-----------------

Common options:
- `-h HOST[:PORT]`, `-p PORT`: Connection target. Default is localhost:27017.
- `-u USERNAME`, `-p PASSWORD`.
- `--uri URI`: Connection information in format `mongodb://`
  `username:password@]host1[:port1]…[,hostN[:portN]]][/[database][?options]]`.
- `--config=FILE`: File with `name: value` pairs for `password`, `uri`,
  `sslPEMKeyPassword`.
- Various SSL options, including cert info for authentication.

### MongoDB Shell `mongosh`:

- mongodb.com, [Welcome to MongoDB Shell (`mongosh`)][mdb-shell]
- mongodbtutorial.org, [MongoDB Shell][mtut-shell]
- slingacademy.com, [MongoDB Shell Commands: The Complete Cheat
  Sheet][sling-mongosh]

### MongoDB Database Tools

- [`mongodump`], `mongorestore`, `bsondump`, `mongoimport`, `mongoexport`,
  `mongostat`, `mongotop`, `mongofiles`.
- mongodb.com, [The MongoDB Database Tools Documentation][mdb-tools]
- Since MongoDB 6.0, separate release track starting w/version 100.0.0.

#### mongodump

The `--archive` option produces a single file, otherwise the dump is in a
directory `dump` (change the name with `-o`/`--out`) with a subdir for each
database and a `.bson` file for each collection. Views will be in
`.metadata.json` files. Adding `--oplog` will add an `oplog.bson` file at
the top level containing write operations that occured during the dump.

Options:
* `--gzip`: Compresses BSON and JSON metadata files; `.gz` extensions will
  be added.
* `--compressors=snappy|zlib|zstd`: Compression between server and client.
  See [Network Compression].
* `-d=DATABASE`, `-c=COLLECTION`: Dump only given database and collection.
* `-q=JSON`: Limit dump to documents matching query.
* `--readPreference=STR|DOCUMENT`
* `--dumpDbUsersAndRoles`
* `--excludeCollection=NAME`, `--excludeCollectionsWithPrefix=PREFIX`
* `-j=N`, `--numParallelCollections=n`: Parallel export; default 4.

#### bsondump

Takes a `.bson` file (or stdin) and gives JSON or a debug format for
diagnostic purposes.

Options:
* `--outFile=FILE`: Output to _file_ instead of stdout.
* `--pretty`: More human-readable JSON. (Tab indentation levels; use
  `python3 -m json.tool` for four spaces.)
* `--type=debug`: Produce a debug format that includes extra BSON info.




Replication
-----------

mongodb.com Documentation:
- [Replication][mdb-replication]
- [Replica Set Data Synchronization][mdb-rep-sync]
- [Replica Set Deployment Architectures][mdb-rep-arch]

A _replica set_ has up to 50 _nodes,_ up to 7 of which can be voting nodes.
A node may be a member of only one replica set. A node that holds data has
a complete copy of all the databases, otherwise it is an _arbiter_ which is
used solely for voting.

(It's also possible to have [sharded] clusters, where each shard is a
separate replica set. These require a replica set of config servers. For
testing, one can set up a degenerate sharded configuration with only one
shard.) The `mongos` daemon routes requests to the correct shard.

From the data-holding nodes a _primary_ is elected; the remainder are
_secondary_ nodes. All nodes can respond to read requests at all times, but
only the primary can accept write requests. (Write requests cannot be
accepted during an election.) Generally an election should take no more
than 12 seconds, but it could be longer depending on latency between the
voting nodes.

When the primary receives a write request, it generates an idempotent
update which it applies to the local data store and adds to the _[oplog],_
the `local.oplog.rs` collection. (This is also used for recovery if a node
goes down.) Secondaries also have an oplog that they update from the
primary or other secondaries and apply asynchronously. They will log
slow oplog applications.

Before MongoDB 5.0 one could do do manual writes to the oplog if a node was
in a replica set. This is no longer possible and writing to the oplog on a
standalone instance "should only be done with guidance from MongoDB
Support."

New secondaries do an [initial sync][mdb-rep-sync], cloning all databases
but `local` from a selected source. (MongoDB Enterprise can also do an
initial sync from a file copy.)

#### Read and Write Semantics

[Read preference] defaults to `primary`, but can also be
`primaryPreferred`, `secondary`, `secondaryPreferred` or `nearest`.

[Write concern] determines how many nodes in the replica set must
acknowledge they've durably committed the write before the call returns.
This is usually `w: "majority"`, but may be an integer from `w: "1"` (only
the primary need acknowledge) through as many secondaries plus the primary
are in the replica set. See [Acknowledgement Behaviour] for more details.



<!-------------------------------------------------------------------->
[BSON]: https://en.wikipedia.org/wiki/BSON
[ObjectID]: https://www.mongodb.com/docs/manual/reference/bson-types/#std-label-objectid
[compound]: https://www.mongodb.com/docs/manual/core/indexes/index-types/index-compound/#std-label-index-type-compound
[documents]: https://www.mongodb.com/docs/manual/core/document/
[id]: https://www.mongodb.com/docs/manual/core/document/#the-_id-field

[dr-mongo-tags]: https://github.com/docker-library/docs/blob/master/mongo/README.md
[dr-mongo]: https://hub.docker.com/_/mongo/
[mdb-dl-server]: https://www.mongodb.com/try/download/community-edition/releases
[mdb-dl-tools]: https://www.mongodb.com/try/download/shell
[mdb-shell]: https://www.mongodb.com/docs/mongodb-shell/
[mdb-tools]: https://www.mongodb.com/docs/database-tools/
[mtut-shell]: https://www.mongodbtutorial.org/getting-started/mongodb-shell/
[sling-mongosh]: https://www.slingacademy.com/article/mongodb-shell-commands-the-complete-cheat-sheet/

<!-- Tools and Clients -->
[Network Compression]: https://www.mongodb.com/docs/drivers/go/current/connect/connection-options/network-compression/
[`mongodump`]: https://www.mongodb.com/docs/database-tools/mongodump/

<!-- Replication -->
[Acknowledgement Behaviour]: https://www.mongodb.com/docs/manual/reference/write-concern/#std-label-wc-ack-behavior
[mdb-rep-arch]: https://www.mongodb.com/docs/manual/core/replica-set-architectures/
[mdb-rep-sync]: https://www.mongodb.com/docs/manual/core/replica-set-sync/
[mdb-replication]: https://www.mongodb.com/docs/manual/replication/
[oplog]: https://www.mongodb.com/docs/manual/core/replica-set-oplog/
[read preference]: https://www.mongodb.com/docs/manual/core/read-preference/
[sharded]: https://www.mongodb.com/docs/manual/core/sharded-cluster-components/#sharded-cluster-components
[write concern]: https://www.mongodb.com/docs/manual/core/replica-set-write-concern/
