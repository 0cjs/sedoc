Bash Error Handling
===================

For more reliable scripts, There are various settings that will help
catch errors.

#### Bash Error Options

The simplest set is to turn on some Bash [options], which should
generally be used in _all_ Bash scripts:

    #!/usr/bin/env bash
    set -Eeuo pipefail

- `-E` Traps on ERR inherited by functions, command substitutions and
  subshells.
- `-T` Traps on DEBUG, RETURN inherited as above.
- `-e`: Exit on pipeline/list/compound command exiting with untested
  non-zero status. (For pipelines, only for last command.)
- `-u` Error on use of undefined variable/param, except `@` and `*`.
- `-o pipefail` Return status of pipeline is rightmost failure, if any,
  instead of rightmost command.

#### Simple Error Traps

You can add a `trap … ERR` that will print more information on any
unchecked failure (i.e., one not caught with `||` or `if`). For very basic
error checking, where stdout/stderr is likely to show the error, use:

    trap 'ec=$?; echo 1>&2 ERROR!; exit $ec' ERR

This will ensure that the script properly aborts on an unexpected error
rather than trying to carry on.

#### Internal Error Traps

In more complex systems, and especially tests, it's worth having functions
to handle expected errors (e.g., file not found) and reserving the ERR trap
to raise internal errors, i.e., either an error that you should have been
handling but weren't, or an error you did not expect to happen. Start with
some functions to help generate errors. (Note that `fail()` integrates
script execution time functionality; this can be removed if you don't need
it.

    die()  { ec="$1"; shift; echo 1>&2 "ERROR ($ec):" "$@"; exit $ec; }
    fail() { ec=$?; echo "FAILED exitcode=$ec ($(elapsed)s)"; exit $ec; }

    elapsed_start=$(date +%s)
    elapsed() { echo $(( $(date +%s) - $elapsed_start )); }

    …

    somecommand || fail "somecommand didn't work"       # usage example

    …

    echo "OK ($(elapsed)s)"     # Canonical script success indication.

The trap can be one of the following:

    #   Short version; works well when not calling other scripts.
    trap 'ec=$?; echo 1>&2 "INTERNAL ERROR: ec=$ec line=$LINENO cmd=$BASH_COMMAND";
          exit $ec;' ERR

    #   Longer version with filename; useful to check sub-scripts as well.
    #   Also handles long command lines more clearly.
    trap 'ec=$?; echo 1>&2 "ERROR: ec=$ec line=$LINENO file=$0"
                 echo 1>&2 "      cmd=$BASH_COMMAND";
                 exit $ec;' ERR



<!-------------------------------------------------------------------->
[options]: http://www.tldp.org/LDP/abs/html/options.html
