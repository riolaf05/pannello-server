### Update Raspbian Stretch to Buster

1. update all the currently installed packages

```console
sudo apt update \
&& sudo apt dist-upgrade -y \
&& sudo rpi-update
```

2. update the Raspberry Pi’s firmware

```console
sudo nano /etc/apt/sources.list
#replace.. deb http://raspbian.raspberrypi.org/raspbian/ stretch main contrib non-free rpi
#with.. deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
```

```console
sudo nano /etc/apt/sources.list.d/raspi.list
#replace.. deb http://archive.raspberrypi.org/debian/ stretch main
#with.. deb http://archive.raspberrypi.org/debian/ buster main
```

3. remove the “apt-listchanges” package (to give us a faster and smoother upgrading process)

```console
sudo apt-get remove apt-listchanges
```

4. update all the packages to their Raspbian Buster versions

```console
sudo apt update && sudo apt dist-upgrade #will need time! 
```

5. get rid of some new applications that will automatically be installed

```console
sudo apt purge timidity lxmusic gnome-disk-utility deluge-gtk evince wicd wicd-gtk clipit usermode gucharmap gnome-system-tools pavucontrol
```

6. ensure we have cleaned up everything leftover from the upgrade

```console
sudo apt autoremove -y && sudo apt autoclean 
sudo reboot 
```

### References 

* [Update Raspbian Stretch to Buster](https://pimylifeup.com/upgrade-raspbian-stretch-to-raspbian-buster/)
