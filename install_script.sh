#!/usr/bin/env bash

BASEDIR=$(dirname "$BASH_SOURCE")

# arguments
SSID=$1
PASSWD=$2

#connect to the internet
nmcli device wifi connect "$SSID" password "$PASSWD" ifname wlan0

#update and install dependencies and tools we will most likely need -> *DO NOT UPGRADE
apt-get update
apt-get -y install jackd2 python-dev alsa-base alsa-utils libicu-dev libasound2-dev libsamplerate0-dev libsndfile1-dev libreadline-dev libxt-dev libudev-dev libavahi-client-dev libfftw3-dev cmake git gcc-4.8 g++-4.8 libjack-jackd2-dev libsndfile1-dev clang sox python3 python3-setuptools libfann-dev
sudo wget -O /usr/local/bin/gpio.sh http://fordsfords.github.io/gpio_sh/gpio.sh

# configure jack
cp ./system.conf /etc/dbus-1/system.conf
chmod 644 /etc/dbus-1/system.conf
cp ./etc_security_limits.conf /etc/security/limits.conf
groupadd realtime
usermod -a -G realtime root
usermod -a -G realtime chip

#install supercollider
git clone --recursive git://github.com/supercollider/supercollider.git supercollider
cd supercollider
git submodule init
git submodule update
mkdir build
cd build
export CC=/usr/bin/gcc-4.8
export CXX=/usr/bin/g++-4.8
cmake -L -DCMAKE_BUILD_TYPE="Release" -DBUILD_TESTING=OFF -DSUPERNOVA=OFF -DNOVA_SIMD=ON -DNATIVE=OFF -DSC_ED=OFF -DSC_WII=OFF -DSC_IDE=OFF -DSC_QT=OFF -DSC_EL=OFF -DSC_VIM=OFF -DCMAKE_C_FLAGS="-mfloat-abi=hard -mfpu=neon" -DCMAKE_CXX_FLAGS="-mfloat-abi=hard -mfpu=neon" ..
make
make install
ldconfig
cd ../..
sudo mv /usr/local/share/SuperCollider/SCClassLibrary/Common/GUI /usr/local/share/SuperCollider/SCClassLibrary/scide_scqt/GUI
sudo mv /usr/local/share/SuperCollider/SCClassLibrary/JITLib/GUI /usr/local/share/SuperCollider/SCClassLibrary/scide_scqt/JITLibGUI

# OPTIONAL -> install SC3-plugins
git clone --recursive https://github.com/supercollider/sc3-plugins.git
cd sc3-plugins
mkdir build
cd build
export CC=/usr/bin/gcc-4.8
export CXX=/usr/bin/g++-4.8
cmake -DSC_PATH=/home/chip/supercollider ..
make
make install

#install sc-dependencies
mkdir /usr/local/share/SuperCollider/Extensions/
cp -rf /home/chip/sc_dependencies/* /usr/local/share/SuperCollider/Extensions/

# install the custom kernel
cd /
tar -xzf /home/chip/4.4.11w1TH+.tgz
cd /boot
rm zImage
cp vmlinuz-4.4.11w1TH+ zImage

# get and compile the default code-bundle
cd /home/chip
mkdir code
git clone https://github.com/Inhibition-EEG/audio_synthesis.git /home/chip/code/audio
cp -rf /home/chip/code/audio/* /home/chip/Inhibition

git clone https://github.com/Inhibition-EEG/neural_net.git /home/chip/code/neural
cd /home/chip/code/neural
mkdir build
cd build
cmake ..
make
cp -rf Install/* /home/chip/Inhibition

git clone https://github.com/Inhibition-EEG/read_spi /home/chip/code/spi
cd /home/chip/code/spi
mkdir build
cd build
cmake ..
make
cp -rf Install/* /home/chip/Inhibition/

# init script
cp $BASEDIR/run.sh /home/chip/Inhibition/run.sh
chmod 777 /home/chip/Inhibition/run.sh

# rc.local
cp $BASHDIR/rc.local /etc/rc.local
chmod 755 /etc/rc.local

# crontab job
cp $BASHDIR/etc_cron.d_ieeg /etc/cron.d/ieeg

#clean up
cp $BASHDIR/halt /etc/init.d/halt
chmod 755 /etc/init.d/halt
