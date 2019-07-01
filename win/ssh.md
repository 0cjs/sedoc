SSH Clients for Windows
=======================

See also [Windows Terminals and Terminal Emulators](terminals.md).

The major options are:
* OpenSSH and [mintty] as included in [Git for Windows].
* [PuTTY], a set of graphical clients for SSH, telnet and raw sockets
  that includes a terminal emulator.
* [Chrome SSH App]: terminal emulator and SSH client
* See [ssh.com/ssh/client] for further options.


Windows OpenSSH Client and Server
-----------------------------

As of Windows 10 1809 (and Server 2019) [Microsoft supplies
OpenSSH][ms-ssh] client and server. As well as the docs linked below,
there is a [wiki][ms-ssh-wiki] along with the [source on
GitHub][ms-ssh-github] on GitHub.

[Install][ms-ssh-inst] from __Settings » Apps » Apps and Features
» Manage Optional Features__. The binaries will be placed in
`C:\Windows\System32\OpenSSH\`. Installing the server creates/enables
a firewall rule named `OpenSSH-Server-In-TCP` allowing inbound traffic
on port 22.

Startup can be done from an admin PowerShell:

    Get-NetFirewallRule -Name *ssh*     # Confirm firewall rule present.
    Start-Service sshd
    Set-Service -Name sshd -StartupType 'Automatic'     # Optional

The server is listed as "OpenSSH SSH Server" in the __Services__ app.
Logs are available from the Event Viewer under __Applications and
Services Logs » OpenSSH__. Not sure how to tail this; perhaps [so
15262196] offers some ideas.

The default shell is `CMD.EXE` and password logins are allowed.
[Configure][ms-ssh-conf] the default shell with:

    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH"  -Name DefaultShell \
        -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" \
        -PropertyType String -Force

The standard keys, config files etc. are under `%programdata%\ssh\`
(usually `C:\ProgramData\ssh\`). Suggested Windows-specific
[configuration options][ms-ssh-conf]:

    AllowUsers  cjs
    AllowUsers  otheruser
    #   Alternatively, to just deny admins (PermitRootLogin not applicable)
    #DenyGroups  Administrators

`.ssh/authorized_keys` in the user's homedir works as usual. The
default `sshd_config` uses `administrators_authorized_keys` in the
config dir for admin users.

Running `C:\Program Files\Git\usr\bin\bash.exe -l` will start a Bash
login session.


OpenSSH from Git for Windows
----------------------------

[Git for Windows](../git/win.md) supplies the OpenSSH suite as well. It's not
clear if this is the same as other ports, such as the [MLS installer].
All appear to be based on the [OpenSSH Portable Release][openssh-portable].
There is also the [PowerShell] fork of on the portable release which
may be [using Windows crypto instead of OpenSSL][PSBlog] (do modern
builds of OpenSSH [still use OpenSSL][openssl]?)


PuTTY
-----

The author's page is at [PuTTY], but there is better documentation at
[putty-ssh.com].

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

### PuTTY on Unix

PuTTY has been ported to Unix; Debian has a `putty` (graphical
terminal client), `putty-tools` (command-line tools) and `putty-doc`
packages.

`putty-tools` includes `plink`, `pscp`, `psftp` and `puttygen`. The
last can be very useful for converting key files from Windows users
that [`ssh-keygen`](../app/openssh.md) can't handle.



<!-------------------------------------------------------------------->
[Chrome SSH App]: https://chrome.google.com/webstore/detail/secure-shell-app/pnhechapfaindjhompbnflcldabbghjo
[ssh.com/ssh/client]: https://www.ssh.com/ssh/client/

[ms-ssh-conf]: https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_server_configuration
[ms-ssh-github]: https://github.com/powershell/win32-openssh/
[ms-ssh-inst]: https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
[ms-ssh-wiki]: https://github.com/powershell/win32-openssh/wiki
[ms-ssh]: https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview
[so 15262196]: https://stackoverflow.com/q/15262196/107294

[MLS installer]: http://www.mls-software.com/opensshd.html
[PSBlog]: https://blogs.msdn.microsoft.com/powershell/2015/10/19/openssh-for-windows-update/
[PowerShell]: https://github.com/PowerShell/openssh-portable
[openssh-portable]: https://www.openssh.com/portable.html
[openssl]: https://it.slashdot.org/story/14/04/30/1822209/openssh-no-longer-has-to-depend-on-openssl

[putty]: https://www.chiark.greenend.org.uk/~sgtatham/putty
[putty-portable]: https://portableapps.com/apps/internet/putty_portable
[putty-registry]: https://stackoverflow.com/q/13023920/107294
[putty-ssh.com]: https://www.ssh.com/ssh/putty/
[ssh-pageant]: https://github.com/cuviper/ssh-pageant
