restic - Encrypted, Deduped Backups
===================================

[restic] \([manual][restic-doc], [source][restic-gh]) creates backups,
dedupes and encrypts (AES-256 in CTR mode) them, and stores them in a
remote untrusted _repository_. Design goals are: easy, fast,
verifiable, secure, efficient.

Backups can be done as a non-root user via [Linux capabilities].

On Windows you'll need to use [`wipty`] to handle password prompts in
MinGW Bash.

Architecture
------------

See also [References] in the docs for more detailed design
information.

Data is stored in _repositories_ (with a unique ID in the repository)
created with `restic -r REPO init`. Repo types are:
- local `/path/to/dir`, with password-encrypted storage
- [rclone] `rclone:foo:bar` supporting many services (e.g. Dropbox)
- SFTP `sftp:user@host:/path`, must not prompt for credentials
- REST`rest:http://host:8000/`
- S3 `s3:s3.amazonaws.com/bucket_name` or [API-compatible][Minio]
- Google Cloud Storage `gs:foo:/`
- Others including Azure, Swift, B2

The repository master encryption and MAC keys are encrypted under one
or more _keys_ derived via `scrypt` from a password; any key gives
full read/write access to the entire repo.

Each individual backup run is stored as a _snapshot_ identified by a
hash (or `latest`); each has an ID, tree hash, timestamp, host, path
and optional tags (view with `cat snapshot`). There is no particular
relationship between snapshots that differ on host or path, but data
is deduped between all snapshots (i.e., backing up a second identicial
dir on different paths or hosts will use no extra space in the repo).
There is an _index_ in the repo which is also cached by local clients.

Within the repo, aside from `config`, the data are stored in _blobs_,
which may be standalone or combined into _packs_. The blobs are
identified by _storage ID_, an SHA-256 hash of the content, and thus
written once only. Blobs are 0.5-8 MiB, aiming for 1 MiB; files larger
than 0.5 MiB are split into multiple blobs using content-defined
chunking (CDC) with Rabin fingerprints.


Installation
------------

- Debian 9 `restic` package. Very old version 0.3.3.
- Official binary from [releases].
- `restic self-update` downloads latest from [releases] above,
  verifies GPG signature.
- Docker container; see [Installation].

Generate Bash completion file with:

    restic generate --bash-completion \
        .local/share/bash-completion/completions/restic


Commands
--------

Arguments:
* Global:
  - `-r REPO`
  - `--password-file`: File containing repo password. Also
    `RESTIC_PASSWORD_FILE` and `RESTIC_PASSWORD` env vars.
  - `-v`, `-vv`: Verbose output
  - `--json`: JSON output for scripting.
* Subcommand:
  - `--host`: Restrict to snapshots from given host.
  - `--path`: Restrict to snapshots with given path.
  - `--tag`: Restrict to snapshots with given tag.

Query:
- `snapshots` lists snapshots (ID, Time, Host, Tags, Paths)
- `ls [latest|SNAPSHOT-ID]` lists files in snapshot
- `mount PATH`: Mount repo on _PATH_ via FUSE.
  Stays in foreground; interrupt to unmount and quit.

Backup/restore:
- `backup PATH [PATH ...]`
- `backup --stdin --stdin-filename NAME`
- `restore`
- `mount` (see above)
- `dump`: Prints files to stdout.

Misc:
- `tag`: Change snapshot tags (changes snapshot ID!).
- `key` Add/remove repository keys.

Maintance:
- `init` to create new repo.
- `check [--read-data]` to fsck repo; run this regularly.
- `forget [--prune] SNAPSHOT [SNAPSHOT ...]`:
   Remove snapshot(s), but not data unless `--prune`.
   May use a policy to automatically determine what to remove.
- `prune`: Remove data; can be very time-consuming.

Misc:
- `cat [pack|blob|snapshot|index|key|masterkey|config|lock] [ID]`





[Linux capabilities]: https://restic.readthedocs.io/en/stable/080_examples.html#backing-up-your-system-without-running-restic-as-root
[Minio]: https://www.minio.io/
[`wipty`]: ../win/unixy.md#winpty
[installation]: https://restic.readthedocs.io/en/stable/020_installation.html
[rclone]: https://rclone.org/
[references]: https://restic.readthedocs.io/en/stable/100_references.html
[releases]: https://github.com/restic/restic/releases/
[restic-doc]: https://restic.readthedocs.io/en/stable/
[restic-gh]: https://github.com/restic/restic/
[restic]: https://restic.net
