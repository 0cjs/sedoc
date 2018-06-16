Bash Variables
==============

Upper-case bold manual page section names below can be found by
searching for them at the start of the line (`^FOO`) in the manual
page.


Parameters
----------

Variables set automatically by Bash, particularly when a script or
function is called. See __PARAMETERS__ for full details.

Positional parameters:
* `$0`: Name of script
  - If file of commands, path used to invoke file
  - If `bash -c`, first arg after string to be executed
  - Othewrise filename used to invoke bash (e.g., `/bin/bash`
    or `-bash` for a login shell)
* `$1`, `$2`, ..., `$10`, `$11`, ....: Positional parameters
* `$#`: Number of positional parameters (in decimal)
* `$*`, `$@`: All positional params, with various quoting (see manpage)

Other:
* `$$`: PID of shell (parent when used in subprocess `(`...`)`
* `$!`: PID of job most recently placed into background (inc. `bg`)
* `$?`: Exit status of most recently executed foreground pipeline
* `$-`: Current set of option flags (via `set`, `-i` or shell itself)
* `$_`: Kinda most recent command executed, but very confusing
