Ansible Commands
================

#### Ad-hoc Commands

See [Using Ansible command line tools][cli].

- `ansible-inventory --list`
- `ansible HOST -m MOD -a ARG`: run module to perform an action on _host._
  - `-b` option for "become" (sudo).
- `ansible-playbook playbook/foo.yml`: Manually run a playbook.

### Inventory Management
- `ansible-inventory --list`: tree of groups/hosts/etc.

### Modules (to perform command-line or playbook actions):

These are given arguments to perform command-line (`ansible -m …`) or
playbook actions.

- `ansible-doc -l` to list modules
- `ansible-doc -t connection -l` to list the available connection plugins.
- `ansible-doc ansible.builtin.copy` to see module documentation
- `ansible-galaxy collection list`
- See also the [Ansible CLI cheatsheet][cheat].

### Configuration

Config examples and documentation commands:
- `ansible-config dump`
- `ansible-config init --disabled` to print all config headings and the
  options under them.

Connecting to managed hosts:
- [Connection variables][cvars]: `ansible_connection`, etc.
- [Using connection plugins][cplug]
- Connection Plugins:
  - [`community.docker.docker`][cp_docker]. Uses `docker` command-line
    tool. Not clear if it can sudo it.
  - [`community.docker.docker_api`][cp_dockapi]: Connects directly to the
    Docker daemon. Makes the sudo problem worse, but one could use the
    [`dockerd-proxy`] from `dent`.


Command-line Completion
-----------------------

For command-line completion you need [argcomplete][] ([docs][argcomplete-doc])
installed; Ansible will automatically make use of it if it's available.
It's also necessary to do some setup on the user side, either specifically
for the program or a general "global" config that works with all
argcomplete programs. The simplest temporary way of adding this may be:

    eval $(register-python-argcomplete ansible)
    eval $(register-python-argcomplete ansible-config)
    eval $(register-python-argcomplete ansible-console)
    eval $(register-python-argcomplete ansible-doc)
    eval $(register-python-argcomplete ansible-galaxy)
    eval $(register-python-argcomplete ansible-inventory)
    eval $(register-python-argcomplete ansible-playbook)
    eval $(register-python-argcomplete ansible-pull)
    eval $(register-python-argcomplete ansible-vault)



<!-------------------------------------------------------------------->
[cheat]: https://docs.ansible.com/ansible/latest/command_guide/cheatsheet.html#ansible
[cli]: https://docs.ansible.com/ansible/latest/command_guide/index.html
[cp_dockapi]: https://docs.ansible.com/ansible/latest/collections/community/docker/docker_api_connection.html#ansible-collections-community-docker-docker-api-connection
[cp_docker]: https://docs.ansible.com/ansible/latest/collections/community/docker/docker_connection.html#ansible-collections-community-docker-docker-connection
[cplug]: https://docs.ansible.com/ansible/latest/plugins/connection.html#using-connection-plugins
[cvars]: https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#connection-variables

[`dockerd-proxy`]: https://github.com/cynic-net/dent/blob/main/bin/dockerd-proxy
[argcomplete-doc]: https://kislyuk.github.io/argcomplete/
[argcomplete]: https://github.com/kislyuk/argcomplete
