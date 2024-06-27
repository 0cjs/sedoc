Docker Tips
===========

* [Overview](README.md) | [Install/Config](config.md) | [Image Build](image.md)
  | [Registries](registries.md) | [Security](security.md) | [Misc](misc.md)
  | [Tips](tips.md) | [Compose](compose.md)

Contents:
- Checking If You're Running in a Container
- Start/Detach/Stop/Restart
- Separate Shell Process in Running Docker Container
- Usage of Docker Volumes
- Docker ps and Filters
- Docker Inspect and Templates
- Force Intermediate Image Rebuilds
- Check Image Growth
- Cleaning Up Old Images, etc.
- Networking MTU Issues
- Setting Proxies for Docker
  - Daemon
  - Containers
- Curl and the Docker REST API
- Systemd in Docker
- Docker in Docker
- Leveraging Docker for Root Access

### Checking If You're Running in a Container

[This SO answer][so-23513045] suggests checking `/proc/1/cgroup` to
see if you're at the root for all hierarchies (e.g., `3:cpuset:/`).
However, as per my comment there, newer systemd versions (e.g.,
Debian 9 systemd 232) may have many cgroups set to `/init.scope`.

Heuristic from [so 52081984]":

    grep -o -P -m1 'docker.*\K[0-9a-f]{64,}' /proc/1/cgroup

Simpler but less reliable:

    grep -s -q ':/docker/' /proc/1/cgroup

If you are certain you're in a container you can probably get your
container ID with `basename $(cat /proc/1/cpuset)`.

### Start/Detach/Stop/Restart

    docker run --name CONT -it debian bash -l   # No `--rm` option
    #   ^P^Q to detach.
    docker attach CONT          #   End existing process with ^D
    docker start -a CONT        #   End new process with ^D
    docker rm CONT

### Separate Shell Process in Running Docker Container

    docker exec -it CONTAINER bash -l

* `-i`: Interactive, keep STDIN open even if not attached
* `-t`: Allocate a pseudo-TTY

Processes started with `exec` will start independent process trees in
the container (with the immediate parent a process outside the
container, rather than process 1 in the container), so `ps -ejH` will
show multiple "root" processes and `pstree` will not show all
processes in the container.

### Usage of Docker Volumes

    docker volume create VOL
    docker run -it --rm --mount=type=volume,destination=/mnt,source=MYVOL ubuntu
    docker volume rm VOL

### Docker ps and Filters

See [`format.md`](./format.md).

### Docker Inspect and Templates

See [`format.md`](./format.md).

### Force Intermediate Image Rebuilds

Two methods:
- Use a `COPY` command from a dummy/marker file whose contents you change
  when you want to force a rebuild.
- Use an `ARG` command with a different value for the ARG name (changed
  with the `--build-arg` option). This will always re-use the cached image
  for the `ARG` line itself, but will invalidate cached images for all
  lines following the `ARG` line, even if the argument value isn't used in
  them.

In both cases, changing the value (in the file or of the argument) and then
changing it back will find and re-use the previous version of the image in
the cache if it has not yet been garbage-collected.

See [Image Build § Build Cache](./image.md#build-cache) for more details on
exactly what causes cache invalidation and rebuild.

### Check Image Growth

Building with `docker build --rm=false --no-cache` will keep the
intermediate images; then use `docker diff` to see exactly what files
are added in each layer.

### Cleaning Up Old Images, etc.

`docker system prune`

### Networking MTU Issues

Path MTU discovery by the Docker daemon seems buggy; If your local MTU is
higher than the path MTU you may get mysterious error messages along the
lines of:

    docker: Error response from daemon: error parsing HTTP 408 response body:
    invalid character '<' looking for beginning of value: "<html><body>...

In this case try `sudo ip link set dev wlp3s0 mtu 1400` or similar.

### Setting Proxies for Docker

##### Daemon

The docker daemon does not use variables from `/etc/environment` so it
must be configured directly via its startup files if you want it to
use a proxy. (Remember, the environment variables of a user calling
the `docker` client are irrelevant because that just sends requests to
the daemon to do pulling and pushing of images.)

Summary of [the Docker documenation][daemon-proxy]:

    # mkdir -p /etc/systemd/system/docker.service.d
    # cat > /etc/systemd/system/docker.service.d/http-proxy.conf
    [Service]
    Environment="HTTP_PROXY=http://proxy.example.com:80/"
    ^D
    # systemctl daemon-reload
    # systemctl restart docker
    # systemctl show --property=Environment docker
    Environment=HTTP_PROXY=http://proxy.example.com:80/
    #

[daemon-proxy]: https://docs.docker.com/config/daemon/systemd/#httphttps-proxy

##### Containers

Docker containers do not have access to the localhost addresses on the
host, so if the host wants to supply a proxy to the container without
the rest of the network being able to connect to it it must listen on
a shared address, typically the [default bridge network] address
`172.17.0.1`. Docker ≥17.07 can [configure the client
automatically][client-proxy] via a `~/.docker/config.json` like:

    {
        "proxies": {
            "default": {
                "httpProxy": "http://172.17.0.1:9080",
                "noProxy": "localhost"
            }
        }
    }

[default bridge network]: https://docs.docker.com/network/
[client-proxy]: https://docs.docker.com/network/proxy/

### Curl and the Docker REST API

You can use `curl` to interact with the Docker daemon via the [REST
API], as explained in [Docker Tips: about /var/run/docker.sock][juggery].

For example, to watch container events:

    curl -s -N --unix-socket /var/run/docker.sock http://localhost/events \
      | jq -C -c    # Colorized, compact output format.

If your tools (`curl`, `socat` etc.) for this are old and you don't
have root access on the host, you can bind mount the Docker socket
into a container where you can install newer tools.

### Systemd in Docker

- [Running Systemd Within a Docker Container](https://rhatdan.wordpress.com/2014/04/30/running-systemd-within-a-docker-container/)
- [Docker versus Systemd - Can't we just get along?](https://www.youtube.com/watch?v=93VPog3EKbs#t=18m16)
  (presentation video)

### Docker in Docker

Another Docker daemon can be run within Docker container if you
started it with the `-privleged` flag. But don't do it unless you're
using it to test a different version of Docker. Instead mount
`/var/run/docker.sock` in your docker container to let it create other
containers using the main Docker daemon.

* [Docker Can Now Run within Docker][dind]
* [Using Docker-in-Docker for your CI or testing environment? Think
  twice.][dind-no-ci] Docker-in-Docker is primarily for testing Docker
  itself. It has problems with LSM (AppArmor, SELinux), storage
  drivers (since they have to run on top of a copy-on-write layer) and
  multiple build caches.

[dind-no-ci]: https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
[dind]: https://blog.docker.com/2013/09/docker-can-now-run-within-docker/

### Leveraging Docker for Root Access

See [Docker Security](security.md)



<!-------------------------------------------------------------------->
[REST API]: https://docs.docker.com/engine/api/v1.24/
[juggery]: https://medium.com/lucjuggery/about-var-run-docker-sock-3bfd276e12fd
[so 52081984]: https://stackoverflow.com/a/52081984/107294
[so-23513045]: https://stackoverflow.com/q/23513045/107294
