#!/bin/bash

######################################################################
# Copyright (c) 2019 Claudio André <claudioandre.br at gmail.com>
#
# This program comes with ABSOLUTELY NO WARRANTY; express or implied.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, as expressed in version 2, seen at
# http://www.gnu.org/licenses/gpl-2.0.html
######################################################################

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
