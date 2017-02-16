#!/bin/bash

rm -rf .travis.yml src/buggy.sh .travis/

wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/.travis.yml 
wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/buggy.sh      -P src/
wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/tests.sh      -P .travis/
wget https://raw.githubusercontent.com/claudioandre/packages/master/john-the-ripper/tests/travis_ci.sh  -P .travis/

chmod +x src/buggy.sh
chmod +x .travis/tests.sh
chmod +x .travis/travis_ci.sh

git add .travis.yml
git add .travis/
git add src/buggy.sh
