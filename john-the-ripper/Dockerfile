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

FROM ubuntu:18.04
LABEL maintainer Claudio André (c) 2017-2019 1.9.0J1
LABEL software John the Ripper 1.9.0 Jumbo 1

COPY john/ /john

RUN apt-get update -qq && \
    apt-get install -y \
        build-essential libssl-dev zlib1g-dev yasm libgmp-dev libpcap-dev pkg-config \
        libbz2-dev wget git libusb-1.0-0-dev && \
    useradd -U -m JtR && \
    #Build John
    cd john/src && \
    ./configure --disable-native-tests --enable-ztex CPPFLAGS=-msse2 && \
    make -sj2 && rm *.o

USER JtR
ENV BASE ubuntu
ENTRYPOINT /john/run/john
