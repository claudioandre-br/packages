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
# Disable all problematic formats, so they don't disturb testing
#
#########################################################################

# Disable clueless formats
echo '[Disabled:Formats]' >> ../run/john-local.conf
echo '#formatname = Y' >> ../run/john-local.conf
echo ".include '\$JOHN/dynamic_disabled.conf'" >> ../run/john-local.conf

echo 'pbkdf2-hmac-md4 = Y' >> ../run/john-local.conf
echo 'pbkdf2-hmac-md5 = Y' >> ../run/john-local.conf
echo 'OpenBSD-SoftRAID = Y' >> ../run/john-local.conf
echo 'dpapimk = Y' >> ../run/john-local.conf
echo 'mscash2 = Y' >> ../run/john-local.conf
echo 'iwork = Y' >> ../run/john-local.conf
echo 'ethereum = Y' >> ../run/john-local.conf
echo 'dmg = Y' >> ../run/john-local.conf
echo 'adxcrypt = Y' >> ../run/john-local.conf
echo 'encfs = Y' >> ../run/john-local.conf
echo 'gpg = Y' >> ../run/john-local.conf

echo 'raw-BLAKE2 = Y' >> ../run/john-local.conf  #BLAKE2
echo 'argon2 = Y' >> ../run/john-local.conf      #BLAKE2
echo 'tezos = Y' >> ../run/john-local.conf       #BLAKE2

echo 'diskcryptor = Y' >> ../run/john-local.conf #BE
echo 'monero = Y' >> ../run/john-local.conf      #BE
echo 'STRIP = Y' >> ../run/john-local.conf       #BE
echo 'enpass = Y' >> ../run/john-local.conf      #BE

echo 'RACF-KDFAES = Y' >> ../run/john-local.conf #SLOW
echo 'RAR = Y' >> ../run/john-local.conf         #SLOW

echo 'pbkdf2_hmac_md4-opencl = Y' >> ../run/john-local.conf
echo 'pbkdf2_hmac_md5-opencl = Y' >> ../run/john-local.conf
echo 'bf-opencl = Y' >> ../run/john-local.conf
echo 'DES-opencl = Y' >> ../run/john-local.conf
echo 'gpg-opencl = Y' >> ../run/john-local.conf
echo 'krb5pa-md5-opencl = Y' >> ../run/john-local.conf
echo 'mscash2-opencl = Y' >> ../run/john-local.conf
echo 'nt-opencl = Y' >> ../run/john-local.conf
echo 'ntlmv2-opencl = Y' >> ../run/john-local.conf
echo 'o5logon-opencl = Y' >> ../run/john-local.conf
echo 'rawmd5-opencl = Y' >> ../run/john-local.conf
echo 'rawmd4-opencl = Y' >> ../run/john-local.conf
echo 'xsha512-free-opencl = Y' >> ../run/john-local.conf
echo 'mysqlsha1-opencl = Y' >> ../run/john-local.conf
echo 'mscash-opencl = Y' >> ../run/john-local.conf
echo 'sl3-opencl = Y' >> ../run/john-local.conf
echo 'rawsha1-opencl = Y' >> ../run/john-local.conf
echo 'salted_sha-opencl = Y' >> ../run/john-local.conf
echo 'bitlocker-opencl = Y' >> ../run/john-local.conf
echo 'keepass-opencl = Y' >> ../run/john-local.conf

