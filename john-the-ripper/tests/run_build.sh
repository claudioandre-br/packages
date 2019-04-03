#!/bin/bash

#########################################################################
# Runs a build and change the file name
#
#########################################################################

function do_build () {
    set -e

    if [[ -n "$1" ]]; then
        make -s clean && make -sj4 && mv ../run/john "$1"
    else
        make -s clean && make -sj4
    fi
    set +e
}
