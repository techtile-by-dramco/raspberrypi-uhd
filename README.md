# Installation guide UHD on RPI 4

## Raspi-config
- Boot in desktop so we could access remotly with VNC viewer
- Enable VNC in the interface
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

## Install required packages
```bash
sudo apt -y install git swig doxygen build-essential libboost-all-dev libtool libusb-1.0-0 libusb-1.0-0-dev libudev-dev libncurses5-dev libfftw3-bin libfftw3-dev libfftw3-doc libcppunit-1.14-0 libcppunit-dev libcppunit-doc ncurses-bin cpufrequtils python-numpy python-numpy-doc python-numpy-dbg python3-scipy python3-docutils qt4-bin-dbg qt4-default qt4-doc libqt4-dev libqt4-dev-bin python-qt4 python-qt4-dbg python-qt4-dev python-qt4-doc python-qt4-doc libqwt6abi1 libfftw3-bin libfftw3-dev libfftw3-doc ncurses-bin libncurses5 libncurses5-dev libncurses6-dbg libfontconfig1-dev libxrender-dev libpulse-dev swig g++ automake autoconf libtool python3-dev libfftw3-dev libcppunit-dev libboost-all-dev libusb-dev libusb-1.0-0-dev fort77 libsdl1.2-dev python-wxgtk3.0 libqt4-dev python3-numpy ccache python3-opengl libgsl-dev python3-cheetah python3-mako python3-lxml doxygen qt4-default qt4-dev-tools libusb-1.0-0-dev libqwtplot3d-qt5-dev pyqt4-dev-tools python-qwt5-qt4 wget libxi-dev gtk2-engines-pixbuf r-base-dev python3-tk liborc-0.4-0 liborc-0.4-dev libasound2-dev python-gtk2 libzmq3-dev libzmq5 python3-requests python3-sphinx libcomedi-dev python3-zmq libqwt-dev libqwt6abi1 python3-six libgps-dev libgps23 gpsd gpsd-clients python-gps python3-setuptools libboost-all-dev libusb-1.0-0-dev python3-mako python3-docutils cmake build-essential tightvncserver
```

## Build the UHD from source
```bash
git clone https://github.com/EttusResearch/uhd.git

cd ~/uhd/host
mkdir build
cd build
cmake ../
make
make test # This step is optional
sudo make install
```
Make sure that libuhd.so is in your LD_LIBRARY_PATH, or add it to /etc/ld.so.conf and make sure to run:
```bash
sudo echo "usr/local/lib" >> /etc/ld.so.conf
sudo ldconfig
```
required to recognize connecting/disconnecting usb
```bash
cd ~/uhd/host/utils
sudo cp uhd-usrp.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
```

download UHD images
```bash
export UHD_IMAGES_DIR=/usr/share/uhd/images
sudo /usr/local/lib/uhd/utils/uhd_images_downloader.py
```

## Install GNU Radio
```bash
sudo apt install gnuradio
```

## check if uhd device is connected
```bash
uhd_find_devices
```

## config VNC server
```bash
sudo crontab -e
@reboot su - pi -c '/usr/bin/tightvncserver -geometry 1920x1080'
# vncserver -kill :1
```
