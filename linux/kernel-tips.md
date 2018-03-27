Linux Kernal Configuration Tips
===============================


inotify ENOSPC
--------------

The `inotify` facility in the kernel has a per-user limit on the
number of watches; exceeding this returns ENOSPC "No free space on
device". The default value is usually:

    sysctl sysctl fs.inotify.max_user_watches=8000
    echo 8000 > /proc/sys/fs/inotify/max_user_watches

You can make a temporary change with one of the commands above or a
permanent change with:

    echo fs.inotify.max_user_watches=128000 \
      > /etc/sysctl.d/40-max-user-watches.conf
    sysctl -p

Per [se-13757], a single inotify watch uses about 1 KB of unswappable
kernel memory. Dropbox's sync tool suggests bumping the limit to
100,000, about 0.1 GB of RAM.



[se-13757]: https://unix.stackexchange.com/a/13757/10489
