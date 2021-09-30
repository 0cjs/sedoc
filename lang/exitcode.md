Unix Standard Exit Codes
========================

Common codes:
- `0`: success (everyone)
- `1`: general failure (everyone, including `false(1)`)
- `2`: bad arguments (cjs, Python [argparse])

The _sysexits_ standard from post-4.3BSD is not widely used, but Linux
has copied the BSD [`/usr/include/sysexits.h`][seh-file]:

      0 EX_OK           No error
     64 EX_BASE         No sysexits codes are lower than this
     64 EX_USAGE        Incorrect command (bad args, etc.)
     65 EX_DATAERR      User-supplied input data incorrect
     66 EX_NOINPUT      User-supplied input not readable
     67 EX_NOUSER       User does not exist (e.g., email)
     68 EX_NOHOST       Host does not exist (network request)
     69 EX_UNAVAILABLE  Service unavailable (e.g. support program or file)
     70 EX_SOFTWARE     Internal software error (not OS error)
     71 EX_OSERR        OS error (lack of resources, can't fork, etc.)
     72 EX_OSFILE       System file can't be read (e.g. /etc/passwd bad syntax)
     73 EX_CANTCREAT    User-specified output file cannot be created
     74 EX_IOERR        Error doing I/O on file
     75 EX_TEMPFAIL     Not really an errror, just re-attempt later
     76 EX_PROTOCOL     Remote system violated protocol during an exchange
     77 EX_NOPERM       Not enough permissions to perform op (not FS, but other)
     78 EX_CONFIG       Something found in un/mis-configured state

Documented in:
- [`/usr/include/sysexits.h`][seh-file] on your system
- [NetBSD manual page](https://man.netbsd.org/sysexits.3)


Argument Parser Libraries
-------------------------

### Python

Python's [argparse] since at least 3.5 has exited with code 2 if a bad
argument was specified. If no arguments are specified and at least one
is required, the help message is printed but the exit code is 0.

Since 3.9 an `exit_on_error` opertion is available to let the programmer
handle the error by catching `argparse.ArgumentError`. This allows
generation of different error codes.



<!-------------------------------------------------------------------->
[seh-file]: file:///usr/include/sysexits.h
[argparse]: https://docs.python.org/3/library/argparse.html
