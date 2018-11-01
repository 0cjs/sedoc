Python Git Libraries
====================

There are a ton of different Git-related libraries on PyPI; the one
you probably want is [GitPython] ([PyPI][gp-pypi], [docs][gp-docs])
with top-level module `git`.

Operations are done with a [`Repo`] object or repo-independent
[functions][Repo.Functions].

#### Class [`Repo`]

These are selected [`Repo`] instance attributes and functions; see the
docs for much more.

Construction and repo information:
- `__init__(path, search_parent_directories=False, expand_vars=True)`.
  Path must be `str`, not a `pathlib` object. `%`/`$` will expand as
  env vars (insecure!) unless you set `expand_vars=False`.
- `bare`: Boolean.
- `git_dir`: Repo dir (`.git` under working copy if not bare)
- `working_dir`: Working copy or repo dir for bare repos
- `working_tree_dir`: Working copy; raises `AssertionError` if bare.

Branch/ref-related:
- `active_branch`: String.
- `heads`, `branches`: List of `Head` objects.
- `head`: `Head` object for current `HEAD`. This is a `git.HEAD`, a
  special case of a `git.refs.symbolic.SymbolicReference` with
  `orig_head()` (previous HEAD value) and `reset()` methods.

Other:
- `close()`
- `config_reader(config_level=None)`. Returns a `GitConfigParser` for
  read-only config access. `config_level` is one of the values from
  `Repo().config_level`, `system|global|user|repository`; `user` is an
  alias for `global`.
- `config_writer()`: As `config_reader` but read-write. This locks the
  config so close as soon as you're done.

### Reference Classes

A `git.refs.symbolic.`[`SymbolicReference`]  points to another `Head`,
e.g. `HEAD`.

Class methods:
- `create()`, `delete()`
- `dereference_recursive()`
- `iter_items()`
- `from_path()`, `to_full_path()`

Instance attributes/methods:
- `is_valid()`: Points to an existing valid object or ref.
- `commit`: Can be set?
- `is_detached`: True if we point to a commit, not another reference.
- `is_remote()`: Ref to a remote-tracking branch.
- `abspath`
- `log()`: Reflog for this reference.

Subclasses of `SymbolicReference` include `Reference` and `HEAD`.

A `git.refs.reference.`[`Reference`] is a subclass of
`SymbolicReference` that points to any object, though subclasses may
restrict this (e.g., `Head`s can point only to commits). They can be
compared for equality?
- `name`: Shortest name of this reference.

A `git.refs.head.`[`Head`] is a sublcass of `Reference` with a name
and a commit object.

Class methods:
- `delete()`

Instance methods:
- `config_reader()`, `config_writer()`
- `checkout(force=False, **kwargs)`
- `rename(new_path, force=False)`
- `tracking_branch()`, `set_tracking_branch(remote_ref)`

### Object Classes

#### Object

[`git.objects.base.Object`][gpapi-object]s compare for equality on SHA1.

Class attributes:
- `NULL_BIN_SHA`, `NULL_HEX_SHA`
- `TYPES`: `('blob', 'tree', 'commit', 'tag')`

Instance attributes/functions:
- `type`, `size`
- `binsha`, `hexsha`
- `repo`
- `data_stream`, `stream_data(ostream)`

#### Commit

[`git.objects.commit.Commit`][gpapi-commit] is a subclass of `Object`.

Class methods:
- `create_from_tree()`: Creates a new commit object.
- `iter_items()`: Find all commits matching given criteria.

Instance attributes:
- `type`: Returns `'commit'`.
- `tree`: Returns a `git.Tree`.
- `parents`: Tuple of `Commit` objects of immediate parents.
- `author`, `authored_date`, `authored_datetime`, `author_tz_offset`
- `committer`, - `committed_date`, `committed_datetime`,
  `committer_tz_offset`
- `summary`, `message`
- `gpgsig`
- `name_rev`: String describing commit based on closest reference.

Instance methods/calculated attributes:
- `stats`: Returns a `git.util.Stats` object with changes between this
  commit and its first parent.
- `count(paths='', **kwargs)`: Number of commits reachable from this
  one. `paths` counts only commits modifying the given path. `kwargs`
  is options passed on to `git-rev-list`.
- `iter_parents(paths'', **kwargs)`: Returns generator that
  recursively iterate all parents of the commit.


[GitPython]: https://github.com/gitpython-developers/GitPython
[Repo.Functions]: https://gitpython.readthedocs.io/en/stable/reference.html#module-git.repo.fun
[`Reference`]: https://gitpython.readthedocs.io/en/stable/reference.html#module-git.refs.reference
[`Repo`]: https://gitpython.readthedocs.io/en/stable/reference.html#module-git.repo.base
[`SymbolicReference`]: https://gitpython.readthedocs.io/en/stable/reference.html#module-git.refs.symbolic
[gp-docs]: http://gitpython.readthedocs.org/
[gp-pypi]: https://pypi.org/project/GitPython/
[gpapi-commit]: https://gitpython.readthedocs.io/en/stable/reference.html#module-git.objects.commit
[gpapi-object]: https://gitpython.readthedocs.io/en/stable/reference.html#module-git.objects.base
