PyMongo API for MongoDB
=======================

[PyMongo] ([API reference][apiref]) is the Python API provided by
[MongoDB], a key-value document store.

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

#### Methods on Collections

Documents are represented in Python by dictionaries.

* [`find_one()`][api-find_one]



[MongoDB]: https://www.mongodb.com/
[PyMongo]: https://api.mongodb.com/python/current/
[api-find_one]: https://api.mongodb.com/python/current/api/pymongo/collection.html#pymongo.collection.Collection.find_one
[apiref]: https://api.mongodb.com/python/current/api/index.html
[api-database]: https://api.mongodb.com/python/current/api/pymongo/database.html
[InvalidName]: https://api.mongodb.com/python/current/api/pymongo/errors.html#pymongo.errors.InvalidName
