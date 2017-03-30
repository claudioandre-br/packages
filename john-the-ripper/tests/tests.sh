#!/bin/bash -e

#------------------------------------------------------
#                     Random Tests
#------------------------------------------------------
do_Test () {
    TEMP=$(mktemp _tmp_output.XXXXXXXX)
    TO_RUN="$1 &> $TEMP"
    eval $TO_RUN
    ret_code=$?

    if [[ $ret_code -ne 0 ]]; then
        read MAX_TIME <<< $(echo $3 | awk '/-max-/ { print 1 }')

        if ! [[ $ret_code -eq 1 && "$MAX_TIME" == "1" ]]; then
            echo "ERROR ($ret_code): $TO_RUN"
            echo

            exit 1
        fi
    fi

    if [[ $3 -lt 0 ]]; then
        read RESULT <<< $(cat $TEMP | grep "$2")

        if [[ -z $RESULT ]]; then
            echo --------------------------------------------
            echo "Test: ($1) FAILED"
            tail -n7 $TEMP
            echo --------------------------------------------
            echo
            exit 1
        fi
    else
        read R1 <<< $(cat $TEMP | grep -E '[0-9]+ password' | grep -o '[0-9]*' | sed -n '1p')
        read R2 <<< $(cat $TEMP | grep -E '[0-9]+ password' | grep -o '[0-9]*' | sed -n '2p')

        if [[ -z $R1 ]] || [[ -z $R2 ]]; then
            echo --------------------------------------------
            echo "Test: ($1) FAILED: |$R1| |$R2|"
            echo --------------------------------------------
            echo
            exit 1
        fi

        if [[ $3 -ne $R1 ]] || [[ $4 -ne $R2 ]]; then
            echo --------------------------------------------
            echo "Test: ($1) FAILED"
            echo "- Expected values: [$3 $4]; found: [$R1 $R2]"
            echo --------------------------------------------
            echo
            exit 1
        fi
    fi
    Total_Tests=$((Total_Tests + 1))
    echo "#################################################"
    echo "==> ($1)"
    cat $TEMP
    echo "#################################################"
    echo
    #-- Remove tmp files.
    rm $TEMP
}

# Extra testing
if test "$EXTRAS" = "yes" ; then
    # Get some data from wiki
    wget http://openwall.info/wiki/_media/john/KeePass-samples.tar
    wget http://openwall.info/wiki/_media/john/rar_sample_files.tar
    wget http://openwall.info/wiki/_media/john/zip_sample_files.tar
    wget http://openwall.info/wiki/_media/john/test.gpg.tar.gz
    tar -xopf KeePass-samples.tar
    tar -xopf rar_sample_files.tar
    tar -xopf zip_sample_files.tar
    tar -xozf test.gpg.tar.gz

    # Prepare for tests
    ../run/zip2john *.zip > ~/file1
    ../run/keepass2john keepass2.kdbx > ~/file2
    ../run/gpg2john *.asc > ~/file4
    ../run/rar2john *.rar > ~/file10

    echo '$SHA512$cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e' > ~/self
    echo '$SHA512$b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86' >> ~/self
    echo '$SHA512$fa585d89c851dd338a70dcf535aa2a92fee7836dd6aff1226583e88e0996293f16bc009c652826e0fc5c706695a03cddce372f139eff4d13959da6f1f5d3eabe' >> ~/self
    echo '$6$ojWH1AiTee9x1peC$QVEnTvRVlPRhcLQCk/HnHaZmlGAAjCfrAN0FtOsOnUk5K5Bn/9eLHHiRzrTzaIKjW9NTLNIBUCtNVOowWS2mN.' >> ~/self

    for i in `../run/john -inc -stdout | head -1000 | shuf | head -30`; do echo -n $i | md5sum  | cut -d" " -f1; done > ~/file3 # openssl md5
    for i in `../run/john -inc -stdout | head -1000 | shuf | head -30`; do echo -n $i | sha1sum | cut -d" " -f1; done > ~/file5
    for i in `../run/john -inc -stdout | head -100                   `; do echo -n $i | md5sum  | cut -d" " -f1; done > ~/file6

    cat ~/file1 ~/file2 ~/file3 ~/file4 ~/file5 ~/file6 ~/file10 > ~/hash

    # Tests
    Total_Tests=0
    JtR="../run/john"

    do_Test "$JtR --max-candidates=50 --stdout --mask=?l"             "26p 0:00:00"       -1  -1

    do_Test "$JtR ~/file1 --single"                                    "2g 0:00:00"       -1  -1
    do_Test "$JtR ~/file2 --wordlist"                                  "1g 0:00:00"       -1  -1
    do_Test "$JtR ~/file3 --incremental --format=Raw-MD5"             "30g 0:00:00"       -1  -1
    do_Test "$JtR ~/file4"                                             "4g 0:00:00"       -1  -1
    do_Test "$JtR ~/file5"                                            "30g 0:00:00"       -1  -1

    do_Test "$JtR ~/hash --loopback"  "No password hashes left to crack (see FAQ)"        -1  -1
    do_Test "$JtR ~/self --loopback"                                   "1g 0:00:00"       -1  -1
    do_Test "$JtR ~/hash --show"                        ""                                37 265
    do_Test "$JtR ~/hash --show:left"                   ""                                 2   0  #Zip format
    do_Test "$JtR ~/hash --show --format=raw-sha1"      ""                                30   0
    do_Test "$JtR ~/self --show --format=Raw-sha512"    ""                                 1   2

    #do_Test "$JtR ~/hash --make-charset=chr --format=Raw-MD5" "Loaded 38 plaintexts"                                      -1  -1
    #do_Test "$JtR ~/hash --make-charset=chr --format=Raw-MD5" "Successfully wrote charset file: chr (28 characters)"      -1  -1

    rm -f ../run/*.pot
    do_Test "$JtR ~/file6 --wordlist --rules=jumbo --format=raw-md5" "64g 0:00:0"         -1  -1
    do_Test "$JtR ~/hash --loopback --format=rar"                     "1g 0:00:0"         -1  -1
    do_Test "$JtR ~/file6 --show --format=raw-md5"                   ""                   64  36
    do_Test "$JtR ~/hash --show:left --format=rar"                   ""                    1   1
    do_Test "$JtR ~/self -form=SHA512crypt"                          "1g 0:00:0"          -1  -1
    do_Test "$JtR ~/self -form=raw-SHA512 --incremental -fork=2"     "2g 0:00:0"          -1  -1
    do_Test "$JtR ~/self --show --format=raw-SHA512"                 ""                    3   0

    echo '--------------------------------------------------------------------------------'
    echo "All tests passed without error! Performed $Total_Tests tests in $SECONDS seconds."
    echo '--------------------------------------------------------------------------------'
fi

# Regular testing.
# Trusty AMD GPU drivers on Travis are fragile. A simple run of --test might fail.
if test "$PROBLEM" = "slow" ; then
    ../run/john -test=0 --format=cpu
elif test -z "$F" -o "$F" = "1" ; then
    ../run/john -test-full=0 --format=cpu
fi

if test -z "$F" -o "$F" = "2" ; then

    if test "$OPENCL" = "yes" ; then

        if test "$CC" != "clang" ; then
            echo
            echo "OpenCL: john --list=opencl-devices"
            ../run/john --list=opencl-devices -verb=5
        fi
        ../run/john -test-full=0 --format=opencl
    fi
fi

