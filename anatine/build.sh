#!/bin/bash

git clone https://github.com/sindresorhus/anatine.git tmp
cp -r tmp/. .

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
sed -i "s/edge/$git_tag-$text/g" ../../../snapcraft.yaml

npm install
nodejs ./node_modules/.bin/electron-packager . --out=dist --ignore='^media$' --platform=linux --arch=x64
cp -r dist/Anatine-linux-x64/. ../install/bin/
