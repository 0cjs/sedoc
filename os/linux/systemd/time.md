systemd timekeeping
===================

To immediately sync the time on your Debian 12 or 13 system to a time
server:

    sudo timedatectl set-ntp false
    sudo timedatectl set-ntp true
    timedatectl status
