Linux Sound
===========

Contents:
- Overview
- Source and Sinks
- Hints

#### Overview

Pulseaudio is the usual system; use `pavucontrol` to bring up the mixer,
and `pactl` to make changes at the command-line. (Do not use `pacmd` to
query the system; that's actually a debugging tool.)

[Pulseaudio sits on top of][au 581128] systems like ALSA. ALSA interfaces
directly with the hardware but only one application at a time can use it.
Going through PulseAudio lets multiple applications record and play sound,
via ALSA drivers to hardware, network driver to other PulseAudio servers
or RTP, etc.


Hints
-----

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


Sources and Sinks
-----------------

`pactl list [short] sinks` will list outputs. The short format gives the
sink number, sink name and several other fields separated by multiple
spaces. The sink name or number can be passed to:

    paplay -d NAME
    paplay --device NAME
    mplayer -ao pulse::NUM

The following options to paplay may also be useful:

    --volume=65535      # 0-65535
    --channel-map=mono
    --fix-rate          # convert source rate to native rate for output device
    --fix-channels      # convert source channels to native output channels


<!-------------------------------------------------------------------->
[au 581128]: https://askubuntu.com/q/581128/354600
[flatvol]: https://linuxhint.com/per_application_sound_volume_ubuntu/
