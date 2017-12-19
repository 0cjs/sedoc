Terminal Emulators and SSH for Windows
======================================

The two major options are [PuTTY] or OpenSSH and [mintty] as included
in [Git for Windows].


[PuTTY]
-------

Terminal emulator connects to serial ports or network hosts via SSH,
Telnet or rlogin. The main components are `PuTTY` (terminal client)
`pscp`, `psftp`, `Plink` (command-line interface to the PuTTY back
ends), `Pageant` (SSH authentication agent for PuTTY/PSCP/Plink),
`PuTTYgen` (key generation/management utility), and `PuTTYtel`
(Telnet-only client).

Configuration is stored in the Registry; it can be dumped/restored
but this is a real pain.

PAgent can be used by other SSH programs that use the standard OpenSSH
agent protocol by using [ssh-pagent] (included w/[Git for Windows]).



[PuTTY]: https://www.chiark.greenend.org.uk/~sgtatham/putty
[mintty]: https://mintty.github.io/
[ssh-pagent]: https://github.com/cuviper/ssh-pageant
[Git for Windows]: git.md
