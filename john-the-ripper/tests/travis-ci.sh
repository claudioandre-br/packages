#!/bin/bash

if [[ "$ASAN" == "yes" ]]; then
    export ASAN_OPT="--enable-asan"
fi

# Disable buggy formats. If a formats fails its tests on super, I will burn it.
(
  cd src || exit 1
  ./buggy.sh disable
)

# Apply all needed patches here.
wget https://raw.githubusercontent.com/claudioandre/packages/master/patches/0002-maintenance-fix-the-expected-data-type-size.patch
git apply 0002-maintenance-fix-the-expected-data-type-size.patch

if [[ "$TEST" == "usual" ]]; then
    cd src || exit 1

    # Build and run with the address sanitizer instrumented code
    export ASAN_OPTIONS=symbolize=1
    export ASAN_SYMBOLIZER_PATH
    ASAN_SYMBOLIZER_PATH=$(which llvm-symbolizer)

    # Prepare environment
    sudo apt-get update -qq
    sudo apt-get install libssl-dev yasm libgmp-dev libpcap-dev pkg-config debhelper libnet1-dev zzuf

    if [[ "$OPENCL" == "yes" ]]; then
        sudo apt-get install fglrx-dev opencl-headers || true

        # Fix the OpenCL stuff
        mkdir -p /etc/OpenCL
        mkdir -p /etc/OpenCL/vendors
        sudo ln -sf /usr/lib/fglrx/etc/OpenCL/vendors/amdocl64.icd /etc/OpenCL/vendors/amd.icd
    fi

    # Configure and build
    eval ./configure "$ASAN_OPT $BUILD_OPTS"
    make -sj4

    ../.travis/tests.sh

elif [[ "$TEST" == "ztex" ]]; then
    # ASAN using a 'recent' environment (compiler/OS)
    # clang 4 + ASAN + libOpenMP are not working on CI.
    docker run -v "$HOME":/root -v "$(pwd)":/cwd ubuntu:devel sh -c " \
      cd /cwd/src; \
      apt-get update -qq; \
      apt-get install -y build-essential libssl-dev yasm libgmp-dev libpcap-dev pkg-config debhelper libnet1-dev libbz2-dev wget clang libusb-1.0-0-dev; \
      export OPENCL=$OPENCL; \
      export CC=$CCO; \
      export EXTRAS=$EXTRAS; \
      export FUZZ=$FUZZ; \
      export AFL_HARDEN=1; \
      ./configure $ASAN_OPT $BUILD_OPTS; \
      make -sj4; \
      PROBLEM='ztex' ../.travis/tests.sh
   "

elif [[ "$TEST" == "fresh" ]]; then
    # ASAN using a 'recent' environment (compiler/OS)
    # clang 4 + ASAN + libOpenMP are not working on CI.
    docker run -v "$HOME":/root -v "$(pwd)":/cwd ubuntu:devel sh -c " \
      cd /cwd/src; \
      apt-get update -qq; \
      apt-get install -y build-essential libssl-dev yasm libgmp-dev libpcap-dev pkg-config debhelper libnet1-dev libbz2-dev wget clang afl; \
      export OPENCL=$OPENCL; \
      export CC=$CCO; \
      export EXTRAS=$EXTRAS; \
      export FUZZ=$FUZZ; \
      export AFL_HARDEN=1; \
      ./configure $ASAN_OPT $BUILD_OPTS; \
      make -sj4; \
      PROBLEM='slow' ../.travis/tests.sh
   "

elif [[ "$TEST" == "stable" ]]; then
    # Stable environment (compiler/OS)
    docker run -v "$HOME":/root -v "$(pwd)":/cwd centos:centos6.6 sh -c " \
      cd /cwd/src; \
      yum -y -q upgrade; \
      yum -y groupinstall 'Development Tools'; \
      yum -y install openssl-devel gmp-devel libpcap-devel bzip2-devel; \
      export OPENCL=$OPENCL; \
      export CC=$CCO; \
      export EXTRAS=$EXTRAS; \
      ./configure $ASAN_OPT $BUILD_OPTS; \
      make -sj4; \
      PROBLEM='slow' ../.travis/tests.sh
   "

elif [[ "$TEST" == "snap" ]]; then
    # Prepare environment
    sudo apt-get update -qq
    sudo apt-get install snapd

    # Install and test
    sudo snap install john-the-ripper
    sudo snap connect john-the-ripper:process-control core:process-control

elif [[ "$TEST" == "snap fedora" ]]; then
    docker run -v "$HOME":/root -v "$(pwd)":/cwd fedora:latest sh -c "
      dnf -y -q upgrade;
      dnf -y install snapd;
      snap install --channel=edge john-the-ripper;
      snap connect john-the-ripper:process-control core:process-control;
      snap alias john-the-ripper john;
      echo '--------------------------------';
      john -list=build-info;
      echo '--------------------------------'
   "

elif [[ "$TEST" == "TS --restore" ]]; then
    # Test Suite --restore run
    cd src || exit 1

    # Prepare environment
    sudo apt-get update -qq
    sudo apt-get install libssl-dev yasm libgmp-dev libpcap-dev pkg-config debhelper libnet1-dev

    # Configure and build
    ./configure
    make -sj4

    cd .. || exit 1
    git clone --depth 1 https://github.com/magnumripper/jtrTestSuite.git tests
    cd tests || exit 1
    #export PERL_MM_USE_DEFAULT=1
    (echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan
    cpan install Digest::MD5
    ./jtrts.pl --restore

elif [[ "$TEST" == "TS" ]]; then
    # Test Suite run
    cd src || exit 1

    # Prepare environment
    sudo apt-get update -qq
    sudo apt-get install libssl-dev yasm libgmp-dev libpcap-dev pkg-config debhelper libnet1-dev
    sudo apt-get install fglrx-dev opencl-headers || true

    # Fix the OpenCL stuff
    mkdir -p /etc/OpenCL
    mkdir -p /etc/OpenCL/vendors
    sudo ln -sf /usr/lib/fglrx/etc/OpenCL/vendors/amdocl64.icd /etc/OpenCL/vendors/amd.icd

    # Configure and build
    ./configure
    make -sj4

    cd .. || exit 1
    git clone --depth 1 https://github.com/magnumripper/jtrTestSuite.git tests
    cd tests || exit 1
    #export PERL_MM_USE_DEFAULT=1
    (echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan
    cpan install Digest::MD5

    if [[ "$OPENCL" != "yes" ]]; then
        ./jtrts.pl -stoponerror -dynamic none
    else
        # Disable failing formats
        echo 'descrypt-opencl = Y' >> john-local.conf

        ./jtrts.pl -noprelims -type opencl
    fi

elif [[ "$TEST" == "TS --internal" ]]; then
    # Test Suite run
    cd src || exit 1

    # Prepare environment
    sudo apt-get update -qq
    sudo apt-get install libssl-dev yasm libgmp-dev libpcap-dev pkg-config debhelper libnet1-dev
    sudo apt-get install fglrx-dev opencl-headers || true

    # Fix the OpenCL stuff
    mkdir -p /etc/OpenCL
    mkdir -p /etc/OpenCL/vendors
    sudo ln -sf /usr/lib/fglrx/etc/OpenCL/vendors/amdocl64.icd /etc/OpenCL/vendors/amd.icd

    # Configure and build
    ./configure
    make -sj4

    cd .. || exit 1
    git clone --depth 1 https://github.com/magnumripper/jtrTestSuite.git tests
    cd tests || exit 1
    #export PERL_MM_USE_DEFAULT=1
    (echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan
    cpan install Digest::MD5

    ./jtrts.pl -noprelims -internal

elif [[ "$TEST" == "TS docker" ]]; then
    # Test Suite run
    docker run -v "$HOME":/root -v "$(pwd)":/cwd ubuntu:xenial sh -c '
      cd /cwd/src;
      apt-get update -qq;
      apt-get install -y build-essential libssl-dev yasm libgmp-dev libpcap-dev pkg-config debhelper libnet1-dev libbz2-dev git;
      ./configure;
      make -sj4;
      cd ..;
      git clone --depth 1 https://github.com/magnumripper/jtrTestSuite.git tests;
      cd tests;
      cpan install Digest::MD5;
      ./jtrts.pl --restore
    '
else
    echo
    echo  -----------------
    echo  "Nothing to do!!"
    echo  -----------------
fi

