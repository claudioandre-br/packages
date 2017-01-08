#!/bin/bash

git clone https://github.com/sindresorhus/anatine.git tmp
cp -r tmp/. .

wget https://raw.githubusercontent.com/claudioandre/packages/master/patches/0001-localization-adapt-the-software-to-different-languag.patch

arch=`uname -m`
text='x'
git_tag=$(git describe --dirty=+ --always 2>/dev/null)

# Localization
git am 0001-localization-adapt-the-software-to-different-languag.patch

case "$arch" in
    'x86_64')
        text='X'
        arch_id='x64'
        ;;
    'armhf' | 'armv7l')
        text='a'
        arch_id='armv7l'
        ;;
    'aarch64' | 'arm64')
        text='B'
        arch_id='unsupported'
        ;;
    'ppc64le' | 'powerpc64le')
        text='P'
        arch_id='unsupported'
        ;;
esac
# Set package version
sed -i "s/edge/$git_tag-$text+/g" ../../../snapcraft.yaml

npm install
nodejs ./node_modules/.bin/electron-packager . --out=dist --ignore='^media$' --platform=linux --arch="$arch_id"
cp -r dist/Anatine-linux*/. ../install/bin/
cp -r static/. ../install/bin/static/
cp -r locales/*.json ../install/bin/locales/

