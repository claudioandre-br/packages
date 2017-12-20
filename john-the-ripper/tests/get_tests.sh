#!/bin/bash
#Check to assure we are in the right place

if [[ ! -d src || ! -d run ]] && [[ $1 != "-f" ]]; then
    echo
    echo 'It seems you are in the wrong directory. To ignore this message, add -f to the command line.'
    exit 1
fi

#Changes needed
rm -rf .travis.yml buggy.sh circle.yml .travis/ .circle/ .circleci/

mkdir -p .circleci/
mkdir -p .travis/

wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/buggy.sh

wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/.travis.yml
wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/tests.sh      -P .travis/
wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/travis-ci.sh  -P .travis/

wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/config.yml    -P .circleci/
wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/circle-ci.sh  -P .circleci/

chmod +x buggy.sh
chmod +x .travis/tests.sh
chmod +x .travis/travis-ci.sh
chmod +x .circleci/circle-ci.sh

git add .travis.yml
git add circle.yml
git add .travis/
git add .circleci/
git add buggy.sh

git commit -m "Extra testing $(date)"

