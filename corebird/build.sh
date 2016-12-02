#!/bin/bash

git clone https://github.com/baedert/corebird.git tmp
cp -r tmp/. .

wget https://raw.githubusercontent.com/claudioandre/packages/master/patches/corebird.patch
patch -p1 < corebird.patch

arch=`uname -m`
text='x'
git_tag=$(git describe --dirty=+ --always 2>/dev/null)

case "$arch" in
    'x86_64')
        text='X'
        ;;
    'armhf' | 'armv7l')
        text='a'
        ;;
    'aarch64' | 'arm64')
        text='B'
        ;;
    'ppc64le' | 'powerpc64le')
        text='P'
        ;;
esac
# Set package version
sed -i "s/edge/$git_tag-$text/g" ../../../snapcraft.yaml

# Install vala - requer 
#sudo add-apt-repository ppa:vala-team/ppa -y
#sudo apt-get update
#sudo apt-get install vala -y

dest=$(dirname "$PWD")

./autogen.sh --prefix= --disable-spellcheck
make
make install DESTDIR="$dest/install"
