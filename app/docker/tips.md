Docker Tips
-----------

### Checking If You're Running in a Container

[This SO answer][so-23513045] suggests checking `/proc/1/cgroup` to
see if you're at the root for all hierarchies (e.g., `3:cpuset:/`).
However, as per my comment there, newer systemd versions (e.g.,
Debian 9 systemd 232) may have many cgroups set to `/init.scope`.
The most reliable heurstic I can think of at the moment is:

    grep -s -q ':/docker/' /proc/1/cgroup

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

### Usage of Docker Volumes

    docker volume create VOL
    docker run -it --rm --mount=type=volume,destination=/mnt,source=MYVOL ubuntu
    docker volume rm VOL

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

### Leveraging Docker for Root Access

See [Docker Security](security.md)


[`ps`]: https://docs.docker.com/engine/reference/commandline/ps/#formatting
[ditm]: https://container-solutions.com/docker-inspect-template-magic/
[go template]: https://golang.org/pkg/text/template/
[so-23513045]: https://stackoverflow.com/q/23513045/107294
