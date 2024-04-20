Git for Windows
===============

[Git for Windows][gfw] (also available [from git-scm.com][gfw gsc]) is a
[MinGW](../win/unixy.md) build of Git and various other tools. It includes:
* Git, Git LFS, tig (ncurses Git repo browser/interface)
* OpenSSH (dunno if it's [Win32-OpenSSH] or not)
* [ssh-pageant], to let OpenSSH use PuTTY's [Pageant](term-ssh.md)
* [mintty] and Bash (used by 'Git Bash Here' menu item in Explorer)
* GPG / GNU Privacy Guard (PGP), curl, perl, tcl/tk, MSYS21
* OpenSSL, zlib
* Root certs

#### Installation Summary

The install options used in previous installations can be found in one of
the following files:

    C:\Program Files\Git\etc\install-options.txt
    C:\Program Files (x86)\Git\etc\install-options.txt
    %USERPROFILE%\AppData\Local\Programs\Git\etc\install-options.txt
    /etc/install-options.txt

Below, ✓ indicates things that should be selected/enabled, and ✗ things
that should be deselected/disabled.

0. If you are going to use [Visual Studio Code][vsc], or have another
   favourite editor, install it before installing Git.
1. Download the installer from the [gitforwindows.org][gfw] and run it; the
   following steps/choices will appear as the install wizard progresses.
   (Not all steps are shown here; what to do for those not shown should be
   obvious when you see them.)
2. Select Components: ensure that the following are checked:
   - ✓ Windows Explorer integration: Git Bash Here
   - ✓ Associate .sh files to be run with Bash
3. Default editor: If your preferred option is not in the list, leave it at
   the default (Vim). This can easily be changed later.
4. Adjusting PATH: "Git from the command line and also from 3rd-party software."
5. SSH executable: "Use OpenSSH."
6. HTTPS backend: "Use the native Windows Secure Channel library."
7. Line ending conversions: "Checkout as-is, commit as-is." (Line endings
   should be handled by your editor, not by Git. Even Windows 10 Notepad
   now handles Unix line endings.)
8. Terminal emulator: "Use MinTTY."
9. Behaviour of `git pull`: "Only ever fast-forward."
10. Credential helper: None.
11. Extra options:
    - ✓ Enable file system caching
    - ✗ Enable symbolic links
12. ✗ Enable experimental support for pseudo consoles.
    (As of 2.28.0.windows.1 this produces odd behaviour such as dropping
    CRs and spawning Windows consoles with your output.)


File Modes
----------

MS-DOS and Windows filesystems (including NTFS) do not support setting an
executable bit. Git handles this automatically on clone by setting the repo
local config (`.git/config`) to include `core.filemode = false`,. which
suppresses checking of the executable bit in the working copy.

But if the repo was cloned on Unix and then shared with a Windows machine
this will not be set and the execute bit will appear to be reset in the
working copy. Fix this with `git config --local core.filemode false`.

To set the executable bit on a new file when committing on such a system,
use `git add --chmod=+x`. (≤2.10 use `git update-index --chmod=+x` after
staging the file.)

For filesystems that do support filemode and have the executable bit set,
but where git is still complaining that it's modified, use `git
update-index --skip-worktree --chmod=+x`:

    $ st
    ## main...origin/main [behind 4]
     M bin/f9post
    $ dif
    diff --git a/bin/f9post b/bin/f9post
    old mode 100755
    new mode 100644
    $ git update-index --skip-worktree --chmod=+x bin/f9post
    $ st
    ## main...origin/main [behind 4]


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


Certificate Management
----------------------

(XXX This applies to Unix as well, and so should be in another sedoc file.)

Git can be [configured][git-config] to use specific certificates (client
and/or server) for specific sites. Setting server certs is useful both
for sites using a non-public PKI (e.g., a self-signed cert) and for
environments using [corporate MITM][mitm].

To set the CA cert to use for a site:

    git config --global http.SITE-URL.sslcainfo 'CERT-FILE-PATH'
    # E.g.:
    git config --global http.https://git.myserver.com/.sslcainfo "C:\Certs\MyCACert.crt"

[so-46332681] has further useful information and discussion on certificate
issues when using Git.

[mitm]: https://security.stackexchange.com/q/107542/12254
[so-46332681]: https://stackoverflow.com/a/46332681/107294


Credential Management
---------------------

Recent versions of [Git for Windows][gfw] install and configure [Git
Credential Manager for Windows][gcmw] if that box is checked during
the install process. This installs the `git credential-manager`
program and sets `credential.helper=manager` in the Git system
configuration. That configuration key is multivalue (each helper is
tried in turn) and thus cannot be overridden; you need to remove it
from the system gitconfig or, possibly, setting `$GIT_CONFIG_NOSYSTEM`.
For manual setting:

    git config -g credential.helper manager

Git Credential Manager for Windows will store the credentials in the
Windows Credential Manager, accessible from "Control Panel » User
Accounts Credential Manager." The "Windows Credentials" section will
have "Generic Credentials" list which will include the HTTP URLs
prefixed with `git:`, e.g., `git:https://git@git.mydomain.com/`. If
you have an incorrect credential in the manager, you can replace it or
delete it here.

This isn't particularly secure; you can get the cleartext of a
password (and the username) stored there by sending a request to it
using the [git-credential] protocol, e.g.,

    echo "protocol=https
    host=git.mycompany.com
    " | git credential-manager get

When using this kind of credential storage you should issue a separate
access token (e.g., a [GitHub personal access token][gh-token]) that
you use nowhere else and perhaps expire it on a regular basis.

Using [2FA] on your GitHub account (as you should!) somewhat increases
your security against this general class of attack as you will not be
able to use just your password to authenticate; you'll have to use a
personal access token instead in these situations. However, the
additional security you gain is merely being able to limit the scope
of the token and easily cancel it without affecting other tokens used
by other machines or applications.


TortoiseGit
-----------

[TortoiseGit] provides a Windows File Explorer extension for Git
commands, a nice stand-alone Git log browser, and copies of PuTTY's
`pageant.exe` and `puttygen.exe`.



<!-------------------------------------------------------------------->
[2FA]: https://help.github.com/articles/about-two-factor-authentication/
[TortoiseGit]: https://tortoisegit.org/
[Win32-OpenSSH]: https://github.com/PowerShell/Win32-OpenSSH
[gcmw]: https://github.com/Microsoft/Git-Credential-Manager-for-Windows
[gfw gsc]: https://git-scm.com/download/win
[gfw]: http://gitforwindows.org/
[gh-token]: https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/
[git-config]: https://git-scm.com/docs/git-config
[git-credential]: https://git-scm.com/docs/git-credential
[mintty]: https://mintty.github.io/
[so-winsecchan]: https://stackoverflow.com/a/46332681
[ssh-pageant]: https://github.com/cuviper/ssh-pageant
[vsc]: https://code.visualstudio.com/
