LVM: Linux Logical Volume Manager
=================================

More details at [Wikipedia].

- PVs (physical volumes) are the backing store for
- VGs (volume groups) that in turn provide storage to
- LVs (logical volumes).

LVs can be snapshotted and configured to use RAID.

Commands
--------

- `lvm`: Covers all subcommands; `lvm help` for more info.
- `pvs`, `vgs`, `lvs`: List physical volumes, volume groups, logical volumes.
- `pvcreate`, `vgcreate`, `lvcreate`
- `pvremove`, `vgremove`, `lvremove`



[Wikipedia]: https://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux)
