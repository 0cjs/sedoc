Git for Windows
===============


Credential Management
---------------------

Recent versions of [Git for Windows][gfw] install and configure [Git
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
    host=codebase.sxi-genesis.com
    " | git credential-manager get

When using this kind of credential storage you should issue a separate
access token (e.g., a [GitHub personal access token][gh-token]) that
you use nowhere else and perhaps expire it on a regular basis.



[gfw]: https://git-for-windows.github.io/
[gcmw]: https://github.com/Microsoft/Git-Credential-Manager-for-Windows
[git-credential]: https://git-scm.com/docs/git-credential
[gh-token]: https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/
