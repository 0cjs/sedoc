ez Share WiFi SD Card Adapter
=============================

This comes in various versions; some have on-board RAM and some take a
micro SD card. (The latter do not have a switch to disable WiFi, so
constantly suck power.)

In all cases they set up their own WiFi access point. (They cannot
connect to other APs.) The default config is SSID `ez Share`, key
`88888888`, and webadmin password `admin`; these can all be changed in
the web admin interface. These settings are stored internally; they
are reset by removing the always-empty `ezshare.cfg` file from the
card and power-cycling it.

The OID prefix is `f4:55:95`; this and other settings cannot be changed.

The [manuals] give details of using their Android/iPhone apps or doing
a direct connect from a PC for their web interface. The apps
apparently offer some sort of auto-upload functionality to transfer
pictures as soon as they're taken.


Network Configuration
---------------------

None of the following is reconfigurable. The server's MAC prefix is
`f4:55:95` and it configures on `192.168.4.1/24`, running the
following services:

    53/udp  DNS     Returns 192.168.4.1 for all queries
    67/udp  DHCP
    80/tcp  HTTP

The web server sometimes returns URLs to host `192.168.4.1`, but
in other cases to `ezshare.card`. You don't want to use its nameserver
(unless you're not connected to the Internet when using the card);
the easiest way to handle this is to add it to `/etc/hosts`:

    #   ez Share SD card WiFi server returns URLs with this host.
    192.168.4.1    ezshare.card

#### Linux USB WiFi Issues

Modern Linux systems often assign names such as `wlx000f007b77b3` to
USB WiFi interfaces, causing NetworkManager to be unable to connect to
the AP. [`linux/network`](../linux/network.md) in this repo discusses
ways of dealing with that and has further links.


URLs
----

As well as the human-oriented interface that finds pictures on the card,
the web server offers an interface directly to the filesystem on the
card using URLs like the following:

    http://ezshare.card/dir?dir=A:
    http://ezshare.card/download?file=EZSHARE.CFG
    http://192.168.4.1/download?file=DCIM%5C101_PANA%5CP1010110.JPG

The `%5C` in the paths above is an ASCII `\`.



<!-------------------------------------------------------------------->
[manuals]: https://awesome.nwgat.ninja/ezshare/

