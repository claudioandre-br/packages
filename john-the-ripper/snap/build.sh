#!/bin/bash

report () {
    exit_code=$?
    total=$((total + 1))

    if test $exit_code -eq 0; then
        echo " Ok: $1"
    else
        if [[ "$2" == "FAIL" ]]; then
            echo " Test: ($1) failed, as expected ($exit_code)."
        else
            error=$((error + 1))
            echo " FAILED: $1"
        fi
    fi
}

# Initialization
total=0
error=0

# Testing controls
TEST='yes;full;extra'

git clone --depth 10 https://github.com/magnumripper/JohnTheRipper.git tmp
cp -r tmp/. .
wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/snap/john-the-ripper.opencl
chmod +x john-the-ripper.opencl
cd src

wget https://raw.githubusercontent.com/claudioandre-br/packages/master/patches/0001-Handle-self-confined-system-wide-build.patch

if [[ -z "${TEST##*no*}" ]]; then
    echo "====> Packaging:"
    SYSTEM_WIDE='--with-systemwide'
    patch < 0001-Handle-self-confined-system-wide-build.patch
fi

wget https://raw.githubusercontent.com/claudioandre-br/packages/master/patches/0001-maint-revert-JtR-to-regex-1.4.patch
patch < 0001-maint-revert-JtR-to-regex-1.4.patch

arch=$(uname -m)

# Set package version
git rev-parse --short HEAD 2>/dev/null > ../../../../My_VERSION.TXT

# Force CFLAGS with -O2
export CFLAGS="-O2 $CFLAGS"

# Show env info
echo '--------------------------------'
uname -m; id
echo 'Compiler version'
gcc --version
echo '--------------------------------'
gcc -dM -E -x c /dev/null
echo '--------------------------------'
cat /proc/cpuinfo
echo '--------------------------------'
env
echo '--------------------------------'

# Disable clueless formats
echo '[Disabled:Formats]' >> ../run/john-local.conf
echo '#formatname = Y' >> ../run/john-local.conf
echo ".include '\$JOHN/dynamic_disabled.conf'" >> ../run/john-local.conf

echo 'pbkdf2-hmac-md4 = Y' >> ../run/john-local.conf
echo 'pbkdf2-hmac-md5 = Y' >> ../run/john-local.conf
echo 'OpenBSD-SoftRAID = Y' >> ../run/john-local.conf
echo 'dpapimk = Y' >> ../run/john-local.conf
echo 'mscash2 = Y' >> ../run/john-local.conf
echo 'iwork = Y' >> ../run/john-local.conf
echo 'ethereum = Y' >> ../run/john-local.conf
echo 'dmg = Y' >> ../run/john-local.conf
echo 'adxcrypt = Y' >> ../run/john-local.conf
echo 'encfs = Y' >> ../run/john-local.conf
echo 'gpg = Y' >> ../run/john-local.conf

echo 'raw-BLAKE2 = Y' >> ../run/john-local.conf  #BLAKE2
echo 'argon2 = Y' >> ../run/john-local.conf      #BLAKE2
echo 'tezos = Y' >> ../run/john-local.conf       #BLAKE2

echo 'diskcryptor = Y' >> ../run/john-local.conf #BE
echo 'monero = Y' >> ../run/john-local.conf      #BE
echo 'STRIP = Y' >> ../run/john-local.conf       #BE
echo 'enpass = Y' >> ../run/john-local.conf      #BE

echo 'RACF-KDFAES = Y' >> ../run/john-local.conf #SLOW
echo 'RAR = Y' >> ../run/john-local.conf         #SLOW

echo 'pbkdf2_hmac_md4-opencl = Y' >> ../run/john-local.conf
echo 'pbkdf2_hmac_md5-opencl = Y' >> ../run/john-local.conf
echo 'bf-opencl = Y' >> ../run/john-local.conf
echo 'DES-opencl = Y' >> ../run/john-local.conf
echo 'gpg-opencl = Y' >> ../run/john-local.conf
echo 'krb5pa-md5-opencl = Y' >> ../run/john-local.conf
echo 'mscash2-opencl = Y' >> ../run/john-local.conf
echo 'nt-opencl = Y' >> ../run/john-local.conf
echo 'ntlmv2-opencl = Y' >> ../run/john-local.conf
echo 'o5logon-opencl = Y' >> ../run/john-local.conf
echo 'rawmd5-opencl = Y' >> ../run/john-local.conf
echo 'rawmd4-opencl = Y' >> ../run/john-local.conf
echo 'xsha512-free-opencl = Y' >> ../run/john-local.conf
echo 'mysqlsha1-opencl = Y' >> ../run/john-local.conf
echo 'mscash-opencl = Y' >> ../run/john-local.conf
echo 'sl3-opencl = Y' >> ../run/john-local.conf
echo 'rawsha1-opencl = Y' >> ../run/john-local.conf
echo 'salted_sha-opencl = Y' >> ../run/john-local.conf
echo 'bitlocker-opencl = Y' >> ../run/john-local.conf
echo 'keepass-opencl = Y' >> ../run/john-local.conf

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
    ./configure $SYSTEM_WIDE                 CPPFLAGS="-D_SNAP -D_BOXED -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-non-omp\\\"\"" && make -s clean && make -sj2

    if false; then
        # Rename binaries
        mv ../run/john-non-omp ../run/john-neon-no-omp
        mv ../run/john ../run/john-neon-omp

        # Allow to compare SIMD and non-SIMD builds
        ./configure --disable-native-tests --disable-simd $SYSTEM_WIDE --disable-openmp CPPFLAGS="-D_SNAP -D_BOXED" && make -s clean && make -sj2 && mv ../run/john ../run/john-non-omp
        ./configure --disable-native-tests --disable-simd $SYSTEM_WIDE                 CPPFLAGS="-D_SNAP -D_BOXED -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-non-omp\\\"\"" && make -s clean && make -sj2

        # Rename new binaries
        mv ../run/john-non-omp ../run/john-no-omp
        mv ../run/john ../run/john-omp

        # Test sha256crypt
        ../run/john-no-omp -test -form:sha256crypt -tune=1
        ../run/john-neon-no-omp -test -form:sha256crypt -tune=1

        ../run/john-omp -test -form:sha256crypt -tune=1
        ../run/john-neon-omp -test -form:sha256crypt -tune=1

        # Test sha512crypt
        ../run/john-no-omp -test -form:sha512crypt -tune=1
        ../run/john-neon-no-omp -test -form:sha512crypt -tune=1

        ../run/john-omp -test -form:sha512crypt -tune=1
        ../run/john-neon-omp -test -form:sha512crypt -tune=1

        # Test something else
        ../run/john-no-omp -test -tune=1 -form:pbkdf2-hmac-md5
        ../run/john-neon-no-omp -test -tune=1 -form:pbkdf2-hmac-md5

        ../run/john-omp -test -tune=1 -form:pbkdf2-hmac-md5
        ../run/john-neon-omp -test -tune=1 -form:pbkdf2-hmac-md5

        # Nothing else to do
        ln -s ../run/john-neon-omp ../run/john
        ln -s ../run/john ../run/john-opencl
        exit 0
    fi
    # Workaround for non X86
    ln -s ../run/john ../run/john-opencl
fi
# Remove unused stuff
rm -rf ../run/kerberom
rm -rf ../run/ztex

# Do some testing
sudo apt-get install -y language-pack-en

echo ""
echo "---------------------------- TESTING -----------------------------"
JTR_BIN='../run/john'
"$JTR_BIN" --list=build-info

echo '$NT$066ddfd4ef0e9cd7c256fe77191ef43c' > tests.in
echo '$NT$8846f7eaee8fb117ad06bdd830b7586c' >> tests.in
echo 'df64225ca3472d32342dd1a33e4d7019f01c513ed7ebe85c6af102f6473702d2' >> tests.in
echo '73e6bc8a66b5cead5e333766963b5744c806d1509e9ab3a31b057a418de5c86f' >> tests.in
echo '$6$saltstring$fgNTR89zXnDUV97U5dkWayBBRaB0WIBnu6s4T7T8Tz1SbUyewwiHjho25yWVkph2p18CmUkqXh4aIyjPnxdgl0' >> tests.in

if [[ -z "${TEST##*full*}" ]]; then
    echo "====> T Full:"
    "$JTR_BIN" -test-full=0
    report "-test-full=0"
fi

if [[ -z "${TEST##*extra*}" ]]; then
    echo
    echo "====> regex T1 A: 9 lines"
    "$JTR_BIN" --stdout --regex='[0-2]password[A-C]'
    echo "====> regex T1 B: 2 lines, 1 special character"
    "$JTR_BIN" --stdout --regex=ab[öc]
    echo "====> regex T1 C: 7 lines, 7 special characters, quotation marks"
    "$JTR_BIN" --stdout --regex="ab[£öçüàñẽ]"
    echo "====> regex T1 D: 5 lines, 4 special characters, quotation marks"
    "$JTR_BIN" --stdout --regex='ab(ö|¿|e|¡|!)'
    echo "====> regex T1 E: 2 lines, 1 special character, vertical bar"
    "$JTR_BIN" --stdout --regex='ab(ö|c)'
    echo "====> regex T1 F: 3 lines, 5 special characters, vertical bar"
    "$JTR_BIN" --stdout --regex='ab(ö,¿|\?,e|¡,!)'
    echo "====> regex T2: 2 lines, at the end"
    echo magnum | "$JTR_BIN" -stdout -stdin -regex='\0[01]'
    echo "====> regex T3 A: 2 lines, at the end, encoding"
    echo müller | iconv -f UTF-8 -t cp850 | "$JTR_BIN" -inp=cp850 -stdout -stdin -regex='\0[01]'
    echo "====> regex T3 B: 2 lines, encoding"
    "$JTR_BIN" -stdout --regex='ab(ö|c)' -target-enc=cp437
    echo

    echo "====> T4:"
    "$JTR_BIN" -test-full=0 --format=nt
    report "-test-full=0 --format=nt"
    echo "====> T5:"
    "$JTR_BIN" -test-full=0 --format=sha256crypt
    report "-test-full=0 --format=sha256crypt"
    echo "====> T6.0:"
    "$JTR_BIN" -test=3 -form='dynamic=md5(sha1($s).md5($p))'
    report '-test=3 -form="dynamic=md5(sha1($s).md5($p))"'
    echo "====> T6.1:"
    "$JTR_BIN" -test=3 -form='dynamic=md5(sha1($s.$p).md5($p))'
    report '-test=3 -form="dynamic=md5(sha1($s.$p).md5($p))"'
    echo "====> T6.2:"
    "$JTR_BIN" -test=3 -form='dynamic=md5($p)'
    report '-test=3 -form="dynamic=md5($p)"'
    echo

    echo "====> T10:"
    "$JTR_BIN" tests.in --format=nt --fork=2
    report "tests.in --format=nt --fork=2"
    echo "====> T11:"
    "$JTR_BIN" tests.in --format=raw-sha256 --fork=2
    report "--format=raw-sha256 --fork=2"
    echo "====> T12-a:"
    "$JTR_BIN" tests.in --format=sha512crypt --mask=jo?l[n-q]
    report "--format=sha512crypt --mask=jo?l[n-q]"

    echo "------------------------------------------------------------------"
    "$JTR_BIN" -test=0 --format=sha* --verb=5 --tune=report
    report "--format=sha* --verb=5 --tune=report"
    echo "------------------------------------------------------------------"
    echo

    if [[ "$arch" == 'x86_64' ]]; then
        echo "====> T6:"
        ../run/john-opencl -test-full=0 --format=sha512crypt-opencl
        report "--format=sha512crypt-opencl" "FAIL"
        echo "------------------------------------------------------------------"
        echo
    fi
fi
echo '-------------------------------------------'
echo "###  Performed $total tests in $SECONDS seconds  ###"
echo '-------------------------------------------'

if [[ $error > 0 ]];  then
    echo '----------------------------------------'
    echo "###    Build failed with $error errors    ###"
    echo '----------------------------------------'
    arch=$(uname -m)
    echo "----------------- $arch ------------------"

    exit 1
fi

# Remove the left-over from testing
rm -f ../run/john.log
rm -f ../run/john.pot
