#!/bin/bash

git clone https://github.com/sindresorhus/anatine.git tmp
cp -r tmp/. .

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

npm install
nodejs ./node_modules/.bin/electron-packager . --out=dist --ignore='^media$' --platform=linux
cp -r dist/Anatine-linux-x64/. ../install/bin/
