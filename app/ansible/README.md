Ansible Sysadmin Automation
===========================

[Ansible][docs] is an agentless IT automation system for
configuration, deployment and orchestration, written in Python.
[Ansible Galaxy][galaxy] is a community site for sharing roles; you
can also run a self-hosted private version.

The latest version is 2.18 as of 2024-11.

As with most systems of this type, update scripts should be
idempotent, but it's left to the developer to ensure that this is the
case. Configurable generic scripts (e.g., from Galaxy) may or may not
do a good job of this.

### Overview

At an interactive login on the _control node_ you download, clone
and/or otherwise arrange access to configuration information that
includes the _inventory_ (list of _managed nodes_ and their
descriptions) and _playbooks_ (containing _tasks_ and _roles_, the
policy and process descriptions). Files are usually read as [YAML].
Some information may be encrypted at rest with [Vault].

At this point you can run Ansible _ad-hoc commands_ or _playbooks_ on
_hosts_ and _groups_ from the inventory. Ansible will connect to the
managed nodes, transfer across any content that it needs (including
scripts) and run commands as necessary. Nothing is left running or
left behind on the managed node once the commands have completed.

Control node requirements:
* Non-dedicated system (often a personal laptop).
* Unix-like (Windows not supported).
* Python 2.7 or ≥3.5.
* Ansible installed via `pip`, OS package manager, or run from a clone
  of the [GitHub repository][github].
* Means of logging in to the managed nodes without interactive
  authentication.

Managed node requirements:
* Python 2.7 or ≥3.5. Default path is `/usr/bin/python`; can be set
  with `ansible-python-interpreter`. Not needed for the [`raw`
  module][mod-raw] or [`script` module][mod-script].
* Running SSH server (also SFTP enabled?) or WinRM if using those.
* If SELinux is enabled, `libselinux-python` to use copy/file/template
  functions. (Can be installed via Ansible, e.g. [`yum`
  module][mod-yum].)


Connecting to Managed Nodes
---------------------------

[Inventory settings][connecting] determine how to connect to the
managed node. The _connector_ is chosen via the `ansible_connection`
variable. Values and additional variables to configure that are spread
throughout the documentation. Connectors include:

- [`local`][non-ssh]: run commands locally (control node is also managed node).
- [`ssh`][connecting]: OpenSSH client (normally uses `ControlPersist`).
- [`paramiko`][connecting]: Python SSH client
- [`docker`][non-ssh]: Docker.
- HTTP requests to to WinRM server.


Installation
------------

Full details are in the [Installation Guide][inst].

To install via pip, set up virtualenv if necessary and then whatever
you need of:

    pip install paramiko        # If using `paramiko` connection plugin.
    pip install ansible
    pip install git+https://github.com/ansible/ansible.git@devel

For working from source, `pip` must be available, then:

    git clone https://github.com/ansible/ansible.git
    cd ./ansible
    git submodule update --init --recursive
    source ./hacking/env-setup      # Bash; -q available
    export ANSIBLE_INVENTORY=.../ansible_hosts



<!-------------------------------------------------------------------->
[docs]: https://docs.ansible.com
[galaxy]: https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html
[github]: https://github.com/ansible/ansible
[vault]: https://docs.ansible.com/ansible/latest/user_guide/playbooks_vault.html
[yaml]: https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html

[connecting]: https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#connecting-to-hosts-behavioral-inventory-parameters
[non-ssh]: https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#non-ssh-connection-types

[inst]: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

[mod-raw]: https://docs.ansible.com/ansible/latest/modules/raw_module.html
[mod-script]: https://docs.ansible.com/ansible/latest/modules/script_module.html
[mod-yum]: https://docs.ansible.com/ansible/latest/modules/yum_module.html
