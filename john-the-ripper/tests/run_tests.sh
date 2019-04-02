#!/bin/bash

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
total=0
error=0

echo "---------------------------- TESTING -----------------------------"
"$JTR_BIN" --list=build-info

echo '$NT$066ddfd4ef0e9cd7c256fe77191ef43c' > tests.in
echo '$NT$8846f7eaee8fb117ad06bdd830b7586c' >> tests.in
echo 'df64225ca3472d32342dd1a33e4d7019f01c513ed7ebe85c6af102f6473702d2' >> tests.in
echo '73e6bc8a66b5cead5e333766963b5744c806d1509e9ab3a31b057a418de5c86f' >> tests.in
echo '$6$saltstring$fgNTR89zXnDUV97U5dkWayBBRaB0WIBnu6s4T7T8Tz1SbUyewwiHjho25yWVkph2p18CmUkqXh4aIyjPnxdgl0' >> tests.in

if [[ -z "${TEST##*full*}" ]]; then
    echo "====> T Full:"
    "$JTR_BIN" -test-full=0
    report "-test-full=0"
fi

if [[ -z "${TEST##*extra*}" ]]; then
    echo
    echo "====> regex T1 A: 9 lines"
    "$JTR_BIN" --stdout --regex='[0-2]password[A-C]'
    echo "====> regex T1 B: 2 lines, 1 special character"
    "$JTR_BIN" --stdout --regex=ab[öc]
    echo "====> regex T1 C: 7 lines, 7 special characters, quotation marks"
    "$JTR_BIN" --stdout --regex="ab[£öçüàñẽ]"
    echo "====> regex T1 D: 5 lines, 4 special characters, quotation marks"
    "$JTR_BIN" --stdout --regex='ab(ö|¿|e|¡|!)'
    echo "====> regex T1 E: 2 lines, 1 special character, vertical bar"
    "$JTR_BIN" --stdout --regex='ab(ö|c)'
    echo "====> regex T1 F: 3 lines, 5 special characters, vertical bar"
    "$JTR_BIN" --stdout --regex='ab(ö,¿|\?,e|¡,!)'
    echo "====> regex T2: 2 lines, at the end"
    echo magnum | "$JTR_BIN" -stdout -stdin -regex='\0[01]'
    echo "====> regex T3 A: 2 lines, at the end, encoding"
    echo müller | iconv -f UTF-8 -t cp850 | "$JTR_BIN" -inp=cp850 -stdout -stdin -regex='\0[01]'
    echo "====> regex T3 B: 2 lines, encoding"
    "$JTR_BIN" -stdout --regex='ab(ö|c)' -target-enc=cp437
    echo

    echo "====> T4:"
    "$JTR_BIN" -test-full=0 --format=nt
    report "-test-full=0 --format=nt"
    echo "====> T5:"
    "$JTR_BIN" -test-full=0 --format=sha256crypt
    report "-test-full=0 --format=sha256crypt"
    echo "====> T6.0:"
    "$JTR_BIN" -test=3 -form='dynamic=md5(sha1($s).md5($p))'
    report '-test=3 -form="dynamic=md5(sha1($s).md5($p))"'
    echo "====> T6.1:"
    "$JTR_BIN" -test=3 -form='dynamic=md5(sha1($s.$p).md5($p))'
    report '-test=3 -form="dynamic=md5(sha1($s.$p).md5($p))"'
    echo "====> T6.2:"
    "$JTR_BIN" -test=3 -form='dynamic=md5($p)'
    report '-test=3 -form="dynamic=md5($p)"'
    echo

    echo "====> T10:"
    "$JTR_BIN" tests.in --format=nt --fork=2
    report "tests.in --format=nt --fork=2"
    echo "====> T11:"
    "$JTR_BIN" tests.in --format=raw-sha256 --fork=2
    report "--format=raw-sha256 --fork=2"
    echo "====> T12-a:"
    "$JTR_BIN" tests.in --format=sha512crypt --mask=jo?l[n-q]
    report "--format=sha512crypt --mask=jo?l[n-q]"

    echo "------------------------------------------------------------------"
    "$JTR_BIN" -test=0 --format=sha* --verb=5 --tune=report
    report "--format=sha* --verb=5 --tune=report"
    echo "------------------------------------------------------------------"
    echo

    if [[ "$arch" == 'x86_64' ]]; then
        echo "====> T6:"
        "$JTR_CL" -test-full=0 --format=sha512crypt-opencl
        report "--format=sha512crypt-opencl" "FAIL"
        echo "------------------------------------------------------------------"
        echo
    fi
fi
echo '-------------------------------------------'
echo "###  Performed $total tests in $SECONDS seconds  ###"
echo '-------------------------------------------'

if [[ $error > 0 ]];  then
    echo '----------------------------------------'
    echo "###    Build failed with $error errors    ###"
    echo '----------------------------------------'
    arch=$(uname -m)
    echo "----------------- $arch ------------------"

    exit 1
fi
