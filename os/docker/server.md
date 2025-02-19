Servers, Contexts and Orchestration
===================================

A Docker _host_ is a Docker server process (`dockerd`) that has a
repository of images, stores container and volume configuration, and starts
and manages containers. (Typically a machine will run only one Docker
server.) The host exposes an _endpoint_ to which clients can connect to
initiate images builds (`docker build`), configure and start containers
(`docker run`, `docker compose`), and the like.

Clients such as `docker` command-line client connect to the server's
endpoint via a reliable stream connection, typically via TCP or Unix domain
socket. The default endpoint is `unix:///var/run/docker.sock` (a Unix
domain socket). TCP endpoints are specified as `tcp://[host]:[port][path]`
with a default port of 2375 (TLS off) or 2376 (`--tls` or `--tlsverify`).
File descriptors are specified with `fd://*` and `fd://[socketfd]`. See the
[command line tool documentation][cl] for more details.

The client connects to the endpoint specified by the first of the
following: (see below for more information on _contexts_):
- `-H`/`--host` _url_ or `-c`/`--context` _name_ command-line option.
  (Specifying both is an error.)
- `DOCKER_HOST` environment variable (`unix:…` etc. URL).
- `DOCKER_CONTEXT` environment variable (context name)
- The endpoint of the current context (in `$DOCKER_CONFIG/config.json`).
- In older versions of Docker without context support, the internal default
  (`unix:///var/run/docker.sock` for the Linux command-line client).

__NOTE:__ The [docs][cls] above claim that `DOCKER_CONTEXT` overrides
`DOCKER_HOST`, but at least for 20.10.17 the reverse is true.


Contexts
--------

_Contexts_ contain information about the default endpoints to which to
Docker and Kubernetes clients connect along with their TLS and
authentication information and which orchestrator is being used. One of the
contexts is the _current context,_ used when not overridden by the options
above.

`docker context ls` will list all the contexts with a `*` after the current
context; `docker context use NAME` will change it. The current context name
is stored in `$DOCKER_CONFIG/config.json`; the context configuration files
(excepting context `default`) are stored under `$DOCKER_CONFIG/contexts`.

There is always a context named `default` that has no configuration files
and cannot be reconfigured. (This essentially provides backwards
compatibility with pre-context Docker versions.) Its configuration is:
- Description: "Current DOCKER_HOST based configuration".
- Endpoint: as specified by `DOCKER_HOST` or, if `DOCKER_HOST` is not set,
  the internal default (`unix:///var/run/docker.sock` on Linux).
- Kubernetes endpoint: none.
- Orchestrator: `swarm`.
- __Note:__ `kubectl config use-context` may also change this.

Detailed configuration information can be displayed with `docker context
inspect NAME`; the `--format`/`-f` option is available for output
[formatting]. To get the default endpoint, use:

    docker context inspect default -f '{{.Endpoints.docker.Host}}'

The orchestrations available are `swarm` and `kubernetes`.


Orchestration
-------------

- Single-engine Docker node
- Docker Swarm cluster
- Kubernetes (k8n) cluster



<!-------------------------------------------------------------------->
[cl]: https://docs.docker.com/engine/reference/commandline/cli/
[formatting]: https://docs.docker.com/config/formatting/
