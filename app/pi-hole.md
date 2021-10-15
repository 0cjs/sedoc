Pi-hole: Ad-blocking DNS/DHCP Server
====================================

There is a [standard version][ph-gh] and a [Dockerised version][phd-gh].
[GitHub repo][phd-gh].

The Dockerised version uses only a single container, but the repo provides
both a [`docker-compose.yml` file][ex-compose] and the [`docker run`
command][ex-run] to do the same thing, though the run command is missing
some useful options, including the capability setting needed for DHCP. (The
image itself comes from  Docker Hub: `pihole/pihole:latest`)

The Dockerized version is designed to run from a $PIHOLE_BASE directory
containing configuration (automatically set up on first run?) and logs;
this is implicitly the directory with `docker-compose.yml` when using
compose.



<!-------------------------------------------------------------------->
[ex-compose]: https://github.com/pi-hole/docker-pi-hole/blob/master/docker-compose.yml.example
[ex-run]: https://github.com/pi-hole/docker-pi-hole/blob/master/docker_run.sh
[ph-gh]: https://github.com/pi-hole/pi-hole
[phd-gh]: https://github.com/pi-hole/docker-pi-hole
