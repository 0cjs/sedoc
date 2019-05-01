Docker Tips
-----------

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
container ID with `basename $(cat /proc/1/cpuset`.

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

The [`ps`] command offers various [filters][ps-filtering] passed as
`--filter key=value`. See the docs for a full list of keys and their
individual parsing details.

The `name` filter may be a regular expression, but always does a
substring match (`^` and `$` appear not to be supported). To print
a list of GitLab CI cache containers:

    docker ps --format='{{.ID}}' \
      --filter name=runner-[0-9a-f]*-project-[0-9]*-concurrent-[0-9]*-cache-

### Docker Inspect and Templates

`docker inspect` prints Json information about any object (containers,
images, volumes, etc.) The `-f` argument lets you specify a [Go
template] to Docker inspect to query and extract specific parts of the
output. E.g.,:

    $ docker inspect -f 'Tags: {{.RepoTags[0]}}' ubuntu
    Tags: [ubuntu:16.04 ubuntu:latest]

* Directives in `{{ }}` will be substituted; everything else is
  cstring literal (`\t` is a tab, etc.).
* `$` is root context (the whole input)
* `.` is current context (initially `$`);  rebinding:  
  `{{with .Foo}} {{$.TopThing}} {{.UnderFooThing}} {{end}}`

Functions and actions take space-separated args and use parens for
grouping:

    {{len .RepoTags}}
    {{index .RepoTags 0}}
    {{index .Volumes "/var/jenkins_home"}}      # When you can't use `.`
    {{if gt (len .RepoTags) 3}} BIG {{else}} SMALL {{end}}
    {{if false}} N {{else if true}} Y {{else}} ? {{end}}

`--format` can also be used with [`ps`]. Prefix the pattern with the
`table` directive to print headers.

References:
* Go library [Package template][go template]
* [Docker Inspect Template Magic][ditm] blog entry

### Check Image Growth

Building with `docker build --rm=false --no-cache` will keep the
intermediate images; then use `docker diff` to see exactly what files
are added in each layer.

### Cleaning Up Old Images, etc.

`docker system prune`

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
[`ps`]: https://docs.docker.com/engine/reference/commandline/ps/#formatting
[ditm]: https://container-solutions.com/docker-inspect-template-magic/
[go template]: https://golang.org/pkg/text/template/
[juggery]: https://medium.com/lucjuggery/about-var-run-docker-sock-3bfd276e12fd
[ps-filtering]: https://docs.docker.com/engine/reference/commandline/ps/#filtering
[so 52081984]: https://stackoverflow.com/a/52081984/107294
[so-23513045]: https://stackoverflow.com/q/23513045/107294
