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


snapcraft clean transfer
snapcraft clean libs
rm -rf stage
rm -rf prime
rm parts/john-the-ripper/state/prime
rm parts/john-the-ripper/state/stage

rm parts/john-the-ripper/build/run/john-*

cd parts/john-the-ripper/build/src
make clean

./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS='-D_SNAP' && make -s clean && make -sj2 && mv ../run/john ../run/john-non-omp       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-non-omp\""' && make -s clean && make -sj2 

cd -
rm -rf parts/john-the-ripper/build/run/kernels


