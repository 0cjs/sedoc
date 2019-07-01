Windows Terminals and Terminal Emulators
========================================

Microsoft Console API
---------------------

### Windows Console Host

The [Windows Console] terminal application is `conhost.exe`,
implementing one or more screen buffers (a rectangular grid of
characters and attributes), an input buffer (keyboard, mouse, etc.
events) and user preferences. This is used by `CMD.EXE`, PowerShell,
the DOS emulator, and third-party programs natively compiled to use it
such as Python and Docker.

Windows command line programs running under terminal emulators not
supporting this API, such as mintty, may freeze when certain API calls
are made, e.g. to disable typeback when reading passwords. [winpty] is
designed to help with this; see below.

`conhost.exe` first appeared in Windows 7, and was spawned by the
[Client Server Runtime Subsystem][csrss], `csrss.exe`. Since Windows 8
`conhost.exe` is spawned directly by Windows command line programs.

#### Windows Terminal

[Windows Terminal] is a new replacement for `conhost.exe` including
support for `CMD.EXE`, PowerShell, [WSL][] (Windows Subsystem for
Linux) and SSH. Unlike `conhost.exe` it may not remain backward
compatible with older Windows console applications

Source for both is [available on GitHub][gh-ms-terminal].

### winpty

The [winpty] library provides a shim between Windows native console
programs and Cygwin/MSYS ptys. It starts a hidden Windows console
window (`winpty-agent.exe`) and polls its screen buffer for text that
it sends to the pty.

The Cygwin/MSYS Unix adapter, `winpty.exe` (distributed with Git for
Windows), is a command-line tool useful to wrap programs depending on
the Windows console API under `mintty` and Cygwin's `sshd`, neither of
which provides the Windows console API.

Debugging environment variables:
- Set `WINPTY_SHOW_CONSOLE=1` not to hide the Windows console window.
- Run `winpty-debugserver.exe` and set `WINPTY_DEBUG=trace` to log
  library actions in child processes using it.

### MS OpenSSH Server

What terminal API is the MS-provided OpenSSH server providing to
Windows command line programs?


pty/POSIX API
-------------

### mintty

[mintty][] ([Wikipedia][mintty-wp]) is a Windows terminal emulator designed
for use with Cygwin, MSYS, MSYS2, and WSL (Windows Subsystem for
Linux). It provides a POSIX pty interface (based on Cygwin's ptys) to
the application it's displaying.

It will display text I/O from native Windows programs that don't do
anything sophisticated, but even something as simple as Python's
`getpass()` can break/block the terminal. `winpty` above can help fix
this if you don't want to use CMD or PowerShell.

Ctrl-Tab and Shift-Ctrl-Tab will cycle focus between all mintty
windows, similar to Alt-Tab for all windows.


Other
-----

See also Wikipedia's [List of Terminal Emulators][termlist].

### Putty

[PuTTY](ssh.md#putty) provides terminal emulator, but on Windows this
can be used to connect only to serial ports and network connections
via raw TCP, Telnet, Rlogin, and SSH protocols. (The `pterm` generic
client is available only under Unix.)



<!-------------------------------------------------------------------->
[WSL]: https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux
[Windows Console]: https://en.wikipedia.org/wiki/Windows_Console
[Windows Terminal]: https://en.wikipedia.org/wiki/Windows_Terminal
[csrss]: https://en.wikipedia.org/wiki/Client/Server_Runtime_Subsystem
[gh-ms-terminal]: https://github.com/Microsoft/Terminal
[winpty]: https://github.com/rprichard/winpty

[mintty-wp]: https://en.wikipedia.org/wiki/Mintty
[mintty]: https://mintty.github.io/

[termlist]: https://en.wikipedia.org/wiki/List_of_terminal_emulators#Microsoft_Windows
