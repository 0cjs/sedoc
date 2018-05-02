OpenSSH Notes
=============

OpenSSH Documentation:
* [Manual pages][manual]
* [`ssh-agent` protocol][agent-protocol]

Related Software:
* [ckssh]
* [Paramiko API] (Python implementation of SSHv2)


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



[Paramiko API]: http://docs.paramiko.org/
[agent-protocol]: http://api.libssh.org/rfc/PROTOCOL.agent
[ckssh]: https://github.com/cynic-net/ckssh
[manual]: https://www.openssh.com/manual.html
[ssh_config]: https://man.openbsd.org/ssh_config
