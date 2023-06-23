Video on Linux
==============

- `mplayer` for command-line playback and control
- `vlc` for a graphical interface

Kernel 4.9 appears to create just one `/dev/videoN` device when a
camera or video capture device is plugged in, but 4.19 creates a pair,
e.g., `/dev/video{0,1}`.

To have mplayer play directly from a camera or USB video capture card,
use `tv://`. The `-tv` option can be used to specify a specific device
and other parameters if necessary:

    mplayer tv:// -tv device=/dev/video2

### OBS Streaming



    #   Do this before starting OBS as it will otherwise try to use [polkit]
    #   to run modprobe to create the device, and fail to auth on my system.
    sudo modprobe v4l2loopback \
        video_nr=9 card_label=Video-Loopback exclusive_caps=1
    v4l2-ctl --list-devices
    #   Created /dev/video4 (which was the next free number)
    #   OBS "Create virtual camera" button now works"; test with:
    ffmpeg /dev/video4

https://wiki.archlinux.org/title/V4l2loopback


;   V4l2loopback does not work as video input
;   see response about chrome enumeration issues
https://github.com/jitsi/jitsi-meet/issues/5186

> Chromium/Chrome are very particular about enumerating devices for some
> reason. I have been able to get it to work though a somewhat convoluted
> series of steps:

> • Close OBS and Chromium. Make sure nothing's using the main webcam
> • Open Chromium and enter a video conference. Choose the main camera.
> • Now open OBS. Activate the OBS V4L2 sink plugin and stream it to the
>   loopback Over in Chromium, go to device settings. Now the loopback option
>   shows up! Switch to it.
> • Over in OBS, adjust video capture settings away from and then back to
>   the main camera. This "steals" it back from Chromium


[polkit]: https://wiki.archlinux.org/title/Polkit
