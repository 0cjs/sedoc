Floppy Diskette Drives on Linux
===============================

Also see [`8bit/floppy.md`](../8bit/floppy.md).

Sometimes formatting a dodgy diskette on a "real" machine will fix
read/write errors that the USB drive can't handle.

USB floppy drives use a different driver and vastly different control
system than "real" floppy drives. For USB drives, `ufiformat` (`ufiformat`
package) for information and formatting.

`ufiformat` options; device `dev/sd?` as last arg:
- `-v`/`--verbose`: (also `-q` to suppress minor diagnostics)
- `-i`/`--inquire`: show device info
- `-V`/`--verify`: verify after formatting; _still formats first._
- `-f SIZE`/`--format SIZE`: specify format size (see below), otherwise default

Supported formats:
- 2HD: 1440, 1232, 1200
- 2DD: 720, 640
