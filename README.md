# Installation guide UHD on RPI 4

## Raspi-config
- Boot in desktop so we could access remotly with VNC viewer
- Enable VNC in the interface
- Set resolution
- Change the hostname
- Change the password
- Update raspi-config

```bash
sudo raspi-config
```

## Update and Upgrade
Update the list of available packages and their versions (it does not install or upgrade any packages).
Execute upgrade installs newer versions of the packages you have. After updating the lists, the package manager knows about available updates for the software you have installed. This is why you first want to update.

```bash
sudo apt-get update && sudo apt-get upgrade
```

## Build the GNURadio and UHD from source with PyBombs
```bash
sudo apt install python3-pip, xterm
sudo pip3 install pybombs 
pybombs auto-config
pybombs recipes add-defaults
pybombs prefix init ~/gr38 -R gnuradio-default
source ~/gr38/setup_env.sh
gnuradio-companion
```

required to recognize connecting/disconnecting usb
```bash
cd ~/gr38/src/uhd/host/utils
sudo cp uhd-usrp.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
```

## check if uhd device is connected
```bash
uhd_find_devices
```
It could be that the images needs to be downloaded. IF so, run:
```bash
home/pi/gr38/lib/uhd/utils/uhd_images_downloader.py
```

