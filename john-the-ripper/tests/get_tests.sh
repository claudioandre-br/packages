#!/bin/bash
#Check to assure we are in the right place

if [[ ! -d src || ! -d run ]] && [[ $1 != "-f" ]]; then
    echo
    echo 'It seems you are in the wrong directory. To ignore this message, add -f to the command line.'
    exit 1
fi

#Changes needed
rm -rf .travis.yml buggy.sh circle.yml appveyor.yml .travis/ .circle/ .circleci/

mkdir -p .circleci/
mkdir -p .travis/

wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/buggy.sh

wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/appveyor.yml

wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/.travis.yml
wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/tests.sh      -P .travis/
wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/travis-ci.sh  -P .travis/

wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/config.yml    -P .circleci/
wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/circle-ci.sh  -P .circleci/


# Patches
wget https://raw.githubusercontent.com/claudioandre-br/packages/master/patches/3204.patch
git am 3204.patch

chmod +x buggy.sh
chmod +x .travis/tests.sh
chmod +x .travis/travis-ci.sh
chmod +x .circleci/circle-ci.sh

git add .circle/CircleCI-MinGW.sh
git add appveyor.yml
git add .travis.yml
git add circle.yml
git add .travis/
git add .circleci/

# Ban all problematic formats (disable buggy formats)
# If a formats fails its tests on super, I will burn it.
./buggy.sh disable

# Save the resulting state
git commit -a -m "CI: do test plus Windows packaging $(date)"

# Clean up
rm -f buggy.sh
rm -f get_tests.sh
rm -f 3204.patch

