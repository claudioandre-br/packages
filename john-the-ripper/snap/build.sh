#!/bin/bash

# Required defines
TEST=';full;extra;' # Controls how the test will happen
arch=$(uname -m)
JTR_BIN='../run/john'
JTR_CL='../run/john-opencl'

# Get JtR source code and adjust it to create a SNAP package
git clone --depth 10 https://github.com/magnumripper/JohnTheRipper.git tmp
cp -r tmp/. .
wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/snap/john-the-ripper.opencl
chmod +x john-the-ripper.opencl

# We are in packages folder, change to JtR folder
cd src

if [[ -z "${TEST##*no*}" ]]; then
    echo "====> Packaging:"
    SYSTEM_WIDE='--with-systemwide'
    wget https://raw.githubusercontent.com/claudioandre-br/packages/master/patches/0001-Handle-self-confined-system-wide-build.patch
    patch < 0001-Handle-self-confined-system-wide-build.patch
fi

wget https://raw.githubusercontent.com/claudioandre-br/packages/master/patches/0001-maint-revert-JtR-to-regex-1.4.patch
patch < 0001-maint-revert-JtR-to-regex-1.4.patch

# Set package version
git rev-parse --short HEAD 2>/dev/null > ../../../../My_VERSION.TXT

# Force CFLAGS with -O2
export CFLAGS="-O2 $CFLAGS"

# Show environmen information
wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/show_info.sh
source show_info.sh

echo ""
echo "---------------------------- BUILDING -----------------------------"

if [[ "$arch" == 'x86_64' ]]; then
    # Allow an OpenCL build
    sudo apt-get install -y beignet-dev

    # OpenCL (and OMP fallback)
    ./configure --disable-native-tests $SYSTEM_WIDE --disable-openmp CPPFLAGS="-D_SNAP -D_BOXED" && make -s clean && make -sj4 && mv ../run/john ../run/john-opencl-non-omp
    ./configure --disable-native-tests $SYSTEM_WIDE                 CPPFLAGS="-D_SNAP -D_BOXED -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-opencl-non-omp\\\"\"" && make -s clean && make -sj4 && mv ../run/john ../run/john-opencl

    # CPU (OMP and extensions fallback)
    ./configure --disable-native-tests --disable-opencl $SYSTEM_WIDE --disable-openmp CPPFLAGS="-D_SNAP -D_BOXED" && make -s clean && make -sj4 && mv ../run/john ../run/john-sse2-non-omp
    ./configure --disable-native-tests --disable-opencl $SYSTEM_WIDE                 CPPFLAGS="-D_SNAP -D_BOXED -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-sse2-non-omp\\\"\"" && make -s clean && make -sj4 && mv ../run/john ../run/john-sse2
    ./configure --disable-native-tests --disable-opencl $SYSTEM_WIDE --disable-openmp CPPFLAGS="-D_SNAP -D_BOXED -mavx" && make -s clean && make -sj4 && mv ../run/john ../run/john-avx-non-omp
    ./configure --disable-native-tests --disable-opencl $SYSTEM_WIDE                 CPPFLAGS="-D_SNAP -D_BOXED -mavx -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-avx-non-omp\\\"\" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY=\"\\\"john-sse2\\\"\"" && make -s clean && make -sj4 && mv ../run/john ../run/john-avx
    ./configure --disable-native-tests --disable-opencl $SYSTEM_WIDE --disable-openmp CPPFLAGS="-D_SNAP -D_BOXED -mxop" && make -s clean && make -sj4 && mv ../run/john ../run/john-xop-non-omp
    ./configure --disable-native-tests --disable-opencl $SYSTEM_WIDE                 CPPFLAGS="-D_SNAP -D_BOXED -mxop -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-xop-non-omp\\\"\" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY=\"\\\"john-avx\\\"\"" && make -s clean && make -sj4 && mv ../run/john ../run/john-xop
    ./configure --disable-native-tests --disable-opencl $SYSTEM_WIDE --disable-openmp CPPFLAGS="-D_SNAP -D_BOXED -mavx2" && make -s clean && make -sj4 && mv ../run/john ../run/john-non-omp
    ./configure --disable-native-tests --disable-opencl $SYSTEM_WIDE                 CPPFLAGS="-D_SNAP -D_BOXED -mavx2 -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-non-omp\\\"\" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY=\"\\\"john-xop\\\"\"" && make -s clean && make -sj4

    # Install OpenCL kernel code
    make kernel-copy
else
    # CPU (OMP and extensions fallback)
    ./configure $SYSTEM_WIDE --disable-openmp CPPFLAGS="-D_SNAP -D_BOXED" && make -s clean && make -sj2 && mv ../run/john ../run/john-non-omp
    ./configure $SYSTEM_WIDE                  CPPFLAGS="-D_SNAP -D_BOXED -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-non-omp\\\"\"" && make -s clean && make -sj2

    # Workaround for non X86
    ln -s ../run/john ../run/john-opencl
fi
# To be able to run testing
sudo apt-get install -y language-pack-en

# "---------------------------- TESTING -----------------------------"
# Adjust the testing environment, import and run some testing
wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/disable_formats.sh
source disable_formats.sh

wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/run_tests.sh
source run_tests.sh

wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/clean_package.sh
source clean_package.sh

# Get the script that computes the package version
wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/package_version.sh
chmod +x package_version.sh
