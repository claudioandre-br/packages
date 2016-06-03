#!/bin/bash

rm -rf snap
rm -rf stage
rm parts/opencl/build/run/john-*

rm parts/opencl/state/stage
rm parts/opencl/state/strip
rm parts/transfer/state/build
rm parts/transfer/state/stage
rm parts/transfer/state/strip
rm -rf parts/transfer/install

cd parts/opencl/build/src
make clean

./configure --disable-native-tests --with-systemwide --disable-openmp CPPFLAGS='-D_SNAP' && make -s clean && make -sj2 && mv ../run/john ../run/john-sse2-non-omp       &&
./configure --disable-native-tests --with-systemwide CPPFLAGS='-D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-sse2-non-omp\""' && make -s clean && make -sj2 && mv ../run/john ../run/john-sse2       &&
./configure --disable-native-tests --with-systemwide CPPFLAGS='-mavx -D_SNAP' --disable-openmp && make -s clean && make -sj2 && mv ../run/john ../run/john-avx-non-omp       &&
./configure --disable-native-tests --with-systemwide CPPFLAGS='-mavx -D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-avx-non-omp\"" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY="\"john-sse2\""' && make -s clean && make -sj2 && mv ../run/john ../run/john-avx       &&
./configure --disable-native-tests --with-systemwide CPPFLAGS='-mxop -D_SNAP' --disable-openmp && make -s clean && make -sj2 && mv ../run/john ../run/john-xop-non-omp       &&
./configure --disable-native-tests --with-systemwide CPPFLAGS='-mxop -D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-xop-non-omp\"" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY="\"john-avx\""' && make -s clean && make -sj2 && mv ../run/john ../run/john-xop       &&
./configure --disable-native-tests --with-systemwide CPPFLAGS='-mavx2 -D_SNAP' --disable-openmp && make -s clean && make -sj2 && mv ../run/john ../run/john-non-omp       &&
./configure --disable-native-tests --with-systemwide CPPFLAGS='-mavx2 -D_SNAP -DOMP_FALLBACK -DOMP_FALLBACK_BINARY="\"john-non-omp\"" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY="\"john-xop\""' && make -s clean && make -sj2 

rm ../run/*.py
rm ../run/*.rb
rm ../run/*.pl

cd -
