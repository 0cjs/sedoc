systemd-journal
===============

* [Archlinux info][arch-journal]

If you don't have `journalctl` available, you can just use `strings` on
a journal to see the messages.

#### Fields

Each journal entry has a set of __fields__ to which are assigned values.
- See all field names with `journalctl -N`; `systemd.journal-fields(7)` has
  more details, including the field categories:
  - Trusted: filled in by `journald`; cannot be altered by the client.
  - User: directly passed from clients.
  - Kernel.
  - Logged on behalf of a different program.

Try `journalctl -o verbose -n 1` to see an example log entry with all the
fields. (On a terminal, trusted fields will be coloured.)

Useful fields: `SYSLOG_IDENTIFIER`, `_COMM` (command), `_EXE`, `_PID`.

#### Values

For any field, you can see all __values__ that field has taken on in the
current logs with `journalctl -F FIELDNAME`.

### journalctl options

Remember to sudo to run this if you're not in the `adm` or other
appropriate group.

* Output:
  * `-f`: Follow as new log messages arrive.
  * `-o FMT`: Output format. Handy are `short-iso`, `verbose`.

* Non-field selection:
  * `-n N`: show only last N entries
  * `-S/-U DATE`: shows since/until given time/date/'20 sec ago' etc.

* Selection based on fields (no wildcards, no negation):
  * `NAME=VAL` Entries where field _name_ matches value _val._
  * `-t VAL`: SYSLOG_IDENTIFIER=_val_ (program name, generally)
  * `-u PAT`: Special; only thing that can use a pattern, allegedly,
    though I've not been able to get it to work. Not clear which of
    the `*UNIT*` fields it uses.

* Other selection:
  * `-p PRIO`: Shows <= `emerg` (0), `alert` (1), `crit`, `err`, `warning`, etc.




<!-------------------------------------------------------------------->
[arch-journal]: https://wiki.archlinux.org/index.php/Systemd#Journal
