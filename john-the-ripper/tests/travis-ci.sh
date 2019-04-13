#!/bin/bash

function do_Install_Dependencies(){
    echo
    echo '-- Installing Base Dependencies --'

    # Prepare environment
    sudo apt-get update -qq
    sudo apt-get -y -qq install \
        build-essential libssl-dev yasm libgmp-dev libpcap-dev pkg-config \
        debhelper libnet1-dev libbz2-dev wget clang llvm zlib1g-dev wget > /dev/null

    if [[ "$_system_version" != "12.04" ]]; then
        # Ubuntu precise doesn't have this package
        sudo apt-get -y -qq install \
            libiomp-dev > /dev/null
    fi

    if [[ ! -f /usr/lib/x86_64-linux-gnu/libomp.so ]]; then
        # A bug somewhere?
        sudo ln -sf /usr/lib/libiomp5.so /usr/lib/x86_64-linux-gnu/libomp.so
    fi

    if [[ "$TEST" == *";OPENCL;"* ]]; then
        sudo apt-get -y -qq install fglrx-dev opencl-headers || true

        # Fix the OpenCL stuff
        mkdir -p /etc/OpenCL
        mkdir -p /etc/OpenCL/vendors
        sudo ln -sf /usr/lib/fglrx/etc/OpenCL/vendors/amdocl64.icd /etc/OpenCL/vendors/amd.icd
    fi
}

function do_Build(){

    BASE="Ubuntu"
    TASK_RUNNING="$TEST"
    wget https://raw.githubusercontent.com/claudioandre-br/packages/master/john-the-ripper/tests/show_info.sh
    source show_info.sh

    echo
    echo '-- Building JtR --'

    # Configure and build
    cd src || exit 1
    eval ./configure "$ASAN_OPT $BUILD_OPTS"
    make -sj2
}

function do_Prepare_To_Test(){
    echo
    echo '-- Preparing to test --'

    # Environmnet
    do_Install_Dependencies

    # Configure and build
    do_Build
}

function do_TS_Setup(){
    echo
    echo '-- Test Suite set up --'

    # Prepare environment
    cd .. || exit 1
    git clone --depth 1 https://github.com/magnumripper/jtrTestSuite.git tests
    cd tests || exit 1
    #export PERL_MM_USE_DEFAULT=1
    (echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan
    cpan install Digest::MD5
}

function do_Build_Docker_Command(){
    echo
    echo '-- Build Docker command --'

    if [[ "$2" == "CentOS" ]]; then
        update="\
          yum -y -q upgrade; \
          yum -y -q groupinstall 'Development Tools'; \
          yum -y -q install openssl-devel gmp-devel libpcap-devel bzip2-devel wget;"
    else
        update="\
          apt-get update -qq; \
          apt-get install -y -qq build-essential libssl-dev yasm libgmp-dev libpcap-dev pkg-config debhelper libnet1-dev libbz2-dev wget llvm libomp-dev zlib1g-dev > /dev/null; \
          apt-get install -y -qq $1 || true;"

        if [[ "$TEST" == *";POCL;"* ]]; then
            update="$update apt-get install -y -qq libpocl-dev ocl-icd-libopencl1 pocl-opencl-icd opencl-headers;"
            export OPENCL="yes"
        fi

        if [[ "$TEST" == *";clang;"* ]]; then
            update="$update apt-get install -y -qq clang;"
        fi

        if [[ "$TEST" == *";clang-4;"* ]]; then
            update="$update apt-get install -y -qq clang-4.0;"
        fi

        if [[ "$TEST" == *";clang-6;"* ]]; then
            update="$update apt-get install -y -qq clang-6.0;"
        fi

        if [[ "$TEST" == *";experimental;"* ]]; then
            update="$update apt-get install -y -qq software-properties-common;"
            update="$update add-apt-repository -y ppa:ubuntu-toolchain-r/test;"
            update="$update apt-get update -qq;"
            update="$update apt-get install -y -qq gcc-snapshot;"
            update="$update update-alternatives --install /usr/bin/gcc gcc /usr/lib/gcc-snapshot/bin/gcc 60 --slave /usr/bin/g++ g++ /usr/lib/gcc-snapshot/bin/g++;"
        fi
    fi

    docker_command=" \
      cd /cwd; \
      $update \
      export OPENCL=$OPENCL; \
      export CC=$CCO; \
      export TEST='$TEST'; \
      export TRAVIS_COMPILER=$TRAVIS_COMPILER; \
      export FUZZ=$FUZZ; \
      export ASAN_OPT=$ASAN_OPT; \
      export BUILD_OPTS='$BUILD_OPTS'; \
      echo; \
      $0 DO_BUILD; \
      cd /cwd/src; \
      ../.travis/CI-tests.sh
   "
}

# Do the build inside Docker
if [[ "$1" == "DO_BUILD" ]]; then
    do_Build
    exit 0
fi

# Set up environment
if [[ "$TEST" == *";ASAN;"* ]]; then
    export ASAN_OPT="--enable-asan"
fi

if [[ "$TEST" == *";OPENCL;"* ]]; then
    export OPENCL="yes"
fi

if [[ "$TEST" == *";gcc;"* ]]; then
    export CCO="gcc"
fi

if [[ "$TEST" == *";experimental;"* ]]; then
    export CCO="gcc"
fi

if [[ "$TEST" == *";clang;"* ]]; then
    export CCO="clang"
fi

if [[ "$TEST" == *";clang-4;"* ]]; then
    export CCO="clang-4.0"
fi

if [[ "$TEST" == *";clang-6;"* ]]; then
    export CCO="clang-6.0"
fi

if [[ "$TEST" == *";afl-clang;"* ]]; then
    export CCO="afl-clang"
fi

if [[ "$TEST" == *";afl-clang-fast;"* ]]; then
    export CCO="afl-clang-fast"
fi

if [[ "$TEST" == *"usual;"* ]]; then
    # Needed on ancient ASAN
    export ASAN_OPTIONS=symbolize=1
    export ASAN_SYMBOLIZER_PATH
    ASAN_SYMBOLIZER_PATH=$(which llvm-symbolizer)

    # Configure and build
    do_Prepare_To_Test

    # Run the test: --test-full=0
    ../.travis/CI-tests.sh

elif [[ "$TEST" == *"ztex;"* ]]; then
    # Build the docker command line
    do_Build_Docker_Command "libusb-1.0-0-dev" "Ubuntu"

    # Run docker
    docker run -v "$HOME":/root -v "$(pwd)":/cwd ubuntu:18.10 sh -c "$docker_command"

elif [[ "$TEST" == *"fresh;"* ]]; then
    # Build the docker command line
    do_Build_Docker_Command "$FUZZ" "Ubuntu"

    # Run docker
    docker run --cap-add SYS_PTRACE -v "$HOME":/root -v "$(pwd)":/cwd ubuntu:devel sh -c "$docker_command"

elif [[ "$TEST" == *"OpenCL;"* ]]; then
    # What is working for OpenCL
    # Build the docker command line
    do_Build_Docker_Command "$FUZZ" "Ubuntu"

    # Run docker
    docker run --cap-add SYS_PTRACE -v "$HOME":/root -v "$(pwd)":/cwd ubuntu:17.10 sh -c "$docker_command"

elif [[ "$TEST" == *"stable;"* ]]; then
    # Stable environment (compiler/OS)
    # Build the docker command line
    do_Build_Docker_Command "$FUZZ" "CentOS"

    # Run docker
    docker run -v "$HOME":/root -v "$(pwd)":/cwd centos:centos6 sh -c "$docker_command"

elif [[ "$TEST" == *"snap;"* ]]; then
    # Prepare environment
    sudo apt-get update -qq
    sudo apt-get install snapd

    # Install and test
    sudo snap install --channel=edge john-the-ripper

    # Run the test
    .travis/CI-tests.sh

elif [[ "$TEST" == *"TS;"* ]]; then
    # Configure and build
    do_Prepare_To_Test

    # Test Suite set up
    do_TS_Setup

    # Run the test: Test Suite
    if [[ "$TEST" != *";OPENCL;"* ]]; then
        ./jtrts.pl -stoponerror -dynamic none
    else
        # Disable failing formats
        echo 'descrypt-opencl = Y' >> john-local.conf

        ./jtrts.pl -noprelims -type opencl
    fi

elif [[ "$TEST" == *"TS --restore;"* ]]; then
    # Configure and build
    do_Prepare_To_Test

    # Test Suite set up
    do_TS_Setup

    # Run the test: Test Suite --restore
    ./jtrts.pl --restore

elif [[ "$TEST" == *"TS --internal;"* ]]; then
    # Configure and build
    do_Prepare_To_Test

    # Test Suite set up
    do_TS_Setup

    # Run the test: Test Suite --internal
    ./jtrts.pl -noprelims -internal

else
    echo
    echo  -----------------
    echo  "Nothing to do!!"
    echo  -----------------
fi
# --------- General notes ---------
# 'Recent' environment (compiler/OS)
# clang 4 + ASAN + libOpenMP + fork are not working on CI.
