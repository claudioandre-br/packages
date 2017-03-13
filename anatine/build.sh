#!/bin/bash

git clone https://github.com/claudioandre/anatine.git tmp
cp -r tmp/. .

if [[ $1 == "PREPARE" ]]; then
    arch=`uname -m`
    text='x'
    git_tag=$(git describe --dirty=+ --always 2>/dev/null)

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
    sed -i "s/edge/$git_tag+$text/g" ../../../snapcraft.yaml

else
    npm install
    nodejs ./node_modules/.bin/electron-packager . --out=dist --ignore='^media$' --platform=linux --arch="$arch_id"
    cp -r dist/Anatine-linux*/. ../install/bin/
    cp -r static/. ../install/bin/static/
    cp -r locales/*.json ../install/bin/locales/
fi

