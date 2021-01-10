Linux Sound
===========

Pulseaudio is the usual system; use `pavucontrol` to bring up the mixer,
and `pactl` to make changes at the command-line.

### Disabling Flat Volume

PulseAudio [defaults to "flat volume,"][flatvol], where overall volume
system is increased in sync with increases in the level of the loudest
application, indirectly increasing the levels of other apps. Turn this off
by adding `flat-volumes = no` to `~/.pulse/daemon.conf` and then restarting
the daemon with `pulseaudio -k`. (This default may have been changed by
Debian 10.)

### pactl

`pavucontrol` allows app volume boosts only up to 150%. To boost further
(for apps w/very low output level):

    pactl list sink-inputs              # find input ID, e.g., `Sink Input #9`
    pactl set-sink-input-volume 9 175%  # persistent setting



<!-------------------------------------------------------------------->
[flatvol]: https://linuxhint.com/per_application_sound_volume_ubuntu/
