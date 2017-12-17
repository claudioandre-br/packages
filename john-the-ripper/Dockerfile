FROM fedora:27
MAINTAINER Claudio André (c) 2017 1.0

RUN dnf -y -q update && \
    dnf -y -q install \
        mingw32-gcc mingw64-gcc mingw32-gcc-c++ mingw64-gcc-c++ mingw32-libgomp mingw64-libgomp \
        mingw32-openssl mingw64-openssl mingw32-gmp mingw64-gmp mingw32-bzip2 mingw64-bzip2 \
        @development-tools wine && \
    useradd -U -m JtR

USER JtR
ENV BASE fedora
CMD /bin/bash
