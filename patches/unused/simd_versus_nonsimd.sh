#!/bin/bash

#########################################################################
# Allow to compare SIMD and non SIMD builds
#
#########################################################################

    if false; then
        # Rename binaries
        mv ../run/john-non-omp ../run/john-neon-no-omp
        mv ../run/john ../run/john-neon-omp

        # Allow to compare SIMD and non-SIMD builds
        ./configure --disable-native-tests --disable-simd $SYSTEM_WIDE --disable-openmp CPPFLAGS="-D_SNAP -D_BOXED" && make -s clean && make -sj2 && mv ../run/john ../run/john-non-omp
        ./configure --disable-native-tests --disable-simd $SYSTEM_WIDE                 CPPFLAGS="-D_SNAP -D_BOXED -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-non-omp\\\"\"" && make -s clean && make -sj2

        # Rename new binaries
        mv ../run/john-non-omp ../run/john-no-omp
        mv ../run/john ../run/john-omp

        # Test sha256crypt
        ../run/john-no-omp -test -form:sha256crypt -tune=1
        ../run/john-neon-no-omp -test -form:sha256crypt -tune=1

        ../run/john-omp -test -form:sha256crypt -tune=1
        ../run/john-neon-omp -test -form:sha256crypt -tune=1

        # Test sha512crypt
        ../run/john-no-omp -test -form:sha512crypt -tune=1
        ../run/john-neon-no-omp -test -form:sha512crypt -tune=1

        ../run/john-omp -test -form:sha512crypt -tune=1
        ../run/john-neon-omp -test -form:sha512crypt -tune=1

        # Test something else
        ../run/john-no-omp -test -tune=1 -form:pbkdf2-hmac-md5
        ../run/john-neon-no-omp -test -tune=1 -form:pbkdf2-hmac-md5

        ../run/john-omp -test -tune=1 -form:pbkdf2-hmac-md5
        ../run/john-neon-omp -test -tune=1 -form:pbkdf2-hmac-md5

        # Nothing else to do
        ln -s ../run/john-neon-omp ../run/john
        ln -s ../run/john ../run/john-opencl
        exit 0
    fi

