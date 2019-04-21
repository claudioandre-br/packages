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

FROM ubuntu:17.10
MAINTAINER Claudio André (c) 2017-2019 1.0.OpenCL

RUN apt-get update -qq && \
    apt-get install -y \
        build-essential libssl-dev yasm libgmp-dev libpcap-dev pkg-config debhelper libnet1-dev \
        libbz2-dev wget llvm libomp-dev zlib1g-dev git clang afl zzuf \
        libpocl-dev ocl-icd-libopencl1 pocl-opencl-icd opencl-headers && \
    useradd -U -m JtR

# USER JtR => it is much better to use root on Travis
ENV BASE ubuntu
CMD /bin/bash
