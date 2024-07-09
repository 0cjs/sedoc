Authy
=====


Desktop App
-----------

While the from-file install still works to install the app itself, as of
2024-07-08 it appears impossible to log in with it; it just shows an
"Attestation token is missing" or "The device does not meet the minimum
integrity requirements" error. (And it looks as if existing installs
may be disabled soon as well.)

### Store Install (no longer available)

The authy snap is no longer in the store, and so can no longer be
downloaded via `snap install authy`. See below for how to deal with this.

    sudo apt-get install snapd
    #sudo snap install authy        # XXX no longer available
    snap run authy

- Login is typically done by confirming through another instance of the
  authy app running on any device.
- After login you will see token names, but still need the backups password
  to decrypt the tokens themselves.

### Install from Another System

On a system on which you've already installed it you can find a copy of the
snap file in `/var/lib/snapd/snaps/authy_23.snap`. Copy that to your new
system. Ideally you'd copy the assertions (`.assert` files?) too, allowing
you to duplicate the store install, but if you can't find them you can
instead: [copy]

    sudo snap install --dangerous authy_23.snap



<!-------------------------------------------------------------------->
[copy]: https://forum.snapcraft.io/t/how-can-i-move-snaps-from-one-pc-to-another-without-redownloading-them-again/10240
