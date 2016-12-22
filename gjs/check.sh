#!/bin/bash -e

# Get and install dependencies
echo $DISTRO
echo '-- Prepare --'
cd /cwd

if [[ OS == "fedora" ]]; then
    dnf -y update
    dnf groupinstall -y 'Development Tools'
    dnf install -y libmount-devel pcre-devel python-devel autoconf automake libtool flex bison pkgconfig zlib-devel libffi-devel
    dnf install -y gamin-devel
    dnf install -y which
else
    apt-get update -qq
    apt-get -y install build-essential
    apt-get -y install libmount-dev libpcre3-dev python-dev dh-autoreconf flex bison pkg-config zlib1g-dev libffi-dev
    apt-get -y install libxml2-utils libgamin-dev #libfam-dev
    apt-get -y install software-properties-common
    add-apt-repository -y ppa:ricotz/testing
    apt-get update
    apt-get -y install libmozjs-31-dev
fi

# Build glib 2.0
echo '-- gLib build --'
cd glib
./autogen.sh
make -sj2
make install

# Build gObject Introspection
echo '-- gObject Instrospection build --'
cd ../gobject-introspection
./autogen.sh
make -sj2
make install

# Build Javascript Bindings for GNOME
echo '-- gjs build --'
cd ../gjs
./autogen.sh --prefix=/usr/local
make -sj2
make install

# Test the build
echo '-- Testing GJS --'

ls -la /usr/local/libexec
ls -la /usr/local/libexec/gjs
ls -la /usr/local/libexec/gjs/installed-tests
ls -la /usr/local/libexec/gjs/installed-tests/js
ls -la /cwd/gjs
ls -la /cwd/gjs/gjs
ls -la /cwd/gjs/test
ls -la /cwd/gjs/installed-tests

# /usr/local/libexec/gjs/gjs-installed-tests



    #'
    #docker run -v $(pwd):/cwd ubuntu:xenial sh -c '

#cd installed-tests
#./autogen.sh && ./configure --prefix=... && make && make install
#$prefix/libexec/gjs/gjs-installed-tests
