RDP (Remote Desktop Protocol)
=============================

Linux uses `xrdp`, which in turn uses `sesman(8)` (part of the xrdp
package) to find or start the session.


Connection/Startup Process
--------------------------

As documented in "a sesman connection" in the [xrdp documents]:

  1. RDP client connects to server, negotiates encryption and
     capabilities. Client chooses screen size and color depth.
  2. Client is presented with window where he selects a module (e.g.
     "sesman-Xvnc") and enters username and pw.
  3. Libvnc.so module is loaded and a TCP connection is made to the IP
     in `xrdp.ini` (usually localhost). All above info is passed to
     sesman which uses pam_userpass to authenticate the user. If ok,
     sesman looks for a running session with same width/height/bpp and
     returns that or starts a new Xvnc with those params.
  4. Linvnc.so connects the the display returns in step 3.

#### Sesman

If `/etc/rdp/sesman.ini` is configured with:

    EnableUserWindowManager=1
    UserWindowManager=startwm.sh

You can create a `~/startwm.sh` file in your home dir (it probably
needs to be executable) with something like the following:

    #!/bin/sh
if [ -r /etc/default/locale ]; then
  . /etc/default/locale
  export LANG LANGUAGE
fi

. /etc/X11/Xsession


Keymaps
-------

See [xrdp-keymap].


Links
-----

(These are visible only in the Markdown source.)

[xrdp documents]: http://xrdp.sourceforge.net/documents/
[xrdp-keymap]: http://xrdp.sourceforge.net/documents/keymap/newkeymap.html
