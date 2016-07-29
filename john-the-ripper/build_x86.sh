#!/bin/bash

#snapcraft clean --step build transfer
#snapcraft clean --step build libs
#rm parts/john-the-ripper/build/run/john-*

git clone https://github.com/magnumripper/JohnTheRipper.git tmp
mv tmp/* ./
mv tmp/.git ./
cd src

wget https://raw.githubusercontent.com/claudioandre/packages/master/patches/0001-Handle-self-confined-system-wide-build.patch
wget https://raw.githubusercontent.com/claudioandre/packages/master/patches/Temporary%20-%20disable%20nice
patch < 0001-Handle-self-confined-system-wide-build.patch
patch < Temporary\ -\ disable\ nice

./configure --disable-native-tests --with-systemwide --disable-openmp CPPFLAGS='-D_SNAP' && make -s clean && make -sj2 && mv ../run/john ../run/john-opencl-non-omp       &&
./configure --disable-native-tests --with-systemwide CPPFLAGS='-D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-opencl-non-omp\""' && make -s clean && make -sj2 && mv ../run/john ../run/john-opencl   

./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS='-D_SNAP' && make -s clean && make -sj2 && mv ../run/john ../run/john-sse2-non-omp       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-sse2-non-omp\""' && make -s clean && make -sj2 && mv ../run/john ../run/john-sse2       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-mavx -D_SNAP' --disable-openmp && make -s clean && make -sj2 && mv ../run/john ../run/john-avx-non-omp       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-mavx -D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-avx-non-omp\"" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY="\"john-sse2\""' && make -s clean && make -sj2 && mv ../run/john ../run/john-avx       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-mxop -D_SNAP' --disable-openmp && make -s clean && make -sj2 && mv ../run/john ../run/john-xop-non-omp       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-mxop -D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-xop-non-omp\"" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY="\"john-avx\""' && make -s clean && make -sj2 && mv ../run/john ../run/john-xop       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-mavx2 -D_SNAP' --disable-openmp && make -s clean && make -sj2 && mv ../run/john ../run/john-non-omp       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-mavx2 -D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-non-omp\"" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY="\"john-xop\""' && make -s clean && make -sj2 
