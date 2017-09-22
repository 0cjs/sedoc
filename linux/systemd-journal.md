systemd-journal
===============

* [Archlinux info][arch-journal]

If you don't have `journalctl` available, you can just use `strings` on
a journal to see the messages.

### journalctl options

Remember to sudo to run this if you're not in the `adm` or other
appropriate group.

* `-f`: follow as new log messages arrive
* `-n N`: show only last N entries
* `-S/-U DATE`: shows since/until given date(s) or '20 sec ago' etc.
* `-o FMT`: formats: `short-iso`, `verbose`
* `-t PAT`: messages where SYSLOG_IDENTIFIER (program name) matches PAT
* `-u PAT`: messages where systemd unit matching PAT
* `-p PRIO`: Shows <= `emerg` (0), `alert` (1), `crit`, `err`, `warning`, etc.

Use `-F FIELD` to get a list of all values for a given field, e.g.,
`_COMM` (command), `_EXE`, `_PID`.
* Quick reference: `journalctl -o verbose -n 1`. For a fu
* Full reference: `man systemd.journal-fields`

The patterns above don't seem to work (it just does exact matches),
nor does it seem to be possible to use patterns for `_MESSAGE`.


[arch-journal]: https://wiki.archlinux.org/index.php/Systemd#Journal
