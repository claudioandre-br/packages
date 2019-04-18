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
