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

function do_Init(){
    echo 'Preparing to run...'
    cp ../pw.dic .
    cp ../rawsha256_tst.in .
    cp ../cisco4_tst.in .
    cp ../rawsha512_tst.in .
    cp ../XSHA512_tst.in .
    cp ../SHA256crypt_tst.in .
    cp ../SHA512crypt_tst.in .

    ../../run/john -form:cpu --list=format-tests 2> /dev/null | cut -f3 1> alltests.in

    read -r CPU_DEV <<< "$(../../run/john --list=opencl-devices -dev:cpu | \
                           grep 'Device #' | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 3 | tr '()\n' ' ')"
    read -r GPU_DEV <<< "$(../../run/john --list=opencl-devices -dev:gpu | \
                           grep 'Device #' | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 3 | tr '()\n' ' ')"
    Device_List="$CPU_DEV $GPU_DEV"
    #echo "--> CPUs: $CPU_DEV"
    #echo "--> GPUs: $GPU_DEV"
    #echo "--> Final: $Device_List"
    clear
}

function do_Done(){
    rm alltests.in
    rm -f test.in
    rm pw.dic
    rm rawsha256_tst.in
    rm cisco4_tst.in
    rm rawsha512_tst.in
    rm XSHA512_tst.in
    rm -f -- *.log*
    rm -f -- *.rec*
}

function do_Test_Full(){
    for i in $Device_List ; do
        TEMP=$(mktemp _tmp_output.XXXXXXXX)
        TO_RUN="$3 ../../run/john --test-full=1 $1 $2 -dev:$i &> $TEMP"
        eval "$TO_RUN"
        ret_code=$?

        if [[ $ret_code -ne 0 ]]; then
            echo "ERROR ($ret_code): $TO_RUN"
            echo

            Total_Erros=$((Total_Erros + 1))
        fi
        Total_Tests=$((Total_Tests + 1))
        #-- Remove tmp files.
        rm "$TEMP"
    done
}

function do_Test_Fuzz(){
    for i in $Device_List ; do
        TEMP=$(mktemp _tmp_output.XXXXXXXX)
        TO_RUN="$3 ../../run/john --fuzz $1 $2 -dev:$i &> $TEMP"
        eval "$TO_RUN"
        ret_code=$?

        if [[ $ret_code -ne 0 ]]; then
            echo "ERROR ($ret_code): $TO_RUN"
            echo

            Total_Erros=$((Total_Erros + 1))
        fi
        Total_Tests=$((Total_Tests + 1))
        #-- Remove tmp files.
        rm "$TEMP"
    done
}

function do_Test_TS(){
    TO_RUN="./jtrts.pl $3 -type $1 -passthru '$2'"
    eval "$TO_RUN"
    ret_code=$?

    if [[ $ret_code -ne 0 ]]; then
        echo "ERROR ($ret_code): $TO_RUN"
        echo

        Total_Erros=$((Total_Erros + 1))
    fi
    Total_Tests=$((Total_Tests + 1))
}

function do_Test_Suite(){
    cd ..

    if [[ "$1" == "rawsha256" ]] || [[ -z "$1" ]] || [[ $# -eq 0 ]]; then
        echo 'Running raw-SHA256 Test Suite tests...'
        do_Test_TS raw-sha256-opencl "-dev:$Dev_1"
        do_Test_TS raw-sha256-opencl "-dev:$Dev_2"
        do_Test_TS raw-sha256-opencl "-dev:$Dev_3"
        do_Test_TS raw-sha256-opencl "-dev:$Dev_1 --fork=2" "-internal"
        do_Test_TS raw-sha256-opencl "-dev:$Dev_2 --fork=3" "-internal"
        do_Test_TS raw-sha256-opencl "-dev:$Dev_3 --fork=4" "-internal"
    fi

    if [[ "$1" == "rawsha512" ]] || [[ -z "$1" ]] || [[ $# -eq 0 ]]; then
        echo 'Running raw-SHA512 Test Suite tests...'
        do_Test_TS raw-sha512-opencl "-dev:$Dev_1"
        do_Test_TS raw-sha512-opencl "-dev:$Dev_2"
        do_Test_TS raw-sha512-opencl "-dev:$Dev_3"
        do_Test_TS raw-sha512-opencl "-dev:$Dev_1 --fork=2" "-internal"
        do_Test_TS raw-sha512-opencl "-dev:$Dev_2 --fork=3" "-internal"
        do_Test_TS raw-sha512-opencl "-dev:$Dev_3 --fork=4" "-internal"

        echo 'Running xSHA512 Test Suite tests...'
        do_Test_TS xsha512-opencl "-dev:$Dev_1"
        do_Test_TS xsha512-opencl "-dev:$Dev_2"
        do_Test_TS xsha512-opencl "-dev:$Dev_3"
        do_Test_TS xsha512-opencl "-dev:$Dev_1 --fork=2" "-internal"
        do_Test_TS xsha512-opencl "-dev:$Dev_2 --fork=3" "-internal"
        do_Test_TS xsha512-opencl "-dev:$Dev_3 --fork=4" "-internal"
    fi

    if [[ "$1" == "sha256" ]] || [[ -z "$1" ]] || [[ $# -eq 0 ]]; then
        echo 'Running SHA256crypt Test Suite tests...'
        do_Test_TS sha256crypt-opencl "-dev:$Dev_1"
        do_Test_TS sha256crypt-opencl "-dev:$Dev_2"
        do_Test_TS sha256crypt-opencl "-dev:$Dev_3"
        do_Test_TS sha256crypt-opencl "-dev:$Dev_1 --fork=2" "-internal"
        do_Test_TS sha256crypt-opencl "-dev:$Dev_2 --fork=3" "-internal"
        do_Test_TS sha256crypt-opencl "-dev:$Dev_3 --fork=4" "-internal"
    fi

    if [[ "$1" == "sha512" ]] || [[ -z "$1" ]] || [[ $# -eq 0 ]]; then
        echo 'Running SHA512crypt Test Suite tests...'
        do_Test_TS sha512crypt-opencl "-dev:$Dev_1"
        do_Test_TS sha512crypt-opencl "-dev:$Dev_2"
        do_Test_TS sha512crypt-opencl "-dev:$Dev_3"
        do_Test_TS sha512crypt-opencl "-dev:$Dev_1 --fork=2" "-internal"
        do_Test_TS sha512crypt-opencl "-dev:$Dev_2 --fork=3" "-internal"
        do_Test_TS sha512crypt-opencl "-dev:$Dev_3 --fork=4" "-internal"
    fi

    cd - || return > /dev/null
}

function do_Test_Bench(){
    TEMP=$(mktemp _tmp_output.XXXXXXXX)
    TO_RUN="$3 ../../run/john $1 $2 --test=5 &> $TEMP"
    eval "$TO_RUN"
    ret_code=$?

    if [[ $ret_code -ne 0 ]]; then
        echo "ERROR ($ret_code): $TO_RUN"
        echo

        cat "$TEMP" >> error.saved
        Total_Erros=$((Total_Erros + 1))
    else
        awk '/Device/ { print $0 }' "$TEMP"
        awk '/c\/s real/ { print $0 }' "$TEMP"
        echo
    fi
    Total_Tests=$((Total_Tests + 1))
    #-- Remove tmp files.
    rm "$TEMP"

    #Leave the OS alone for a moment
    sleep 0.5
}

function do_Test(){
    TEMP=$(mktemp _tmp_output.XXXXXXXX)
    TO_RUN="$5 ../../run/john -ses=tst-cla -pot=tst-cla.pot $1 $2 $3 &> /dev/null"
    eval "$TO_RUN"
    ret_code=$?

    if [[ $ret_code -ne 0 ]]; then
        read -r MAX_TIME <<< "$(echo "$3" | awk '/-max-run/ { print 1 }')"

        if ! [[ $ret_code -eq 1 && "$MAX_TIME" == "1" ]]; then
            echo "ERROR ($ret_code): $TO_RUN"
            echo

            exit 1
        fi
    fi
    TO_SHOW="../../run/john -show=left -pot=tst-cla.pot $1 $2 &> $TEMP"
    eval "$TO_SHOW"
    ret_code=$?

    if [[ $ret_code -ne 0 ]]; then
        echo "ERROR ($ret_code): $TO_SHOW"
        echo

        exit 1
    fi
    read -r CRACKED <<< "$(awk '/password hash/ { print $1 }' "$TEMP")"

    #echo "DEBUG: ($CRACKED) $TO_RUN"
    #echo "DEBUG: ($CRACKED) $TO_SHOW"

    if [[ $CRACKED -ne $4 ]]; then
        echo "ERROR: $TO_RUN"
        echo "Expected value: $4, value found: $CRACKED. $TO_SHOW"
        echo

        exit 1
    fi
    Total_Tests=$((Total_Tests + 1))
    #-- Remove tmp files.
    rm tst-cla.pot

    if [[ $ret_code -eq 0 ]]; then
        rm "$TEMP"
    fi
}

function do_Regressions(){
    echo 'Regression testing...'
    do_Test "alltests.in"             "-form:Raw-SHA256-opencl"  "-wo:pw.dic --skip"              7  #Skip self test segfaults
    do_Test "XSHA512_tst.in"          "-form=xSHA512-opencl"     "-wo:pw.dic --rules --skip"   1500  #Skip self test segfaults II
    do_Test "crack_me_if_you_can.tst" "-form:Raw-SHA512-opencl"  "-mask=?l?l?l?l"                 6  #Can't handle more than a few hashes
    do_Test "regression_1.tst"        "-form:Raw-SHA256-opencl"  ""                           12027  #Miss cracks
}

function do_All_Devices(){

    if [[ "$1" == "rawsha256" ]] || [[ -z "$1" ]] || [[ $# -eq 0 ]]; then
        echo 'Evaluating raw-sha256 in all devices...'
        for i in $Device_List ; do
            do_Test_Bench "-form:Raw-SHA256-opencl" "-dev:$i" ""
            do_Test_Bench "-form:Raw-SHA256-opencl" "--mask -dev:$i" ""
        done
    fi

    if [[ "$1" == "rawsha512" ]] || [[ -z "$1" ]] || [[ $# -eq 0 ]]; then
        echo 'Evaluating raw-sha512 in all devices...'
        for i in $Device_List ; do
            do_Test_Bench "-form:Raw-SHA512-opencl" "-dev:$i" ""
            do_Test_Bench "-form:Raw-SHA512-opencl" "--mask -dev:$i" ""
        done

        echo 'Evaluating xSHA512 in all devices...'
        for i in $Device_List ; do
            do_Test_Bench "-form:xSHA512-opencl" "-dev:$i" ""
            do_Test_Bench "-form:xSHA512-opencl" "--mask -dev:$i" ""
        done
    fi

    if [[ "$1" == "sha256" ]] || [[ -z "$1" ]] || [[ $# -eq 0 ]]; then
        echo 'Evaluating sha256crypt in all devices...'
        for i in $Device_List ; do
            do_Test_Bench "-form:sha256crypt-opencl" "-dev:$i" ""
            do_Test_Bench "-form:sha256crypt-opencl" "--mask -dev:$i" ""
        done
    fi

    if [[ "$1" == "sha512" ]] || [[ -z "$1" ]] || [[ $# -eq 0 ]]; then
        echo 'Evaluating sha512crypt in all devices...'
        for i in $Device_List ; do
            do_Test_Bench "-form:sha512crypt-opencl" "-dev:$i" ""
            do_Test_Bench "-form:sha512crypt-opencl" "--mask -dev:$i" ""
        done
    fi
}

function do_Self_Test(){
    echo 'Test full testing...'
    do_Test_Full "-form:Raw-SHA256-opencl"
    do_Test_Full "-form:Raw-SHA512-opencl"
    do_Test_Full "-form=xSHA512-opencl"
    do_Test_Full "-form:SHA256crypt-opencl"
    do_Test_Full "-form:SHA512crypt-opencl"
}

function do_Fuzz(){
    echo 'Test fuzz testing... [Need to be enabled in configure]'
    do_Test_Fuzz "-form:Raw-SHA256-opencl"
    do_Test_Fuzz "-form:Raw-SHA512-opencl"
    do_Test_Fuzz "-form=xSHA512-opencl"
    do_Test_Fuzz "-form:SHA256crypt-opencl"
    do_Test_Fuzz "-form:SHA512crypt-opencl"
}

function sha256(){
    echo 'Running SHA256crypt cracking tests...'
    do_Test "SHA256crypt_tst.in" "-form:SHA256crypt-opencl" "-wo:pw.dic --rules --skip"                                    1500
    do_Test "SHA256crypt_tst.in" "-form:SHA256crypt-opencl" "-wo:pw.dic --rules=all -dev:$Dev_Fast"                        1500
    do_Test "alltests.in"      "-form=SHA256crypt-opencl" "-incremental -max-run=50 -fork=2 -dev:$Dev_Fast,$Dev_1"            2
    do_Test "alltests.in"      "-form=SHA256crypt-opencl" "-incremental -max-run=40 -fork=2 -dev:$Dev_Fast,$Dev_3"            2

    do_Test "alltests.in"      "-form=SHA256crypt-opencl" "-mask:?l -min-len=0 -max-len=4"           1
    do_Test "alltests.in"      "-form=SHA256crypt-opencl" "-mask:?d -min-len=0 -max-len=4"           1 "_GPU_MASK_CAND=0"
    do_Test "alltests.in"      "-form=SHA256crypt-opencl" "-mask=[Pp][Aa@][Ss5][Ss5][Ww][Oo0][Rr][Dd] -dev:$Dev_1"            1
}

function sha512(){
    echo 'Running SHA512crypt cracking tests...'
    do_Test "SHA512crypt_tst.in" "-form:SHA512crypt-opencl" "-wo:pw.dic --rules --skip"                                    1500
    do_Test "SHA512crypt_tst.in" "-form:SHA512crypt-opencl" "-wo:pw.dic --rules=all -dev:$Dev_Fast"                        1500
    do_Test "alltests.in"      "-form=SHA512crypt-opencl" "-incremental -max-run=50 -fork=2 -dev:$Dev_Fast,$Dev_1"            1
    do_Test "alltests.in"      "-form=SHA512crypt-opencl" "-incremental -max-run=40 -fork=2 -dev:$Dev_Fast,$Dev_1"            1

    do_Test "alltests.in"      "-form=SHA512crypt-opencl" "-mask:?l -min-len=0 -max-len=4"           1
    do_Test "alltests.in"      "-form=SHA512crypt-opencl" "-mask:?d -min-len=0 -max-len=4"           1 "_GPU_MASK_CAND=0"
    do_Test "alltests.in"      "-form=SHA512crypt-opencl" "-mask=[Hh][E3e@][LlI][LlI][O0o][.\ ,][Ww][Oo0][Rr][LlI][Dd][\!~] -dev:$Dev_Fast"          1
}

function rawsha256(){
    echo 'Running raw-SHA256 cracking tests...'
    do_Test "cisco4_tst.in"    "-form:Raw-SHA256-opencl" "-wo:pw.dic --rules --skip"                                    1500
    do_Test "rawsha256_tst.in" "-form:Raw-SHA256-opencl" "-wo:pw.dic --rules=all -dev:$Dev_2"                           1500
    do_Test "alltests.in"      "-form=raw-SHA256-opencl" "-incremental -max-run=50 -fork=4 -dev:$Dev_1"                    9
    do_Test "alltests.in"      "-form=raw-SHA256-opencl" "-incremental -max-run=40 -fork=4 -dev:$Dev_3"                    9

    do_Test "alltests.in"      "-form=Raw-SHA256-opencl" "-mask:?l -min-len=4 -max-len=7"           3
    do_Test "alltests.in"      "-form=Raw-SHA256-opencl" "-mask:?d -min-len=1 -max-len=8"           5 "_GPU_MASK_CAND=0"
    do_Test "alltests.in"      "-form=raw-SHA256-opencl" "-mask=[Pp][Aa@][Ss5][Ss5][Ww][Oo0][Rr][Dd] -dev:$Dev_1"          2
    do_Test "alltests.in"      "-form=Raw-SHA256-opencl" "-mask:tes?a?a"                                                   3
}

function rawsha512(){
    echo 'Running raw-SHA512 cracking tests...'
    do_Test "rawsha512_tst.in" "-form=raw-SHA512-opencl" "-wo:pw.dic --rules=all --skip"                               1500
    do_Test "XSHA512_tst.in"   "-form=xSHA512-opencl"    "-wo:pw.dic --rules"                                          1500
    do_Test "alltests.in"      "-form=raw-SHA512-opencl" "-incremental -max-run=50 -fork=4 -dev:$Dev_1"                   3
    do_Test "alltests.in"      "-form=raw-SHA512-opencl" "-incremental -max-run=40 -fork=4 -dev:$Dev_3"                   3

    do_Test "alltests.in"      "-form=raw-SHA512-opencl" "-mask=[Pp][Aa@][Ss5][Ss5][Ww][Oo0][Rr][Dd] -dev:$Dev_1"                2
    do_Test "alltests.in"      "-form=raw-SHA512-opencl" "-mask:?l?l?l?l?l?l?l --skip -dev:$Dev_2"                               1
    do_Test "alltests.in"      "-form=raw-SHA512-opencl" "-mask:?d2345?d?d?d"                                                    2
    do_Test "alltests.in"      "-form=raw-SHA512-opencl" "-mask:1?d3?d5?d7?d90123?d5?d7?d90"                                     2
    do_Test "alltests.in"      "-form=raw-SHA512-opencl" "-mask=?u?u?uCAPS"                                                      2
    do_Test "alltests.in"      "-form=raw-SHA512-opencl" "-mask:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx[x-z] -min=55 -max-l=55"  1
    do_Test "alltests.in"      "-form=raw-SHA512-opencl" "-mask:TestTESTt3st"                                                    2
    do_Test "alltests.in"      "-form=raw-SHA512-opencl" "-mask:john?a?l?l?lr  -dev:$Dev_3"                                      2
    do_Test "alltests.in"      "-form=raw-SHA512-opencl" "-mask:?a -min-len=0 -max-len=3"                                        1

    do_Test "alltests.in"      "-form=xSHA512-opencl" "-mask:?l?l?l?l?l"                            1
    do_Test "alltests.in"      "-form=xSHA512-opencl" "-mask=[Pp][Aa@][Ss5][Ss5][Ww][Oo0][Rr][Dd]"  1
    do_Test "alltests.in"      "-form=xSHA512-opencl" "-mask=boob?l?l?l"                            1
    do_Test "alltests.in"      "-form=xSHA512-opencl" "-mask:?d -min-len=1 -max-len=4"              5 "_GPU_MASK_CAND=0"
    do_Test "alltests.in"      "-form=xSHA512-opencl" "-mask:?d -min-len=4 -max-len=8"              6
}

function do_Random(){
    echo 'Running random cracking tests...'
    do_Test "test1.in"    "-form:sha512crypt-opencl" "--incremental --skip"                         200
    do_Test "test2.in"    "-form:sha512crypt-opencl" "--incremental -dev:$Dev_Fast"                 200
    do_Test "test3.in"    "-form:sha512crypt-opencl" "--incremental -fork=2 -dev:$Dev_3"             50
    do_Test "test5.in"    "-form:sha256crypt-opencl" "--incremental -dev:$Dev_Fast"                 600

    for i in `../../run/john -inc -stdout | head -15000 | shuf | head -5309`; do echo -n $i | sha512sum | sed 's/-/ /g'; done > test.in
    do_Test "test.in"    "-form:raw-sha512-opencl" "--incremental -fork=3 -dev:$Dev_Fast"          5309

    for i in `../../run/john -inc -stdout | head -15000 | shuf | head -5309`; do echo -n $i | sha256sum | sed 's/-/ /g'; done > test.in
    do_Test "test.in"    "-form:raw-sha256-opencl" "--incremental -fork=5 -dev:$Dev_Fast"          5309

    for i in `seq 1 35027 99999999`; do echo -n $i | sha256sum | sed 's/-/ /g'; done > test.in
    do_Test "test.in"    "-form:raw-sha256-opencl" "--mask=?d --min-len=0 --max-len=8"             2855

    for i in `seq 9999999 1743778271 999999999999`; do echo -n $i | sha256sum | sed 's/-/ /g'; done > test.in
    do_Test "test.in"    "-form:raw-sha256-opencl" "--mask=?d --min-len=0 --max-len=12"             574

    for i in `seq 1 35027 99999999`; do echo -n $i | sha512sum | sed 's/-/ /g'; done > test.in
    do_Test "test.in"    "-form:raw-sha512-opencl" "--mask=?d --min-len=0 --max-len=8 -dev:$Dev_Fast"   2855 "_GPU_AUTOTUNE_LIMIT=500"

    for i in `seq 9999999 1743778271 99999999999`; do echo -n $i | sha512sum | sed 's/-/ /g'; done > test.in
    do_Test "test.in"    "-form:raw-sha512-opencl" "--mask=?d --min-len=7 --max-len=11 -dev:$Dev_3"      58  "_GPU_AUTOTUNE_LIMIT=500"

    # $JtR --mask=?a --min-len=0 --max-len=5 --format=raw-sha512-opencl 100%_salt_free_110%_hassle.txt
    # 395g 0:00:00:55 99,94% (5) (ETA: 02:23:28) 7.115g/s 141968Kp/s 141968Kc/s 15102GC/s o2j"|..aa|||
    do_Test "100%_salt_free_110%_hassle.txt"    "-form:raw-sha512-opencl" "--mask=?a --min-len=0 --max-len=5"      395
}

do_Mask_Test () {
    #-- Copied from an issue.
    #for i in `cat post.lst`; do echo $i | mkpasswd -m sha-512 -P 0 ; done > ~/testhashes
    #echo admin > word.lst

    #rm -f ../../run/john.pot && ../../run/john testhashes -mask:admin?d?d?d -form:sha512crypt-opencl
    #rm -f ../../run/john.pot && ../../run/john testhashes -mask:admin?d -min-len=4 -max-len=10 -form:sha512crypt-opencl
    #rm -f ../../run/john.pot && ../../run/john testhashes -mask:admin?d -min-len=0 -max-len=10 -form:sha512crypt-opencl
    #rm -f ../../run/john.pot && ../../run/john testhashes -w:word.lst -mask:?w?d?d?d -form:sha512crypt-opencl

    echo 'Running mask tests...'
    do_Test "testhashes.in"      "-form=sha512crypt-opencl" "-mask:admin?d?d?d"                       1
    do_Test "testhashes.in"      "-form=sha512crypt-opencl" "-mask:admin?d -min-len=4 -max-len=10"    7
    do_Test "testhashes.in"      "-form=sha512crypt-opencl" "-mask:admin?d -min-len=0 -max-len=10"    11
    do_Test "testhashes.in"      "-form=sha512crypt-opencl" "-w:word.lst -mask:?w?d?d?d"              1
    do_Test "testhashes.in"      "-form=sha512crypt-opencl" "-w:post.lst"                             11
}

function do_help(){
    echo 'Usage: ./tests.sh [OPTIONS] [hash]'
    echo
    echo '--help:       prints this help.'
    echo '--version:    prints the version information.'
    echo '--basic:      tests hashes against all available devices (CPU and GPU). To filter a hash type, use:'
    echo '               ./tests.sh --basic [hash]'
    echo '--cracking:   runs the cracking tests. To filter a hash type, use:'
    echo '               ./tests.sh [hash]'
    echo '--random:     runs a few random cracking tests.'
    echo '--regression: ensures fixed bugs were not reintroduced.'
    echo '--ts:         executes the Test Suite. To filter a hash type, use:'
    echo '               ./tests.sh --ts [hash]'
    echo ' '
    echo 'Available hashes:'
    echo '  sha256: execute sha256crypt cracking tests.'
    echo '  sha512: execute sha512crypt cracking tests.'
    echo '  rawsha256: execute raw-sha256 cracking tests.'
    echo '  rawsha512: execute x/raw-sha512 cracking tests.'
    echo

    exit 0
}

function do_version(){
    echo 'Tester Sidekick, version 0.6-beta'
    echo
    echo 'Copyright (C) 2016 Claudio André <claudioandre.br at gmail.com>'
    echo 'License GPLv2+: GNU GPL version 2 or later <http://gnu.org/licenses/gpl.html>'
    echo 'This program comes with ABSOLUTELY NO WARRANTY; express or implied.'
    echo

    exit 0
}

#-----------   Helper   -----------
case "$1" in
    "help" | "--help" | "-h")
        do_help;;
    "version" | "--version" | "-v")
        do_version;;
esac

if [[ $# -eq 0 ]]; then
    do_help
fi

#-----------   Init   -----------
Total_Tests=0
Total_Erros=0
Dev_1=6    # GTX TITAN
Dev_2=1    # Radeon RX Vega
Dev_3=5    # GTX TITAN X
Dev_Fast=4 # GTX 1080
do_Init

#-----------   Tests   -----------

case "$1" in
    "--all" | "-a")
        do_All_Devices  #--basic
        do_Test_Suite   #--ts
        do_Self_Test    #--self
        do_Regressions  #--regression
        do_Fuzz         #--fuzz
        do_Mask_Test    #--mask
        sha256          #--cracking
        sha512          #   idem
        rawsha256       #--cracking
        rawsha512       #   idem
        ;;
    "--basic" | "-b")
        do_All_Devices "$2"
        ;;
    "--cracking" | "-c")
        if [[ "$2" == "sha256" ]] || [[ -z "$2" ]]; then
            sha256
        fi

        if [[ "$2" == "sha512" ]] || [[ -z "$2" ]]; then
            sha512
        fi

        if [[ "$2" == "rawsha256" ]] || [[ -z "$2" ]]; then
            rawsha256
        fi

        if [[ "$2" == "rawsha512" ]] || [[ -z "$2" ]]; then
            rawsha512
        fi
        ;;
    "--random")
        do_Random
        ;;
    "--regression" | "-r")
        do_Regressions
        ;;
    "--self" | "-s")
        do_Self_Test
        ;;
    "--ts" | "-ts")
        do_Test_Suite "$2"
        ;;
    "--mask" | "-m")
        do_Mask_Test
        ;;
    "--fuzz" | "-f")
        do_Fuzz
        ;;
esac

#-----------   Done  -----------
do_Done

#----------- The End -----------
echo
echo '--------------------------------------------------------------------------------'
if [[ $Total_Erros -eq 0 ]]; then
    echo "All tests passed without error! Performed $Total_Tests tests in $SECONDS seconds."
else
    echo "$Total_Erros tests FAILED! Performed $Total_Tests tests in $SECONDS seconds."
fi
echo '--------------------------------------------------------------------------------'

