Docker Format Strings
=====================

Most commands that produce output can take a `-f FMT`/`--format FMT`
argument where _FMT_ is a [Go template] string. Docker's [Format command
and log output][formatting] page gives a summary of the template commands.

References:
* Go library [Package template][go template]
* [Docker Inspect Template Magic][ditm] blog entry

The fields available in templates are listed in the man pages for the
docker commands, or you can just show all content as JSON:

    docker container ls --format='{{json .}}'

* Directives in `{{ }}` will be substituted; everything else is a cstring
  literal (`\t` is a tab, etc.).
* `$` is root context (the whole input)
* `.` is current context (initially `$`)
  * Rebinding:  `{{with .Foo}} {{$.TopThing}} {{.UnderFooThing}} {{end}}`

Prefix the entire pattern with `table` to produce tabular output with
aligned columns (sized for the widest member) for each tab-separated format
item:

    docker container ls -f 'table: {{{.Names}}\t{{.Image}}\t{{.Status}}'

Functions and actions take space-separated args and use parens for
grouping. E.g., with `docker inspect -f`:

    {{len .RepoTags}}
    {{index .RepoTags 0}}
    {{index .Volumes "/var/jenkins_home"}}      # When you can't use `.`
    {{if gt (len .RepoTags) 3}} BIG {{else}} SMALL {{end}}
    {{if false}} N {{else if true}} Y {{else}} ? {{end}}

### Docker inspect

`docker inspect` prints Json information about any object (containers,
images, volumes, etc.) With `-f` you can query and extract specific parts
of the output. E.g.,:

    $ docker inspect -f 'Tags: {{.RepoTags[0]}}' ubuntu
    Tags: [ubuntu:16.04 ubuntu:latest]

`--format` can also be used with [`ps`]. Prefix the pattern with the
`table` directive to print headers.


Filters
-------

The [`ps`] command offers various [filters][ps-filtering] passed as
`--filter key=value`. See the docs for a full list of keys and their
individual parsing details.

The `name` filter may be a regular expression, but always does a
substring match (`^` and `$` appear not to be supported). To print
a list of GitLab CI cache containers:

    docker ps --format='{{.ID}}' \
      --filter name=runner-[0-9a-f]*-project-[0-9]*-concurrent-[0-9]*-cache-


<!-------------------------------------------------------------------->
[go template]: https://pkg.go.dev/text/template
[formatting]: https://docs.docker.com/config/formatting/
[ditm]: https://container-solutions.com/docker-inspect-template-magic/

[ps-filtering]: https://docs.docker.com/engine/reference/commandline/ps/#filtering
[`ps`]: https://docs.docker.com/engine/reference/commandline/ps/#formatting
