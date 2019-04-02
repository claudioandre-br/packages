#!/bin/bash

# Required defines
TEST=';full;extra;' # Controls how the test will happen
arch=$(uname -m)
JTR_BIN='/app/bin/john'
JTR_CL='/app/bin/john-opencl'

# Show environmen information
source ../show_info.sh

if [[ -z "$TASK" ]]; then
    # Set package version
    git rev-parse --short HEAD 2>/dev/null > My_VERSION.TXT

    # The script that computes the package version
    source ../package_version.sh

    echo ""
    echo "---------------------------- BUILDING -----------------------------"

    if [[ "$arch" == "x86_64" ]]; then
        # CPU (OMP and extensions fallback)
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS="-D_BOXED" && make -s clean && make -sj2 && mv ../run/john ../run/john-sse2-non-omp
        ./configure --disable-native-tests --disable-opencl --with-systemwide                  CPPFLAGS="-D_BOXED -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-sse2-non-omp\\\"\"" && make -s clean && make -sj2 && mv ../run/john ../run/john-sse2
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS="-D_BOXED -mavx" && make -s clean && make -sj2 && mv ../run/john ../run/john-avx-non-omp
        ./configure --disable-native-tests --disable-opencl --with-systemwide                  CPPFLAGS="-D_BOXED -mavx -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-avx-non-omp\\\"\" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY=\"\\\"john-sse2\\\"\"" && make -s clean && make -sj2 && mv ../run/john ../run/john-avx
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS="-D_BOXED -mxop" && make -s clean && make -sj2 && mv ../run/john ../run/john-xop-non-omp
        ./configure --disable-native-tests --disable-opencl --with-systemwide                  CPPFLAGS="-D_BOXED -mxop -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-xop-non-omp\\\"\" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY=\"\\\"john-avx\\\"\"" && make -s clean && make -sj2 && mv ../run/john ../run/john-xop
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS="-D_BOXED -mavx2" && make -s clean && make -sj2 && mv ../run/john ../run/john-non-omp
        ./configure --disable-native-tests --disable-opencl --with-systemwide                  CPPFLAGS="-D_BOXED -mavx2 -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-non-omp\\\"\" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY=\"\\\"john-xop\\\"\"" && make -s clean && make -sj2
    else
        # CPU (OMP and extensions fallback)
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS="-D_BOXED" && make -s clean && make -sj2 && mv ../run/john ../run/john-non-omp
        ./configure --disable-native-tests --disable-opencl --with-systemwide                  CPPFLAGS="-D_BOXED -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-non-omp\\\"\"" && make -s clean && make -sj2
    fi

    # Workaround for non X86 (non-OpenCL)
    if [[ ! -f ../run/john-opencl ]]; then
        ln -s ../run/john ../run/john-opencl
    fi

elif [[ "$TASK" == "test" ]]; then
    # "---------------------------- TESTING -----------------------------"

    # Adjust the testing environment, import and run some testing
    source ../disable_formats.sh

    source ../run_tests.sh
fi
source ../clean_package.sh

echo '=================================='
