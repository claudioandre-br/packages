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
# Show information about the environment
#
#########################################################################

if [[ -z "$MUTE_SYS_INFO" ]]; then

    if [[ -n "$TRAVIS_COMPILER" ]]; then
        echo -en 'travis_fold:start:build_environment\r'
    fi
    echo 'Build system information'
    echo '--------------------------------'

    uname -m; id
    uname -a
    echo '--------------------------------'
    cat /etc/*-release
    echo '--------------------------------'
    cat /proc/cpuinfo
    echo '--------------------------------'
    env
    echo '--------------------------------'

    if [[ -n "$TRAVIS_COMPILER" ]]; then
        echo -en 'travis_fold:end:build_environment\r'
    fi

    if [[ -n $CCO ]]; then
        TMP_CC="$CCO"
    elif [[ -n "$CC" ]]; then
        TMP_CC="$CC"
    else
        TMP_CC="gcc"
    fi

    if [[ -n "$TRAVIS_COMPILER" ]]; then
        echo -en 'travis_fold:start:compiler_info\r'
    fi
    echo 'Compiler information'
    echo '--------------------------------'

    "$TMP_CC" --version
    echo '--------------------------------'
    "$TMP_CC" -dM -E -x c /dev/null
    echo '--------------------------------'

    if [[ -n "$TRAVIS_COMPILER" ]]; then
        echo -en 'travis_fold:end:compiler_info\r'
    fi
fi

echo '------ Task ------'
echo "Running on: $BASE"
echo "Doing: $TASK_RUNNING"
echo '--------------------------------'

