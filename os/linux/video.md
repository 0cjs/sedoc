Video on Linux
==============

- `mplayer` for command-line playback and control
- `vlc` for a graphical interface

Kernel 4.9 appears to create just one `/dev/videoN` device when a
camera or video capture device is plugged in, but 4.19 creates a pair,
e.g., `/dev/video{0,1}`.

`ffplay` (from the ffmpeg package) or `mplayer` (from the mplayer package)
can be used to play back video. But the latter seems to crash fairly often
when playing back from capture devices.

    ffplay -x 1920 -y 1080 /dev/video4
    mplayer tv:// -tv device=/dev/video2    # tv:// can include more opts

### OBS Streaming

To use the virtual camera for output you need the [V4l2loopback] module
started in your kernel, and you probably also want v4l-utils:

    sudo apt install v4l2loopback-dkms v4l-utils
    #   Reboot so new module can take effect.

It does not create a virtual camera by default; `modprobe` with parameters
is used to do this. Set up the virtual camera before starting OBS as it
will otherwise try to use [polkit] to run modprobe to create the device,
and fail to auth (on my system, anyway).

    sudo modprobe v4l2loopback \
        video_nr=9 card_label=Video-Loopback exclusive_caps=1
    v4l2-ctl --list-devices
    #   Created /dev/video4 (which was the next free number)
    #   OBS "Create virtual camera" button now works"; test with:
    ffmpeg /dev/video4



V4l2loopback does not work as video input for Chrome. The response on
[Jitsi issue 5186][j#5186] about Chrome enumeration issues claims that the
following is a workaround, but it didn't work for me using Jitsi or Google
Meet.

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



<!-------------------------------------------------------------------->
[V4l2loopback]: https://wiki.archlinux.org/title/V4l2loopback
[j#5186]: https://github.com/jitsi/jitsi-meet/issues/5186
[polkit]: https://wiki.archlinux.org/title/Polkit
