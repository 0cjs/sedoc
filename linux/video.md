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
