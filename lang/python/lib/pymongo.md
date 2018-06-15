PyMongo API for MongoDB
=======================

[PyMongo] is the Python API provided by [MongoDB], a key-value
document store.

API Summary
-----------

Connecting, getting a database handle, getting a collection:

    from pymongo import MongoClient
    client = MongoClient('localhost', 27017)  # or 'mongodb://localhost:27017/'

    db = client['test_database']
    db = client.test_database

    col = db['test_collection']
    col = db.test_collection

#### Methods on Collections

Documents are represented in Python by dictionaries.

* [`find_one()`][api-find_one]



[MongoDB]: https://www.mongodb.com/
[PyMongo]: https://api.mongodb.com/python/current/
[api-find_one]: https://api.mongodb.com/python/current/api/pymongo/collection.html#pymongo.collection.Collection.find_one
