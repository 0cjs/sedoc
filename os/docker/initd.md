Init Daemons in Docker Containers
=================================

Unless explicitly installed and used, most Docker containers start your
application program as PID 1, rather than an init daemon. This can
cause various issues which are well described in the [dumb-init README].

One easy solution for simpler cases is to use [dumb-init]. This is
available in most Linux distributions (though you'll have to explicitly
request install of it) or, if the distro doesn't have it, as a downloadable
static binary or via PyPI. It will deal with reaping zombie proceses, some
signal issues, and various other things, with options for further
intersting stuff. It's generally best used as container entrypoint,
causing it to be prepended to any command given to `docker run`:

    #   Note: JSON syntax must be used for both of these.
    ENTRYPOINT ["/usr/bin/dumb-init", "--"]
    CMD ["/my/script", "--with", "--args"]      # or
    CMD ["bash", "-c", "pre-start-script && exec my-server"]



<!-------------------------------------------------------------------->
[dumb-init]: https://github.com/Yelp/dumb-init
[dumb-init README]: https://github.com/Yelp/dumb-init/blob/master/README.md
