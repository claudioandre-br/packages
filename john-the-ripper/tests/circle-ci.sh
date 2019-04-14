#!/bin/bash -e

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

# Setup testing environment
JTR=../run/john

# Control System Information presentation
if [[ $2 == "TEST" ]]; then
    MUTE_SYS_INFO="Yes"
fi
TASK_RUNNING="$2"
wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/show_info.sh
source show_info.sh

# Build and testing
if [[ $2 == "BUILD" ]]; then

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
    $WINE $JTR --list=build-info

elif [[ $2 == "TEST" ]]; then

    if [[ -n $WINE ]]; then
        do_Copy_Dlls
        export WINEDEBUG=-all
    fi
    # Required defines
    TEST=";$EXTRA;" # Controls how the test will happen
    arch=$(uname -m)
    JTR_BIN="$WINE $JTR"
    JTR_CL=""

    wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/run_tests.sh
    source run_tests.sh
fi

