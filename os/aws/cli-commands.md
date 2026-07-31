AWS CLI Command Reference
=========================

The AWS [reference] lists all options and commands in detail.

There's no `--help` option; instead use the `help` subcommands.

### s3

Paths:
- Paths are specified as a standard `LocalPath` (absolute or relative)
  or an `S3Uri` in the form `s3://bucketname/key`.
- A `LocalPath` ending in `/` (`\` on Windows) refers to a directory.
  An `S3Uri` ending in `/` is an "S3 prefix."
- Commands take a single source path or a pair of source and target
  paths. The target path may usually be a directory or S3 prefix, in
  which case the basename of. source path will be used as the target
  filename.

Object can have further properties such as content type, encoding and
langauge.

#### Commands

- `cp SRC DST`
- `ls [SRC]`: Without _SRC_, lists buckets.
  - Options: `--human-readable`, `--summarize`
- `mb SRC`: Make bucket. No options.
- `mv SRC DST`
- `presign`: Generate pre-signed URL for an object, allowing anybody
  with it to retrieve the object with an HTTP `GET` request.
- `rb SRC`: Remove an empty bucket. `--force` will delete even if
  there are still objects and/or versioned objects in it.
- `rm SRC`
- `sync SRC DST`: Sync directories and S3 prefixes.
- `website SRC`: Set website config for a bucket.
  - `--index-document VALUE`: Default object name when a prefix is requested.
  - `--error-document VALUE`: Object key name to use when `4xx` error.

#### Subcommand Options

Available on many of the above subcommands (particularly ones taking a
destination), but not all.

- `--dryrun`: Display operations that would be performed.
- `--quiet`
- `-follow-symlinks`, `-no-follow-symlinks`
- `--exclude`, `--include`: Evaluates shell glob patterns against the
  source directory; if the source is a file the file's directory is
  used.
- `--recursive`



<!-------------------------------------------------------------------->
[reference]: https://docs.aws.amazon.com/cli/latest/reference/
