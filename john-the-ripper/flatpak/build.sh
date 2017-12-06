#!/bin/bash
if [[ "$TEST" != "yes" ]]; then
    arch=$(uname -m)
    text='x'
    git_tag=$(git describe --dirty=+ --always 2>/dev/null)

    case "$arch" in
        'x86_64')
            text='X'
            ;;
        'armhf' | 'armv7l')
            text='a'
            ;;
        'aarch64' | 'arm64')
            text='B'
            ;;
        'ppc64le' | 'powerpc64le')
            text='P'
            ;;
    esac
    # View package version
    echo "s/edge/1.8JP-$git_tag$text/g"

    echo ""
    echo "---------------------------- BUILDING -----------------------------"

    if [[ "$arch" == "x86_64" ]]; then
        # CPU (OMP and extensions fallback)
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS="-D_BOXED" && make -s clean && make -sj2 && mv ../run/john ../run/john-sse2-non-omp
        ./configure --disable-native-tests --disable-opencl --with-systemwide                  CPPFLAGS="-D_BOXED -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-sse2-non-omp\\\"\"" && make -s clean && make -sj2 && mv ../run/john ../run/john-sse2
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS="-D_BOXED -mavx" && make -s clean && make -sj2 && mv ../run/john ../run/john-avx-non-omp
        ./configure --disable-native-tests --disable-opencl --with-systemwide                  CPPFLAGS="-D_BOXED -mavx -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-avx-non-omp\\\"\" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY=\"\\\"john-sse2\\\"\"" && make -s clean && make -sj2 && mv ../run/john ../run/john-avx
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS="-D_BOXED -mxop" && make -s clean && make -sj2 && mv ../run/john ../run/john-xop-non-omp
        ./configure --disable-native-tests --disable-opencl --with-systemwide                  CPPFLAGS="-D_BOXED -mxop -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-xop-non-omp\\\"\" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY=\"\\\"john-avx\\\"\"" && make -s clean && make -sj2 && mv ../run/john ../run/john-xop
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS="-D_BOXED -mavx2" && make -s clean && make -sj2 && mv ../run/john ../run/john-non-omp
        ./configure --disable-native-tests --disable-opencl --with-systemwide                  CPPFLAGS="-D_BOXED -mavx2 -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-non-omp\\\"\" -DCPU_FALLBACK -DCPU_FALLBACK_BINARY=\"\\\"john-xop\\\"\"" && make -s clean && make -sj2
    else
        # CPU (OMP and extensions fallback)
        ./configure --disable-native-tests --disable-opencl --with-systemwide --disable-openmp CPPFLAGS="-D_BOXED" && make -s clean && make -sj2 && mv ../run/john ../run/john-non-omp
        ./configure --disable-native-tests --disable-opencl --with-systemwide                  CPPFLAGS="-D_BOXED -DOMP_FALLBACK -DOMP_FALLBACK_BINARY=\"\\\"john-non-omp\\\"\"" && make -s clean && make -sj2
    fi
    ln -s ../run/john ../run/john-opencl

else
    echo ""
    echo "---------------------------- TESTING -----------------------------"
    JTR_BIN='/app/bin/john'
    "$JTR_BIN" --list=build-info

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
    echo "====> T5:"
    "$JTR_BIN" -test-full=0 --format=raw-sha256
    echo "------------------------------------------------------------------"
    "$JTR_BIN" -test=0
    echo "------------------------------------------------------------------"
fi
