#!/bin/bash

#dpkg --add-architecture armhf
#dpkg --print-foreign-architectures
#apt-get update
#apt-get install crossbuild-essential-armhf

# sudo apt-get install ubuntu-dev-tools
#mk-sbuild --arch=armhf xenial
#mk-sbuild --arch=armhf xenial #Duas vezes
#sudo sbuild-shell xenial-armhf

# To CHANGE the golden image: sudo schroot -c source:xenial-armhf -u root
# To ENTER an image snapshot: schroot -c xenial-armhf
#/var/lib/schroot/mount
## ----------------------------------

#snapcraft clean --step build transfer
#snapcraft clean --step build libs
#rm parts/john-the-ripper/build/run/john-*

#cd parts/john-the-ripper/build/src
#git fetch --unshallow

git clone https://github.com/magnumripper/JohnTheRipper.git tmp
cp -r tmp/. .
cd src

wget https://raw.githubusercontent.com/claudioandre/packages/master/patches/0001-Handle-self-confined-system-wide-build.patch
wget https://raw.githubusercontent.com/claudioandre/packages/master/patches/Temporary%20-%20disable%20nice
patch < 0001-Handle-self-confined-system-wide-build.patch
patch < Temporary\ -\ disable\ nice

if [[ "$TEST" = "yes" ]]; then
    ./configure --with-systemwide CPPFLAGS='-D_SNAP' && make -s clean && make -s
    ../run/john --list=build-info
    ../run/john --stdout --regex='[0-2]password[A-C]'
    ../run/john -test-full=0 --format=raw-sha256
    ../run/john -test-full=0 --format=sha512crypt

    exit 0
fi

# CFLAGS is set when regex is build. Harm JtR configure process.
unset CFLAGS

# CPU (OMP and extensions fallback)
./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS='-D_SNAP' && make -s clean && make -sj2 && mv ../run/john ../run/john-non-omp       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-non-omp\""' && make -s clean && make -sj2 
