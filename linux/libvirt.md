libvirt/virsh Virtual Machine Management
========================================

For a general overview of typical VM operations, see [this Dell paper][dell].

[dell]: http://linux.dell.com/files/whitepapers/KVM_Virtualization_in_RHEL_7_Made_Easy.pdf


[`virsh`] Quick Reference
-----------------------

In libvirt terminology a "node" is the host for the VMs and "domains"
are the VMs themselves. Domains `<dom>` below may be specified as a
short integer (from the `list` command), the domain name or a UUID.

    help <cmd>          Show mini-manpage for command
    list [--all]        Show running [all] domains
    shutdown <dom>      Graceful shutdown of a domain
    undefine <dom>      Remove domain definition (from /etc/libvirt)
    dominfo <dom>       Basic info about a domain
    domblklist <dom>    List a domains block devices and backing
    domiflist <dom>     List a domain's network interfaces
    dumpxml <dom>       Domain info usable by define/create

[`virsh`]: https://linux.die.net/man/1/virsh


virt-install
------------

Instead of `virsh define` from an XML file, you can install a new
VM from an existing image with e.g.

    virt-install --import --name=myhost --os-variant=centos7.0 \
        --ram=2048 --vcpus=2
        --disk=/var/lib/libvirt/images/foo.qcow2,format=qcow2,bus=virtio \
        --graphics=none --console=pty,target_type=serial \
        --network=bridge=br0 --network=bridge=br1
    virsh autostart "$vm_name"

On occasion you may see `internal error: cannot load AppArmor
profile 'libvirt-84c60c62-f4a0-a419-4f5e-a782d5472762`. The current
workaround is to suspend enforcement of the AppArmor profile with
`aa-complain /usr/sbin/libvirtd`, do the virt-install, and then
re-enable enforcement with `aa-enforce /usr/sbin/libvirtd`.


Images
------

Use [`qemu-img`], e.g.

    qemu-img create -f qcow2 "/var/lib/libvirt/images/foo.qcow2" 12G

Suggested config:

* QCOW2
* No backing image (at least for production images). This avoids
  having to keep track of more than one file when copying or backing
  up images.
* No encryption on domains that must boot without human intervention.
* Compression is optional. This can save storage space and speed up
  copying an initial image between hosts, where useful. This is only
  useful when creating a new image from an existing image, since
  blocks written in a runing domain will not be compressed.

Empty blocks will not be stored in a qcow2 image, reducing the size,
but blocks allocated by the FS will not be released in the image when
they are no longer used.

[`qemu-img`]: https://linux.die.net/man/1/qemu-img


Network Installs and Netbooting
-------------------------------

Network installs and netbooting are two separate things that are
orthogonal to each other; they can be used together, or either can be
used without the other.

Network installs are done by the installer and, optionally, the kernel
and root image themselves may be loaded over the network via either a
netboot process or, without netbooting, by `virt-install`. In this
second case the source for the kernel, install root image can be
loaded from a CentOS mirror via `virt-install`'s `--location URL`
command-line option. The kernel and install image are downloaded from
the URL, `libvirt-install` configures the VM to boot these downloaded
files (not from the network, but locally configured), and a parameter
is passed to the installer to ask it to use that same URL to download
the packages to be installed. All of this is done via HTTP (or FTP).

A netboot involves configuring the VM to start the [iPXE] boot system
which will then use DHCP and (usually) TFTP to fetch the initial
kernel and root image. From that point you may run either a standard
OS or the install system, depending on what you downloaded; if you're
using the install system most frequently you would then do a network
install, as described above.

The main branch of this repository does not currently have support for
network booting; see the `netboot` branch for some code and
configuration to help support this.

[iPXE]: https://en.wikipedia.org/wiki/IPXE


Installer Errors
----------------

When doing a network install you may see errors along the lines of

    dracut-initqueue[587]: /sbin/dmsquash-live-root line 273: printf: write error: No space left on device
    dracut-mount[962]: Warning: Can't mount root filesystem

This may come and go depending on even just changing the order of
seemingly unrelated lines (such as network configuration lines) in the
kickstart file.

This is generally due to not allocating enough RAM to the VM for the
install to run. The install has been seen to break in this way with even
1024 MB of RAM, so it's probably best to allocate at least 2048 MB to an
install VM even if the later production VM won't need that much.

