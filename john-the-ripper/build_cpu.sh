#!/bin/bash

rm parts/john-the-ripper/build/run/john-*

rm parts/john-the-ripper/state/stage
rm parts/john-the-ripper/state/strip

cd parts/john-the-ripper/build/src
make clean

./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS='-D_SNAP' && make -s clean && make -sj2 && mv ../run/john ../run/john-sse2-non-omp       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-sse2-non-omp\""' && make -s clean && make -sj2 && mv ../run/john ../run/john-sse2       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-mavx -D_SNAP' --disable-openmp && make -s clean && make -sj2 && mv ../run/john ../run/john-avx-non-omp       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-mavx -D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-avx-non-omp\"" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY="\"john-sse2\""' && make -s clean && make -sj2 && mv ../run/john ../run/john-avx       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-mxop -D_SNAP' --disable-openmp && make -s clean && make -sj2 && mv ../run/john ../run/john-xop-non-omp       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-mxop -D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-xop-non-omp\"" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY="\"john-avx\""' && make -s clean && make -sj2 && mv ../run/john ../run/john-xop       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-mavx2 -D_SNAP' --disable-openmp && make -s clean && make -sj2 && mv ../run/john ../run/john-non-omp       &&
./configure --disable-native-tests --disable-opencl --with-systemwide CPPFLAGS='-mavx2 -D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-non-omp\"" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY="\"john-xop\""' && make -s clean && make -sj2 

cd -
rm -rf parts/john-the-ripper/build/run/kernels

