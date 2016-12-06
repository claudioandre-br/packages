#!/bin/bash

git clone https://github.com/magnumripper/johnTheRipper.git tmp
cd tmp/src
proj='../../john'

wget https://raw.githubusercontent.com/claudioandre/packages/master/patches/0001-Handle-self-confined-system-wide-build.patch
patch < 0001-Handle-self-confined-system-wide-build.patch

arch=`uname -m`
text='x'
git_tag=$(git describe --dirty=+ --always 2>/dev/null)

case "$arch" in
    'x86_64')
        text='J1'
        ;;
    'armhf' | 'armv7l')
        text='a1'
        ;;
    'aarch64' | 'arm64')
        text='B1'
        ;;
    'ppc64le' | 'powerpc64le')
        text='P1'
        ;;
esac
# Set package version
sed -i "s/edge/1.8-$text-$git_tag/g" "$proj"/metadata

echo ""
echo "---------------------------- BUILDING -----------------------------"

if [[ "$arch" == 'x86_64' ]]; then
    # CPU (OMP and extensions fallback)
    flatpak build --env=CPPFLAGS="-D_BOXED" "$proj" \
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp
    flatpak build "$proj" make -s clean
    flatpak build "$proj" make -sj4 && mv ../run/john ../run/john-sse2-non-omp

    flatpak build --env=CPPFLAGS="-D_BOXED -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-sse2-non-omp\\\"\"" "$proj" \
       ./configure --disable-native-tests --disable-opencl --with-systemwide
    flatpak build "$proj" make -s clean
    flatpak build "$proj" make -sj4 && mv ../run/john ../run/john-sse2

    flatpak build --env=CPPFLAGS="-D_BOXED -mavx" "$proj" \
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp
    flatpak build "$proj" make -s clean
    flatpak build "$proj" make -sj4 && mv ../run/john ../run/john-avx-non-omp

    flatpak build --env=CPPFLAGS="-D_BOXED -mavx -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-avx-non-omp\\\"\" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY=\"\\\"john-sse2\\\"\"" "$proj" \
        ./configure --disable-native-tests --disable-opencl --with-systemwide
    flatpak build "$proj" make -s clean
    flatpak build "$proj" make -sj4 && mv ../run/john ../run/john-avx

    flatpak build --env=CPPFLAGS="-D_BOXED -mxop" "$proj"\
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp
    flatpak build "$proj" make -s clean
    flatpak build "$proj" make -sj4 && mv ../run/john ../run/john-xop-non-omp

    flatpak build --env=CPPFLAGS="-D_BOXED -mxop -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-xop-non-omp\\\"\" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY=\"\\\"john-avx\\\"\"" "$proj" \
        ./configure --disable-native-tests --disable-opencl --with-systemwide
    flatpak build "$proj" make -s clean
    flatpak build "$proj" make -sj4 && mv ../run/john ../run/john-xop

    flatpak build --env=CPPFLAGS="-D_BOXED -mavx2" "$proj" \
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp
    flatpak build "$proj" make -s clean
    flatpak build "$proj" make -sj4 && mv ../run/john ../run/john-non-omp

    flatpak build --env=CPPFLAGS="-D_BOXED -mavx2 -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-non-omp\\\"\" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY=\"\\\"john-xop\\\"\"" "$proj" \
        ./configure --disable-native-tests --disable-opencl --with-systemwide
    flatpak build "$proj" make -s clean
    flatpak build "$proj" make -sj4
else
    # CPU (OMP and extensions fallback)
    flatpak build --env=CPPFLAGS="-D_BOXED" "$proj" \
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp
    flatpak build "$proj" make -s clean
    flatpak build "$proj" make -sj2 && mv ../run/john ../run/john-non-omp

    flatpak build --env=CPPFLAGS="-D_BOXED -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-non-omp\\\"\"" "$proj" \
        ./configure --disable-native-tests --disable-opencl --with-systemwide
    flatpak build "$proj" make -s clean
    flatpak build "$proj" make -sj2
fi

# Move files to the right folder
rm -rf "$proj"/files/bin
mkdir -p "$proj"/files/bin
cp -r ../run/. "$proj"/files/bin

# Do some testing
TEST=yes #always

if [[ "$TEST" == "yes" ]]; then
    echo ""
    echo "---------------------------- TESTING -----------------------------"
    flatpak build "$proj" ../run/john --list=build-info
    #echo "====> T1:"
    #flatpak build "$proj" ../run/john --stdout --regex='[0-2]password[A-C]'
    #echo "====> T2:"
    #echo magnum | flatpak build "$proj" ../run/john -stdout -stdin -regex='\0[01]'
    #echo "====> T3:"
    #echo müller | iconv -f UTF-8 -t cp850 | flatpak build "$proj" ../run/john -inp=cp850 -stdout -stdin -regex='\0[01]'
    echo "====> T4:"
    flatpak build "$proj" ../run/john -test-full=0 --format=nt
    echo "====> T5:"
    flatpak build "$proj" ../run/john -test-full=0 --format=raw-sha256
    #echo "====> T6:"
    #flatpak build "$proj" ../run/john-opencl -test-full=0 --format=sha512crypt-opencl
    echo "------------------------------------------------------------------"
    echo ""
fi
