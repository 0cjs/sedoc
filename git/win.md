[Git for Windows]
=================

Includes:
* Git, of course
* OpenSSH (dunno if it's [Win32-OpenSSH] or not)
* [ssh-pagent], to let OpenSSH use PuTTY's [Pageant](term-ssh.md)
* [mintty] and Bash (used by 'Git Bash Here' menu item in Explorer)
* zlib, curl, tcl/tk, perl, MSYS21
* Root certs


TLS (SSL) Libraries
-------------------

First, a warning: lots of people recommend `git config --global
http.sslVerify false`; this disables all authentication and should not
be done.

Git for Windows comes with a MinGW OpenSSL library; this will be used
by `curl` and the like. Git itself [can be configured][so-winsecchan]
(without reinstallation, but for just that user) to use this or the
native Windows Secure Channel library via one of the following:

    git config --global http.sslBackend openssl
    git config --global http.sslBackend schannel


Credential Management
---------------------

Recent versions of [Git for Windows] install and configure [Git
Credential Manager for Windows][gcmw] if that box is checked during
the install process. This installs the `git credential-manager`
program and sets `credential.helper=manager` in the Git system
configuration. That configuration key is multivalue (each helper is
tried in turn) and thus cannot be overridden; you need to remove it
from the system gitconfig or, possibly, setting `$GIT_CONFIG_NOSYSTEM`.

Git Credential Manager for Windows will store the credentials in the
Windows Credential Manager, accessible from the top level of the
Control Panel. This isn't particularly secure; you can get the
cleartext of a password stored there by sending a request to it using
the [git-credential] protocol, e.g.,

    echo "protocol=https
    host=git.mycompany.com
    " | git credential-manager get

When using this kind of credential storage you should issue a separate
access token (e.g., a [GitHub personal access token][gh-token]) that
you use nowhere else and perhaps expire it on a regular basis.



[Git for Windows]: http://gitforwindows.org/
[Win32-OpenSSH]: https://github.com/PowerShell/Win32-OpenSSH
[gcmw]: https://github.com/Microsoft/Git-Credential-Manager-for-Windows
[gh-token]: https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/
[git-credential]: https://git-scm.com/docs/git-credential
[mintty]: https://mintty.github.io/
[so-winsecchan]: https://stackoverflow.com/a/46332681
[ssh-pagent]: https://github.com/cuviper/ssh-pageant
