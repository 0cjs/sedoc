Terminal Emulators and SSH for Windows
======================================

The major options are:

* OpenSSH and [mintty] as included in [Git for Windows].
* [PuTTY], a set of graphical clients for SSH, telnet and raw sockets
  that includes a terminal emulator.
* [Chrome SSH App]: terminal emulator and SSH client
* See [ssh.com/ssh/client] for further options.



OpenSSH for Windows
-------------------

The port I use is the one included in [Git for Windows]. It's not
clear if this is the same as other ports, such as the [MLS installer].
All appear to be based on the [OpenSSH Portable Release][portable].
There is also the [PowerShell] fork of on the portable release which
may be [using Windows crypto instead of OpenSSL][PSBlog] (do modern
builds of OpenSSH [still use OpenSSL][openssl]?)


PuTTY
-----

The author's page is at [PuTTY], but there is better documentation at
[ssh.com/ssh/putty].

PuTTY's terminal emulator connects to serial ports or network hosts
via SSH, Telnet or rlogin. The main components are `PuTTY` (terminal
client) `pscp`, `psftp`, `Plink` (command-line interface to the PuTTY
back ends), `Pageant` (SSH authentication agent for PuTTY/PSCP/Plink),
`PuTTYgen` (key generation/management utility), and `PuTTYtel`
(Telnet-only client).

#### PuTTY Configuration in the Registry

A huge downside of PuTTY is that all configuration is stored in the
registry. This can be [dumped and restored][putty-registry], and may
be easier if you're using [putty-portable].

To dump (you may need to be an admin):

    regedit /ea sessions.reg HKEY_CURRENT_USER\Software\SimonTatham\PuTTY

Running this should (re-)load the entries. The format is fairly
human-readable.

### PAgeant and ssh-pageant

PAgeant (note spelling) can be used by other SSH programs that use the
standard OpenSSH agent protocol by using [ssh-pageant]. This is not
included in the standard PuTTY distribution, but is included with [Git
for Windows].

It's started just like ssh-agent: `eval $(ssh-pageant)`. PAgeant does
not need to be running at the time, but in that case a query will fail:

    $ ssh-add -l; echo $?
    error fetching identities: agent refused operation
    1

You can start PAgeant later and `ssh-pageant` will then be able to
communicate with it.



[Chrome SSH App]: https://chrome.google.com/webstore/detail/secure-shell-app/pnhechapfaindjhompbnflcldabbghjo
[Git for Windows]: git.md
[MLS installer]: http://www.mls-software.com/opensshd.html
[PSBlog]: https://blogs.msdn.microsoft.com/powershell/2015/10/19/openssh-for-windows-update/
[PowerShell]: https://github.com/PowerShell/openssh-portable
[PuTTY]: https://www.chiark.greenend.org.uk/~sgtatham/putty
[mintty]: https://mintty.github.io/
[openssl]: https://it.slashdot.org/story/14/04/30/1822209/openssh-no-longer-has-to-depend-on-openssl
[portable]: https://www.openssh.com/portable.html
[putty-portable]: https://portableapps.com/apps/internet/putty_portable
[putty-registry]: https://stackoverflow.com/q/13023920/107294
[ssh-pageant]: https://github.com/cuviper/ssh-pageant
[ssh.com/ssh/client]: https://www.ssh.com/ssh/client/
[ssh.com/ssh/putty]: https://www.ssh.com/ssh/putty/
