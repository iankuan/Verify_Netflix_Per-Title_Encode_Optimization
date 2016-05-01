#!/bin/bash

cd ~
wget https://bitbucket.org/multicoreware/x265/downloads/x265_1.9.tar.gz
tar zxvf x265_1.9.tar.gz
cd x265_1.9/build/linux/
apt-get install cmake cmake-curses-gui
sudo bash make-Makefiles.bash
sudo make install
sudo ldconfig
