Virtual Machines, Hypervisors, etc.
===================================

Networking
----------

Typically VMs have a virtual network interface tied to a kernel
software bridge (`apt-get install bridge-utils`). Use `brctl` to
configure and monitor bridges on the fly. Bring configuration on
Debian goes in `/etc/network/interfaces`, e.g.:

    auto br2
    iface br2 inet static
      bridge_ports eth0
      address 192.168.100.10
      netmask 255.255.255.0


libvirt
-------

[libvirt] provides an API to manage VMs provided by various platforms,
including KVM, QEMU, Xen, VMWare, etc. Guests are called "domains" and
are identified by a unique name, ID and UUID. Configuration is stored
as XML files under `/etc/libvirt/`.

The `virsh` command controls things. `virt-install` helps with the
creation of new domains.

##### `virsh` commands:

- `help`: List commands, given command name gives help for that command.
- `list [--all]`: List domains.
- `dominfo DOM`: Information about a domain.
- `domstate DOM`: Returns `running`, `shut off`.
- `create`: Create a domain from an XML file. (See also `virt-install`.)
- `edit`: Edit XML config for a domain.
- `define`: Define domain info from XML, but do not start domain.
- `undefine`: Undefine an inactive domain.
- `start`
- `reboot DOM`
- `shutdown DOM`: Graceful shutdown of a domain.
- `destroy DOM`: Immediate termination.
- `console DOM`: Connect to a guest's console (exit with `^]`).
- `ttyconsole DOM`: Print the name of DOM's console device.
- `vncdisplay DOM`: Print IP address and port number for VNC display.
  Connect with, e.g., `vncviwer --via host :1`

##### Storage Management

See [Storage Management][libvirt-storage] and [XML
configuration][libvirt-storage-xml].

To add and boot of a cdrom ([mycfg.net]):

    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='/isos/systemresucecd-x86-2.2.0.iso'/>
      <target dev='hdc' bus='ide'/>
      <readonly/>
      <address type='drive' controller='0' bus='1' unit='0'/>
    </disk>

    <os>
      <type arch='x86_64' machine='pc-0.12'>hvm</type>
      <boot dev='cdrom'/>
      <boot dev='hd'/>
    </os>

[libvirt-storage-xml]: https://libvirt.org/formatstorage.html
[libvirt-storage]: https://libvirt.org/storage.html
[libvirt]: https://libvirt.org/
[mycfg.net]: https://mycfg.net/articles/booting-from-a-cdrom-in-a-kvm-guest-with-libvirt.html


Xen Hypervisor/Virtual Machine Monitor
--------------------------------------

Site is [xenproject.org]. There is also a [Xen wiki]. Host ("control
domain") is `Dom0`; other domains are guests.

### Installation

From [Xen Project Beginners Guide][xenwiki-xpbg]:

1. `apt-get install lvm2 bridge-utils xen-linux-system`.  
   (Ubuntu maybe `xen-hypervisor-4.4-amd64`.)
2. Create [LVM](../linux/lvm.md) volumes.
3. Add bridge(s) to `/etc/network/interfaces`.
4. Configure grub to boot Xen dom0 kernel.

### Commands

- `xl info`: Hypervisor and dom0 info.
- `xl list`: List running domains.

[Xen wiki]: https://wiki.xenproject.org/
[xenwiki-xpbg]: https://wiki.xenproject.org/wiki/Xen_Project_Beginners_Guide
[xenproject.org]: https://xenproject.org
