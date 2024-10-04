sudo apt update --allow-releaseinfo-change
sudo apt upgrade --yes -o Dpkg::Options::="--force-confold"


sudo UCF_FORCE_CONFFOLD=1 apt install --yes -o Dpkg::Options::="--force-confold" git cmake g++ libboost-all-dev libgmp-dev swig python3-numpy \
python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 \
liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins \
python3-zmq python3-scipy libpthread-stubs0-dev libusb-1.0-0 libusb-1.0-0-dev \
libudev-dev python3-setuptools build-essential liborc-0.4-0 liborc-0.4-dev \
python3-gi-cairo libeigen3-dev libsndfile1-dev xterm python3-ruamel.yaml ruamel.yaml


cd ~
git config --global user.email "callebaut.gilles@gmail.com"
git config --global user.name "GillesC"

 
git -C ./uhd/ pull || git clone https://github.com/EttusResearch/uhd.git
cd uhd
git checkout UHD-4.7


wget https://raw.githubusercontent.com/techtile-by-dramco/raspberrypi-uhd/refs/heads/master/iface.patch
git apply --stat ./iface.patch
git am --keep-cr --signoff < ./iface.patch


cd ~/uhd/host
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ../ -DENABLE_C_API=O -DENABLE_PYTHON_API=ON -DENABLE_LIBUHD=ON -DENABLE_PYMOD_UTILS=ON -DENABLE_B100=OFF -DENABLE_USRP1=OFF -DENABLE_USRP2=OFF -DENABLE_X300=OFF -DENABLE_N300=OFF  -DENABLE_N320=OFF -DENABLE_E300=OFF -DENABLE_E320=OFF -DENABLE_X400=OFF -DUHD_LOG_MIN_LEVEL=1
make -j6
make test
sudo make -j6 install

# problem is that older versions of UHD are still referred to/used:

# Define the path to libuhd.so

LIBUHD_PATH="/usr/local/lib/libuhd.so"  # Adjust this path if necessary

# Check if the file is a symlink
if [ -L "$LIBUHD_PATH" ]; then
    # Get the target of the symlink
    TARGET=$(readlink "$LIBUHD_PATH")
    
    # Check if the target is libuhd.so.4.7.0
    if [ "$TARGET" = "libuhd.so.4.7.0" ]; then
        echo "$LIBUHD_PATH is a symlink to libuhd.so.4.7.0"
    else
        echo "Error: $LIBUHD_PATH is a symlink, but it points to $TARGET"  >&2
    fi
else
    echo "Error: $LIBUHD_PATH is not a symlink" >&2
fi

LIBUHD_DIR="/usr/local/lib"

# List all files that match libuhd.so.* but exclude libuhd.so.4.7.0
OTHER_VERSIONS=$(ls "$LIBUHD_DIR/libuhd.so."* 2>/dev/null | grep -v "libuhd.so.4.7.0")

if [ -n "$OTHER_VERSIONS" ]; then
    echo "Found other versions of libuhd.so:" >&2
    echo "$OTHER_VERSIONS" >&2
    echo "Consider removing it"
else
    echo "No other versions of libuhd.so found"
fi

# necessary as the new uhd is stored in python3.7 not in python3
sudo cp -a /usr/local/lib/python3.7/site-packages/uhd/. /usr/local/lib/python3/dist-packages/uhd/

sudo ldconfig
sudo uhd_images_downloader
cd ~/uhd/host/utils
sudo cp uhd-usrp.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
