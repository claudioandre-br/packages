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
# Runs all tests designed to assure the quality of a package
#
#########################################################################
# All "master" scripts have to add this defines
#
# define TEST=';full;extra;'
# define arch=$(uname -m)
# define JTR_BIN='../run/john'
# define JTR_CL='../run/john-opencl'
#########################################################################

report () {
    exit_code=$?
    total=$((total + 1))

    if test $exit_code -eq 0; then
        echo " Ok: $1"
    else
        if [[ "$2" == "FAIL" ]]; then
            echo " Test: ($1) failed, as expected ($exit_code)."
        else
            error=$((error + 1))
            echo " FAILED: $1"
        fi
    fi
}

# Variable initialization
total=1
error=0

echo "---------------------------- TESTING -----------------------------"
$JTR_BIN --list=build-info

echo '$NT$066ddfd4ef0e9cd7c256fe77191ef43c' > ~/tests.in
echo '$NT$8846f7eaee8fb117ad06bdd830b7586c' >> ~/tests.in
echo 'df64225ca3472d32342dd1a33e4d7019f01c513ed7ebe85c6af102f6473702d2' >> ~/tests.in
echo '73e6bc8a66b5cead5e333766963b5744c806d1509e9ab3a31b057a418de5c86f' >> ~/tests.in
echo '$6$saltstring$fgNTR89zXnDUV97U5dkWayBBRaB0WIBnu6s4T7T8Tz1SbUyewwiHjho25yWVkph2p18CmUkqXh4aIyjPnxdgl0' >> ~/tests.in

if [[ -z "${TEST##*full*}" ]]; then
    echo "--------------------------- test full ---------------------------"
    $JTR_BIN -test-full=0 --format=cpu
    report "-test-full=0 --format=cpu"
fi

if [[ -z "${TEST##*extra*}" ]]; then
    echo "--------------------------- extras ---------------------------"
    echo "====> mask T1 A: 9 lines"
    $JTR_BIN --stdout --mask='[0-2]password[A-C]'
    echo "====> mask T1 C: 7 lines, 7 special characters, quotation marks"
    $JTR_BIN --stdout --mask="ab[£öçüàñẽ]" --internal-codepage=ISO-8859-1
    echo "====> mask T1 E: 3 lines, 1 special character, vertical bar"
    $JTR_BIN --stdout --mask='ab[ö|c]' --internal-codepage=ISO-8859-1
    echo "====> mask T1 F: 8 lines, 5 special characters, vertical bar"
    $JTR_BIN --stdout --mask='ab[ö,¿|\?,e|¡,!]' --internal-codepage=ISO-8859-1
    echo "====> mask T2: 2 lines, at the end"
    echo magnum | $JTR_BIN -stdout -stdin -mask='?w[01]'
    echo "====> mask T3 A: 2 lines, at the end, encoding"
    echo müller | iconv -f UTF-8 -t cp850 | $JTR_BIN -inp=cp850 -stdout -stdin -mask='?W[01]'
    echo "====> mask T3 B: 3 lines, encoding"
    $JTR_BIN -stdout --mask='ab[ö|c]' -target-enc=cp437
    echo

    echo "====> T4:"
    $JTR_BIN -test-full=0 --format=nt
    report "-test-full=0 --format=nt"
    echo "====> T5:"
    $JTR_BIN -test-full=0 --format=sha256crypt
    report "-test-full=0 --format=sha256crypt"
    echo "====> T6.0:"
    $JTR_BIN -test=3 -form='dynamic=md5(sha1($s).md5($p))'
    report '-test=3 -form="dynamic=md5(sha1($s).md5($p))"'
    echo "====> T6.1:"
    $JTR_BIN -test=3 -form='dynamic=md5(sha1($s.$p).md5($p))'
    report '-test=3 -form="dynamic=md5(sha1($s.$p).md5($p))"'
    echo "====> T6.2:"
    $JTR_BIN -test=3 -form='dynamic=md5($p)'
    report '-test=3 -form="dynamic=md5($p)"'
    echo

    if [[ -z "$WINE" ]]; then
        echo "====> T10:"
        $JTR_BIN ~/tests.in --format=nt --fork=2
        report "tests.in --format=nt --fork=2"
        echo "====> T11:"
        $JTR_BIN ~/tests.in --format=raw-sha256 --fork=2
        report "--format=raw-sha256 --fork=2"
    fi
    echo "====> T12:"
    $JTR_BIN ~/tests.in --format=sha512crypt --mask=jo?l[n-q]
    report "--format=sha512crypt --mask=jo?l[n-q]"

    echo "------------------------------------------------------------------"
    $JTR_BIN -test=0 --format=sha1crypt --verb=5 --tune=report
    report "--format=sha1crypt --verb=5 --tune=report"
    $JTR_BIN -test=0 --format=sha256crypt --verb=5 --tune=report
    report "--format=sha256crypt --verb=5 --tune=report"
    $JTR_BIN -test=0 --format=sha512crypt --verb=5 --tune=report
    report "--format=sha512crypt --verb=5 --tune=report"
    echo "------------------------------------------------------------------"
    echo

    if [[ -n "$JTR_CL" ]]; then
        echo "====> T20:"
        $JTR_CL -test-full=0 --format=sha512crypt-opencl
        report "--format=sha512crypt-opencl" "FAIL"
        echo "------------------------------------------------------------------"
        echo
    fi
fi

if [[ -z "${TEST##*crack*}" ]]; then
    echo "--------------------------- real cracking ---------------------------"
    $JTR_BIN -list=format-tests | cut -f3 > alltests.in
    $JTR_BIN -form=SHA512crypt alltests.in --max-len=2 --progress=30
    report "-form=SHA512crypt alltests.in --max-len=2 --progress=30"

    $JTR_BIN -list=format-tests --format=sha512crypt | cut -f4 | head > solucao
    $JTR_BIN -form=SHA512crypt alltests.in -w:solucao
    report "-form=SHA512crypt alltests.in -w:solucao"

    $JTR_BIN --incremental=digits --mask='?w?d?d?d' --min-len=8 --max-len=8 --stdout | head
    $JTR_BIN --incremental=digits --mask='?w?d?d?d' --min-len=8 --stdout | head

    total=$((total + 4))
fi

if [[ -z "${TEST##*CHECK*}" ]]; then
    echo "--------------------------- make check ---------------------------"
    make check
    report "make check"
fi

if [[ -z "${TEST##*AFL_FUZZ*}" ]]; then
    echo "------------------------- afl fuzzing --------------------------"
    echo "$ afl-fuzz -i in -o out JtR @@ "
    export LWS=5
    export GWS=25

    mkdir -p in
    export AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1
    export AFL_NO_UI=1
    export AFL_HARDEN=1

    #echo core >/proc/sys/kernel/core_pattern

    $JTR_BIN -form:raw-sha256  --list=format-tests 2> /dev/null | cut -f3 | sed -n '11p' 1> in/test_hash1
    $JTR_BIN -form:raw-sha256  --list=format-tests 2> /dev/null | cut -f3 | sed -n '2p'  1> in/test_hash2
    $JTR_BIN -form:raw-sha512  --list=format-tests 2> /dev/null | cut -f3 | sed -n '2p'  1> in/test_hash3
    $JTR_BIN -form:Xsha512     --list=format-tests 2> /dev/null | cut -f3 | sed -n '2p'  1> in/test_hash4
    $JTR_BIN -form:sha256crypt --list=format-tests 2> /dev/null | cut -f3 | sed -n '3p'  1> in/test_hash5
    $JTR_BIN -form:sha512crypt --list=format-tests 2> /dev/null | cut -f3 | sed -n '3p'  1> in/test_hash6
    afl-fuzz -m none -t 5000+ -i in -o out -d $JTR_BIN --format=opencl --nolog --verb=1 @@
    echo $?

    total=$((total + 1))
fi

if [[ -z "${TEST##*ZZUF_FUZZ*}" ]]; then
    echo "------------------------- zzuf fuzzing --------------------------"
    echo "$ zzuf -s 0:1000 -c -C 3 -T 3 JtR"
    export LWS=8
    export GWS=64

    $JTR_BIN -form:raw-sha256 --list=format-tests 2> /dev/null | cut -f3 | sed -n '7p' 1> test_hash
    zzuf -s 0:1000 -c -C 1 -T 3 $JTR_BIN --format=raw-sha256-opencl --skip --max-run=1 --verb=1 test_hash
    echo $?

    $JTR_BIN -form:raw-sha512 --list=format-tests 2> /dev/null | cut -f3 | sed -n '7p' 1> test_hash
    zzuf -s 0:1000 -c -C 1 -T 3 $JTR_BIN --format=raw-sha256-opencl --skip --max-run=1 --verb=1 test_hash
    echo $?

    $JTR_BIN -form:sha256crypt --list=format-tests 2> /dev/null | cut -f3 | sed -n '3p' 1> test_hash
    zzuf -s 0:1000 -c -C 1 -T 3 $JTR_BIN --format=sha512crypt-opencl --skip --max-run=1 --verb=1 test_hash
    echo $?

    $JTR_BIN -form:sha512crypt --list=format-tests 2> /dev/null | cut -f3 | sed -n '3p' 1> test_hash
    zzuf -s 0:1000 -c -C 1 -T 3 $JTR_BIN --format=sha512crypt-opencl --skip --max-run=1 --verb=1 test_hash
    echo $?

    total=$((total + 4))
fi

if [[ -z "${TEST##*MY_INTERNAL*}" ]]; then
    echo "------------------------- fuzzing --fuzz --------------------------"
    echo "$ JtR --fuzz @@ "

    # Check if all formats passes self-test
    $JTR_BIN --fuzz --format=raw-sha256-opencl
    $JTR_BIN --fuzz --format=raw-sha512-opencl
    $JTR_BIN --fuzz --format=xsha512-opencl
    $JTR_BIN --fuzz --format=sha256crypt-opencl
    $JTR_BIN --fuzz --format=sha512crypt-opencl
    total=$((total + 5))
fi

if [[ -z "${TEST##*MY_FULL*}" ]]; then
    echo "------------------------- test full --------------------------"
    echo "$ JtR -test-full=1 @@ "

    # Check if all formats passes self-test
    $JTR_BIN -test-full=10 --format=raw-sha256-opencl
    $JTR_BIN -test-full=10 --format=raw-sha512-opencl
    $JTR_BIN -test-full=10 --format=xsha512-opencl
    $JTR_BIN -test-full=10 --format=sha256crypt-opencl
    $JTR_BIN -test-full=10 --format=sha512crypt-opencl

    $JTR_BIN -test-full=10 --format=sha256crypt-opencl --mask
    $JTR_BIN -test-full=10 --format=sha512crypt-opencl --mask
    $JTR_BIN -test-full=10 --format=raw-sha256-opencl --mask
    $JTR_BIN -test-full=10 --format=raw-sha512-opencl --mask
    $JTR_BIN -test-full=10 --format=xsha512-opencl    --mask

    $JTR_BIN -test-full=10 --format=sha256crypt-opencl --mask=?w?l?d?a?1
    $JTR_BIN -test-full=10 --format=sha512crypt-opencl --mask=?w?l?d?a?1
    $JTR_BIN -test-full=10 --format=raw-sha256-opencl --mask=?w?l?d?a?1
    $JTR_BIN -test-full=10 --format=raw-sha512-opencl --mask=?w?l?d?a?1
    $JTR_BIN -test-full=10 --format=xsha512-opencl    --mask=?w?l?d?a?1
    total=$((total + 15))
fi

echo '-------------------------------------------'
echo "###  Performed $total tests in $SECONDS seconds  ###"
echo '-------------------------------------------'
echo "----------------- $(uname -m) ------------------"

if [[ $error > 0 ]];  then
    echo '----------------------------------------'
    echo "###    Build failed with $error errors    ###"
    echo '----------------------------------------'

    exit 1
fi
