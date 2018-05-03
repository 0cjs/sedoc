cryptdisks, LUKS, etc.
======================


`/etc/crypttab` is read on boot and by `cryptdisks_start NAME`. 
The four fields are:
* _target_: name (`/` not allowed) to map to in `/dev/mapper`
* _source device_: device name, UUID=partition-UUID, etc.
* _key file_: 

In many situations it's reasonably safe to add a key file as an
additional key to a LUKS filesystem and store that on your encrypted
boot disk (readable root only of course). This means that someone who
can decrypt your root disk can decrypt the additional disk, too, but
that's often a price worth paying for not having to type two passwords
at boot.

#### Manpages

* crypttab(5)
* cryptdisks(8)
* cryptdisks_start(8)
* cryptdisks_stop(8)

#### Other Docs

* <https://blog.tinned-software.net/automount-a-luks-encrypted-volume-on-system-start/>
* <https://unix.stackexchange.com/q/363542/10489>
