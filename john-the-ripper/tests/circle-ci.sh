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
    else
        echo
        echo '-- Error: invalid BASE code --'
        exit 1
    fi
    echo '-- Done --'
}

function do_Show_Compiler(){

    if [[ ! -z $CC ]]; then
        echo
        echo '-- Compiler in use --'
        $CC --version
    fi
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

    if [[ $ARCH == "x86_64" ]]; then
        cp "$basepath/libgcc_s_seh-1.dll" ../run
    fi

    if [[ $ARCH == "i686" ]]; then
        cp "$basepath/libgcc_s_sjlj-1.dll" ../run
    fi

#      xcopy C:\$msys\$mingw\bin\libeay32.dll ..\run\
#      xcopy C:\$msys\$mingw\bin\ssleay32.dll ..\run\
#      if ($arch -eq "i686") {
#        xcopy C:\$msys\$mingw\bin\libgcc_s_dw2-1.dll ..\run\
#      }
    echo '-- Done --'
}

# ----------- BUILD -----------
cd /cwd/src

# Show some environment info
echo
echo '-- Environment --'
echo "Running on: $BASE"
echo "Doing: $1"
id
env

ARCH=$1

do_Install_Dependencies
do_Show_Compiler
do_Copy_Dlls
export WINEDEBUG=-all

if [[ $ARCH == "i686" ]]; then
    ./configure --host=i686-w64-mingw32 --build=i686-redhat-linux-gnu --target=i686-w64-mingw32
fi

if [[ $ARCH == "x86_64" ]]; then
    ./configure --host=x86_64-w64-mingw32 --build=x86_64-redhat-linux-gnu --target=x86_64-w64-mingw64
fi
# Build
make -sj2
mv ../run/john ../run/john.exe
rm -rf kernels ztex

echo
echo '-- Build Info --'
wine ../run/john.exe --list=build-info

echo
echo '-- Test Full --'
wine ../run/john.exe --test-full=0

