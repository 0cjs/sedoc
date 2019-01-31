SQLAlchemy - Python SQL RDBMS Interface and Object Mapping
==========================================================

An interface to RDBMSes that exposes the relational nature of the
DBMS.

Architecture
------------

Layers:
- ORM: Object-relational mapper.
- Core (upper): Schema/types, SQL expression language, engine
- Core (lower): Connection pooling, dialect.
- DBAPI: An interface specification from SQLAlchemy implemented by
  third-party code connecting to SQLite, PostgreSQL, etc.

Applications typically use either or both of the ORM and Core layers.

### DBAPI

`sqlalchemy.engine` has generic `Dialect` and `ExecutionContext`
classes that ...

- An `Engine` is a simpified interface that encapsulates a connection,
  accepts queries and returns their results.
- A `Connection` enc
Offers connections and cursors 

### Schema Definition

- `sqlalchemy.schema`
- `MetaData` collection of `Table`s, in turn collection of, `Column`s.

### SQL Expressions

All below assumes `from sqlalchemy import *`.

Build ASTs corresponding to SQL statements:

    from sqlalchemy.sql import table, column, select
    #   SELECT id FROM user WHERE name = ?
    user = table('user', column('id'), column('name'))
    stmt = select([user.c.id]).where(user.c.name=='ed')

A `Table`'s `c` attribute has an attribute for each column.

`__eq__()` etc. are overloaded to make `column('a') == 2` return an AST:

    sql.expression._BinaryExpression(
        left     = sql.column('a'),
        right    = sql.bindparam('a', value=2, unique=True),
        operator = operators.eq)

`Compiled` class compiles ASTs to SQL statements.
Subclasses `SQLCompiler` and `DDLCompiler`.

### ORM

Does mapping of user-defined classes to columns in tables and defines
relationships between classes corresponding to relationships between
tables. Similar idea to [SQLObject].

The older "classical" style instruments existing classes via `class
User(): pass; mapper(user, user_table)`, leaving `User.id` attributes
etc.

The newer "declarative" style is set up during class definition. (A
metaclass is used to execute the mappings at the time the class is
declared.) The end result is the same as using classical definition.

    class User(Base):
        __tablename__ = 'user'
        id = Column(Integer, primary_key=True)
    result = session.query(User).filter(User.username == 'joe').all()


Example Code
------------

    from sqlalchemy import *
    from sqlalchemy.orm import Session
    from sqlalchemy.ext.declarative import declarative_base
    Base = declarative_base()

    class User(Base):
        __tablename__ = 'user'
        id = Column(Integer, primary_key=True)
        name = Column(String, nullable=False)
        password = Column(String(50))
        def __init__(self, id, name, password=None):
            self.id = id; self.name = name; self.password = password
        def __repr__(self):
            return 'User({}, {}, {})'.format(self.id, self.name, self.password)

    engine = create_engine('sqlite://:memory:', echo=True)
    session = Session(engine)

    Base.metadata.create_all(engine)

    session.query(User).all()               # ⇒ []
    u = User(3, 'Three'); session.add(u)    # session.commit() optional?
    session.query(User).all()               # ⇒ [(User(3, Three, None)]


References
----------

* [SQLAlchemy Documentation][docs]
* [Object Relational Tutorial][tutorial]
* [SQLAlchemy][aosa-sqlalchemy] chapter from [_The Architecture of
  Open Source Applications_][aosa] (2011). Describes 0.7 architecture.
  Includes detailed internal class relationship diagrams.
* [PEP 249: Python Database API Specification v2.0][PEP 249].
* [`sqlite3`] standard library, [PEP 249] interface.



[PEP 249]: https://www.python.org/dev/peps/pep-0249/
[SQLObject]: http://sqlobject.org/
[`sqlite3`]: https://docs.python.org/3/library/sqlite3.html
[aosa-sqlalchemy]: http://aosabook.org/en/sqlalchemy.html
[aosa]: https://aosabook.org/
[docs]: https://docs.sqlalchemy.org/en/latest/
[tutorial]: https://docs.sqlalchemy.org/en/latest/orm/tutorial.html
