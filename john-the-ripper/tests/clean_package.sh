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
# Remove unnecessary artifacts
#
#########################################################################

# Remove the left-over from testing
rm -f ../run/john.log
rm -f ../run/john.pot
rm -f ../run/john-local.conf

# Remove unused stuff
rm -rf ../run/ztex
