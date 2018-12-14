OpenSSH Notes
=============

OpenSSH Documentation:
* [Manual pages][manual]
* [`ssh-agent` protocol][agent-protocol]

Related Software:
* [PuTTY]
* [ckssh]
* [Paramiko API] (Python implementation of SSHv2)


Selected Client Configuration Directives
----------------------------------------

Configuration directives are parsed in order from the command line
`~/.ssh/config` and `/etc/ssh/ssh_config`; the first-obtained value is
used. Configuration keywords and arguments are separated by whitespace
and an optional `=`. In configuration files:
- Whitespace-only lines and lines starting with `#` are ignored;
  configuration lines cannot have trailing comments.
- Configuration arguments may be enclosed in double quotes.

#### Tokens

These may not exist in all versions of SSH or work in all directives.

    %%    Literal ‘%’.
    %C    Shorthand for %l%h%p%r.
    %d    Local user's home directory.
    %h    The remote hostname (after HostName, canonicalization, if any).
    %i    The local user ID.
    %L    The local hostname.
    %l    The local hostname, including the domain name.
    %n    The original remote hostname, as given on the command line.
    %p    The remote port.
    %r    The remote username.
    %u    The local username.

In most paths, `~` alone will be replaced with the user's homedir.

#### Section Directives

`Host` and `Match` apply to all directives until the next `Host` or
`Match` directive.

`Host` takes a whitespace-separated list of patterns where `*` and `?`
match as per shell globs and all else is literal. A pattern negated
with a leading `!` will cause the host entry to be ignored even if
other patterns match. The patterns are matched against the hostname
given on the command line unless `CanonicalizeHostname` is in effect.

`Match` takes list of whitespace-separated conditions, negated with a
leading `!`, all of which must be satisfied.

Conditions taking no argument are:
- `all`: Always matches.
- `canonical`: Matches when config is reparsed after
  `CanonicalizeHostname` canonicalization.

The `exec command` condition takes one argument, executing _command_
using user's shell. It is true if exit status is 0. Accepts tokens
`%h %L %l %n %p %r %u`.

The following conditions take as their argument a comma-separated list
of patterns (`*`, `?` and leading `!` for negation):
- `host`: Matched against target hostname after any subsitution by
  `HostName` or `CanonicalizeHostname` options.
- `originalhost`: Matched against hostname as typed on command line.
- `user`: Matched against target username on remote host.
- `localuser`: Matched against name of user running `ssh`.

#### Directives

Authentication:
- `HostKeyAlias`: Name under which to look up the host key in
  known_hosts files. (≥5.3 or earlier.)
- `IdentityAgent`: Path to SSH agent socket (`~` and `%` tokens
  allowed).

Canonicalization:
- `CanonicalizeHostname`: Default `no`, do no rewriting; system
  resolver handles lookups. If `yes`, connections not using a
  `ProxyCommand` are canonicalized; if `always` proxied connections
  are too.


IdentityFile and IdentitiesOnly Behaviour
-----------------------------------------

Though it may seem from the [manual page][ssh_config] that
`IdentitiesOnly` will always use a private key loaded from the
specified file, this is not the case. If it can figure out what the
public key is, and an agent has the corresponding private key, it will
use the agent instead of loading the private key itself.

Consider this configuration:

    Host aremote
        IdentitiesOnly yes
        IdentityFile ~/.ssh/keyfile

If no agent is running, it will attempt to load `keyfile` (possibly
prompting for a passphrase). However, if an agent is running, it will
do the following:

1. Attempt to open `/.ssh/keyfile.pub` and read the public key. If the
   `IdentityFile` path already has a `.pub` on the end, a second
   `.pub` will not be added.
2. If it successfully read the public key, it will ask the agent if it
   has this key available.
3. If the agent has it available, the agent will be asked to do the
   signing required to authenticate to the remote server.
4. If the agent does not have that key available, `keyfile` will be
   loaded as above.

Note the following implications:

1. You do not need the private key available to `ssh`, only the public
   key (just `keyfile.pub`) so long as the agent has the corresponding
   private key loaded.
2. If `IdentitiesOnly yes` is specified and  no `keyfile.pub` exists,
   the agent will not be used even if it has the same private key
   that's in `keyfile`.
3. If `IdentitiesOnly` is not specified, OpenSSH will use the agent to
   authenticate with any identity the agent holds, even if that's not
   the identity specified by `IdentityFile`.

Also good to keep in mind is that none of the above affects agent
forwarding; once it's been forwarded anybody on the remote host with
access to the socket can authenticate with all the keys in the agent.


Key File Formats and Conversion
-------------------------------

Though `ssh-keygen` claims to be able to handle PEM files, the
manpage may be a little optimistic about what the program can
actually do.\[[unix 84122]]

Debian has a [`putty-tools`][putty] package that includes Unix command-line
version of `puttygen` that is better at doing conversions. Useful
conversion commands are:

    puttygen foo.pem -l                         # Show ingerprint
    puttygen foo.pem -L                         # Show OpenSSH public key
    puttygen foo.pem -O private-openssh -o foo  # Convert private key

All the above work on PEM private key files, which start with lines like:

    -----BEGIN RSA PRIVATE KEY-----
    Proc-Type: 4,ENCRYPTED



Versions
--------

    Ver     Distros                 New Config Directives
    ---------------------------------------------------------------------------
    7.6     Ubuntu 18.04
    7.4     Debian 9                IdentityAgent Include
    6.6     Ubuntu 14.04            Match IgnoreUnknown
    5.9     Ubuntu 12.04
    5.3     Ubuntu 10.04



[Paramiko API]: http://docs.paramiko.org/
[PuTTY]: ../win/term-ssh.md
[agent-protocol]: http://api.libssh.org/rfc/PROTOCOL.agent
[ckssh]: https://github.com/cynic-net/ckssh
[manual]: https://www.openssh.com/manual.html
[ssh_config]: https://man.openbsd.org/ssh_config
[unix 84122]: https://unix.stackexchange.com/a/84122/10489
