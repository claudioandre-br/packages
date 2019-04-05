#!/bin/bash

#########################################################################
# Get the package version from git
#
#########################################################################

arch=$(uname -m)
text='x'

# It might be outside a git repository. A git describe will not work.
git_tag=$(cat My_VERSION.TXT)

case "$arch" in
    'x86_64')
        text='X'
        ;;
    'aarch64' | 'arm64')
        text='B'
        ;;
    'ppc64le' | 'powerpc64le')
        text='P'
        ;;
    's390x')
        text='S'
        ;;
    'armhf' | 'armv7l')
        text='a'
        ;;
    'i686' | 'i386')
        text='i'
        ;;
    'ppc' | 'powerpc')
        text='w'
        ;;
esac
# View package version
echo "1.9J1-$git_tag$text"
