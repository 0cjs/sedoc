socat (SOcket CAT)
==================

* [Very brief intro article][lc-socat]
* [Home page][socat-home]
* [Manpage][manpage]


Common Endpoints
----------------

    tcp-listen:<port>   # also tcp-l:<port>
    udp-listen:<port>


Server Examples
---------------

    # One-shot message server
    echo hello | socat -u  stdin  tcp-listen:5555,resuseaddr

    # Prints all data sent by remote
    socat -u  tcp-l:5555,reuseaddr  stdout

    # Multi-connection discard server
    socat -u  tcp-l:5555,reuseaddr,fork  gopen:/dev/null

    # Multi-connection echo server with traffic copied to stdout
    socat -v  tcp-l:5555,reuseaddr,fork  exec:/bin/cat



[lc-socat]: https://www.linux.com/news/socat-general-bidirectional-pipe-handler
[socat-home]: http://www.dest-unreach.org/socat/
[manpage]: http://www.dest-unreach.org/socat/doc/socat.html
