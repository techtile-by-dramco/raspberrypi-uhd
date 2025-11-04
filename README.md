# Installation guide UHD on RPI 4 & 5 [Update 2025-09-02]

## Update and Upgrade
Update the list of available packages and their versions (it does not install or upgrade any packages).
Execute upgrade installs newer versions of the packages you have. After updating the lists, the package manager knows about available updates for the software you have installed. This is why you first want to update.

```bash
sudo apt update && sudo apt upgrade
```

```bash
sudo apt update --allow-releaseinfo-change
sudo apt upgrade --yes -o Dpkg::Options::="--force-confold"
sudo apt install --yes -o Dpkg::Options::="--force-confold" git cmake build-essential libboost-all-dev libgmp-dev swig python3-numpy \
python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 \
liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins \
python3-zmq python3-scipy libpthread-stubs0-dev libusb-1.0-0 libusb-1.0-0-dev \
libudev-dev python3-setuptools build-essential liborc-0.4-0 liborc-0.4-dev \
python3-gi-cairo libeigen3-dev libsndfile1-dev xterm python3-ruamel.yaml

```

```bash
cd ~
git clone https://github.com/EttusResearch/uhd.git
cd uhd
git checkout UHD-4.9
cd ~/uhd/host
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ../ -DENABLE_C_API=O -DENABLE_PYTHON_API=ON -DENABLE_LIBUHD=ON -DENABLE_PYMOD_UTILS=ON -DENABLE_B100=OFF -DENABLE_USRP1=OFF -DENABLE_USRP2=OFF -DENABLE_X300=OFF -DENABLE_N300=OFF  -DENABLE_N320=OFF -DENABLE_E300=OFF -DENABLE_E320=OFF -DENABLE_X400=OFF -DUHD_LOG_MIN_LEVEL=0 -DPYTHON_EXECUTABLE=$(which python3)
make -j6
make test
sudo make -j6 install
sudo ldconfig
sudo uhd_images_downloader
cd ~/uhd/host/utils
sudo cp uhd-usrp.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
```


## Restart terminal
```bash
uhd_usrp_probe
```

## Search for devices
```bash
uhd_find_devices
```
## Forsee UHD + Python-bindings
```bash
sudo apt install libuhd-dev uhd-host python3-uhd -y

```

## Update image location
```bash
export UHD_IMAGES_DIR=/usr/local/share/uhd/images
```

## Test tx_waveforms script
Copy example script to new folder "examples"
```bash
mkdir ~/examples
cp uhd/host/examples/python/tx_waveforms.py examples

```
❗CHANGE tx_waveform.py (due to problems with the file)❗

```bash
python3 examples/tx_waveforms.py  --args "type=b200" --freq 1e9 --rate 1e6 --duration 10 --channels 0 --wave-freq 0e5 --wave-ampl 0.8 --gain 0

```
<hr style="width:100%;text-align:left;background-color:grey;margin-left:0; border-style: none; height: 5px;">
**Follow the steps up to this point**
<hr style="width:100%;text-align:left;background-color:grey;margin-left:0; border-style: none; height: 5px;">

# Samba

1. Change password "Techtile" and execute following commands
   ```
   curl -sSL https://get.docker.com | sh
   sudo docker run -itd --name samba --restart=unless-stopped -p 139:139 -p 445:445 -v /home/pi:/mount dperson/samba -u "pi;Techtile229" -s "pi;/mount;yes;no;no;pi"
   sudo chmod 755 /home/pi
   sudo chown pi:pi /home/pi
   ```
2. Mount network drive \\IP_ADDRESS\pi and fill in credentials

<hr style="width:100%;text-align:left;background-color:grey;margin-left:0; border-style: none; height: 5px;">




