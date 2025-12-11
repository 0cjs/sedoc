Redis
=====

[Redis] is a key/value store with a variety of data types (see below);
because it's an in-memory server it's often used for caching, queuing and
pub/sub systems. (Redis has a built-in pub/sub system.) The standard [docs]
page is not so useful; see the references below.

Redis is durable to some degree: all writes are added to an
append-only-file (AOF) that may allow recovery after a shutdown. It also
supports clustering, including redundant key/value storage across the
cluster.

Sources:
- CLI client (`redis-cli`) other tools: Debian `redis-tools` package.
- GUI clients: [Redis Insight][] (works fine on Debian 12).
- Server: official [docker image]; Debian `redis-server` package.
- Managed Redis or Redis-clone services: Redis Cloud; Amazon's AWS
  ElastiCache; Google's Cloud Memorystore; Microsoft's Azure Cache for
  Redis.

__References:__
- redis.io [Cheat Sheet]: All commands (verbs) for CLI, node-redis
  (JavaScript), redis-py (Python), NRedisStack (C#/.Net) and Jedis (Java).
- redios.io [Overview]


Clients
-------

### Redis CLI

E.g.

    redis-cli -h hostname -p port -a password

### Redis Insight

Does not accept command-line parameters.


Data Types
----------

Keys are always sequences of bytes (no encoding is used or assumed), but
client libraries typically convert keys to UTF-8 before sending them to the
server. The maximum size is 512 MB. The keyspace is flat; a common
convention is to use multi-part keys with the parts separated by `:`, e.g.,
`user:123:fullname`.

Redis calls value types, "key types." Value types include:
- Hash: maps of field-value pairs (essentially nested key/value pairs).
- List: ordered collections of Strings.
- Set: unordered collections of unique Strings.
- Sorted Set (zset): Sets with scored sub-values for ordering.
- String: a bytestring (again no encoding used or assumed).
- JSON document.
- Stream: append-only log data structure.
- Bitmap.
- HyperLogLog: probabilistic cardinality estimation.

The query engine is capable of indexing and searching within certain types
of values, such as Hash and JSON.


Commands
--------

Also see the [Cheat Sheet][cheat].

- `TYPE`: return the type of the value associated with a key.



<!-------------------------------------------------------------------->
[Cheat Sheet]: https://redis.io/learn/howtos/quick-start/cheat-sheet
[Redis]: https://redis.io
[docs]: https://redis.io/docs/latest/
[overview]: https://redis.io/learn/develop/node/nodecrashcourse/whatisredis
[docker image]: https://hub.docker.com/_/redis/
[Redis Insight]: https://github.com/redis/RedisInsight/releases
