Linux Sensors
=============

    #   Reported as °C * 1000
    cat /sys/class/thermal/theremal_zone*/emp

    apt-get install lm-sensors
    sudo sensors-detect
    sensors

See [se-15832] for much more.



[se-15832]: https://askubuntu.com/q/15832/354600
