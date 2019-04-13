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

    basepath="/usr/$TARGET_ARCH-w64-mingw32/sys-root/mingw/bin"

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

JTR_BIN=../run/john
export OMP_NUM_THREADS=3

if [[ $# -eq 1 ]]; then
    # Show some environment info
    echo
    echo '-- Environment --'
    echo "Running on: $BASE"
    echo "Doing: $1"

    wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/show_info.sh
    source show_info.sh

    if [[ -n $WINE ]]; then
        do_Copy_Dlls
        export WINEDEBUG=-all
    fi

    if [[ $TARGET_ARCH == "x86_64" ]]; then
        ./configure --host=x86_64-w64-mingw32 --build=x86_64-redhat-linux-gnu --target=x86_64-w64-mingw64 CPPFLAGS="-g -gdwarf-2"
    fi

    if [[ $TARGET_ARCH == *"NIX"* || $TARGET_ARCH == *"ARM"* ]]; then
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
    # Required defines
    TEST=";$EXTRA;extra;" # Controls how the test will happen
    arch=$(uname -m)
    JTR_BIN="$WINE $JtR"
    JTR_CL=""

    wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/run_tests.sh
    source run_tests.sh
fi

