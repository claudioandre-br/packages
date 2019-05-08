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

set -e
echo "$@"
binaries="sse2 sse2-no-omp ssse3 ssse3-no-omp sse4.1 sse4.1-no-omp sse4.2 sse4.2-no-omp
          avx avx-no-omp xop xop-no-omp avx2 avx2-no-omp
          avx512f avx512f-no-omp avx512bw avx512bw-no-omp
          ztex ztex-no-omp
          "
binary="$1"

if [[ $# -gt 0 && "$binaries" == *"$binary"* ]]; then
    shift
fi

if [[ "$binary" = 'sse2' ]]; then
    exec /john/run/john-sse2 "$@"
elif [[ "$binary" = 'sse2-no-omp' ]]; then
    exec /john/run/john-sse2-no-omp "$@"
elif [[ "$binary" = 'ssse3' ]]; then
    exec /john/run/john-ssse3 "$@"
elif [[ "$binary" = 'ssse3-no-omp' ]]; then
    exec /john/run/john-ssse3-no-omp "$@"
elif [[ "$binary" = 'sse4.1' ]]; then
    exec /john/run/john-sse4.1 "$@"
elif [[ "$binary" = 'sse4.1-no-omp' ]]; then
    exec /john/run/john-sse4.1-no-omp "$@"
elif [[ "$binary" = 'sse4.2' ]]; then
    exec /john/run/john-sse4.2 "$@"
elif [[ "$binary" = 'sse4.2-no-omp' ]]; then
    exec /john/run/john-sse4.2-no-omp "$@"
elif [[ "$binary" = 'avx' ]]; then
    exec /john/run/john-avx "$@"
elif [[ "$binary" = 'avx-no-omp' ]]; then
    exec /john/run/john-avx-no-omp "$@"
elif [[ "$binary" = 'xop' ]]; then
    exec /john/run/john-xop "$@"
elif [[ "$binary" = 'xop-no-omp' ]]; then
    exec /john/run/john-xop-no-omp "$@"
elif [[ "$binary" = 'avx2' ]]; then
    exec /john/run/john-avx2 "$@"
elif [[ "$binary" = 'avx2-no-omp' ]]; then
    exec /john/run/john-avx2-no-omp "$@"
elif [[ "$binary" = 'avx512f' ]]; then
    exec /john/run/john-avx512f "$@"
elif [[ "$binary" = 'avx512f-no-omp' ]]; then
    exec /john/run/john-avx512f-no-omp "$@"
elif [[ "$binary" = 'avx512bw' ]]; then
    exec /john/run/john-avx512bw "$@"
elif [[ "$binary" = 'avx512bw-no-omp' ]]; then
    exec /john/run/john-avx512bw-no-omp "$@"
elif [[ "$binary" = 'ztex' ]]; then
    exec /john/run/john-ztex "$@"
elif [[ "$binary" = 'ztex-no-omp' ]]; then
    exec /john/run/john-ztex-no-omp "$@"
else
    exec /john/run/john-sse2 "$@"
fi
message='### See you soon! ###'
printf "%*s\n" $(((${#message} + $(tput cols)) / 2)) "$message"

