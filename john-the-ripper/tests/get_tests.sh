#!/bin/bash
#Check to assure we are in the right place

if [[ ! -d src || ! -d run ]] && [[ $1 != "-f" ]]; then
    echo
    echo 'It seems you are in the wrong directory. To ignore this message, add -f to the command line.'
    exit 1
fi

#Changes needed
rm -rf .travis.yml circle.yml src/buggy.sh .travis/ .circle/

mkdir -p .circle/
mkdir -p .travis/

wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/buggy.sh      -P src/

wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/.travis.yml
wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/tests.sh      -P .travis/
wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/travis-ci.sh  -P .travis/

wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/circle.yml    .
wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/circle-ci.sh  -P .circle/

chmod +x src/buggy.sh
chmod +x .travis/tests.sh
chmod +x .travis/travis-ci.sh
chmod +x .circle/circle-ci.sh

git add .travis.yml
git add circle.yml
git add .travis/
git add .circle/
git add src/buggy.sh
