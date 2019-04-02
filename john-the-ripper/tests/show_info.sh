#!/bin/bash

#########################################################################
# Show information about the environment
#
#########################################################################


if [[ -n "$TRAVIS_COMMIT" ]]; then
    echo -en 'travis_fold:start:build_environment\r'
fi
echo 'Build system information'
echo '--------------------------------'

uname -m; id
uname -a
echo '--------------------------------'
cat /proc/cpuinfo
echo '--------------------------------'
env
echo '--------------------------------'

if [[ -n "$TRAVIS_COMMIT" ]]; then
    echo -en 'travis_fold:end:build_environment\r'
fi

if [[ -z "$CC" ]]; then
    TMP_CC="gcc"
else
    TMP_CC="$CC"
fi

if [[ -n "$TRAVIS_COMMIT" ]]; then
    echo -en 'travis_fold:start:compiler_info\r'
fi
echo 'Compiler information'
echo '--------------------------------'

"$TMP_CC" --version
echo '--------------------------------'
"$TMP_CC" -dM -E -x c /dev/null
echo '--------------------------------'

if [[ -n "$TRAVIS_COMMIT" ]]; then
    echo -en 'travis_fold:end:compiler_info\r'
fi
