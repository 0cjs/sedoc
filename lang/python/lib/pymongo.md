PyMongo API for MongoDB
=======================

[PyMongo] ([API reference][apiref]) is the Python API provided by
[MongoDB], a key-value document store.

The latest version is 3.7, supporting MongoDB versions 2.6, 3.0, 3.2,
3.4 and 3.6 In the API summary below, [version 2.8] APIs are given in
parens after the 3.7 API.

API Summary
-----------

Connecting, getting a [database handle][api-database], getting a
collection:

    from pymongo import MongoClient
    client = MongoClient('localhost', 27017)  # or 'mongodb://localhost:27017/'

    db = client['test_database']
    db = client.test_database

    collection = db['test_collection']
    collection = db.test_collection

Asking a client for an invalid database name will raise [InvalidName].

#### Methods on Clients

- `server_info()`

#### Methods on Databases

See [current][api-database] and [version 2.8][api-database-2.8] API docs.

- `client` (`connection`): The client instance for the DB
- [`command(...)`]: Issue a MongoDB command
- `list_collection_names()` (≤3.6: `collection_names()`) Get a list of
  collections in the DB. `include_system_collections=False` is a
  default param
- `list_collections()` (≥3.6): Return a `CommandCursor` over the
  collections in the DB
- `create_collection(name, **kwargs)`: Normally collection creation is
  automatic, but this can be used if you need to set options
- `drop_collection(name_or_collection)`

#### Methods on Collections

Documents are represented in Python by dictionaries.

See [current][api-collection] and [version 2.8][api-collection-2.8] API docs.

Collection information:
- `name`, `full_name`
- `database`
- `rename(new_name)`: Rename collection
- `drop()`: Alias for `Database.drop_collection()`

Searching/retrieval:
- `count_documents()` (<3.7: `count()`)
- `estimated_document_count()` (≥3.7): Estimate from metadata
- [`find()`]: returns a [Cursor]
- [`find_one()`]: Returns a single document or `None`

Inserts/updates/deletes:
- `insert_one()`, `insert_many()` (<3.0: `insert()`)
- `replace_one()`, `update_one()`, `update_many()`
- `delete_one()`, `delete_many()`

Deprecated:
- `save`: Use `{insert,replace}_one()`
- `update()`: Use `replace_one()` or `update_{one,many}()`
- `remove()`: Use `delete_{one,many}()`
- `find_and_modify()`: Use `find_one_and_{delete,replace,update}()`


Examples
--------

The [tutorial] may be useful.

Write a document:

    doc = { 'name': 'test', 'value': 42, }
    oid = collection.insert_one(doc)
    oid                             ⇒ ObjectId('5b35e112055dd50014002f1b')
    collection.find_one(_id = oid)  ⇒ {'name': 'test', 'value': 42,
                                       '_id': ObjectId('5b35e112055dd50014002f1b')}

Query:

    collection.find({'afield': re.compile('^foo')}).count()

Ref. [query operators].



[Cursor]: https://api.mongodb.com/python/current/api/pymongo/cursor.html#pymongo.cursor.Cursor
[InvalidName]: https://api.mongodb.com/python/current/api/pymongo/errors.html#pymongo.errors.InvalidName
[MongoDB]: https://www.mongodb.com/
[PyMongo]: https://api.mongodb.com/python/current/
[`command(...)`]: https://api.mongodb.com/python/current/api/pymongo/database.html#pymongo.database.Database.command
[`find()`]: https://api.mongodb.com/python/current/api/pymongo/collection.html#pymongo.collection.Collection.find
[`find_one()`]: https://api.mongodb.com/python/current/api/pymongo/collection.html#pymongo.collection.Collection.find_one
[api-collection-2.8]: https://api.mongodb.com/python/2.8/api/pymongo/collection.html
[api-collection]: https://api.mongodb.com/python/current/api/pymongo/collection.html
[api-database-2.8]: https://api.mongodb.com/python/2.8/api/pymongo/database.html
[api-database]: https://api.mongodb.com/python/current/api/pymongo/database.html
[apiref]: https://api.mongodb.com/python/current/api/index.html
[query operators]: https://docs.mongodb.com/manual/reference/operator/query/
[tutorial]: https://api.mongodb.com/python/current/tutorial.html
[version 2.8]: https://api.mongodb.com/python/2.8/api/pymongo/
