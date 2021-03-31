# Installation guide UHD on RPI 4

## Raspi-config
- Boot in desktop so we could access remotely with VNC viewer
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

## Set thread-priority
When UHD software spawns a new thread, it may try to boost the thread's scheduling priority. If setting the new priority fails, the UHD software prints a warning to the console, as shown below. This warning is harmless; it simply means that the thread will retain a normal or default scheduling priority.

```
UHD Warning:
    Unable to set the thread priority. Performance may be negatively affected.
    Please see the general application notes in the manual for instructions.
    EnvironmentError: OSError: error in pthread_setschedparam
```
Link: `https://files.ettus.com/manual/page_general.html#general_threading_prio`

Non-privileged users need special permission to change the scheduling priority. Add the following line to the file /etc/security/limits.conf:
```
@GROUP    - rtprio    99
```

Replace GROUP with a group in which your user is a member. You may need to log out and log back into the account for the settings to take effect. In most Linux distributions, a list of groups and group members can be found in the file /etc/group.





