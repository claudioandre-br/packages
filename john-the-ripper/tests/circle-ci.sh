#!/bin/bash -e

function do_Install_Dependencies(){
    echo
    echo '-- Installing Dependencies --'

    if [[ $BASE == "fedora" ]]; then
        dnf -y -q upgrade

        # Testing dependencies
        dnf -y -q install mingw32-gcc mingw64-gcc mingw32-gcc-c++ mingw64-gcc-c++ mingw32-libgomp mingw64-libgomp \
                          mingw32-openssl mingw64-openssl mingw32-gmp mingw64-gmp mingw32-bzip2 mingw64-bzip2 \
                          @development-tools wine

    elif [[ $BASE == "OSX" ]]; then
        brew install --force openssl

    else
        echo
        echo '-- Error: invalid BASE code --'
        exit 1
    fi
    echo '-- Done --'
}

function do_Copy_Dlls(){
    echo
    echo '-- Copying Dlls --'

    basepath="/usr/$ARCH-w64-mingw32/sys-root/mingw/bin"

    cp "$basepath/libgomp-1.dll" ../run
    cp "$basepath/libgmp-10.dll" ../run
    cp "$basepath/libbz2-1.dll" ../run
    cp "$basepath/libwinpthread-1.dll" ../run
    cp "$basepath/zlib1.dll" ../run
    cp "$basepath/libcrypto-10.dll" ../run
    cp "$basepath/libssl-10.dll" ../run
    cp "$basepath/libgcc_s_seh-1.dll" ../run
    echo '-- Done --'
}

# ----------- BUILD -----------
cd src
ARCH=$1
JTR_BIN=../run/john
export OMP_NUM_THREADS=3

if [[ $# -eq 1 ]]; then
    # Show some environment info
    echo
    echo '-- Environment --'
    echo "Running on: $BASE"
    echo "Doing: $1"

    source ../show_info.sh

    if [[ -n $WINE ]]; then
        do_Copy_Dlls
        export WINEDEBUG=-all
    fi

    if [[ $ARCH == "x86_64" ]]; then
        ./configure --host=x86_64-w64-mingw32 --build=x86_64-redhat-linux-gnu --target=x86_64-w64-mingw64 CPPFLAGS="-g -gdwarf-2"
    fi

    if [[ $ARCH == *"NIX"* || $ARCH == *"ARM"* || $ARCH == *"OSX"* ]]; then
        ./configure --enable-werror $ASAN $BUILD_OPTS
    fi

    # Build
    make -sj4

    echo
    echo '-- Build Info --'
    $WINE $JTR_BIN --list=build-info
fi

if [[ $2 == "TEST" ]]; then

    if [[ -n $WINE ]]; then
        do_Copy_Dlls
        export WINEDEBUG=-all
    fi

    echo '-- Build Info --'
    $WINE $JTR_BIN --list=build-info

    if [[ $EXTRA == "CHECK" ]]; then
        echo "--------------------------- make check ---------------------------"
        make check
    elif [[ $EXTRA == "AFL_FUZZ" ]]; then
        echo "------------------------- fuzzing check --------------------------"
        echo "$ afl-fuzz -i in -o out JtR @@ "
        export LWS=8
        export GWS=64

        # Check if all formats passes self-test
        "$JTR_BIN" -test-full=0 --format=raw-sha256-opencl
        "$JTR_BIN" -test-full=0 --format=raw-sha512-opencl
        "$JTR_BIN" -test-full=0 --format=xsha512-opencl
        "$JTR_BIN" -test-full=0 --format=sha256crypt-opencl
        "$JTR_BIN" -test-full=0 --format=sha512crypt-opencl

        mkdir -p in
        export AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1
        export AFL_NO_UI=1
        #echo core >/proc/sys/kernel/core_pattern

        "$JTR_BIN" -form:raw-sha256  --list=format-tests 2> /dev/null | cut -f3 | sed -n '11p' 1> in/test_hash1
        "$JTR_BIN" -form:raw-sha256  --list=format-tests 2> /dev/null | cut -f3 | sed -n '2p'  1> in/test_hash2
        "$JTR_BIN" -form:raw-sha512  --list=format-tests 2> /dev/null | cut -f3 | sed -n '2p'  1> in/test_hash3
        "$JTR_BIN" -form:Xsha512     --list=format-tests 2> /dev/null | cut -f3 | sed -n '2p'  1> in/test_hash4
        "$JTR_BIN" -form:sha256crypt --list=format-tests 2> /dev/null | cut -f3 | sed -n '3p'  1> in/test_hash5
        "$JTR_BIN" -form:sha512crypt --list=format-tests 2> /dev/null | cut -f3 | sed -n '3p'  1> in/test_hash6
        afl-fuzz -m none -t 500+ -i in -o out -d "$JTR_BIN" --format=opencl --nolog --verb=1 @@
        echo $?
    else
        echo "---------------------------- TESTING -----------------------------"
        echo '$NT$066ddfd4ef0e9cd7c256fe77191ef43c' > tests.in
        echo '$NT$8846f7eaee8fb117ad06bdd830b7586c' >> tests.in
        echo 'df64225ca3472d32342dd1a33e4d7019f01c513ed7ebe85c6af102f6473702d2' >> tests.in
        echo '73e6bc8a66b5cead5e333766963b5744c806d1509e9ab3a31b057a418de5c86f' >> tests.in
        echo '$6$saltstring$fgNTR89zXnDUV97U5dkWayBBRaB0WIBnu6s4T7T8Tz1SbUyewwiHjho25yWVkph2p18CmUkqXh4aIyjPnxdgl0' >> tests.in

        echo "====> T10:"
        $WINE $JTR_BIN tests.in --format=nt
        echo "====> T11:"
        $WINE $JTR_BIN tests.in --format=raw-sha256
        echo "====> T12:"
        $WINE $JTR_BIN tests.in --format=sha512crypt --mask=jo?l[n-q]

        echo
        echo '-- Test Full --'
        $WINE $JTR_BIN --test-full=0
    fi
fi

