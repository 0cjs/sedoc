[Python Concurrency-related Libraries][17]
==========================================


[`subprocess`]
--------------

This module is preferred over the [`os.system`] and [`os.spawn*`]
functions; see also [Replacing Older Functions with the `subprocess`
Module][rof] (which has lots of good exaples).

`run()` arrived with Python 3.5, see Legacy API below for ≤ 3.4.

#### Examples:

    output = run(['df', '-h'], stdout=PIPE).stdout  # no exception on error
    run(['git', 'clone', 'https://github.com/foo'], cwd='/tmp', check=True)

    p1 = Popen(['dmesg'], stdout=PIPE)
    p2 = Popen(['grep', 'sd0'], stdin=p1.stdout, stdout=PIPE)
    p1.stdout.close()  # Allow p1 to receive a SIGPIPE if p2 exits.
    output = p2.communicate()[0]

#### Popen() and run() Details

Use the underlying `Popen` interface only where you need more
functionality than `run()`.

[`run()`] and [`Popen()`] are called with `(args, *, **kwargs)`:

* `args`: sequence or string (if program name only or `shell=True`).
  Path is searched.
* `stdin`, `stdout`, `stderr`: Replace current process stdin/out/error with
  file handles, `DEVNULL` (use `os.devnull`),  `stderr=STDOUT`, or
  `PIPE` (creates new pipe for `communicate` below),
* `encoding`, `errors`, `universal_newlines=true`: opens stdin etc. in
  text mode with specified or defaults for [`io.TextIOWrapper`].
* `cwd`: Change dir before exec (default `None`).
* `env`: mapping of environment vars (default `None` inherits)
* `check=True`: raise `CalledProcessError` if _returncode_ ≠ 0
* `shell=True`: executes command via `/bin/sh`. Use [`shlex.quote()`] if needed.
* `executable`: Actual program to execute, but `argv[0]` still comes from `args`.
* `preexec_fn`: called in child proc just before exec (not safe with threads).
* `close_fds=True`: Close all FDs but 0, 1, 2 befor exec.
* `pass_fds`: sequence of FDs to keep open; forces `close_fds=True`.
* `bufsize`: `0` unbuffered, `1` line buffered (if `universal_newlines=True`),
  positive is approximate bufsize, `-1` (default) is `io.DEFAULT_BUFFER_SIZE`.
* `restore_signals`
* `start_new_session`
* `startupinfo`: [`STARTUPINFO`] has Windows-specific stuff.

`run()` returns a [`CompletedProcess`] instance with the following attributes:
* `args`: Args used to launch the process, sequence or string.
* `returncode`: 0 for success, _-n_ for termination by signal _n_
* `check_returncode()`: raise `CalledProcessError` if _returncode_ ≠ 0
* `stdout`, `stderr`: _None_ if not captured, byte sequence, string if
  _run()_ was called with encoding information

`Popen` instances are context managers (`with Popen(...) as p`) and
have the following attributes:
* `poll()`: If process finished, set and return `returncode`, else `None`.
* `wait(timeout=None)`: Timeout in seconds.
* `communicate(input=None, timeout=None)`: Send _input_ to process; reads
  output and returns tuple `(stdout_data, stderr_data)`. (Must have been
  set up with `stdin`/`stdout`/`stderr` = `PIPE`.)
* `send_signal(signal)`
* `terminate()`
* `kill()`
* `stdin`, `stdout`, `stderr`
* `pid`
* `returncode`

Exceptions:
* [`subprocess.SubprocessError`]
  * `subprocess.TimeoutExpired`: Attributes `cmd`, `timout`, `output`/`stdout`, `stderr`
  * [`subprocess.CalledProcessError`]: Attributes `returncode`, `cmd`,
    `output`/`stdout`, `stderr`
* [`OSError`]: non-existent file to execute, etc.
* [`ValueError`]: invalid arguments

#### [Legacy API]

`run()` arrived with Python 3.5, use the following for ≤ 3.4:

* `call()`: `run(...).returncode`
* `check_call()`: `run(..., check=True)`
* `check_output`: `run(..., check=True, stdout=PIPE).stdout`
* [`getstatusoutput(cmd)`], [`getoutput(cmd)`]: Don't use;
  insecure and uses system shell.



[17]: https://docs.python.org/3/library/concurrency.html
[`CalledProcessError`]: https://docs.python.org/3/library/subprocess.html#subprocess.CalledProcessError
[`CompletedProcess`]: https://docs.python.org/3/library/subprocess.html#subprocess.CompletedProcess
[`OSError`]: https://docs.python.org/3/library/exceptions.html#OSError
[`STARTUPINFO`]: https://docs.python.org/3/library/subprocess.html#subprocess.STARTUPINFO
[`ValueError`]: https://docs.python.org/3/library/exceptions.html#ValueError
[`io.TextIOWrapper`]: https://docs.python.org/3/library/io.html#io.TextIOWrapper
[`os.spawn*`]: https://docs.python.org/3/library/os.html?#os.spawnl
[`os.system`]: https://docs.python.org/3/library/os.html?#os.system
[`run()`]: https://docs.python.org/3/library/subprocess.html#subprocess.run
[`shlex.quote()`]: https://docs.python.org/3/library/shlex.html#shlex.quote
[`subprocess.SubprocessError`]: https://docs.python.org/3/library/subprocess.html#subprocess.SubprocessError
[`subprocess`]: https://docs.python.org/3/library/subprocess.html
[legacy API]: https://docs.python.org/3/library/subprocess.html#older-high-level-api
[rof]: https://docs.python.org/3/library/subprocess.html#subprocess-replacements
