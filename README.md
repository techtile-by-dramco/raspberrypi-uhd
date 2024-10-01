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

```bash
sudo apt update --allow-releaseinfo-change
sudo apt upgrade --yes -o Dpkg::Options::="--force-confold"
sudo apt install --yes -o Dpkg::Options::="--force-confold" git cmake g++ libboost-all-dev libgmp-dev swig python3-numpy \
python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 \
liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins \
python3-zmq python3-scipy libpthread-stubs0-dev libusb-1.0-0 libusb-1.0-0-dev \
libudev-dev python3-setuptools build-essential liborc-0.4-0 liborc-0.4-dev \
python3-gi-cairo libeigen3-dev libsndfile1-dev xterm python3-ruamel.yaml ruamel.yaml

```

```bash
cd ~

git config --global user.email "callebaut.gilles@gmail.com"
git config --global user.name "GillesC"

git -C ./uhd/ pull || git clone https://github.com/EttusResearch/uhd.git
cd uhd
git checkout UHD-4.7


wget https://raw.githubusercontent.com/techtile-by-dramco/raspberrypi-uhd/refs/heads/master/iface.patch
git apply --stat ./iface.patch
git am < ./iface.patch

cd ~/uhd/host
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ../ -DENABLE_C_API=O -DENABLE_PYTHON_API=ON -DENABLE_LIBUHD=ON -DENABLE_PYMOD_UTILS=ON -DENABLE_B100=OFF -DENABLE_USRP1=OFF -DENABLE_USRP2=OFF -DENABLE_X300=OFF -DENABLE_N300=OFF  -DENABLE_N320=OFF -DENABLE_E300=OFF -DENABLE_E320=OFF -DENABLE_X400=OFF -DUHD_LOG_MIN_LEVEL=1
make -j6
make test
sudo make install


sudo ldconfig
sudo uhd_images_downloader
cd ~/uhd/host/utils
sudo cp uhd-usrp.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
```


# restart terminal
```bash
uhd_usrp_probe
```



```bash
cd
git clone --recursive https://github.com/gnuradio/volk.git
cd volk
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../
make -j6
make test
sudo make install
sudo ldconfig

```bash
python3 -m pip install pytest numpy scipy
git clone https://github.com/pybind/pybind11.git
cd pybind11
cmake -DDOWNLOAD_CATCH=1
mkdir build
cd build
cmake ..
sudo make install
cd ..
```


```bash
cd
git clone https://github.com/gnuradio/gnuradio.git
cd gnuradio
git checkout maint-3.9
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../
make -j6
make test
sudo make install
sudo ldconfig
```



# add to $HOME/.bashrc (only for CLI):
```bash
export LD_LIBRARY_PATH=/usr/local/lib
export PYTHONPATH=/usr/local/lib/python3/dist-packages

source ~/.bashrc
```



# OLD way

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





